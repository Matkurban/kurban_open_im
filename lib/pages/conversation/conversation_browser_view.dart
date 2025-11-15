import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class ConversationBrowserView extends StatefulWidget {
  const ConversationBrowserView({super.key});

  @override
  State<ConversationBrowserView> createState() => _ConversationBrowserViewState();
}

class _ConversationBrowserViewState extends State<ConversationBrowserView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final RxList<ConversationInfo> all = <ConversationInfo>[].obs;
  final TextEditingController _oneCtrl = TextEditingController();
  final TextEditingController _multiCtrl = TextEditingController();
  final Rx<ConversationInfo?> one = Rx<ConversationInfo?>(null);
  final RxList<ConversationInfo> multi = <ConversationInfo>[].obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  Future<void> _loadAll() async {
    final list = await OpenIM.iMManager.conversationManager.getAllConversationList();
    all.assignAll(list);
  }

  Future<void> _loadOne() async {
    final id = _oneCtrl.text.trim();
    if (id.isEmpty) return;
    // 该 SDK 版本不支持通过 conversationID 直接获取单个会话，改为在 all 列表中筛选
    one.value = all.firstWhereOrNull((c) => c.conversationID == id);
  }

  Future<void> _loadMulti() async {
    final ids = _multiCtrl.text
        .trim()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (ids.isEmpty) return;
    multi.assignAll(all.where((c) => ids.contains(c.conversationID)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('会话浏览器'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '单个'),
            Tab(text: '多个'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(
            () => ListView.builder(
              itemCount: all.length,
              itemBuilder: (_, i) {
                final c = all[i];
                return ListTile(
                  title: Text(c.showName ?? c.conversationID),
                  subtitle: Text(c.conversationID),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _oneCtrl,
                  decoration: const InputDecoration(hintText: 'conversationID'),
                ),
                const SizedBox(height: 8),
                FilledButton(onPressed: _loadOne, child: const Text('查询')),
                const SizedBox(height: 12),
                Obx(() {
                  final c = one.value;
                  if (c == null) return const SizedBox.shrink();
                  return ListTile(
                    title: Text(c.showName ?? c.conversationID),
                    subtitle: Text(c.conversationID),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _multiCtrl,
                  decoration: const InputDecoration(hintText: '逗号分隔多个 conversationID'),
                ),
                const SizedBox(height: 8),
                FilledButton(onPressed: _loadMulti, child: const Text('查询')),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: multi.length,
                      itemBuilder: (_, i) {
                        final c = multi[i];
                        return ListTile(
                          title: Text(c.showName ?? c.conversationID),
                          subtitle: Text(c.conversationID),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
