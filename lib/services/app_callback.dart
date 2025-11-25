import "package:flutter_openim_sdk/flutter_openim_sdk.dart";
import "package:kurban_open_im/model/enum/im_sdk_status.dart";
import "package:rxdart_flutter/rxdart_flutter.dart";

mixin AppCallback {
  ///ImSdk状态监听
  var imSdkStatus = BehaviorSubject<({IMSdkStatus status, bool reInstall, int? progress})>.seeded((
    status: IMSdkStatus.connectionSucceeded,
    reInstall: false,
    progress: null,
  ));

  ///会话更新
  var onConversationChanged = PublishSubject<List<ConversationInfo>>();

  ///新的会话
  var onNewConversation = PublishSubject<List<ConversationInfo>>();

  ///新消息事件
  var onRecvNewMessage = PublishSubject<Message>();

  ///消息撤回事件
  var onMessageRevoked = PublishSubject<String>();

  ///单聊已读回执
  var onC2CReadReceipt = PublishSubject<List<ReadReceiptInfo>>();

  ///群聊已读信息
  var onGroupReadReceipt = PublishSubject<List<GroupHasReadInfo>>();

  ///消息发送进度
  var onMsgSendProgress = PublishSubject<({String msgID, int progress})>();

  ///未读总数变化
  var onTotalUnreadChanged = PublishSubject<int>();
}
