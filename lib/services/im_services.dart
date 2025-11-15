import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:kurban_open_im/config/app_config.dart';
import 'package:kurban_open_im/model/enum/im_platform_type.dart';
import 'package:kurban_open_im/model/enum/im_sdk_status.dart';
import 'package:kurban_open_im/services/app_global_event.dart';
import 'package:path_provider/path_provider.dart';

class ImServices extends GetxService {
  ///初始化ImSdk
  Future<bool> initImSdk() async {
    var directory = await getApplicationSupportDirectory();
    var initialized = await OpenIM.iMManager.initSDK(
      platformID: ImPlatformType.current().value,
      apiAddr: AppConfig.imApiUrl,
      wsAddr: AppConfig.imWsUrl,
      dataDir: directory.path,
      logLevel: 2,
      listener: OnConnectListener(
        onConnecting: () => imSdkStatus(IMSdkStatus.connecting),
        onConnectSuccess: () => imSdkStatus(IMSdkStatus.connectionSucceeded),
        onConnectFailed: (_, e) => imSdkStatus(IMSdkStatus.connectionFailed),
      ),
    );

    OpenIM.iMManager.conversationManager.setConversationListener(
      OnConversationListener(
        onConversationChanged: AppGlobalEvent.onConversationChanged.add,
        onNewConversation: AppGlobalEvent.onNewConversation.add,
        onTotalUnreadMessageCountChanged: AppGlobalEvent.onTotalUnreadChanged.add,
        onSyncServerFailed: (reInstall) {
          imSdkStatus(IMSdkStatus.syncFailed, reInstall: reInstall ?? false);
        },
        onSyncServerFinish: (reInstall) {
          imSdkStatus(IMSdkStatus.syncEnded, reInstall: reInstall ?? false);
        },
        onSyncServerStart: (reInstall) {
          imSdkStatus(IMSdkStatus.syncStart, reInstall: reInstall ?? false);
        },
        onSyncServerProgress: (progress) {
          imSdkStatus(IMSdkStatus.syncProgress, progress: progress);
        },
      ),
    );

    OpenIM.iMManager.messageManager.setAdvancedMsgListener(
      OnAdvancedMsgListener(
        onRecvNewMessage: AppGlobalEvent.onRecvNewMessage.add,
        onRecvC2CReadReceipt: AppGlobalEvent.onC2CReadReceipt.add,
      ),
    );


    OpenIM.iMManager.messageManager.setMsgSendProgressListener(
      OnMsgSendProgressListener(
        onProgress: (msgID, progress) {
          AppGlobalEvent.onMsgSendProgress.add((msgID: msgID, progress: progress));
        },
      ),
    );

    

    OpenIM.iMManager.friendshipManager.setFriendshipListener(
      OnFriendshipListener(
        onFriendInfoChanged: AppGlobalEvent.onFriendInfoChanged.add,
        onFriendAdded: AppGlobalEvent.onFriendListAdded.add,
        onFriendDeleted: AppGlobalEvent.onFriendListDeleted.add,
      ),
    );

    OpenIM.iMManager.groupManager.setGroupListener(
      OnGroupListener(
        onGroupInfoChanged: (info) {
          AppGlobalEvent.onGroupInfoChanged.add(info);
        },
        onGroupMemberAdded: (member) {
          AppGlobalEvent.onGroupMemberEnter.add((groupID: member.groupID ?? '', members: [member]));
        },
        onGroupMemberDeleted: (member) {
          AppGlobalEvent.onGroupMemberKicked.add((groupID: member.groupID ?? '', members: [member]));
        },
      ),
    );

    if (initialized is bool) {
      return initialized;
    } else {
      return false;
    }
  }

  void imSdkStatus(IMSdkStatus status, {bool reInstall = false, int? progress}) {
    AppGlobalEvent.imSdkStatus.add((status: status, reInstall: reInstall, progress: progress));
    // imSdkStatusPublishSubject.add((status: status, reInstall: reInstall, progress: progress));
  }
}
