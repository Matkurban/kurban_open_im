import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/pages/auth/login/login_logic.dart';

class LoginPage extends GetView<LoginLogic> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppStyle.defaultHorizontalPadding,
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                Gap(16.h),
                FlutterLogo(size: 48),
                Gap(20.h),
                TextFormField(
                  controller: controller.emailController,
                  validator: controller.emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "邮箱", hintText: "请输入邮箱"),
                ),
                Gap(20.h),
                Obx(() {
                  return TextFormField(
                    controller: controller.passwordController,
                    validator: controller.passwordValidator,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: controller.passwordVisible.value,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      labelText: "密码",
                      hintText: "请输入密码",
                      suffixIcon: IconButton(
                        onPressed: controller.passwordVisible.toggle,
                        icon: Icon(
                          controller.passwordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  );
                }),
                Gap(24.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: controller.login, child: Text("登录")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
