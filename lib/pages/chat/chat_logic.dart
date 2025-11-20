import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurban_open_im/config/app_config.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/enum/chat_button_type.dart';
import 'package:kurban_open_im/model/enum/panel_type.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_card_picker_dialog.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_location_picker_dialog.dart';
import 'package:kurban_open_im/services/app_services.dart';
import 'package:kurban_open_im/utils/app_util.dart';
import 'package:kurban_open_im/utils/file_util.dart';
import 'package:kurban_open_im/utils/permission_util.dart';
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

  ///加载历史记录每次获取的数量
  final int count = 20;

  final bottomController = ChatBottomPanelContainerController<PanelType>();

  final FocusNode inputFocusNode = FocusNode();

  PanelType currentPanelType = PanelType.none;

  final Rx<ChatButtonType> bottonType = ChatButtonType.tool.obs;

  late ListObserverController chatListObserver;

  late ChatScrollObserver chatScrollObserver;

  late final AppServices _appServices;

  final RxMap<String, int> sendingProgress = <String, int>{}.obs;

  late final StreamSubscription<Message> _newMessageSubscription;

  late final StreamSubscription<String> _messageRevokedSubscription;

  late final StreamSubscription<({String msgID, int progress})> _sendProgressSubscription;

  @override
  void onInit() {
    super.onInit();
    _appServices = Get.find<AppServices>();
    inputController = TextEditingController();
    scrollController = ScrollController();
    chatListObserver = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;
    chatScrollObserver = ChatScrollObserver(chatListObserver)
      ..fixedPositionOffset = 5
      ..onHandlePositionResultCallback = _onHandlePositionResultCallback;
    scrollController.addListener(_scrollListen);
    inputController.addListener(_inputListen);
    _newMessageSubscription = _appServices.onRecvNewMessage.listen(_onRecvNewMessage);
    _messageRevokedSubscription = _appServices.onMessageRevoked.listen(_onMessageRevoked);
    _sendProgressSubscription = _appServices.onMsgSendProgress.listen(_onMsgSendProgress);
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
    inputFocusNode.unfocus();
    bottomController.updatePanelType(ChatBottomPanelType.none);
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

  Future<void> _sendMessage(Message msg) async {
    final id = msg.clientMsgID;
    if (id != null) {
      sendingProgress[id] = 0;
    }
    try {
      final resp = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: isGroupChat ? null : recvID,
        groupID: isGroupChat ? groupID : null,
        offlinePushInfo: AppConfig.offlinePushInfo,
      );
      messages.add(resp);
      chatScrollObserver.standby();
    } finally {
      if (id != null) {
        Future<void>.delayed(const Duration(seconds: 1), () {
          sendingProgress.remove(id);
        });
      }
    }
  }

  ///接收到新的消息
  void _onRecvNewMessage(Message msg) {
    if (isGroupChat) {
      if (msg.groupID != groupID) return;
    } else {
      final peerID = userID;
      if (peerID == null) return;
      final selfID = userInfo.value.userID;
      final fromPeer = msg.sendID == peerID && (selfID == null || msg.recvID == selfID);
      final fromSelf = selfID != null && msg.sendID == selfID && msg.recvID == peerID;
      if (!fromPeer && !fromSelf) return;
    }
    info("接收到新的单个消息：${msg.clientMsgID}");
    messages.add(msg);
    chatScrollObserver.standby();
    _scrollToBottom();
  }

  void _onMessageRevoked(String msgID) {
    final index = messages.indexWhere((element) => element.clientMsgID == msgID);
    if (index == -1) return;
    messages.removeAt(index);
  }

  void _onMsgSendProgress(({String msgID, int progress}) event) {
    sendingProgress[event.msgID] = event.progress;
    if (event.progress >= 100) {
      Future<void>.delayed(const Duration(seconds: 1), () {
        sendingProgress.remove(event.msgID);
      });
    }
  }

  ///发送文本消息
  Future<void> sendText() async {
    final content = inputController.text.trim();
    if (content.isEmpty) return;
    try {
      final msg = await OpenIM.iMManager.messageManager.createTextMessage(text: content);
      _sendMessage(msg);
      inputController.clear();
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///选择图片
  Future<void> selectImage() async {
    var hasPermission = await PermissionUtil.albumPermission();
    info("是否有权限：${hasPermission.toString()}");
    if (hasPermission) {
      ImagePicker imagePicker = ImagePicker();
      var result = await imagePicker.pickMultipleMedia(limit: 9);
      for (var file in result) {
        var fileType = FileUtil.getFileType(file.path);
        if (fileType != FileType.none) {
          if (fileType == FileType.image) {
            await sendImage(file);
          } else if (fileType == FileType.video) {
            await sendVideo(file);
          }
        }
      }
      bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
    }
  }

  Future<void> captureImage() async {
    final granted = await PermissionUtil.cameraPermission();
    if (!granted) return;
    try {
      final picker = ImagePicker();
      final result = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (result != null) {
        await sendImage(result);
        bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> selectFile() async {
    try {
      final result = await file_picker.FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: file_picker.FileType.any,
      );
      if (result == null) return;
      for (final file in result.files) {
        final path = file.path;
        if (path == null) continue;
        await sendFile(File(path));
      }
      bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
    } on PlatformException catch (e) {
      error("选择文件失败：${e.message}");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> selectLocation() async {
    final context = Get.context;
    if (context == null) return;
    final result = await ChatLocationPickerDialog.show(context);
    if (result == null) return;
    await sendLocation(result.title, result.latitude, result.longitude);
    bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
  }

  Future<void> selectCard() async {
    final context = Get.context;
    if (context == null) return;
    final result = await ChatCardPickerDialog.show(context, isGroup: isGroupChat);
    if (result == null) return;
    await sendCard(
      userID: result.userID,
      groupID: result.groupID,
      name: result.name,
      faceURL: result.faceURL,
    );
    bottomController.updatePanelType(ChatBottomPanelType.none, data: PanelType.none);
  }

  void startVideoCall() {
    final targetID = isGroupChat ? groupID : userID;
    if (targetID == null) {
      Get.snackbar("提示", "暂不支持的视频通话类型");
      return;
    }
    Get.snackbar("提示", "视频通话功能开发中");
  }

  Future<void> sendImage(XFile file) async {
    try {
      final msg = await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
        imagePath: file.path,
      );
      await _sendMessage(msg);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> sendVideo(XFile file) async {
    try {
      var duration = await FileUtil.getVideoDurationFromFile(file.path);
      final msg = await OpenIM.iMManager.messageManager.createVideoMessageFromFullPath(
        videoPath: file.path,
        duration: duration,
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

  Future<void> sendCard({String? userID, String? groupID, String? name, String? faceURL}) async {
    try {
      final payload = <String, dynamic>{
        "type": "card",
        if (userID != null) "userID": userID,
        if (groupID != null) "groupID": groupID,
        if (name != null && name.isNotEmpty) "name": name,
        if (faceURL != null && faceURL.isNotEmpty) "faceURL": faceURL,
      };
      final desc = groupID != null ? "群名片" : "个人名片";
      final msg = await OpenIM.iMManager.messageManager.createCustomMessage(
        data: jsonEncode(payload),
        extension: "",
        description: desc,
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

  void insertEmoji(String emoji) {
    // 获取当前的光标位置
    final int selectionStart = inputController.selection.start;
    final int selectionEnd = inputController.selection.end;
    // 获取当前文本
    final String text = inputController.text;
    if (selectionStart < 0) {
      // 如果没有焦点或光标位置无效，则简单地追加到末尾
      inputController.text += emoji;
    } else {
      // 在光标位置插入表情
      final String newText = text.replaceRange(selectionStart, selectionEnd, emoji);
      // 更新文本
      inputController.text = newText;
      // 移动光标到插入的表情之后
      inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: selectionStart + emoji.length),
      );
    }
  }

  @override
  void onClose() {
    _newMessageSubscription.cancel();
    _messageRevokedSubscription.cancel();
    _sendProgressSubscription.cancel();
    inputController.dispose();
    scrollController.removeListener(_scrollListen);
    scrollController.dispose();
    super.onClose();
  }
}
