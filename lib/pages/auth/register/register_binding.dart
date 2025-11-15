import 'package:get/get.dart';
import 'package:kurban_open_im/pages/auth/register/register_logic.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterLogic());
  }
}