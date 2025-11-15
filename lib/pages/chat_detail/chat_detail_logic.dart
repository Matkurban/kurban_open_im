import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class ChatDetailLogic extends GetxController {
  late bool isGroup;
  String? recvID;
  String? groupID;
  String? conversationID;
  String title = "";

  final Rx<PublicUserInfo?> userInfo = Rx<PublicUserInfo?>(null);
  final Rx<GroupInfo?> groupInfo = Rx<GroupInfo?>(null);
  final RxList<GroupMembersInfo> members = <GroupMembersInfo>[].obs;

  final RxBool pinned = false.obs;
  final RxInt recvOpt = 0.obs;

  final TextEditingController draftCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    isGroup = args["isGroup"] == true;
    recvID = args["recvID"];
    groupID = args["groupID"];
    title = args["title"] ?? "";
    _loadBase();
  }

  Future<void> _loadBase() async {
    final sourceID = isGroup ? groupID : recvID;
    if (sourceID == null) return;
    conversationID = await OpenIM.iMManager.conversationManager.getConversationIDBySessionType(
      sourceID: sourceID,
      sessionType: isGroup ? ConversationType.superGroup : ConversationType.single,
    );
    if (isGroup) {
      await _loadGroupInfo();
      await _loadMembers();
    } else {
      await _loadUserInfo();
    }
  }

  Future<void> _loadUserInfo() async {
    if (recvID == null) return;
    final list = await OpenIM.iMManager.userManager.getUsersInfo(userIDList: [recvID!]);
    if (list.isNotEmpty) userInfo.value = list.first;
  }

  Future<void> _loadGroupInfo() async {
    if (groupID == null) return;
    final list = await OpenIM.iMManager.groupManager.getGroupsInfo(groupIDList: [groupID!]);
    if (list.isNotEmpty) groupInfo.value = list.first;
  }

  Future<void> _loadMembers() async {
    if (groupID == null) return;
    final list = await OpenIM.iMManager.groupManager.getGroupMemberList(
      groupID: groupID!,
      filter: 0,
      offset: 0,
      count: 50,
    );
    members.assignAll(list);
  }

  Future<void> setPinned(bool isPinned) async {
    if (conversationID == null) return;
    await OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: conversationID!,
      isPinned: isPinned,
    );
    pinned.value = isPinned;
  }

  Future<void> setRecvOptValue(int value) async {
    if (conversationID == null) return;
    await OpenIM.iMManager.conversationManager.setConversation(conversationID!, ConversationReq());
    recvOpt.value = value;
  }

  Future<void> setFriendRemark(String remark) async {
    if (recvID == null) return;
    await OpenIM.iMManager.friendshipManager.updateFriends(UpdateFriendsReq(remark: remark));
    await _loadUserInfo();
  }

  Future<void> addBlacklist() async {
    if (recvID == null) return;
    await OpenIM.iMManager.friendshipManager.addBlacklist(userID: recvID!);
    await _loadUserInfo();
  }

  Future<void> removeBlacklist() async {
    if (recvID == null) return;
    await OpenIM.iMManager.friendshipManager.removeBlacklist(userID: recvID!);
    await _loadUserInfo();
  }

  Future<void> deleteFriend() async {
    if (recvID == null) return;
    await OpenIM.iMManager.friendshipManager.deleteFriend(userID: recvID!);
  }

  Future<void> inviteUsers(List<String> uids) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.inviteUserToGroup(groupID: groupID!, userIDList: uids);
    await _loadMembers();
  }

  Future<void> kickUsers(List<String> uids) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.kickGroupMember(
      groupID: groupID!,
      userIDList: uids,
      reason: "",
    );
    await _loadMembers();
  }

  Future<void> setAdmin(String uid, bool isAdmin) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.setGroupMemberInfo(
      groupMembersInfo: SetGroupMemberInfo(
        groupID: groupID!,
        userID: uid,
        roleLevel: isAdmin ? 3 : 0,
      ),
    );
    await _loadMembers();
  }

  Future<void> muteMember(String uid, int seconds) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.changeGroupMemberMute(
      groupID: groupID!,
      userID: uid,
      seconds: seconds,
    );
    await _loadMembers();
  }

  Future<void> muteGroup(bool isMute) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.changeGroupMute(groupID: groupID!, mute: isMute);
    await _loadGroupInfo();
  }

  Future<void> transferOwner(String uid) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.transferGroupOwner(groupID: groupID!, userID: uid);
    await _loadGroupInfo();
  }

  Future<void> quitGroup() async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.quitGroup(groupID: groupID!);
  }

  Future<void> dismissGroup() async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.dismissGroup(groupID: groupID!);
  }

  Future<void> setGroupInfo({String? name, String? faceURL, String? notification}) async {
    if (groupID == null) return;
    await OpenIM.iMManager.groupManager.setGroupInfo(
      GroupInfo(groupID: groupID!, groupName: name, faceURL: faceURL, notification: notification),
    );
    await _loadGroupInfo();
  }

  Future<void> setDraft(String text) async {
    if (conversationID == null) return;
    await OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID!,
      draftText: text,
    );
  }

  Future<void> clearConversation() async {
    if (conversationID == null) return;
    await OpenIM.iMManager.conversationManager.clearConversationAndDeleteAllMsg(
      conversationID: conversationID!,
    );
  }

  Future<void> deleteConversation() async {
    if (conversationID == null) return;
    await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(
      conversationID: conversationID!,
    );
  }
}
