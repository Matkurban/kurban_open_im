import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_logic.dart';

class ProfileView extends GetView<ProfileLogic> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final nicknameCtrl = TextEditingController();
    final faceCtrl = TextEditingController();
    final genderCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    final birthCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('我的资料')),
      body: Obx(() {
        final s = controller.self.value;
        nicknameCtrl.text = s?.nickname ?? '';
        faceCtrl.text = s?.faceURL ?? '';
        genderCtrl.text = '';
        emailCtrl.text = '';
        mobileCtrl.text = '';
        birthCtrl.text = '';
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: nicknameCtrl,
                decoration: const InputDecoration(labelText: '昵称'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: faceCtrl,
                decoration: const InputDecoration(labelText: '头像URL'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: genderCtrl,
                decoration: const InputDecoration(labelText: '性别(0/1/2)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: '邮箱'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileCtrl,
                decoration: const InputDecoration(labelText: '手机'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: birthCtrl,
                decoration: const InputDecoration(labelText: '生日(秒)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Obx(() {
                return FilledButton(
                  onPressed: controller.saving.value
                      ? null
                      : () async {
                          await controller.save(
                            nickname: nicknameCtrl.text.trim(),
                            faceURL: faceCtrl.text.trim(),
                          );
                          if (context.mounted) Navigator.pop(context);
                        },
                  child: Text(controller.saving.value ? '保存中' : '保存'),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
