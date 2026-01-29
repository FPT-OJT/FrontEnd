import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/core/common/token/refresh_token_datasource.dart';
import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/network/auth_refresh_interceptor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './mock_exception_handler.dart';
@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<TokenStore>(),
  MockSpec<RefreshTokenDataSource>(),
  MockSpec<RequestInterceptorHandler>(),
  MockSpec<ErrorInterceptorHandler>(),
])
import 'auth_refresh_interceptor_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late MockTokenStore mockTokenStore;
  late MockRefreshTokenDataSource mockRefreshDataSource;
  late AuthRefreshInterceptor interceptor;

  setUp(() {
    mockDio = MockDio();
    mockTokenStore = MockTokenStore();
    mockRefreshDataSource = MockRefreshTokenDataSource();
    interceptor = AuthRefreshInterceptor(
      dio: mockDio,
      tokenStore: mockTokenStore,
      refreshDataSource: mockRefreshDataSource,
    );
  });

  group('onRequest', () {
    test('should attach access token to request headers', () async {
      // Arrange
      final handler = MockRequestInterceptorHandler();
      final options = RequestOptions(path: '/api/users');
      const accessToken = 'test_access_token';

      when(
        mockTokenStore.getAccessToken(),
      ).thenAnswer((_) async => accessToken);

      // Act
      await interceptor.onRequest(options, handler);

      // Assert
      expect(options.headers['Authorization'], accessToken);
      verify(handler.next(options)).called(1);
    });

    test('should continue without token when access token is empty', () async {
      // Arrange
      final handler = MockRequestInterceptorHandler();
      final options = RequestOptions(path: '/api/users');

      when(mockTokenStore.getAccessToken()).thenAnswer((_) async => '');

      // Act
      await interceptor.onRequest(options, handler);

      // Assert
      expect(options.headers.containsKey('Authorization'), false);
      verify(handler.next(options)).called(1);
    });

    test(
      'should skip token attachment when shouldAttachToken returns false',
      () async {
        // Arrange
        final handler = MockRequestInterceptorHandler();
        final options = RequestOptions(path: '/public/auth/login');
        final interceptorWithFilter = AuthRefreshInterceptor(
          dio: mockDio,
          tokenStore: mockTokenStore,
          refreshDataSource: mockRefreshDataSource,
          shouldAttachToken: (opts) => !opts.path.contains('/public/'),
        );

        // Act
        await interceptorWithFilter.onRequest(options, handler);

        // Assert
        verifyNever(mockTokenStore.getAccessToken());
        verify(handler.next(options)).called(1);
      },
    );

    test(
      'should skip token attachment when isRefreshRequest returns true',
      () async {
        // Arrange
        final handler = MockRequestInterceptorHandler();
        final options = RequestOptions(path: '/api/auth/refresh');
        final interceptorWithFilter = AuthRefreshInterceptor(
          dio: mockDio,
          tokenStore: mockTokenStore,
          refreshDataSource: mockRefreshDataSource,
          isRefreshRequest: (opts) => opts.path.contains('/refresh'),
        );

        // Act
        await interceptorWithFilter.onRequest(options, handler);

        // Assert
        verifyNever(mockTokenStore.getAccessToken());
        verify(handler.next(options)).called(1);
      },
    );

    test('should handle token store errors gracefully', () async {
      // Arrange
      final handler = MockRequestInterceptorHandler();
      final options = RequestOptions(path: '/api/users');

      when(mockTokenStore.getAccessToken()).thenThrow(Exception('Error'));

      // Act
      await interceptor.onRequest(options, handler);

      // Assert
      verify(handler.next(options)).called(1);
    });
  });

  group('onError - 401 handling', () {
    test('should pass through non-401 errors', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/users');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 500),
      );

      // Act
      await interceptor.onError(dioException, handler);

      // Assert
      verify(handler.next(dioException)).called(1);
      verifyNever(mockTokenStore.getRefreshToken());
    });

    test('should refresh token and retry request on 401 error', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/users');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      const refreshToken = 'old_refresh_token';
      const newAccessToken = 'new_access_token';
      const newRefreshToken = 'new_refresh_token';

      when(
        mockTokenStore.getRefreshToken(),
      ).thenAnswer((_) async => refreshToken);
      when(
        mockRefreshDataSource.refreshTokens(refreshToken),
      ).thenAnswer((_) async => (newAccessToken, newRefreshToken));
      when(
        mockTokenStore.saveAccessToken(newAccessToken),
      ).thenAnswer((_) async {});
      when(
        mockTokenStore.replaceRefreshToken(newRefreshToken),
      ).thenAnswer((_) async {});
      when(
        mockTokenStore.getAccessToken(),
      ).thenAnswer((_) async => newAccessToken);

      final retryResponse = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'success': true},
      );
      when(mockDio.fetch<dynamic>(any)).thenAnswer((_) async => retryResponse);

      // Act
      await interceptor.onError(dioException, handler);

      // Assert
      verify(mockTokenStore.getRefreshToken()).called(1);
      verify(mockRefreshDataSource.refreshTokens(refreshToken)).called(1);
      verify(mockTokenStore.saveAccessToken(newAccessToken)).called(1);
      verify(mockTokenStore.replaceRefreshToken(newRefreshToken)).called(1);
      verify(mockDio.fetch<dynamic>(any)).called(1);
      verify(handler.resolve(retryResponse)).called(1);
    });

    test(
      'should not retry if already retried (infinite loop prevention)',
      () async {
        // Arrange
        final handler = MockErrorInterceptorHandler();
        final requestOptions = RequestOptions(
          path: '/api/users',
          extra: {'__retried__': true},
        );
        final dioException = DioException(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 401),
        );

        // Act
        await interceptor.onError(dioException, handler);

        // Assert
        verify(handler.next(dioException)).called(1);
        verifyNever(mockTokenStore.getRefreshToken());
      },
    );

    test('should delete tokens and pass error when refresh fails', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/users');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      when(
        mockTokenStore.getRefreshToken(),
      ).thenAnswer((_) async => 'refresh_token');
      when(
        mockRefreshDataSource.refreshTokens(any),
      ).thenAnswer((_) => Future.error(Exception('Refresh failed')));
      when(mockTokenStore.deleteAccessToken()).thenAnswer((_) async {});
      when(mockTokenStore.deleteRefreshToken()).thenAnswer((_) async {});

      // Act
      await interceptor.onError(dioException, handler);

      // Assert
      verify(mockTokenStore.deleteAccessToken()).called(1);
      verify(mockTokenStore.deleteRefreshToken()).called(1);
      verify(handler.next(dioException)).called(1);
    });

    test('should skip refresh for public paths', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/public/auth/login');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      final interceptorWithFilter = AuthRefreshInterceptor(
        dio: mockDio,
        tokenStore: mockTokenStore,
        refreshDataSource: mockRefreshDataSource,
        shouldAttachToken: (opts) => !opts.path.contains('/public/'),
      );

      // Act
      await interceptorWithFilter.onError(dioException, handler);

      // Assert
      verify(handler.next(dioException)).called(1);
      verifyNever(mockTokenStore.getRefreshToken());
    });

    test('should skip refresh for refresh request itself', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/auth/refresh');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      final interceptorWithFilter = AuthRefreshInterceptor(
        dio: mockDio,
        tokenStore: mockTokenStore,
        refreshDataSource: mockRefreshDataSource,
        isRefreshRequest: (opts) => opts.path.contains('/refresh'),
      );

      // Act
      await interceptorWithFilter.onError(dioException, handler);

      // Assert
      verify(handler.next(dioException)).called(1);
      verifyNever(mockTokenStore.getRefreshToken());
    });

    test('should handle empty refresh token', () async {
      final handler = TestErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/users');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      when(mockTokenStore.getRefreshToken()).thenAnswer((_) async => '');
      when(mockTokenStore.deleteAccessToken()).thenAnswer((_) async {});
      when(mockTokenStore.deleteRefreshToken()).thenAnswer((_) async {});

      await interceptor.onError(dioException, handler);
      await handler.completer.future;

      verify(mockTokenStore.deleteAccessToken()).called(1);
      verify(mockTokenStore.deleteRefreshToken()).called(1);

      expect(handler.nextError, same(dioException));
      expect(handler.resolvedResponse, isNull);
      expect(handler.rejectedError, isNull);
    });

    test('should mark retry request with __retried__ flag', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/users');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      const refreshToken = 'refresh_token';
      const newAccessToken = 'new_access_token';
      const newRefreshToken = 'new_refresh_token';

      when(
        mockTokenStore.getRefreshToken(),
      ).thenAnswer((_) async => refreshToken);
      when(
        mockRefreshDataSource.refreshTokens(refreshToken),
      ).thenAnswer((_) async => (newAccessToken, newRefreshToken));
      when(
        mockTokenStore.saveAccessToken(newAccessToken),
      ).thenAnswer((_) async {});
      when(
        mockTokenStore.replaceRefreshToken(newRefreshToken),
      ).thenAnswer((_) async {});
      when(
        mockTokenStore.getAccessToken(),
      ).thenAnswer((_) async => newAccessToken);

      RequestOptions? capturedOptions;
      when(mockDio.fetch<dynamic>(any)).thenAnswer((invocation) async {
        capturedOptions = invocation.positionalArguments[0] as RequestOptions;
        return Response(requestOptions: capturedOptions!, statusCode: 200);
      });

      // Act
      await interceptor.onError(dioException, handler);

      // Assert
      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.extra['__retried__'], true);
      expect(capturedOptions!.headers['Authorization'], newAccessToken);
    });
  });

  group('concurrent refresh handling', () {
    test(
      'should only refresh once when multiple 401s happen simultaneously',
      () async {
        // Arrange
        final handler1 = MockErrorInterceptorHandler();
        final handler2 = MockErrorInterceptorHandler();

        final requestOptions1 = RequestOptions(path: '/api/users');
        final requestOptions2 = RequestOptions(path: '/api/posts');

        final dioException1 = DioException(
          requestOptions: requestOptions1,
          response: Response(requestOptions: requestOptions1, statusCode: 401),
        );

        final dioException2 = DioException(
          requestOptions: requestOptions2,
          response: Response(requestOptions: requestOptions2, statusCode: 401),
        );

        const refreshToken = 'refresh_token';
        const newAccessToken = 'new_access_token';
        const newRefreshToken = 'new_refresh_token';

        when(
          mockTokenStore.getRefreshToken(),
        ).thenAnswer((_) async => refreshToken);
        when(mockRefreshDataSource.refreshTokens(refreshToken)).thenAnswer((
          _,
        ) async {
          // Simulate slow refresh
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return (newAccessToken, newRefreshToken);
        });
        when(
          mockTokenStore.saveAccessToken(newAccessToken),
        ).thenAnswer((_) async {});
        when(
          mockTokenStore.replaceRefreshToken(newRefreshToken),
        ).thenAnswer((_) async {});
        when(
          mockTokenStore.getAccessToken(),
        ).thenAnswer((_) async => newAccessToken);

        when(mockDio.fetch<dynamic>(any)).thenAnswer((invocation) async {
          final opts = invocation.positionalArguments[0] as RequestOptions;
          return Response(requestOptions: opts, statusCode: 200);
        });

        // Act - trigger both simultaneously
        await Future.wait([
          interceptor.onError(dioException1, handler1),
          interceptor.onError(dioException2, handler2),
        ]);

        // Assert - should only call refresh once
        verify(mockRefreshDataSource.refreshTokens(refreshToken)).called(1);
        verify(mockTokenStore.saveAccessToken(newAccessToken)).called(1);
        verify(mockTokenStore.replaceRefreshToken(newRefreshToken)).called(1);
      },
    );
  });
}
