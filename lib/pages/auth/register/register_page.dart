import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/pages/auth/register/register_logic.dart';

class RegisterPage extends GetView<RegisterLogic> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("注册")),
      body: SafeArea(
        top: false,
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [RegisterAccountStep(), RegisterProfileStep()],
        ),
      ),
    );
  }
}

/// 第一步：账号信息
class RegisterAccountStep extends GetView<RegisterLogic> {
  const RegisterAccountStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppStyle.defaultHorizontalPadding,
      child: Form(
        key: controller.step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),
            Text("选择账号类型"),
            Gap(8.h),
            Obx(() {
              return SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: "email", label: Text("邮箱")),
                  ButtonSegment(value: "phone", label: Text("手机号")),
                ],
                selected: {controller.accountType.value},
                onSelectionChanged: (set) => controller.onAccountTypeChanged(set.first),
              );
            }),
            Gap(16.h),
            Obx(() {
              if (controller.accountType.value == "email") {
                return TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "邮箱", hintText: "请输入邮箱"),
                  validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入邮箱",
                );
              } else {
                return TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "手机号", hintText: "请输入手机号"),
                  validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入手机号",
                );
              }
            }),
            Gap(16.h),
            TextFormField(
              controller: controller.passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: "密码", hintText: "请输入6~16位密码"),
              validator: (v) =>
                  (v != null && v.length >= 6 && v.length <= 16) ? null : "请输入6~16位密码",
            ),
            Gap(24.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: controller.nextStep, child: const Text("下一步")),
            ),
          ],
        ),
      ),
    );
  }
}

/// 第二步：个人信息
class RegisterProfileStep extends GetView<RegisterLogic> {
  const RegisterProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppStyle.defaultHorizontalPadding,
      child: Form(
        key: controller.step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),
            TextFormField(
              controller: controller.nicknameController,
              decoration: const InputDecoration(labelText: "昵称", hintText: "请输入昵称"),
              validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入昵称",
            ),
            Gap(16.h),
            Row(
              children: [
                const Text("性别"),
                Gap(8.w),
                Obx(() {
                  return SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text("未知")),
                      ButtonSegment(value: 1, label: Text("男")),
                      ButtonSegment(value: 2, label: Text("女")),
                    ],
                    selected: {controller.gender.value},
                    onSelectionChanged: (set) => controller.gender.value = set.first,
                  );
                }),
              ],
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: controller.prevStep, child: const Text("上一步")),
                ),
                Gap(12.w),
                Expanded(
                  child: FilledButton(onPressed: controller.submit, child: const Text("提交注册")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
