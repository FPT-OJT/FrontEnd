import 'package:fpt_ojt/core/storages/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore implements KeyValueStorage {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> set<T extends Object>(String key, T value) async {
    final prefs = await instance;

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  Future<T?> get<T extends Object>(String key) async {
    final prefs = await instance;

    if (T == String) return prefs.getString(key) as T?;
    if (T == int) return prefs.getInt(key) as T?;
    if (T == bool) return prefs.getBool(key) as T?;
    if (T == double) return prefs.getDouble(key) as T?;
    if (T == List<String>) return prefs.getStringList(key) as T?;

    throw Exception('Unsupported type: $T');
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await instance;
    await prefs.remove(key);
  }
}
