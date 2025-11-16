import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/extension/context_extension.dart';
import 'package:kurban_open_im/model/enum/chat_button_type.dart';
import 'package:kurban_open_im/model/enum/panel_type.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_bottom_emoji_pane.dart';
import 'package:kurban_open_im/pages/chat/widgets/chat_bottom_tool_pane.dart';

class ChatInputBar extends GetWidget<ChatLogic> {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    var viewPadding = context.getViewPadding;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            right: 8.w,
            left: 8.w,
            bottom: viewPadding.bottom + 16.h,
            top: 4.h,
          ),
          child: Row(
            crossAxisAlignment: .center,
            children: [
              IconButton(onPressed: controller.onRecordTap, icon: Icon(Icons.mic)),
              Expanded(
                child: TextField(
                  controller: controller.inputController,
                  focusNode: controller.inputFocusNode,
                  decoration: const InputDecoration(hintText: "输入消息", isDense: true),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              IconButton(
                onPressed: controller.onEmojiBtnTap,
                icon: Icon(Icons.emoji_emotions_outlined),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.bottonType.value == ChatButtonType.send,
                  replacement: IconButton(
                    onPressed: controller.onToolBtnTap,
                    icon: Icon(Icons.add_circle_outline),
                  ),
                  child: IconButton(onPressed: controller.sendText, icon: Icon(Icons.send)),
                );
              }),
            ],
          ),
        ),
        ChatBottomPanelContainer<PanelType>(
          controller: controller.bottomController,
          inputFocusNode: controller.inputFocusNode,
          otherPanelWidget: (type) {
            if (type == null) return SizedBox.shrink();
            switch (type) {
              case PanelType.emoji:
                return ChatBottomEmojiPane();
              case PanelType.tool:
                return ChatBottomToolPane();
              default:
                return SizedBox.shrink();
            }
          },
          onPanelTypeChange: (panelType, data) {
            // 记录当前的面板类型
            switch (panelType) {
              case ChatBottomPanelType.none:
                controller.currentPanelType = PanelType.none;
                break;
              case ChatBottomPanelType.keyboard:
                controller.currentPanelType = PanelType.keyboard;
                break;
              case ChatBottomPanelType.other:
                if (data == null) return;
                switch (data) {
                  case PanelType.emoji:
                    controller.currentPanelType = PanelType.emoji;
                    break;
                  case PanelType.tool:
                    controller.currentPanelType = PanelType.tool;
                    break;
                  default:
                    controller.currentPanelType = PanelType.none;
                    break;
                }
                break;
            }
          },
        ),
      ],
    );
  }
}
