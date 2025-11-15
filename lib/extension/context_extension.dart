import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ///获取size
  Size get getSize {
    return MediaQuery.sizeOf(this);
  }

  ///获取viewPadding
  EdgeInsets get getViewPadding {
    return MediaQuery.viewPaddingOf(this);
  }

  ///获取theme
  ThemeData get getTheme {
    return Theme.of(this);
  }
}
