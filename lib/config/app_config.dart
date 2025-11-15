import 'package:kurban_open_im/config/host.dart';
import 'package:kurban_open_im/model/enum/environment_type.dart';

sealed class AppConfig {
  static final EnvironmentType _envType = EnvironmentType.dev;

  static final String _devHost = host;

  static final String _prodHost = host;

  static String get appAuthUrl {
    switch (_envType) {
      case EnvironmentType.dev:
        return "http://$_devHost:10008";
      case EnvironmentType.prod:
        return "https://$_prodHost/chat";
    }
  }

  static String get imApiUrl {
    switch (_envType) {
      case EnvironmentType.dev:
        return "http://$_devHost:10002";
      case EnvironmentType.prod:
        return "https://$_prodHost/api";
    }
  }

  static String get imWsUrl {
    switch (_envType) {
      case EnvironmentType.dev:
        return "ws://$_devHost:10001";
      case EnvironmentType.prod:
        return "wss://$_prodHost/msg_gateway";
    }
  }
}
