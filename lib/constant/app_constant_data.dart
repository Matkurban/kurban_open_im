import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/model/domain/user_full_info.dart';

///用户信息
final Rx<UserFullInfo> userInfo = UserFullInfo().obs;

double pictureWidth = 120.w;
double videoWidth = 120.w;
double locationWidth = 220.w;
