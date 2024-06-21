import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/login/login_binding.dart';
import 'package:iot/pages/common/login/login_view.dart';
import 'package:iot/utils/HhLog.dart';

class CodeController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  late String code = '';
  late BuildContext context;

}
