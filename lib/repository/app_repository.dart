import 'package:kurban_open_im/model/domain/api_response.dart';

abstract class AppRepository {
  ///邮箱登录
  Future<ApiResponse> loginByEmail({required String email, required String password});

  ///手机号登录
  Future<ApiResponse> loginByPhone({required String phone, required String password});

  ///注册（邮箱或手机号 + 密码 + 个人信息）
  Future<ApiResponse> register({
    required String accountType, // email 或 phone
    required String account, // 邮箱地址或手机号
    required String password, // 明文密码，服务端按需加密校验
    required String nickname, // 昵称
    String? faceURL, // 头像地址
    int? gender, // 性别：1男 2女 0未知
  });
}
