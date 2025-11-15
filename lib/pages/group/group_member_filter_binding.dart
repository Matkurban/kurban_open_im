import 'package:get/get.dart';
import 'group_member_filter_logic.dart';

class GroupMemberFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupMemberFilterLogic());
  }
}