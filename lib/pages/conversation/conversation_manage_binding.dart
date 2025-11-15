import 'package:get/get.dart';
import 'conversation_manage_logic.dart';

class ConversationManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConversationManageLogic());
  }
}