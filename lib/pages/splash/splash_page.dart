import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/extension/context_extension.dart';
import 'package:kurban_open_im/pages/splash/splash_logic.dart';

class SplashPage extends GetView<SplashLogic> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = context.getSize;
    var theme = context.getTheme;
    var textTheme = theme.textTheme;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("OpenIm", style: textTheme.titleLarge?.copyWith(color: theme.primaryColor)),
          ],
        ),
      ),
    );
  }
}
