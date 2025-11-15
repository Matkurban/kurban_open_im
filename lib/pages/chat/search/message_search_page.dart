import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:kurban_open_im/pages/chat/widgets/message_item.dart';

class MessageSearchPage extends StatefulWidget {
  const MessageSearchPage({super.key});

  @override
  State<MessageSearchPage> createState() => _MessageSearchPageState();
}

class _MessageSearchPageState extends State<MessageSearchPage> {
  final TextEditingController _queryCtrl = TextEditingController();
  final RxList<Message> _results = <Message>[].obs;
  String? _conversationID;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    _conversationID = args['conversationID'];
  }

  Future<void> _search() async {
    final q = _queryCtrl.text.trim();
    if (_conversationID == null || q.isEmpty) return;
    final res = await OpenIM.iMManager.messageManager.searchLocalMessages(conversationID: _conversationID!, keywordList: [q], keywordListMatchType: 0, senderUserIDList: [], messageTypeList: [], searchTimePosition: 0, searchTimePeriod: 0, pageIndex: 1, count: 50);
    final items = res.searchResultItems ?? [];
    final list = <Message>[];
    for (final item in items) {
      final msgs = item.messageList ?? [];
      list.addAll(msgs);
    }
    _results.assignAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('搜索消息')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _queryCtrl, decoration: const InputDecoration(hintText: '关键字'))),
                const SizedBox(width: 8),
                FilledButton(onPressed: _search, child: const Text('搜索')),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return MessageItem(message: _results[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}