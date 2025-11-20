import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:kurban_open_im/config/app_config.dart';
import 'package:kurban_open_im/model/enum/im_platform_type.dart';
import 'package:kurban_open_im/model/enum/im_sdk_status.dart';
import 'package:kurban_open_im/services/app_callback.dart';
import 'package:path_provider/path_provider.dart';

class AppServices extends GetxService with AppCallback {
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
        onConversationChanged: onConversationChanged.add,
        onNewConversation: onNewConversation.add,
        onTotalUnreadMessageCountChanged: onTotalUnreadChanged.add,
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
        onRecvNewMessage: onRecvNewMessage.add,
        onRecvC2CReadReceipt: onC2CReadReceipt.add,
        onNewRecvMessageRevoked: (info) {
          final id = info.clientMsgID;
          if (id != null && id.isNotEmpty) {
            onMessageRevoked.add(id);
          }
        },
      ),
    );

    OpenIM.iMManager.messageManager.setMsgSendProgressListener(
      OnMsgSendProgressListener(
        onProgress: (msgID, progress) {
          onMsgSendProgress.add((msgID: msgID, progress: progress));
        },
      ),
    );

    if (initialized is bool) {
      return initialized;
    } else {
      return false;
    }
  }

  void imSdkStatusUpdate(IMSdkStatus status, {bool reInstall = false, int? progress}) {
    imSdkStatus.add((status: status, reInstall: reInstall, progress: progress));
  }
}
