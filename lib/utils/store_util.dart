import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../constant/cache_keys.dart';

sealed class StoreUtil {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

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

  ///初始化SharedPreferences（需在app启动时调用）
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  ///从SharedPreferences读取
  static String? getLocal(String key) => _prefs?.getString(key);

  ///写入SharedPreferences
  static Future<void> setLocal({required String key, required String value}) async {
    await _prefs?.setString(key, value);
  }

  ///获取本地设备ID，没有则生成
  static Future<String> getOrCreateDeviceID() async {
    if (_prefs == null) {
      await init();
    }
    var id = getLocal(CacheKeys.deviceID);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      await setLocal(key: CacheKeys.deviceID, value: id);
    }
    return id;
  }
}
