import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/home/data/datasources/home_datasource.dart';
import 'package:fpt_ojt/features/home/data/models/home_data.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class HomeDatasourceImpl implements HomeDatasource {
  HomeDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<ApiResponse<HomeData>> getHome() async {
    final response = await _dio.get<Map<String, dynamic>>('/home');

    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => HomeData.fromJson(json! as Map<String, dynamic>),
    );
  }
}
