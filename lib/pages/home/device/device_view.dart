import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../utils/HhColors.dart';
import 'device_controller.dart';

class DevicePage extends StatelessWidget {
  final logic = Get.find<DeviceController>();

  DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Center(
          child: Column(
        children: [
            Pinput(
            defaultPinTheme: logic.defaultPinTheme,
            focusedPinTheme: logic.focusedPinTheme,
            submittedPinTheme: logic.submittedPinTheme,
            validator: (s) {
              return s == logic.title.value ? null : 'Pin is incorrect';
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) => logic.onCodeComplete(pin),
          ),
          Text(logic.title.value),
        ],
      )),
    );
  }
}
