import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

  final ScrollController scrollController = ScrollController();
  int _offset = 0;
  final int _count = 30;
  bool _loading = false;
  bool _noMore = false;

  @override
  void onInit() {
    super.onInit();
    getConversationList();
    AppGlobalEvent.onConversationChanged.listen(_onConversationChanged);
    AppGlobalEvent.onNewConversation.listen(_onConversationChanged);
    AppGlobalEvent.imSdkStatus.listen(_imSdkStatusChanged);
    scrollController.addListener(_onScroll);
  }

  ///获取会话集合
  Future<void> getConversationList() async {
    _offset = 0;
    _noMore = false;
    final res = await OpenIM.iMManager.conversationManager.getConversationListSplit(
      offset: _offset,
      count: _count,
    );
    conversationList.assignAll(res);
  }

  Future<void> loadMore() async {
    if (_loading || _noMore) return;
    _loading = true;
    _offset += _count;
    final res = await OpenIM.iMManager.conversationManager.getConversationListSplit(
      offset: _offset,
      count: _count,
    );
    if (res.isEmpty) {
      _noMore = true;
    } else {
      conversationList.addAll(res);
      _sortConversation();
    }
    _loading = false;
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

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      loadMore();
    }
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

  ///设置会话置顶
  Future<void> setPinned(String conversationID, bool pinned) async {
    try {
      await OpenIM.iMManager.conversationManager.pinConversation(
        conversationID: conversationID,
        isPinned: pinned,
      );
      await getConversationList();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///设置免打扰
  Future<void> setRecvOpt(String conversationID, int recvOpt) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversation(conversationID, ConversationReq());
      await getConversationList();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }
}
