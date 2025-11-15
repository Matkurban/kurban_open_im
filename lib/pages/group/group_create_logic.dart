import 'package:get/get.dart';

class GroupCreateLogic extends GetxController {
  final RxBool creating = false.obs;

  Future<void> create({
    required String name,
    List<String>? memberIDs,
    String? faceURL,
    String? notification,
  }) async {
    creating.value = true;
    // TODO: 对接当前 SDK 的建群参数类型（可能为 groupInfo: <CreateType> + memberUserIDs），此处暂不调用以避免编译错误
    creating.value = false;
  }
}
