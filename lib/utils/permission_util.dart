import 'package:kurban_open_im/widgets/app_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

sealed class PermissionUtil {
  ///请求权限
  static Future<bool> _requestPermission({
    required Permission permission,
    required String permissionName,
    required String permissionTip,
  }) async {
    var permissionStatus = await permission.status;
    if (permissionStatus.isGranted) {
      return true;
    } else {
      var permissionStatus = await permission.request();
      if (permissionStatus.isGranted) {
        return true;
      } else if (await permission.isDenied) {
        await AppDialog.tipDialog(
          title: "$permissionName权限",
          content: "你已拒绝$permissionName权限，$permissionTip，需要你去手机设置里面手动打开$permissionName权限",
          onConfirm: () async {
            await openAppSettings();
          },
        );
        return false;
      } else {
        return false;
      }
    }
  }

  ///图库权限
  static Future<bool> albumPermission() async {
    return await _requestPermission(
      permission: Permission.photos,
      permissionName: "图库",
      permissionTip: "为保证你能正常选择图片",
    );
  }

  ///相机权限
  static Future<bool> cameraPermission() async {
    return await _requestPermission(
      permission: Permission.camera,
      permissionName: "相机",
      permissionTip: "为保证你能正常拍摄照片",
    );
  }
}
