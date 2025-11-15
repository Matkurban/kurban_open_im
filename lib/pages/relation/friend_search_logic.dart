import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class FriendSearchLogic extends GetxController {
  final RxList<Map<String, String>> results = <Map<String, String>>[].obs;

  Future<void> search(String keyword) async {
    final list = await OpenIM.iMManager.friendshipManager.searchFriends(keywordList: [keyword]);
    results.assignAll(list.map((e) => {
          'userID': e.userID ?? '',
          'showName': e.nickname ?? '',
        }));
  }
}