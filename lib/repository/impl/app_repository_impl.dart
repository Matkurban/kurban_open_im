import 'package:kurban_open_im/config/api_urls.dart';
import 'package:kurban_open_im/model/domain/api_response.dart';
import 'package:kurban_open_im/model/enum/im_platform_type.dart';
import 'package:kurban_open_im/network/http_client.dart';
import 'package:kurban_open_im/repository/app_repository.dart';
import 'package:kurban_open_im/utils/app_util.dart';

class AppRepositoryImpl implements AppRepository {
  @override
  Future<ApiResponse> login({String? email, String? password}) async {
    var response = await HttpClient().post(
      ApiUrls.login,
      data: {
        "email": ?email,
        "password": ?AppUtil.generateMD5(password),
        "platform": ImPlatformType.current().value,
      },
    );
    return ApiResponse.fromJson(response.data);
  }
}
