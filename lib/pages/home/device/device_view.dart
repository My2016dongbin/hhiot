import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/HhColors.dart';
import 'device_controller.dart';
class DevicePage extends StatelessWidget {
  final logic = Get.find<DeviceController>();
  DevicePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Center(child:Text(logic.title.value)),
    );
  }
}
