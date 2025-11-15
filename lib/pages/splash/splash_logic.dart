import 'dart:convert';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/cache_keys.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/domain/auth_cache_data.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/services/im_services.dart';
import 'package:kurban_open_im/utils/store_util.dart';

class SplashLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
    FlutterNativeSplash.remove();
  }

  @override
  void onReady() async {
    super.onReady();
    await init();
  }

  Future<void> init() async {
    ImServices imServices = Get.find<ImServices>();
    bool initialized = await imServices.initImSdk();
    if (initialized) {
      var authCacheData = await StoreUtil.get(CacheKeys.authData);
      if (authCacheData != null) {
        try {
          var authData = AuthCacheData.fromJson(jsonDecode(authCacheData));
          await autoLogin(data: authData);
        } catch (e, s) {
          error(e.toString(), stackTrace: s);
          Get.offAllNamed(RouterName.login);
        }
      } else {
        warn("鉴权信息为空，跳转到登录页面");
        Get.offAllNamed(RouterName.login);
      }
    } else {
      error("初始化OpenImSdk错误");
    }
  }

  Future<void> autoLogin({required AuthCacheData data}) async {
    // 返回当前登录用户的资料
    final user = await OpenIM.iMManager.login(userID: data.userID, token: data.imToken);
    userInfo.value = UserFullInfo.fromJson(user.toJson());
    Get.offAllNamed(RouterName.main);
  }
}
