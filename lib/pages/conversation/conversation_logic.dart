import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
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

  ///搜索关键字
  final RxString searchKeyword = ''.obs;

  ///过滤后的会话列表
  List<ConversationInfo> get filteredConversationList {
    if (searchKeyword.value.isEmpty) {
      return conversationList;
    }
    return conversationList.where((conv) {
      final name = conv.showName?.toLowerCase() ?? '';
      final keyword = searchKeyword.value.toLowerCase();
      return name.contains(keyword);
    }).toList();
  }

  ///总未读消息数
  final RxInt totalUnreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getConversationList();
    getTotalUnreadMsgCount();
    AppGlobalEvent.onConversationChanged.listen(_onConversationChanged);
    AppGlobalEvent.onNewConversation.listen(_onConversationChanged);
    AppGlobalEvent.onTotalUnreadChanged.listen(_onTotalUnreadMsgCountChanged);
    AppGlobalEvent.imSdkStatus.listen(_imSdkStatusChanged);
  }

  ///获取会话集合
  Future<void> getConversationList() async {
    final res = await OpenIM.iMManager.conversationManager.getAllConversationList();
    conversationList.assignAll(res);
    _sortConversation();
  }

  ///分页获取会话列表
  Future<List<ConversationInfo>> getConversationListSplit({
    required int offset,
    required int count,
  }) async {
    final res = await OpenIM.iMManager.conversationManager.getConversationListSplit(
      offset: offset,
      count: count,
    );
    return res;
  }

  ///获取单个会话
  Future<ConversationInfo?> getOneConversation({String? sourceID, int? sessionType}) async {
    try {
      final res = await OpenIM.iMManager.conversationManager.getOneConversation(
        sourceID: sourceID ?? '',
        sessionType: sessionType ?? 0,
      );
      return res;
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      return null;
    }
  }

  ///获取多个会话
  Future<List<ConversationInfo>> getMultipleConversation({
    required List<String> conversationIDList,
  }) async {
    final res = await OpenIM.iMManager.conversationManager.getMultipleConversation(
      conversationIDList: conversationIDList,
    );
    return res;
  }

  ///获取总未读消息数
  Future<void> getTotalUnreadMsgCount() async {
    try {
      final count = await OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount();
      totalUnreadCount.value = int.tryParse(count) ?? 0;
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///监听总未读消息数变化
  void _onTotalUnreadMsgCountChanged(int count) {
    totalUnreadCount.value = count;
  }

  ///接收到会话更新,接收到新的会话
  void _onConversationChanged(List<ConversationInfo> newList) {
    info("接收到会话更新,接收到新的会话");
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

  ///标记会话消息为已读
  Future<void> markConversationMessageAsRead(String conversationID) async {
    try {
      await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
        conversationID: conversationID,
      );
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///设置会话草稿
  Future<void> setConversationDraft({
    required String conversationID,
    required String draftText,
  }) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversationDraft(
        conversationID: conversationID,
        draftText: draftText,
      );
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///删除会话
  Future<void> deleteConversation(String conversationID) async {
    try {
      await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(
        conversationID: conversationID,
      );
      conversationList.removeWhere((e) => e.conversationID == conversationID);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///清空会话消息
  Future<void> clearConversationAndDeleteAllMsg(String conversationID) async {
    try {
      await OpenIM.iMManager.conversationManager.clearConversationAndDeleteAllMsg(
        conversationID: conversationID,
      );
      await getConversationList();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///设置会话信息（免打扰等）
  Future<void> setConversation({
    required String conversationID,
    int? recvMsgOpt,
    bool? isPinned,
    int? groupAtType,
  }) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversation(
        conversationID,
        ConversationReq(recvMsgOpt: recvMsgOpt, isPinned: isPinned, groupAtType: groupAtType),
      );
      await getConversationList();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///设置免打扰
  Future<void> setRecvMsgOpt({required String conversationID, required int recvMsgOpt}) async {
    try {
      await setConversation(conversationID: conversationID, recvMsgOpt: recvMsgOpt);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///批量设置免打扰
  Future<void> setMultipleConversationRecvMsgOpt({
    required List<String> conversationIDList,
    required int status,
  }) async {
    try {
      await Future.wait(
        conversationIDList.map(
          (conversationID) => OpenIM.iMManager.conversationManager.setConversation(
            conversationID,
            ConversationReq(recvMsgOpt: status),
          ),
        ),
      );
      await getConversationList();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///获取会话ID
  Future<String> getConversationIDBySessionType({
    required String sourceID,
    required int sessionType,
  }) async {
    return await OpenIM.iMManager.conversationManager.getConversationIDBySessionType(
      sourceID: sourceID,
      sessionType: sessionType,
    );
  }

  ///更新搜索关键字
  void updateSearchKeyword(String keyword) {
    searchKeyword.value = keyword;
  }

  ///清空搜索
  void clearSearch() {
    searchKeyword.value = '';
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
