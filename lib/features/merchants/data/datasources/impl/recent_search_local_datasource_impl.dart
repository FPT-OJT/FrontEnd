import 'dart:convert';

import 'package:fpt_ojt/core/storages/key_value_storage.dart';
import 'package:fpt_ojt/features/merchants/data/datasources/recent_search_local_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/models/merchant_agency_model.dart';

class RecentSearchLocalDatasourceImpl implements RecentSearchLocalDatasource {
  RecentSearchLocalDatasourceImpl({required this.storage});

  final KeyValueStorage storage;

  static const _key = 'recent_merchant_searches';
  static const _maxEntries = 4;

  @override
  Future<List<MerchantAgencyModel>> getRecentSearches() async {
    final raw = await storage.get<List<String>>(_key);
    if (raw == null || raw.isEmpty) return [];
    return raw
        .map(
          (s) => MerchantAgencyModel.fromJson(
            jsonDecode(s) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<void> pushRecentSearch(MerchantAgencyModel agency) async {
    final existing = await getRecentSearches();

    // Deduplicate by id, remove old entry if exists
    final filtered = existing.where((e) => e.id != agency.id).toList();

    // Prepend newest, keep max 4
    final updated = [agency, ...filtered].take(_maxEntries).toList();

    final encoded = updated.map((e) => jsonEncode(e.toJson())).toList();
    await storage.set<List<String>>(_key, encoded);
  }
}
