import 'package:get/get.dart';
import 'package:kurban_open_im/pages/auth/login/login_binding.dart';
import 'package:kurban_open_im/pages/auth/login/login_page.dart';
import 'package:kurban_open_im/pages/auth/register/register_binding.dart';
import 'package:kurban_open_im/pages/auth/register/register_page.dart';
import 'package:kurban_open_im/pages/chat/chat_binding.dart';
import 'package:kurban_open_im/pages/chat/chat_view.dart';
import 'package:kurban_open_im/pages/mine/profile_binding.dart';
import 'package:kurban_open_im/pages/mine/profile_view.dart';
import 'package:kurban_open_im/pages/main/main_binding.dart';
import 'package:kurban_open_im/pages/main/main_page.dart';
import 'package:kurban_open_im/pages/splash/splash_binding.dart';
import 'package:kurban_open_im/pages/splash/splash_page.dart';
import 'package:kurban_open_im/router/router_name.dart';

sealed class RouterPage {
  ///所有路由的集合
  static List<GetPage> allPages() {
    return [
      GetPage(name: RouterName.splash, page: () => SplashPage(), binding: SplashBinding()),
      GetPage(name: RouterName.login, page: () => LoginPage(), binding: LoginBinding()),
      GetPage(name: RouterName.register, page: () => RegisterPage(), binding: RegisterBinding()),
      GetPage(name: RouterName.chat, page: () => ChatView(), binding: ChatBinding()),
      GetPage(name: RouterName.main, page: () => MainPage(), binding: MainBinding()),
      GetPage(name: RouterName.profile, page: () => const ProfileView(), binding: ProfileBinding()),
    ];
  }
}
