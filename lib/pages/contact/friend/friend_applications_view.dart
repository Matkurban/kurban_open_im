import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_applications_logic.dart';
import 'package:kurban_open_im/widgets/avatar_view.dart';

class FriendApplicationsView extends GetView<FriendApplicationsLogic> {
  const FriendApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("好友申请"),
        actions: [
          IconButton(
            onPressed: controller.loadApplications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: _ApplicationSection(
                title: "收到的申请",
                data: controller.incoming,
                onAgree: controller.processing.value ? null : controller.accept,
                onReject: controller.processing.value
                    ? null
                    : controller.refuse,
                showAction: true,
              ),
            ),
            Expanded(
              child: _ApplicationSection(
                title: "发出的申请",
                data: controller.outgoing,
                showAction: false,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ApplicationSection extends StatelessWidget {
  const _ApplicationSection({
    required this.title,
    required this.data,
    this.onAgree,
    this.onReject,
    this.showAction = false,
  });

  final String title;
  final List<FriendApplicationInfo> data;
  final void Function(FriendApplicationInfo info)? onAgree;
  final void Function(FriendApplicationInfo info)? onReject;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(height: 1),
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text("暂无"))
                : ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final face = item.fromFaceURL ?? item.toFaceURL;
                      final name =
                          item.fromNickname ??
                          item.toNickname ??
                          item.fromUserID ??
                          item.toUserID ??
                          "";
                      final desc = item.reqMsg ?? "";
                      return ListTile(
                        leading: AvatarView(url: face, name: name),
                        title: Text(name),
                        subtitle: Text(desc),
                        trailing: !showAction
                            ? Text(_statusDesc(item))
                            : Wrap(
                                spacing: 8,
                                children: [
                                  TextButton(
                                    onPressed: () => onReject?.call(item),
                                    child: const Text("拒绝"),
                                  ),
                                  FilledButton(
                                    onPressed: () => onAgree?.call(item),
                                    child: const Text("同意"),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _statusDesc(FriendApplicationInfo info) {
    if (info.handleResult == 1) return "已同意";
    if (info.handleResult == -1) return "已拒绝";
    return "待处理";
  }
}
