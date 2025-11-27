import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/domain/auth_cache_data.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';
import 'package:kurban_open_im/model/enum/account_type.dart';
import 'package:kurban_open_im/repository/impl/app_repository_impl.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/utils/store_util.dart';

class RegisterLogic extends GetxController {
  ///页面控制器（两步注册）
  late PageController pageController;

  ///当前步骤索引
  final RxInt currentIndex = 0.obs;

  ///账号类型：email / phone
  final Rx<AccountType> accountType = AccountType.email.obs;
  final RxInt gender = 1.obs;
  final Rx<DateTime?> birthDate = Rx<DateTime?>(null);

  ///邮箱控制器
  late TextEditingController emailController;

  ///手机号控制器
  late TextEditingController phoneController;

  ///区域码控制器
  late TextEditingController areaCodeController;

  ///验证码控制器
  late TextEditingController verificationCodeController;

  ///邀请码控制器
  late TextEditingController invitationCodeController;

  ///密码控制器
  late TextEditingController passwordController;

  ///昵称控制器
  late TextEditingController nicknameController;

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
    areaCodeController = TextEditingController(text: "+86");
    passwordController = TextEditingController();
    nicknameController = TextEditingController();
    verificationCodeController = TextEditingController(text: "666666");
    invitationCodeController = TextEditingController();
  }

  ///切换账号类型
  void onAccountTypeChanged(AccountType type) {
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

  Future<void> selectBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      birthDate.value = picked;
    }
  }

  void onGenderChanged(int value) => gender.value = value;

  Future<void> requestVerifyCode() async {
    final isEmail = accountType.value == AccountType.email;
    final accountText = isEmail ? emailController.text.trim() : phoneController.text.trim();
    if (accountText.isEmpty) {
      warn(isEmail ? "请输入邮箱" : "请输入手机号");
      return;
    }
    final repo = AppRepositoryImpl();
    final resp = await repo.requestVerificationCode(
      email: isEmail ? emailController.text.trim() : null,
      areaCode: isEmail ? null : areaCodeController.text.trim(),
      phoneNumber: isEmail ? null : phoneController.text.trim(),
      usedFor: 1,
      invitationCode: invitationCodeController.text.trim().isEmpty
          ? null
          : invitationCodeController.text.trim(),
    );
    resp.isSuccess ? info("验证码发送成功") : error(resp.toString());
  }

  ///提交注册
  Future<void> submit() async {
    FocusScope.of(Get.context!).unfocus();
    final state = step2FormKey.currentState;
    if (state != null && state.validate()) {
      final repo = AppRepositoryImpl();
      final deviceID = await StoreUtil.getOrCreateDeviceID();
      final phoneAreaCode = areaCodeController.text.trim().isEmpty
          ? "+86"
          : areaCodeController.text.trim();

      final resp = await repo.register(
        nickname: nicknameController.text.trim(),
        password: passwordController.text.trim(),
        areaCode: accountType.value == AccountType.phone ? phoneAreaCode : null,
        phoneNumber: accountType.value == AccountType.phone ? phoneController.text.trim() : null,
        email: accountType.value == AccountType.email ? emailController.text.trim() : null,
        birth: birthDate.value?.millisecondsSinceEpoch ?? 0,
        gender: gender.value,
        verificationCode: verificationCodeController.text.trim(),
        invitationCode: invitationCodeController.text.trim().isEmpty
            ? null
            : invitationCodeController.text.trim(),
        autoLogin: true,
        deviceID: deviceID,
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
    areaCodeController.dispose();
    passwordController.dispose();
    nicknameController.dispose();
    verificationCodeController.dispose();
    invitationCodeController.dispose();
    super.onClose();
  }
}
