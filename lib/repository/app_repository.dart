import 'package:kurban_open_im/model/domain/api_response.dart';

abstract class AppRepository {
  ///登录
  Future<ApiResponse> login({String? email, String? password});
}
