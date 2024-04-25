import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DeviceController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "设备".obs;
}
