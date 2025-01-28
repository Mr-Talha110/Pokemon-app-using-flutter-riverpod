import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  LocalDatabase();

  Future<bool?> saveList(String key, List<String> value) async {
    try {
      final SharedPreferences ref = await SharedPreferences.getInstance();
      bool result = await ref.setStringList(key, value);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getList(String key) async {
    try {
      final SharedPreferences ref = await SharedPreferences.getInstance();
      List<String>? value = ref.getStringList(key);
      return value ?? [];
    } catch (e) {
      return [];
    }
  }
}
