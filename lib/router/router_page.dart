import 'package:get/get.dart';
import 'package:kurban_open_im/pages/auth/login/login_binding.dart';
import 'package:kurban_open_im/pages/auth/login/login_page.dart';
import 'package:kurban_open_im/pages/auth/register/register_binding.dart';
import 'package:kurban_open_im/pages/auth/register/register_page.dart';
import 'package:kurban_open_im/pages/chat/chat_binding.dart';
import 'package:kurban_open_im/pages/chat/chat_view.dart';
import 'package:kurban_open_im/pages/chat_detail/chat_detail_binding.dart';
import 'package:kurban_open_im/pages/chat_detail/chat_detail_view.dart';
import 'package:kurban_open_im/pages/conversation/conversation_manage_binding.dart';
import 'package:kurban_open_im/pages/conversation/conversation_manage_view.dart';
import 'package:kurban_open_im/pages/group/group_applications_binding.dart';
import 'package:kurban_open_im/pages/group/group_applications_view.dart';
import 'package:kurban_open_im/pages/group/group_create_binding.dart';
import 'package:kurban_open_im/pages/group/group_create_view.dart';
import 'package:kurban_open_im/pages/group/group_member_filter_binding.dart';
import 'package:kurban_open_im/pages/group/group_member_filter_view.dart';
import 'package:kurban_open_im/pages/group/group_search_binding.dart';
import 'package:kurban_open_im/pages/group/group_search_view.dart';
import 'package:kurban_open_im/pages/mine/profile_binding.dart';
import 'package:kurban_open_im/pages/mine/profile_view.dart';
import 'package:kurban_open_im/pages/main/main_binding.dart';
import 'package:kurban_open_im/pages/main/main_page.dart';
import 'package:kurban_open_im/pages/relation/blacklist_binding.dart';
import 'package:kurban_open_im/pages/relation/blacklist_view.dart';
import 'package:kurban_open_im/pages/relation/friend_add_binding.dart';
import 'package:kurban_open_im/pages/relation/friend_add_view.dart';
import 'package:kurban_open_im/pages/relation/friend_applications_binding.dart';
import 'package:kurban_open_im/pages/relation/friend_applications_view.dart';
import 'package:kurban_open_im/pages/relation/friend_search_binding.dart';
import 'package:kurban_open_im/pages/relation/friend_search_view.dart';
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
      GetPage(name: RouterName.chatDetail, page: () => ChatDetailView(), binding: ChatDetailBinding()),
      GetPage(name: RouterName.main, page: () => MainPage(), binding: MainBinding()),
      GetPage(name: RouterName.friendAdd, page: () => const FriendAddView(), binding: FriendAddBinding()),
      GetPage(name: RouterName.friendSearch, page: () => const FriendSearchView(), binding: FriendSearchBinding()),
      GetPage(name: RouterName.friendApplications, page: () => const FriendApplicationsView(), binding: FriendApplicationsBinding()),
      GetPage(name: RouterName.blacklist, page: () => const BlacklistView(), binding: BlacklistBinding()),
      GetPage(name: RouterName.groupCreate, page: () => const GroupCreateView(), binding: GroupCreateBinding()),
      GetPage(name: RouterName.groupSearch, page: () => const GroupSearchView(), binding: GroupSearchBinding()),
      GetPage(name: RouterName.groupApplications, page: () => const GroupApplicationsView(), binding: GroupApplicationsBinding()),
      GetPage(name: RouterName.groupMemberFilter, page: () => const GroupMemberFilterView(), binding: GroupMemberFilterBinding()),
      GetPage(name: RouterName.conversationManage, page: () => const ConversationManageView(), binding: ConversationManageBinding()),
      GetPage(name: RouterName.profile, page: () => const ProfileView(), binding: ProfileBinding()),
    ];
  }
}
