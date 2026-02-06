import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/impl/mock.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/merchant_category_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_category.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';

class MerchantCategoryDataSourceImpl implements MerchantCategoryDataSource {
  MerchantCategoryDataSourceImpl({required Dio dio}) : _dio = dio;
  // ignore: unused_field
  final Dio _dio;
  @override
  Future<ApiResponse<List<CategoryModel>>> getMerchantCategories({
    required int page,
    required int limit,
  }) async {
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(seconds: 1));
    // mock data for now
    final json = jsonDecode(mockMerchantCategoriesJson) as Map<String, dynamic>;
    final response = ApiResponse<List<CategoryModel>>.fromJson(
      json,
      (data) => (data! as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return response;
  }
}
