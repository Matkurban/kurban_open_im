import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_theme.dart';
import 'package:kurban_open_im/pages/splash/splash_binding.dart';
import 'package:kurban_open_im/pages/splash/splash_page.dart';
import 'package:kurban_open_im/router/router_page.dart';
import 'package:kurban_open_im/widgets/custom_message_widget.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CustomMessageWidget(
      child: ScreenUtilInit(
        designSize: Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          title: "OpenIm",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          getPages: RouterPage.allPages(),
          home: SplashPage(),
          initialBinding: SplashBinding(),
          /*  builder: (context, child) {
              return Scaffold(body: CustomMessageWidget(child: child ?? SizedBox.shrink()));
            },*/
        ),
      ),
    );
  }
}
