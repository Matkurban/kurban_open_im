import 'package:kurban_open_im/model/domain/api_response.dart';

abstract class AppRepository {
  ///邮箱登录
  Future<ApiResponse> loginByEmail({required String email, required String password});

  ///手机号登录
  Future<ApiResponse> loginByPhone({required String phone, required String password});

  ///发送验证码
  Future<ApiResponse> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  });

  ///注册（参考 im-meeting Apis.register）
  Future<ApiResponse> register({
    required String nickname,
    required String password,
    String? faceURL,
    String? areaCode,
    String? phoneNumber,
    String? email,
    String? account,
    int birth = 0,
    int gender = 1,
    required String verificationCode,
    String? invitationCode,
    bool autoLogin = true,
    required String deviceID,
  });
}
