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
        "phone": phone,
        "password": AppUtil.generateMD5(password),
        "platform": ImPlatformType.current().value,
      },
    );
    return ApiResponse.fromJson(response.data);
  }

  ///注册
  @override
  Future<ApiResponse> register({
    required String accountType,
    required String account,
    required String password,
    required String nickname,
    String? faceURL,
    int? gender,
  }) async {
    final response = await HttpClient().post(
      ApiUrls.register,
      data: {
        "accountType": accountType,
        "account": account,
        "password": AppUtil.generateMD5(password),
        "nickname": nickname,
        "faceURL": faceURL,
        "gender": gender,
        "platform": ImPlatformType.current().value,
      },
    );
    return ApiResponse.fromJson(response.data);
  }
}
