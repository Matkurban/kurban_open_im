import 'package:kurban_open_im/config/api_urls.dart';
import 'package:kurban_open_im/model/domain/api_response.dart';
import 'package:kurban_open_im/model/enum/im_platform_type.dart';
import 'package:kurban_open_im/network/http_client.dart';
import 'package:kurban_open_im/repository/app_repository.dart';
import 'package:kurban_open_im/utils/app_util.dart';

class AppRepositoryImpl implements AppRepository {
  ///邮箱登录
  @override
  Future<ApiResponse> loginByEmail({required String email, required String password}) async {
    final response = await HttpClient().post(
      ApiUrls.loginByEmail,
      data: {
        "email": email,
        "password": AppUtil.generateMD5(password),
        "platform": ImPlatformType.current().value,
      },
    );
    return ApiResponse.fromJson(response.data);
  }

  ///手机号登录
  @override
  Future<ApiResponse> loginByPhone({required String phone, required String password}) async {
    final response = await HttpClient().post(
      ApiUrls.loginByPhone,
      data: {
        "areaCode": "+86",
        "phoneNumber": phone,
        "password": AppUtil.generateMD5(password),
        "platform": ImPlatformType.current().value,
      },
    );
    return ApiResponse.fromJson(response.data);
  }

  ///注册
  @override
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
  }) async {
    final response = await HttpClient().post(
      ApiUrls.register,
      data: {
        "deviceID": deviceID,
        "verifyCode": verificationCode,
        "platform": ImPlatformType.current().value,
        "invitationCode": invitationCode,
        "autoLogin": autoLogin,
        "user": {
          "nickname": nickname,
          "faceURL": faceURL,
          "birth": birth,
          "gender": gender,
          "email": email,
          "areaCode": areaCode,
          "phoneNumber": phoneNumber,
          "account": account,
          "password": AppUtil.generateMD5(password),
        },
      },
    );
    return ApiResponse.fromJson(response.data);
  }

  @override
  Future<ApiResponse> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    final response = await HttpClient().post(
      ApiUrls.getVerifyCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
        "usedFor": usedFor,
        "invitationCode": invitationCode,
      },
    );
    return ApiResponse.fromJson(response.data);
  }
}
