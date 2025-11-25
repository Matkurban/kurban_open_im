import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/constant/app_resource.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/pages/auth/login/login_logic.dart';
import 'package:kurban_open_im/router/router_name.dart';

class LoginPage extends GetView<LoginLogic> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme;
    info("Login Build");
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppStyle.defaultHorizontalPadding,
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(16.h),
                Image(
                  image: AssetImage(AppResource.logo),
                  width: 96.w,
                  height: 96.w,
                  fit: BoxFit.cover,
                ),
                Gap(20.h),
                Obx(() {
                  return SegmentedButton<int>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: theme.inputDecorationTheme.fillColor,
                    ),
                    segments: const [
                      ButtonSegment(value: 0, label: Text("邮箱登录")),
                      ButtonSegment(value: 1, label: Text("手机号登录")),
                    ],
                    selected: {controller.loginMode.value},
                    onSelectionChanged: (set) {
                      controller.loginMode.value = set.first;
                    },
                  );
                }),
                Gap(12.h),
                Obx(() {
                  if (controller.loginMode.value == 0) {
                    return TextFormField(
                      controller: controller.emailController,
                      validator: controller.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "邮箱", hintText: "请输入邮箱"),
                    );
                  } else {
                    return TextFormField(
                      controller: controller.phoneController,
                      validator: controller.phoneValidator,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "手机号", hintText: "请输入手机号"),
                    );
                  }
                }),
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
                Gap(8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "忘记密码",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RouterName.register);
                      },
                      child: Text("去注册"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
