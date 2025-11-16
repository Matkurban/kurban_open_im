import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/constant/app_constant_data.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key, required this.message, required this.isMe});

  final Message message;

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    late double trulyWidth;
    late double trulyHeight;

    final picture = message.pictureElem;
    String? sourcePath = picture?.sourcePath;

    String? sourceUrl = picture?.bigPicture?.url;
    String? snapshotUrl = picture?.snapshotPicture?.url;

    var w = picture?.sourcePicture?.width?.toDouble() ?? 1.0;
    var h = picture?.sourcePicture?.height?.toDouble() ?? 1.0;

    if (pictureWidth > w) {
      trulyWidth = w;
      trulyHeight = h;
    } else {
      trulyWidth = pictureWidth;
      trulyHeight = trulyWidth * h / w;
    }

    final height = pictureWidth * 1.sh / 1.sw;

    if (trulyHeight > 2 * height) {
      trulyHeight = trulyWidth;
    }

    Widget child;
    if (isMe && sourcePath != null && sourcePath.isNotEmpty) {
      child = Image(
        image: FileImage(File(sourcePath)),
        width: trulyWidth,
        height: trulyHeight,
        fit: BoxFit.fitWidth,
      );
    } else if (snapshotUrl != null && snapshotUrl.isNotEmpty) {
      child = CachedNetworkImage(
        imageUrl: snapshotUrl,
        width: trulyWidth,
        height: trulyHeight,
        fit: BoxFit.fitWidth,
      );
    } else if (sourceUrl != null && sourceUrl.isNotEmpty) {
      child = CachedNetworkImage(
        imageUrl: sourceUrl,
        width: trulyWidth,
        height: trulyHeight,
        fit: BoxFit.fitWidth,
      );
    } else {
      child = SizedBox(width: trulyWidth, height: trulyHeight);
    }
    return ClipRRect(borderRadius: AppStyle.defaultRadius, child: child);
  }
}
