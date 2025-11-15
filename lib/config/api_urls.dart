import 'package:kurban_open_im/config/app_config.dart';

sealed class ApiUrls {
  static final login = "${AppConfig.appAuthUrl}/account/login";
}
