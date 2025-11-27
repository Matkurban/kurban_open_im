import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/domain/api_response.dart';
import 'package:kurban_open_im/model/domain/auth_cache_data.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';
import 'package:kurban_open_im/repository/app_repository.dart';
import 'package:kurban_open_im/repository/impl/app_repository_impl.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/utils/store_util.dart';
import 'package:string_validator/string_validator.dart';

class LoginLogic extends GetxController {
  ///登录模式：0=邮箱，1=手机号
  final RxInt loginMode = 0.obs;

  ///From表单的key
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  ///邮箱输入框控制器
  late TextEditingController emailController;

  ///密码数据框控制器
  late TextEditingController passwordController;

  ///手机号输入框控制器
  late TextEditingController phoneController;

  ///控制密码是否可见 true为 不可见，false为可见
  final RxBool passwordVisible = true.obs;

  Timer? _passwordVisibleTimer;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    passwordVisible.listen(_passwordVisibleListen);
  }

  ///校验邮箱
  String? emailValidator(String? value) {
    if (value != null && value.isEmail) {
      return null;
    } else {
      return "您输入的邮箱格式有误";
    }
  }

  ///校验手机号（简单长度判断，具体规则可按需增强）
  String? phoneValidator(String? value) {
    if (value != null && value.isLength(6, 20)) {
      return null;
    } else {
      return "请输入正确的手机号";
    }
  }

  ///检验密码
  String? passwordValidator(String? value) {
    if (value != null && value.isLength(6, 16)) {
      return null;
    } else {
      return "请输入6~16位密码";
    }
  }

  ///监听密码输入框的切换，切换为可见后两秒后变为不可见
  void _passwordVisibleListen(bool value) {
    if (!value) {
      if (_passwordVisibleTimer == null) {
        _passwordVisibleTimer = Timer.periodic(
          Duration(seconds: 2),
          (_) => passwordVisible.value = true,
        );
      } else {
        _passwordVisibleTimer?.cancel();
      }
    }
  }

  ///登录方法
  Future<void> login() async {
    try {
      FocusScope.of(Get.context!).unfocus();
      var currentState = loginFormKey.currentState;
      if (currentState != null && currentState.validate()) {
        AppRepository appRepository = AppRepositoryImpl();
        FlutterToastPro.showLoading(message: "登录中...");
        ApiResponse apiResponse;
        if (loginMode.value == 0) {
          apiResponse = await appRepository.loginByEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
        } else {
          apiResponse = await appRepository.loginByPhone(
            phone: phoneController.text.trim(),
            password: passwordController.text.trim(),
          );
        }
        if (apiResponse.isSuccess) {
          info(apiResponse.toString());
          var authCacheData = AuthCacheData.fromJson(apiResponse.data);
          var user = await OpenIM.iMManager.login(
            userID: authCacheData.userID,
            token: authCacheData.imToken,
          );
          userInfo.value = UserFullInfo.fromJson(user.toJson());
          await StoreUtil.set(key: CacheKeys.authData, value: authCacheData.toString());

          ///跳转到主页面
          Get.offAllNamed(RouterName.main);
        } else {
          error(apiResponse.toString());
          if (apiResponse.errCode == 20002) {
            FlutterToastPro.showWaringMessage("账号未注册");
          } else {
            FlutterToastPro.showWaringMessage(apiResponse.errMsg);
          }
        }
      } else {
        warn("loginFormKey.currentState 为空 或者 表单校验不通过");
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    } finally {
      FlutterToastPro.hideLoading();
    }
  }

  @override
  void onClose() {
    if (_passwordVisibleTimer != null) {
      _passwordVisibleTimer!.cancel();
    }
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
