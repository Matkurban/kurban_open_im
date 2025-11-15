import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;

  final double? width;

  final double? height;

  final BoxShape shape;

  final BoxFit fit;

  ///只有在[shape] 为[BoxShape.rectangle] 是才生效,默认为10
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget imageProvider = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(radius: 6),
        );
      },
      errorWidget: (context, url, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.person_outlined, color: theme.cardColor),
        );
      },
    );
    Widget image;
    switch (shape) {
      case BoxShape.rectangle:
        image = ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          child: imageProvider,
        );
        break;
      case BoxShape.circle:
        image = ClipOval(child: imageProvider);
        break;
    }

    return image;
  }
}
