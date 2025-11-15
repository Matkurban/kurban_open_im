import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/enum/im_sdk_status.dart';
import 'package:kurban_open_im/services/app_global_event.dart';

class ConversationLogic extends GetxController {
  ///会话列表集合
  final RxList<ConversationInfo> conversationList = <ConversationInfo>[].obs;

  ///imSdk的状态
  final imStatus = IMSdkStatus.connectionSucceeded.obs;

  ///是否是重新安装
  bool reInstall = false;

  @override
  void onInit() {
    super.onInit();
    getConversationList();
    AppGlobalEvent.onConversationChanged.listen(_onConversationChanged);
    AppGlobalEvent.onNewConversation.listen(_onConversationChanged);
    AppGlobalEvent.imSdkStatus.listen(_imSdkStatusChanged);
  }

  ///获取会话集合
  Future<void> getConversationList() async {
    var list = await OpenIM.iMManager.conversationManager.getAllConversationList();
    conversationList.assignAll(list);
  }

  ///接收到会话更新,接收到新的会话
  void _onConversationChanged(List<ConversationInfo> newList) {
    if (reInstall) {
      conversationList.addAll(newList);
    }
    for (var conversion in newList) {
      conversationList.removeWhere((e) => e.conversationID == conversion.conversationID);
    }
    conversationList.insertAll(0, newList);
    _sortConversation();
  }

  void _sortConversation() {
    OpenIM.iMManager.conversationManager.simpleSort(conversationList);
  }

  void _imSdkStatusChanged(({IMSdkStatus status, bool reInstall, int? progress}) value) {
    final status = value.status;
    final appReInstall = value.reInstall;
    final progress = value.progress;
    imStatus.value = status;
    if (status == IMSdkStatus.syncStart) {
      reInstall = appReInstall;
    }
    info('IM SDK Status: $status, reinstall: $reInstall, progress: $progress');
    if (status == IMSdkStatus.syncEnded || status == IMSdkStatus.syncFailed) {
      if (reInstall) {
        reInstall = false;
      }
    }
  }
}
