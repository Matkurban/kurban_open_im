import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/auth/register/register_logic.dart';
import 'package:kurban_open_im/pages/auth/register/widget/register_account_step.dart';
import 'package:kurban_open_im/pages/auth/register/widget/register_profile_step.dart';

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
