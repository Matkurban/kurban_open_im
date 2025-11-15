import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_logic.dart';

class ContactView extends GetView<ContactLogic> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("好友")));
  }
}
