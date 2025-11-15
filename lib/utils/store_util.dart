import 'package:flutter_secure_storage/flutter_secure_storage.dart';

sealed class StoreUtil {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  ///获取
  static Future<String?> get(String key) async {
    return _storage.read(key: key);
  }

  ///写入
  static Future<void> set({required String key, required String value}) async {
    return _storage.write(key: key, value: value);
  }

  ///删除
  static Future<void> delete(String key) async {
    return _storage.delete(key: key);
  }
}
