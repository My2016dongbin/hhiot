import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';

class DeviceController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "设备".obs;
  final code = "2222".obs;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  PinTheme ?focusedPinTheme;

  PinTheme ?submittedPinTheme;

  @override
  void onInit() {
    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    super.onInit();
  }

  void onCodeComplete(var code){
    HhLog.i("code ==> $code");
  }
}
