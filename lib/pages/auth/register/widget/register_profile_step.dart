import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/config/app_style.dart';
import 'package:kurban_open_im/pages/auth/register/register_logic.dart';

/// 第二步：个人信息
class RegisterProfileStep extends GetWidget<RegisterLogic> {
  const RegisterProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      padding: AppStyle.defaultHorizontalPadding,
      child: Form(
        key: controller.step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(16.h),
            TextFormField(
              controller: controller.nicknameController,
              decoration: const InputDecoration(labelText: "昵称", hintText: "请输入昵称"),
              validator: (v) => (v != null && v.isNotEmpty) ? null : "请输入昵称",
            ),
            Gap(16.h),
            Obx(() {
              final birth = controller.birthDate.value;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                tileColor: theme.inputDecorationTheme.fillColor,
                shape: RoundedRectangleBorder(borderRadius: AppStyle.defaultRadius),
                title: birth != null
                    ? Text(
                        "生日：${birth.year}-${birth.month}-${birth.day}",
                        style: theme.inputDecorationTheme.labelStyle,
                      )
                    : Text("点击选择生日", style: TextStyle(color: Theme.of(context).hintColor)),
                onTap: () => controller.selectBirthDate(context),
              );
            }),
            Gap(16.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("性别"),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => SegmentedButton<int>(
                        style: SegmentedButton.styleFrom(
                          backgroundColor: theme.inputDecorationTheme.fillColor,
                        ),
                        segments: const [
                          ButtonSegment(value: 1, label: Text("男")),
                          ButtonSegment(value: 0, label: Text("女")),
                        ],
                        selected: {controller.gender.value},
                        onSelectionChanged: (values) => controller.onGenderChanged(values.first),
                      ),
                    ),
                  ),
                ],
              ),
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
