import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/model/enum/account_type.dart';
import 'package:kurban_open_im/pages/auth/register/register_logic.dart';

/// 第一步：账号信息
class RegisterAccountStep extends GetWidget<RegisterLogic> {
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
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                return SegmentedButton<AccountType>(
                  segments: const [
                    ButtonSegment(value: AccountType.email, label: Text("邮箱")),
                    ButtonSegment(value: AccountType.phone, label: Text("手机号")),
                  ],
                  selected: {controller.accountType.value},
                  onSelectionChanged: (set) => controller.onAccountTypeChanged(set.first),
                );
              }),
            ),
            Gap(16.h),
            Obx(() {
              if (controller.accountType.value == AccountType.email) {
                return TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "邮箱", hintText: "请输入邮箱"),
                  validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入邮箱",
                );
              } else {
                return Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: controller.areaCodeController,
                        decoration: const InputDecoration(labelText: "区号"),
                        validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入区号",
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: "手机号", hintText: "请输入手机号"),
                        validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入手机号",
                      ),
                    ),
                  ],
                );
              }
            }),
            Gap(12.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.verificationCodeController,
                    decoration: const InputDecoration(labelText: "验证码", hintText: "请输入验证码"),
                    validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入验证码",
                  ),
                ),
                Gap(12.w),
                OutlinedButton(onPressed: controller.requestVerifyCode, child: const Text("获取验证码")),
              ],
            ),
            Gap(12.h),
            TextFormField(
              controller: controller.invitationCodeController,
              decoration: const InputDecoration(labelText: "邀请码", hintText: "选填"),
            ),
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
