import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/HhColors.dart';
import 'my_controller.dart';
class MyPage extends StatelessWidget {
  final logic = Get.find<MyController>();
  MyPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Center(child:Text(logic.title.value)),
    );
  }
}
