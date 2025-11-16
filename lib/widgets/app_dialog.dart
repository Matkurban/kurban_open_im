import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';

sealed class AppDialog {
  ///提示弹框
  static Future<void> tipDialog({
    required String title,
    required String content,
    String cancelText = "取消",
    VoidCallback? onCancel,
    String confirmText = "确定",
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var theme = context.getTheme;
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Gap(16.h),
                Text(content, style: theme.textTheme.bodyMedium),
                Gap(24.h),
                Row(
                  spacing: 16.w,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onCancel?.call();
                        },
                        child: Text(cancelText),
                      ),
                    ),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Get.back();
                          onConfirm();
                        },
                        child: Text(confirmText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
