import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fpt_ojt/core/common/token/refresh_token_datasource.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';

class AuthRefreshInterceptor extends Interceptor {
  AuthRefreshInterceptor({
    required Dio dio,
    required TokenStore tokenStore,
    required RefreshTokenDataSource refreshDataSource,
    this.shouldAttachToken,
    this.isRefreshRequest,
  }) : _dio = dio,
       _tokenStore = tokenStore,
       _refreshDs = refreshDataSource;

  final Dio _dio;
  final TokenStore _tokenStore;
  final RefreshTokenDataSource _refreshDs;

  final bool Function(RequestOptions options)? shouldAttachToken;
  final bool Function(RequestOptions options)? isRefreshRequest;

  bool _refreshing = false;
  Completer<void>? _refreshCompleter;

  static const _retryMarkKey = '__retried__';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Nếu bạn muốn bỏ qua attach token cho một số request:
      if (shouldAttachToken != null && !shouldAttachToken!(options)) {
        return handler.next(options);
      }

      // Tránh attach token cho chính request refresh (nếu cần)
      if (isRefreshRequest != null && isRefreshRequest!(options)) {
        return handler.next(options);
      }

      final accessToken = await _tokenStore.getAccessToken();
      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {}

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    // Không phải 401 -> bình thường
    if (status != 401) return handler.next(err);

    final req = err.requestOptions;

    // Nếu đây là request refresh -> không refresh tiếp (tránh loop)
    if (isRefreshRequest != null && isRefreshRequest!(req)) {
      return handler.next(err);
    }

    // Chống retry vô hạn: mỗi request chỉ retry 1 lần
    final alreadyRetried = (req.extra[_retryMarkKey] == true);
    if (alreadyRetried) return handler.next(err);

    try {
      await _ensureRefreshedTokens();

      // Lấy access token mới rồi retry request cũ
      final newAccessToken = await _tokenStore.getAccessToken();

      final retryOptions = _cloneOptionsForRetry(req, newAccessToken);
      final response = await _dio.fetch(retryOptions);

      return handler.resolve(response);
    } on Exception catch (_) {
      // Refresh fail -> xoá token , rồi trả lỗi về để app logout
      try {
        await _tokenStore.deleteAccessToken();
        await _tokenStore.deleteRefreshToken();
      } on Exception catch (_) {}
      return handler.next(err);
    }
  }

  Future<void> _ensureRefreshedTokens() async {
    // Nếu đang refresh rồi -> chờ
    if (_refreshing) {
      await (_refreshCompleter?.future ?? Future.value());
      return;
    }

    _refreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await _tokenStore.getRefreshToken();
      if (refreshToken.isEmpty) {
        throw StateError('No refresh token');
      }

      final (accessToken, newRefreshToken) = await _refreshDs.refreshTokens(
        refreshToken,
      );

      await _tokenStore.saveAccessToken(accessToken);
      await _tokenStore.saveRefreshToken(newRefreshToken);

      _refreshCompleter?.complete();
    } catch (e) {
      _refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      _refreshing = false;
    }
  }

  RequestOptions _cloneOptionsForRetry(RequestOptions req, String accessToken) {
    final headers = Map<String, dynamic>.from(req.headers);
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final extra = Map<String, dynamic>.from(req.extra);
    extra[_retryMarkKey] = true;

    return RequestOptions(
      path: req.path,
      method: req.method,
      baseUrl: req.baseUrl,
      data: req.data,
      queryParameters: req.queryParameters,
      headers: headers,
      extra: extra,
      contentType: req.contentType,
      responseType: req.responseType,
      followRedirects: req.followRedirects,
      listFormat: req.listFormat,
      maxRedirects: req.maxRedirects,
      persistentConnection: req.persistentConnection,
      receiveDataWhenStatusError: req.receiveDataWhenStatusError,
      receiveTimeout: req.receiveTimeout,
      requestEncoder: req.requestEncoder,
      responseDecoder: req.responseDecoder,
      sendTimeout: req.sendTimeout,
      validateStatus: req.validateStatus,
      onReceiveProgress: req.onReceiveProgress,
      onSendProgress: req.onSendProgress,
      cancelToken: req.cancelToken,
    );
  }
}
