import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_config.dart';
import 'package:kurban_open_im/model/enum/im_platform_type.dart';
import 'package:kurban_open_im/model/enum/im_sdk_status.dart';
import 'package:kurban_open_im/services/app_global_event.dart';
import 'package:path_provider/path_provider.dart';

class AppServices extends GetxService {
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
        onConnecting: () => imSdkStatusUpdate(IMSdkStatus.connecting),
        onConnectSuccess: () => imSdkStatusUpdate(IMSdkStatus.connectionSucceeded),
        onConnectFailed: (_, e) => imSdkStatusUpdate(IMSdkStatus.connectionFailed),
      ),
    );

    OpenIM.iMManager.conversationManager.setConversationListener(
      OnConversationListener(
        onConversationChanged: AppGlobalEvent.onConversationChanged.add,
        onNewConversation: AppGlobalEvent.onNewConversation.add,
        onTotalUnreadMessageCountChanged: AppGlobalEvent.onTotalUnreadChanged.add,
        onSyncServerFailed: (reInstall) {
          imSdkStatusUpdate(IMSdkStatus.syncFailed, reInstall: reInstall ?? false);
        },
        onSyncServerFinish: (reInstall) {
          imSdkStatusUpdate(IMSdkStatus.syncEnded, reInstall: reInstall ?? false);
        },
        onSyncServerStart: (reInstall) {
          imSdkStatusUpdate(IMSdkStatus.syncStart, reInstall: reInstall ?? false);
        },
        onSyncServerProgress: (progress) {
          imSdkStatusUpdate(IMSdkStatus.syncProgress, progress: progress);
        },
      ),
    );

    OpenIM.iMManager.messageManager.setAdvancedMsgListener(
      OnAdvancedMsgListener(
        onRecvNewMessage: AppGlobalEvent.onRecvNewMessage.add,
        onRecvC2CReadReceipt: AppGlobalEvent.onC2CReadReceipt.add,
        onNewRecvMessageRevoked: (info) {
          final id = info.clientMsgID;
          if (id != null && id.isNotEmpty) {
            AppGlobalEvent.onMessageRevoked.add(id);
          }
        },
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
        onFriendAdded: AppGlobalEvent.onFriendAdded.add,
        onFriendDeleted: AppGlobalEvent.onFriendDeleted.add,
        onFriendInfoChanged: AppGlobalEvent.onFriendInfoChanged.add,
        onFriendApplicationAdded: AppGlobalEvent.onFriendApplicationChanged.add,
        onFriendApplicationAccepted: AppGlobalEvent.onFriendApplicationChanged.add,
        onFriendApplicationDeleted: AppGlobalEvent.onFriendApplicationChanged.add,
        onFriendApplicationRejected: AppGlobalEvent.onFriendApplicationChanged.add,
        onBlackAdded: AppGlobalEvent.onBlacklistAdded.add,
        onBlackDeleted: AppGlobalEvent.onBlacklistDeleted.add,
      ),
    );

    if (initialized is bool) {
      return initialized;
    } else {
      return false;
    }
  }

  void imSdkStatusUpdate(IMSdkStatus status, {bool reInstall = false, int? progress}) {
    AppGlobalEvent.imSdkStatus.add((status: status, reInstall: reInstall, progress: progress));
  }
}
