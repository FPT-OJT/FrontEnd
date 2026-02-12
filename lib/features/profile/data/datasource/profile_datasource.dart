import 'package:fpt_ojt/features/profile/data/models/profile_model.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

abstract interface class ProfileDatasource {
  Future<ApiResponse<ProfileModel>> getMyProfile();
  Future<ApiResponse<void>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
  });
}
