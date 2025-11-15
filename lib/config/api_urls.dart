import 'package:kurban_open_im/config/app_config.dart';

sealed class ApiUrls {
  ///邮箱登录
  static final loginByEmail = "${AppConfig.appAuthUrl}/account/login_email";

  ///手机号登录
  static final loginByPhone = "${AppConfig.appAuthUrl}/account/login_phone";

  ///注册（邮箱或手机号）
  static final register = "${AppConfig.appAuthUrl}/account/register";

  ///验证码（可选）
  static final getVerifyCode = "${AppConfig.appAuthUrl}/account/verify_code";
}
