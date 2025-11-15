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
}
