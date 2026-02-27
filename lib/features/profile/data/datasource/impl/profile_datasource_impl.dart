import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/profile/data/datasource/profile_datasource.dart';
import 'package:fpt_ojt/features/profile/data/models/profile_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  ProfileDatasourceImpl({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<ApiResponse<ProfileModel>> getMyProfile() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/core/users/profile');
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => ProfileModel.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/core/users/profile',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'countryPhoneCode': countryCode,
        'phoneNumber': phoneNumber,
      },
    );
    return ApiResponse.fromJson(
      response.data ?? {},
      (json) => json! as Map<String, dynamic>,
    );
  }
}
