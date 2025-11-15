import 'package:get/get.dart';
import 'package:kurban_open_im/pages/auth/login/login_logic.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginLogic());
  }
}
