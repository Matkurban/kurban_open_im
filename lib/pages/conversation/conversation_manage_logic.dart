import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class ConversationManageLogic extends GetxController {
  Future<void> hide(String conversationID) async {
    try {
      await OpenIM.iMManager.conversationManager.hideConversation(conversationID: conversationID);
    } catch (_) {}
  }

  Future<void> hideAll() async {
    // 当前 SDK 版本未提供隐藏所有会话接口
  }
}