import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/model/enum/im_sdk_status.dart';
import 'package:kurban_open_im/services/app_global_event.dart';
import 'package:rxdart_flutter/rxdart_flutter.dart';

class ConnectStatusWidget extends StatefulWidget {
  const ConnectStatusWidget({super.key});

  @override
  State<ConnectStatusWidget> createState() => _ConnectStatusWidgetState();
}

class _ConnectStatusWidgetState extends State<ConnectStatusWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: ValueStreamBuilder(
            stream: AppGlobalEvent.imSdkStatus,
            builder:
                (
                  BuildContext context,
                  ({int? progress, bool reInstall, IMSdkStatus status}) value,
                  Widget? child,
                ) {
                  switch (value.status) {
                    case IMSdkStatus.connectionFailed:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "连接失败",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          Icon(Icons.error_outline, size: 16, color: theme.colorScheme.error),
                        ],
                      );
                    case IMSdkStatus.connecting:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "连接中...",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          CupertinoActivityIndicator(color: theme.primaryColor, radius: 8),
                        ],
                      );
                    case IMSdkStatus.connectionSucceeded:
                      return SizedBox.shrink();
                    case IMSdkStatus.syncStart:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "开始同步",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          CircularProgressIndicator(
                            value: value.progress?.toDouble(),
                            constraints: BoxConstraints(maxHeight: 36, maxWidth: 36),
                          ),
                        ],
                      );
                    case IMSdkStatus.synchronizing:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "同步中...",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          CircularProgressIndicator(
                            value: value.progress?.toDouble(),
                            constraints: BoxConstraints(maxHeight: 36, maxWidth: 36),
                          ),
                        ],
                      );
                    case IMSdkStatus.syncEnded:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "同步结束",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Icon(Icons.check_circle_outline, size: 16, color: theme.primaryColor),
                        ],
                      );
                    case IMSdkStatus.syncFailed:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "同步失败",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          Icon(Icons.error_outline, size: 16, color: theme.colorScheme.error),
                        ],
                      );
                    case IMSdkStatus.syncProgress:
                      return Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            "同步中...",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          CircularProgressIndicator(
                            value: value.progress?.toDouble(),
                            constraints: BoxConstraints(maxHeight: 36, maxWidth: 36),
                          ),
                        ],
                      );
                  }
                },
          ),
        ),
      ],
    );
  }
}
