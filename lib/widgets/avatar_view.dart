import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/extension/context_extension.dart';
import 'package:kurban_open_im/widgets/custom_network_image.dart';
import 'package:lpinyin/lpinyin.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({super.key, this.url, this.name, this.width, this.height});

  final String? url;

  final String? name;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    if (url != null && url!.isNotEmpty) {
      return CustomNetworkImage(imageUrl: url!, width: width ?? 48.w, height: height ?? 48.w);
    } else if (name != null && name!.isNotEmpty) {
      return Container(
        width: width ?? 48.w,
        height: height ?? 48.w,
        decoration: BoxDecoration(color: theme.primaryColor, borderRadius: AppStyle.defaultRadius),
        alignment: Alignment.center,
        child: Text(
          PinyinHelper.getShortPinyin(name!).split('').first.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(color: theme.cardColor),
        ),
      );
    } else {
      return Container(
        width: width ?? 48.w,
        height: height ?? 48.w,
        decoration: BoxDecoration(color: theme.primaryColor, borderRadius: AppStyle.defaultRadius),
        alignment: Alignment.center,
        child: Icon(Icons.person, color: theme.cardColor, size: (width ?? 48.w) / 2),
      );
    }
  }
}
