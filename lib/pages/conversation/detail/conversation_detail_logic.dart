import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';

class ConversationDetailLogic extends GetxController {
  ConversationDetailLogic({required this.conversation});

  final ConversationInfo conversation;

  bool get isGroupChat => (conversation.groupID?.isNotEmpty ?? false);

  bool get isSingleChat => (conversation.userID?.isNotEmpty ?? false);

  String get conversationID => conversation.conversationID;

  final RxBool isPinned = false.obs;

  final RxInt recvMsgOpt = 0.obs;

  final Rxn<PublicUserInfo> userInfo = Rxn<PublicUserInfo>();

  final Rxn<GroupInfo> groupInfo = Rxn<GroupInfo>();

  final RxList<GroupMembersInfo> memberPreview = <GroupMembersInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    isPinned.value = conversation.isPinned ?? false;
    recvMsgOpt.value = conversation.recvMsgOpt ?? 0;
    if (isSingleChat && conversation.userID != null) {
      _loadUserInfo(conversation.userID!);
    }
    if (isGroupChat && conversation.groupID != null) {
      _loadGroupInfo(conversation.groupID!);
      _loadGroupMembers(conversation.groupID!);
    }
  }

  Future<void> togglePinned(bool value) async {
    try {
      await OpenIM.iMManager.conversationManager.pinConversation(
        conversationID: conversationID,
        isPinned: value,
      );
      isPinned.value = value;
      conversation.isPinned = value;
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> updateRecvMsgOpt(int value) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversation(
        conversationID,
        ConversationReq(recvMsgOpt: value),
      );
      recvMsgOpt.value = value;
      conversation.recvMsgOpt = value;
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> clearChatHistory() async {
    try {
      await OpenIM.iMManager.conversationManager.clearConversationAndDeleteAllMsg(
        conversationID: conversationID,
      );
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> deleteConversation() async {
    try {
      await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(
        conversationID: conversationID,
      );
      Get.back(result: true);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> quitGroup() async {
    if (!isGroupChat || conversation.groupID == null) return;
    try {
      await OpenIM.iMManager.groupManager.quitGroup(groupID: conversation.groupID!);
      Get.back(result: true);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> _loadUserInfo(String userID) async {
    try {
      final result = await OpenIM.iMManager.userManager.getUsersInfo(userIDList: [userID]);
      if (result.isNotEmpty) {
        userInfo.value = result.first;
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> _loadGroupInfo(String groupID) async {
    try {
      final result = await OpenIM.iMManager.groupManager.getGroupsInfo(groupIDList: [groupID]);
      if (result.isNotEmpty) {
        groupInfo.value = result.first;
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> _loadGroupMembers(String groupID) async {
    try {
      final result = await OpenIM.iMManager.groupManager.getGroupMemberList(
        groupID: groupID,
        filter: 0,
        offset: 0,
        count: 9,
      );
      memberPreview.assignAll(result);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }
}
