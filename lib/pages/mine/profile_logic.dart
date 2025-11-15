import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:kurban_open_im/constant/app_constant_data.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';

class ProfileLogic extends GetxController {
  final Rx<UserFullInfo?> self = Rx<UserFullInfo?>(null);
  final RxBool saving = false.obs;

  @override
  void onReady() async {
    super.onReady();
    final me = await OpenIM.iMManager.userManager.getSelfUserInfo();
    self.value = UserFullInfo.fromJson(me.toJson());
  }

  Future<void> save({
    String? nickname,
    String? faceURL,
    int? gender,
    String? email,
    String? mobile,
    int? birth,
  }) async {
    if (saving.value) return;
    saving.value = true;
    try {
      await OpenIM.iMManager.userManager.setSelfInfo(
        nickname: nickname,
        faceURL: faceURL,
      );
      final me = await OpenIM.iMManager.userManager.getSelfUserInfo();
      final updated = UserFullInfo.fromJson(me.toJson());
      userInfo.value = updated;
      self.value = updated;
    } catch (_) {
    } finally {
      saving.value = false;
    }
  }
}
