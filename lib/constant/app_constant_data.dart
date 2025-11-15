import 'package:get/get.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';

///用户信息
final Rx<UserFullInfo> userInfo = UserFullInfo().obs;
