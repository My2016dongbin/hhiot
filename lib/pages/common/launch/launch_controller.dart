import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';

class LaunchController extends GetxController {
  final Rx<bool> testStatus = true.obs;
}
