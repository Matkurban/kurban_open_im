import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';
import 'package:kurban_open_im/pages/chat/widgets/mention_picker.dart';
import 'package:kurban_open_im/pages/chat/widgets/emoji_picker.dart';

class ChatActionPanel extends StatelessWidget {
  const ChatActionPanel({super.key});

  ChatLogic get logic => Get.find<ChatLogic>();

  Future<void> _pickImage(BuildContext context) async {
    final assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(requestType: RequestType.image, maxAssets: 1),
    );
    if (assets != null && assets.isNotEmpty) {
      final file = await assets.first.file;
      if (file != null) {
        await logic.sendImage(File(file.path));
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(requestType: RequestType.video, maxAssets: 1),
    );
    if (assets != null && assets.isNotEmpty) {
      final entity = assets.first;
      final file = await entity.file;
      if (file != null) {
        final durationMs = (entity.duration) * 1000;
        await logic.sendVideo(File(file.path), durationMs);
      }
    }
  }

  Future<void> _sendLocation(BuildContext context) async {
    final titleCtrl = TextEditingController();
    final latCtrl = TextEditingController();
    final lngCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('发送位置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(hintText: '标题'),
              ),
              TextField(
                controller: latCtrl,
                decoration: const InputDecoration(hintText: '纬度'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lngCtrl,
                decoration: const InputDecoration(hintText: '经度'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('发送')),
          ],
        );
      },
    );
    if (ok == true) {
      final title = titleCtrl.text.trim();
      final lat = double.tryParse(latCtrl.text.trim()) ?? 0;
      final lng = double.tryParse(lngCtrl.text.trim()) ?? 0;
      await logic.sendLocation(title, lat, lng);
    }
  }

  Future<void> _sendCard(BuildContext context) async {
    final userCtrl = TextEditingController();
    final groupCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('发送名片'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(hintText: '用户ID'),
              ),
              TextField(
                controller: groupCtrl,
                decoration: const InputDecoration(hintText: '群ID'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('发送')),
          ],
        );
      },
    );
    if (ok == true) {
      final uid = userCtrl.text.trim().isEmpty ? null : userCtrl.text.trim();
      final gid = groupCtrl.text.trim().isEmpty ? null : groupCtrl.text.trim();
      await logic.sendCard(userID: uid, groupID: gid);
    }
  }

  Future<void> _sendVoice(BuildContext context) async {
    final pathCtrl = TextEditingController();
    final durCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('发送语音'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pathCtrl,
                decoration: const InputDecoration(hintText: '文件路径'),
              ),
              TextField(
                controller: durCtrl,
                decoration: const InputDecoration(hintText: '时长(秒)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('发送')),
          ],
        );
      },
    );
    if (ok == true) {
      final path = pathCtrl.text.trim();
      final d = int.tryParse(durCtrl.text.trim()) ?? 0;
      if (path.isNotEmpty) {
        await logic.sendVoice(File(path), d);
      }
    }
  }

  Future<void> _sendFile(BuildContext context) async {
    final pathCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('发送文件'),
          content: TextField(
            controller: pathCtrl,
            decoration: const InputDecoration(hintText: '文件路径'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('发送')),
          ],
        );
      },
    );
    if (ok == true) {
      final path = pathCtrl.text.trim();
      if (path.isNotEmpty) {
        await logic.sendFile(File(path));
      }
    }
  }

  Future<void> _sendCustom(BuildContext context) async {
    final jsonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('自定义消息 JSON'),
          content: TextField(controller: jsonCtrl, minLines: 3, maxLines: 6),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('发送')),
          ],
        );
      },
    );
    if (ok == true) {
      try {
        final data = jsonDecode(jsonCtrl.text.trim());
        if (data is Map<String, dynamic>) {
          await logic.sendCustom(data);
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('图片'),
            onTap: () async {
              Navigator.pop(context);
              await _pickImage(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('视频'),
            onTap: () async {
              Navigator.pop(context);
              await _pickVideo(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.keyboard_voice),
            title: const Text('语音'),
            onTap: () async {
              Navigator.pop(context);
              await _sendVoice(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text('文件'),
            onTap: () async {
              Navigator.pop(context);
              await _sendFile(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('位置'),
            onTap: () async {
              Navigator.pop(context);
              await _sendLocation(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_page),
            title: const Text('名片'),
            onTap: () async {
              Navigator.pop(context);
              await _sendCard(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('自定义'),
            onTap: () async {
              Navigator.pop(context);
              await _sendCustom(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text('@ 提及'),
            onTap: () async {
              Navigator.pop(context);
              await showModalBottomSheet(context: context, builder: (_) => const MentionPicker());
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_emotions),
            title: const Text('表情'),
            onTap: () async {
              Navigator.pop(context);
              await showModalBottomSheet(context: context, builder: (_) => const EmojiPicker());
            },
          ),
        ],
      ),
    );
  }
}
