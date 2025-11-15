import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/utils/store_util.dart';

class MineLogic extends GetxController {
  ///退出登录
  Future<void> logout() async {
    try {
      await OpenIM.iMManager.logout();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
    await StoreUtil.delete(CacheKeys.authData);
    Get.offAllNamed(RouterName.login);
  }
}
