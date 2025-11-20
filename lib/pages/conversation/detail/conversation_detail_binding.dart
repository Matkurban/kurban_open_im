import 'package:get/get.dart';
import 'package:kurban_open_im/pages/conversation/detail/conversation_detail_logic.dart';

class ConversationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConversationDetailLogic(conversation: Get.arguments));
  }
}
