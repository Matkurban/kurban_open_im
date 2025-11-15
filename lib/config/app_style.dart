import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

sealed class AppStyle {
  static EdgeInsetsGeometry get defaultPadding {
    return EdgeInsets.all(16.w);
  }

  static EdgeInsetsGeometry get defaultHorizontalPadding {
    return EdgeInsets.symmetric(horizontal: 16.w);
  }

  static BorderRadiusGeometry get defaultRadius {
    return BorderRadius.circular(10);
  }
}
