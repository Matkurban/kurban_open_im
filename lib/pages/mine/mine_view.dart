import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/mine/mine_logic.dart';

class MineView extends GetView<MineLogic> {
  const MineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("我的")));
  }
}
