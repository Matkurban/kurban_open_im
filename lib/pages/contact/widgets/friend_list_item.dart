import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class FriendListItem extends StatelessWidget {
  const FriendListItem({super.key, required this.user});

  final FriendInfo user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AvatarView(url: user.faceURL, name: user.nickname ?? user.userID ?? ""),
      title: Text(user.nickname ?? user.userID ?? ""),
      subtitle: Text(user.remark ?? user.userID ?? ""),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'detail':
              Get.toNamed(RouterName.friendDetail, arguments: user);
              break;
            case 'chat':
              _openChat();
              break;
            case 'black':
              Get.toNamed(RouterName.friendBlacklist);
              break;
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'detail', child: Text('查看详情')),
          PopupMenuItem(value: 'chat', child: Text('发消息')),
          PopupMenuItem(value: 'black', child: Text('黑名单')),
        ],
      ),
      onTap: _openChat,
    );
  }

  void _openChat() {
    Get.toNamed(
      RouterName.chat,
      arguments: {
        "isGroup": false,
        "recvID": user.userID,
        "groupID": null,
        "title": user.nickname ?? user.userID ?? "",
      },
    );
  }
}
