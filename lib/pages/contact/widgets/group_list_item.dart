import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/router/router_name.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({super.key, required this.group});

  final GroupInfo group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AvatarView(url: group.faceURL, name: group.groupName),
      title: Text(group.groupName ?? ""),
      onTap: () {
        Get.toNamed(
          RouterName.chat,
          arguments: {
            "isGroup": true,
            "recvID": null,
            "groupID": group.groupID,
            "title": group.groupName,
          },
        );
      },
    );
  }
}
