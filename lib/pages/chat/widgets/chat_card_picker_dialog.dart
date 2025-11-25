import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class ChatCardResult {
  const ChatCardResult({this.userID, this.groupID, required this.name, this.faceURL});

  final String? userID;
  final String? groupID;
  final String name;
  final String? faceURL;

  bool get isGroup => groupID != null;
}

class ChatCardPickerDialog extends StatefulWidget {
  const ChatCardPickerDialog({super.key, required this.isGroup});

  final bool isGroup;

  static Future<ChatCardResult?> show(BuildContext context, {required bool isGroup}) {
    return showDialog<ChatCardResult>(
      context: context,
      builder: (_) => ChatCardPickerDialog(isGroup: isGroup),
    );
  }

  @override
  State<ChatCardPickerDialog> createState() => _ChatCardPickerDialogState();
}

class _ChatCardPickerDialogState extends State<ChatCardPickerDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<FriendInfo> _friends = const [];
  List<GroupInfo> _groups = const [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.isGroup ? 1 : 0);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        OpenIM.iMManager.friendshipManager.getFriendList(),
        OpenIM.iMManager.groupManager.getJoinedGroupList(),
      ]);
      if (!mounted) return;
      setState(() {
        _friends = results[0] as List<FriendInfo>;
        _groups = results[1] as List<GroupInfo>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _selectFriend(FriendInfo info) {
    final name = _friendDisplayName(info);
    Navigator.of(
      context,
    ).pop(ChatCardResult(userID: info.userID, name: name, faceURL: info.faceURL));
  }

  void _selectGroup(GroupInfo info) {
    final name = _groupDisplayName(info);
    Navigator.of(
      context,
    ).pop(ChatCardResult(groupID: info.groupID, name: name, faceURL: info.faceURL));
  }

  String _friendDisplayName(FriendInfo info) {
    final nickname = info.nickname;
    if (nickname != null && nickname.trim().isNotEmpty) {
      return nickname.trim();
    }
    final userID = info.userID;
    if (userID != null && userID.trim().isNotEmpty) {
      return userID.trim();
    }
    return "";
  }

  String _groupDisplayName(GroupInfo info) {
    final groupName = info.groupName;
    if (groupName != null && groupName.trim().isNotEmpty) {
      return groupName.trim();
    }
    final groupID = info.groupID;
    if (groupID.trim().isNotEmpty) {
      return groupID.trim();
    }
    return groupID;
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_error ?? "加载失败"),
          SizedBox(height: 12.h),
          FilledButton(onPressed: _loadData, child: const Text("重试")),
        ],
      ),
    );
  }

  Widget _buildFriends() {
    if (_friends.isEmpty) {
      return const Center(child: Text("暂无好友"));
    }
    return ListView.separated(
      itemCount: _friends.length,
      separatorBuilder: (_, i) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final item = _friends[index];
        final displayName = _friendDisplayName(item);
        return ListTile(
          leading: AvatarView(url: item.faceURL, name: displayName),
          title: Text(displayName),
          onTap: () => _selectFriend(item),
        );
      },
    );
  }

  Widget _buildGroups() {
    if (_groups.isEmpty) {
      return const Center(child: Text("暂无群组"));
    }
    return ListView.separated(
      itemCount: _groups.length,
      separatorBuilder: (_, i) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final item = _groups[index];
        final displayName = _groupDisplayName(item);
        return ListTile(
          leading: AvatarView(url: item.faceURL, name: displayName),
          title: Text(displayName),
          onTap: () => _selectGroup(item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("选择名片"),
      content: SizedBox(
        width: 360.w,
        height: 420.h,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "好友"),
                Tab(text: "群组"),
              ],
            ),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (_loading) return _buildLoading();
                  if (_error != null) return _buildError();
                  return TabBarView(
                    controller: _tabController,
                    children: [_buildFriends(), _buildGroups()],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("取消"))],
    );
  }
}
