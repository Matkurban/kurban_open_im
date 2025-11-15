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
      onTap: () {
        Get.toNamed(
          RouterName.chat,
          arguments: {
            "isGroup": false,
            "recvID": user.userID,
            "groupID": null,
            "title": user.nickname ?? user.userID ?? "",
          },
        );
      },
    );
  }
}
