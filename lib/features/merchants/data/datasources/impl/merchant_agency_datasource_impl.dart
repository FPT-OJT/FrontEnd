import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/impl/mock.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/merchant_agency_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';

class MerchantAgencyDatasourceImpl implements MerchantAgencyDatasource {
  MerchantAgencyDatasourceImpl({required Dio dio}) : _dio = dio;

  // ignore: unused_field
  final Dio _dio;

  @override
  Future<List<MerchantAgencyModel>> getNearestMerchants({
    required double latitude,
    required double longitude,
    required int limit,
  }) async {
    final json = jsonDecode(mockMerchantAgencies) as List<dynamic>;
    return json
        .map((e) => MerchantAgencyModel.fromJson(e as Map<String, dynamic>))
        .take(limit)
        .toList();
  }
}
