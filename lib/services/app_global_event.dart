import "package:flutter_openim_sdk/flutter_openim_sdk.dart";
import "package:kurban_open_im/model/enum/im_sdk_status.dart";
import "package:rxdart_flutter/rxdart_flutter.dart";

sealed class AppGlobalEvent {
  ///ImSdk状态监听
  static var imSdkStatus = ReplaySubject<({IMSdkStatus status, bool reInstall, int? progress})>();

  ///会话更新
  static var onConversationChanged = PublishSubject<List<ConversationInfo>>();

  ///新的会话
  static var onNewConversation = PublishSubject<List<ConversationInfo>>();

  ///新消息事件
  static var onRecvNewMessage = PublishSubject<Message>();

  ///消息撤回事件
  static var onMessageRevoked = PublishSubject<String>();

  ///单聊已读回执
  static var onC2CReadReceipt = PublishSubject<List<ReadReceiptInfo>>();

  ///群聊已读信息
  static var onGroupReadReceipt = PublishSubject<List<GroupHasReadInfo>>();

  ///消息发送进度
  static var onMsgSendProgress = PublishSubject<({String msgID, int progress})>();

  ///未读总数变化
  static var onTotalUnreadChanged = PublishSubject<int>();

  static var onFriendInfoChanged = PublishSubject<FriendInfo>();
  static var onFriendListAdded = PublishSubject<FriendInfo>();
  static var onFriendListDeleted = PublishSubject<FriendInfo>();
  static var onBlacklistAdded = PublishSubject<BlacklistInfo>();
  static var onBlacklistDeleted = PublishSubject<BlacklistInfo>();

  static var onGroupInfoChanged = PublishSubject<GroupInfo>();
  static var onGroupMemberEnter = PublishSubject<({String groupID, List<GroupMembersInfo> members})>();
  static var onGroupMemberKicked = PublishSubject<({String groupID, List<GroupMembersInfo> members})>();
  static var onGroupMemberLeave = PublishSubject<({String groupID, GroupMembersInfo member})>();
}
