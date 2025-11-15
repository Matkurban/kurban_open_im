import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class GroupSearchLogic extends GetxController {
  final RxList<Map<String, String>> results = <Map<String, String>>[].obs;

  Future<void> search(String keyword) async {
    final list = await OpenIM.iMManager.groupManager.searchGroups(keywordList: [keyword]);
    results.assignAll(list.map((e) => {'groupName': e.groupName ?? '', 'groupID': e.groupID}));
  }
}
