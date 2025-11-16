import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_config.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/enum/chat_button_type.dart';
import 'package:kurban_open_im/model/enum/panel_type.dart';
import 'package:kurban_open_im/utils/app_util.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class ChatLogic extends GetxController {
  final ConversationInfo conversation;

  ChatLogic({required this.conversation});

  String? get userID => conversation.userID;

  ///群聊ID
  String? get groupID => conversation.groupID;

  bool get isSingleChat => null != userID && userID!.trim().isNotEmpty;

  bool get isGroupChat => null != groupID && groupID!.trim().isNotEmpty;

  ///单聊接收方ID
  String? get recvID => conversation.userID;

  ///会话ID
  String get conversationID => conversation.conversationID;

  ///页面标题
  String get title => conversation.showName ?? "";

  ///消息列表
  final RxList<Message> messages = <Message>[].obs;

  ///输入框控制器
  late TextEditingController inputController;

  ///滚动控制器
  late ScrollController scrollController;

  ///高级消息监听器
  late OnAdvancedMsgListener msgListener;

  ///加载历史记录每次获取的数量
  final int count = 20;

  final bottomController = ChatBottomPanelContainerController<PanelType>();

  final FocusNode inputFocusNode = FocusNode();

  PanelType currentPanelType = PanelType.none;

  final Rx<ChatButtonType> bottonType = ChatButtonType.tool.obs;

  late ListObserverController chatListObserver;

  late ChatScrollObserver chatScrollObserver;

  @override
  void onInit() {
    super.onInit();
    inputController = TextEditingController();
    scrollController = ScrollController();
    chatListObserver = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;
    chatScrollObserver = ChatScrollObserver(chatListObserver)
      ..fixedPositionOffset = 5
      ..onHandlePositionResultCallback = _onHandlePositionResultCallback;
    scrollController.addListener(_scrollListen);
    inputController.addListener(_inputListen);
    _loadMessages();
  }

  ///监听输入框切换发送和更多面板按钮
  void _inputListen() {
    var text = inputController.text;
    if (text.isEmpty) {
      bottonType.value = ChatButtonType.tool;
    } else {
      bottonType.value = ChatButtonType.send;
    }
  }

  ///聊天消息位置的处理回调
  void _onHandlePositionResultCallback(ChatScrollObserverHandlePositionResultModel result) {
    switch (result.type) {
      case ChatScrollObserverHandlePositionType.keepPosition:
        // 保持当前聊天消息位置
        // updateUnreadMsgCount(changeCount: result.changeCount);
        break;
      case ChatScrollObserverHandlePositionType.none:
        // 对聊天消息位置不做处理
        // updateUnreadMsgCount(isReset: true);
        break;
    }
  }

  ///监听滑动
  void _scrollListen() {
    if (_isTop) {
      loadMoreHistory();
    }
  }

  bool get _isTop {
    return scrollController.offset >= scrollController.position.maxScrollExtent;
  }

  ///加载历史消息
  Future<void> _loadMessages() async {
    try {
      var message = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
        conversationID: conversationID,
        startMsg: null,
        count: count,
      );
      if (message.messageList != null && message.messageList!.isNotEmpty) {
        messages.assignAll(message.messageList!);
      }
      _scrollToBottom();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///加载更多消息
  Future<bool> loadMoreHistory() async {
    info("加载更多消息");
    final first = messages.isNotEmpty ? messages.first : null;
    final res = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
      conversationID: conversationID,
      startMsg: first,
      count: count,
    );
    if (res.messageList == null || res.messageList!.isEmpty) {
      return false;
    }
    messages.insertAll(0, res.messageList!);
    chatScrollObserver.standby(changeCount: res.messageList!.length);
    return res.isEnd != true;
  }

  ///发送文本消息
  Future<void> sendText() async {
    final content = inputController.text.trim();
    if (content.isEmpty) return;
    try {
      final msg = await OpenIM.iMManager.messageManager.createTextMessage(text: content);
      _sendMessage(msg);
      inputController.clear();
      // _scrollToBottom(isAnimate: true);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> _sendMessage(Message msg) async {
    final resp = await OpenIM.iMManager.messageManager.sendMessage(
      message: msg,
      userID: isGroupChat ? null : recvID,
      groupID: isGroupChat ? groupID : null,
      offlinePushInfo: AppConfig.offlinePushInfo,
    );
    messages.add(resp);
    chatScrollObserver.standby();
  }

  Future<void> sendImage(File file) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
        imagePath: file.path,
      );
      await _sendMessage(msg);
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
      await _sendMessage(msg);
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
      await _sendMessage(msg);
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
      await _sendMessage(msg);
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
      await _sendMessage(msg);
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
      await _sendMessage(msg);
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
      await _sendMessage(msg);
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
      await _sendMessage(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  void _scrollToBottom({bool isAnimate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        if (isAnimate) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        } else {
          scrollController.jumpTo(0);
        }
      }
    });
  }

  Future<void> revoke(Message msg) async {
    try {
      if (msg.clientMsgID == null) return;
      await OpenIM.iMManager.messageManager.revokeMessage(
        clientMsgID: msg.clientMsgID!,
        conversationID: conversationID,
      );
      messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendAt(List<String> atUserIDs, String text) async {
    if (text.isEmpty) return;
    final msg = await OpenIM.iMManager.messageManager.createTextAtMessage(
      text: text,
      atUserIDList: atUserIDs,
      quoteMessage: null,
    );
    await _sendMessage(msg);
  }

  Message indexOfMessage(int index, {bool calculate = true}) =>
      AppUtil.calChatTimeInterval(messages, calculate: calculate).reversed.elementAt(index);

  ///点击录音按钮
  void onRecordTap() {
    inputFocusNode.unfocus();
    bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
  }

  ///点击表情面板
  void onEmojiBtnTap() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
      bottomController.updatePanelType(ChatBottomPanelType.other, data: PanelType.emoji);
    } else {
      if (currentPanelType == PanelType.tool || currentPanelType == PanelType.none) {
        bottomController.updatePanelType(ChatBottomPanelType.other, data: PanelType.emoji);
      } else {
        inputFocusNode.requestFocus();
        bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
      }
    }
  }

  ///点击更多面板
  void onToolBtnTap() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
      bottomController.updatePanelType(ChatBottomPanelType.other, data: PanelType.tool);
    } else {
      if (currentPanelType == PanelType.emoji || currentPanelType == PanelType.none) {
        bottomController.updatePanelType(ChatBottomPanelType.other, data: PanelType.tool);
      } else {
        inputFocusNode.requestFocus();
        bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
      }
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.removeListener(_scrollListen);
    scrollController.dispose();
    super.onClose();
  }
}
