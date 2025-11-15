import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';

class ChatLogic extends GetxController {
  ///是否群聊
  late bool isGroup;

  ///单聊接收方ID
  String? recvID;

  ///群聊ID
  String? groupID;

  ///会话ID
  String? conversationID;

  ///页面标题
  String title = "";

  ///消息列表
  final RxList<Message> messages = <Message>[].obs;

  ///输入框控制器
  late TextEditingController inputController;

  ///滚动控制器
  late ScrollController scrollController;

  ///高级消息监听器
  late OnAdvancedMsgListener msgListener;

  @override
  void onInit() {
    super.onInit();
    inputController = TextEditingController();
    scrollController = ScrollController();
    _initArgs();
    _loadHistory();
    _listenMessage();
    scrollController.addListener(_onScroll);
  }

  void _initArgs() {
    final args = Get.arguments ?? {};
    isGroup = args["isGroup"] == true;
    recvID = args["recvID"];
    groupID = args["groupID"];
    title = args["title"] ?? "";
  }

  ///加载历史消息
  Future<void> _loadHistory() async {
    try {
      final sourceID = isGroup ? groupID : recvID;
      if (sourceID == null) return;
      conversationID = await OpenIM.iMManager.conversationManager.getConversationIDBySessionType(
        sourceID: sourceID,
        sessionType: isGroup ? ConversationType.superGroup : ConversationType.single,
      );
      final am = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageListReverse(
        conversationID: conversationID,
        startMsg: null,
        count: 30,
      );
      messages.assignAll(am.messageList ?? []);
      await _clearUnread();
      _scrollToBottom();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  bool _loadingMore = false;
  Future<void> _loadMoreHistory() async {
    if (_loadingMore || conversationID == null) return;
    _loadingMore = true;
    try {
      final first = messages.isNotEmpty ? messages.first : null;
      final res = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
        conversationID: conversationID,
        startMsg: first,
        count: 20,
      );
      final list = res.messageList ?? [];
      if (list.isNotEmpty) {
        messages.insertAll(0, list);
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
    _loadingMore = false;
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels <= 50) {
      _loadMoreHistory();
    }
  }

  ///监听新消息
  void _listenMessage() {
    msgListener = OnAdvancedMsgListener(
      onRecvNewMessage: (msg) {
        final isCurrent = isGroup
            ? msg.groupID == groupID
            : msg.sendID == recvID || msg.recvID == recvID;
        if (isCurrent) {
          messages.add(msg);
          _scrollToBottom();
        }
      },
    );
    OpenIM.iMManager.messageManager.setAdvancedMsgListener(msgListener);
  }

  ///发送文本消息
  Future<void> sendText() async {
    final content = inputController.text.trim();
    if (content.isEmpty) return;
    try {
      final msg = await OpenIM.iMManager.messageManager.createTextMessage(text: content);
      final push = OfflinePushInfo();
      final resp = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: isGroup ? null : recvID,
        groupID: isGroup ? groupID : null,
        offlinePushInfo: push,
      );
      messages.add(resp);
      inputController.clear();
      _scrollToBottom();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> _send(Message msg) async {
    final push = OfflinePushInfo();
    final resp = await OpenIM.iMManager.messageManager.sendMessage(
      message: msg,
      userID: isGroup ? null : recvID,
      groupID: isGroup ? groupID : null,
      offlinePushInfo: push,
    );
    messages.add(resp);
    _scrollToBottom();
  }

  Future<void> sendImage(File file) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
        imagePath: file.path,
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendVideo(File file, int durationMs) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createVideoMessageFromFullPath(
        videoPath: file.path,
        duration: durationMs,
        snapshotPath: file.path,
        videoType: 'mp4',
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendVoice(File file, int durationSec) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createSoundMessageFromFullPath(
        soundPath: file.path,
        duration: durationSec,
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendFile(File file) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createFileMessageFromFullPath(
        filePath: file.path,
        fileName: file.uri.pathSegments.last,
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendLocation(String title, double latitude, double longitude) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createLocationMessage(
        description: title,
        longitude: longitude,
        latitude: latitude,
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendCard({String? userID, String? groupID}) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createCustomMessage(
        data: jsonEncode({"type": "card", "userID": userID, "groupID": groupID}),
        extension: "",
        description: "名片",
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendMerger(List<Message> selected) async {
    try {
      final titles = selected.map((e) => e.senderNickname ?? e.sendID ?? '').toList();
      final msg = await OpenIM.iMManager.messageManager.createMergerMessage(
        title: "聊天记录",
        summaryList: titles,
        messageList: selected,
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendQuote(Message origin, String text) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createQuoteMessage(
        quoteMsg: origin,
        text: text,
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> forward(Message origin) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createForwardMessage(message: origin);
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  

  Future<void> sendCustom(Map<String, dynamic> payload) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createCustomMessage(
        data: jsonEncode(payload),
        extension: "",
        description: "自定义",
      );
      await _send(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> _clearUnread() async {
    try {
      if (conversationID != null) {
        await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
          conversationID: conversationID!,
        );
      }
    } catch (_) {}
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> revoke(Message msg) async {
    try {
      if (conversationID == null || msg.clientMsgID == null) return;
      await OpenIM.iMManager.messageManager.revokeMessage(
        clientMsgID: msg.clientMsgID!,
        conversationID: conversationID!,
      );
      messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> deleteLocal(Message msg) async {
    try {
      if (conversationID == null || msg.clientMsgID == null) return;
      await OpenIM.iMManager.messageManager.deleteMessageFromLocalStorage(
        clientMsgID: msg.clientMsgID!,
        conversationID: conversationID!,
      );
      messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  void onInputChanged(String text) {
    try {
      if (conversationID != null) {
        OpenIM.iMManager.conversationManager.changeInputStates(
          conversationID: conversationID!,
          focus: text.isNotEmpty,
        );
      }
    } catch (_) {}
  }

  Future<void> deleteOnServer(Message msg) async {
    // 当前 SDK 版本未提供服务端单条删除接口
  }

  Future<void> clearLocalAll() async {
    // 当前 SDK 版本未提供按会话清空本地接口
  }

  Future<void> clearLocalAndServerAll() async {
    // 当前 SDK 版本未提供按会话清空本地与服务端接口
  }

  Future<void> sendAt(List<String> atUserIDs, String text) async {
    if (text.isEmpty) return;
    final msg = await OpenIM.iMManager.messageManager.createTextAtMessage(
      text: text,
      atUserIDList: atUserIDs,
      quoteMessage: null,
    );
    await _send(msg);
  }

  Future<void> sendEmoji(int index, String data) async {
    final msg = await OpenIM.iMManager.messageManager.createFaceMessage(index: index, data: data);
    await _send(msg);
  }

  Future<void> insertLocalSingle(Message msg) async {
    final me = await OpenIM.iMManager.userManager.getSelfUserInfo();
    final uid = me.userID ?? '';
    await OpenIM.iMManager.messageManager.insertSingleMessageToLocalStorage(
      message: msg,
      receiverID: recvID ?? '',
      senderID: uid,
    );
    messages.add(msg);
  }

  Future<void> insertLocalGroup(Message msg) async {
    final me = await OpenIM.iMManager.userManager.getSelfUserInfo();
    final uid = me.userID ?? '';
    await OpenIM.iMManager.messageManager.insertGroupMessageToLocalStorage(
      message: msg,
      groupID: groupID ?? '',
      senderID: uid,
    );
    messages.add(msg);
  }

  Future<void> setLocalEx(Message msg, Map<String, dynamic> ex) async {
    // 依据 SDK 方法签名调整后再启用
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    // 页面关闭时不再设置高级消息监听（如需移除请在全局服务统一管理）
    super.onClose();
  }
}
