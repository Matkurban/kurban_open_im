import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class FriendAddLogic extends GetxController {
  final RxBool submitting = false.obs;

  Future<void> addFriend({required String userID, String? reqMessage}) async {
    if (submitting.value) return;
    submitting.value = true;
    try {
      await OpenIM.iMManager.friendshipManager.addFriend(userID: userID);
    } catch (_) {} finally {
      submitting.value = false;
    }
  }

  

  

  
}