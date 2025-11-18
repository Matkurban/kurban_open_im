import 'package:get/get.dart';
import 'package:kurban_open_im/pages/splash/splash_logic.dart';
import 'package:kurban_open_im/services/app_services.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashLogic());
    Get.put(AppServices());
  }
}
