import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/auth/login/login_binding.dart';
import 'package:kurban_open_im/pages/auth/login/login_page.dart';
import 'package:kurban_open_im/pages/auth/register/register_binding.dart';
import 'package:kurban_open_im/pages/auth/register/register_page.dart';
import 'package:kurban_open_im/pages/chat/chat_binding.dart';
import 'package:kurban_open_im/pages/chat/chat_view.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_applications_logic.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_applications_view.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_detail_logic.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_detail_view.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_search_binding.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_search_view.dart';
import 'package:kurban_open_im/pages/conversation/detail/conversation_detail_binding.dart';
import 'package:kurban_open_im/pages/conversation/detail/conversation_detail_view.dart';
import 'package:kurban_open_im/pages/main/main_binding.dart';
import 'package:kurban_open_im/pages/main/main_page.dart';
import 'package:kurban_open_im/pages/mine/profile_binding.dart';
import 'package:kurban_open_im/pages/mine/profile_view.dart';
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
      GetPage(
        name: RouterName.conversationDetail,
        page: () => const ConversationDetailView(),
        binding: ConversationDetailBinding(),
      ),
      GetPage(name: RouterName.main, page: () => MainPage(), binding: MainBinding()),
      GetPage(name: RouterName.profile, page: () => const ProfileView(), binding: ProfileBinding()),
      GetPage(
        name: RouterName.friendSearch,
        page: () => const FriendSearchView(),
        binding: FriendSearchBinding(),
      ),
      GetPage(
        name: RouterName.friendApplications,
        page: () => const FriendApplicationsView(),
        binding: BindingsBuilder(() => Get.lazyPut(() => FriendApplicationsLogic())),
      ),
      GetPage(
        name: RouterName.friendDetail,
        page: () => FriendDetailView(),
        binding: BindingsBuilder(() {
          final arg = Get.arguments as FriendInfo;
          Get.lazyPut(() => FriendDetailLogic(friend: arg));
        }),
      ),
    ];
  }
}
