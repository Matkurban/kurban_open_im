import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/domain/auth_cache_data.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';
import 'package:kurban_open_im/repository/impl/app_repository_impl.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/utils/store_util.dart';

class RegisterLogic extends GetxController {
  ///页面控制器（两步注册）
  late PageController pageController;

  ///当前步骤索引
  final RxInt currentIndex = 0.obs;

  ///账号类型：email / phone
  final RxString accountType = "email".obs;

  ///邮箱控制器
  late TextEditingController emailController;

  ///手机号控制器
  late TextEditingController phoneController;

  ///密码控制器
  late TextEditingController passwordController;

  ///昵称控制器
  late TextEditingController nicknameController;

  ///头像地址
  final RxString faceURL = "".obs;

  ///性别：1男 2女 0未知
  final RxInt gender = 0.obs;

  ///第1步表单Key
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();

  ///第2步表单Key
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    nicknameController = TextEditingController();
  }

  ///切换账号类型
  void onAccountTypeChanged(String type) {
    accountType.value = type;
  }

  ///下一步（校验第1步）
  void nextStep() {
    final state = step1FormKey.currentState;
    if (state != null && state.validate()) {
      currentIndex.value = 1;
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    } else {
      warn("注册第1步表单校验失败");
    }
  }

  ///上一步
  void prevStep() {
    currentIndex.value = 0;
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  ///提交注册
  Future<void> submit() async {
    final state = step2FormKey.currentState;
    if (state != null && state.validate()) {
      final repo = AppRepositoryImpl();
      final account = accountType.value == "email"
          ? emailController.text.trim()
          : phoneController.text.trim();
      final resp = await repo.register(
        accountType: accountType.value,
        account: account,
        password: passwordController.text.trim(),
        nickname: nicknameController.text.trim(),
        faceURL: faceURL.value.isNotEmpty ? faceURL.value : null,
        gender: gender.value,
      );
      if (resp.isSuccess) {
        info(resp.toString());
        final authData = AuthCacheData.fromJson(resp.data);
        final user = await OpenIM.iMManager.login(userID: authData.userID, token: authData.imToken);
        userInfo.value = UserFullInfo.fromJson(user.toJson());
        await StoreUtil.set(key: CacheKeys.authData, value: authData.toString());
        Get.offAllNamed(RouterName.main);
      } else {
        error(resp.toString());
      }
    } else {
      warn("注册第2步表单校验失败");
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    nicknameController.dispose();
    super.onClose();
  }
}
