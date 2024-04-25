import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/HhColors.dart';
import 'message_controller.dart';
class MessagePage extends StatelessWidget {
  final logic = Get.find<MessageController>();
  MessagePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Center(child:Text(logic.title.value)),
    );
  }
}
