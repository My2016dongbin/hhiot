import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/HhColors.dart';
import 'main_controller.dart';
class MainPage extends StatelessWidget {
  final logic = Get.find<MainController>();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: HhColors.backColor,
      body: Center(child:Text(logic.title.value)),
    ));
  }
}
