import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late BuildContext context;
  final Rx<String> ?nickname = ''.obs;
  final Rx<String> ?mobile = ''.obs;
  final Rx<String> ?avatar = ''.obs;
  late StreamSubscription infoSubscription;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    mobile!.value = prefs.getString(SPKeys().mobile)!;
    avatar!.value = prefs.getString(SPKeys().avatar)!;

    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          nickname!.value = prefs.getString(SPKeys().nickname)!;
          mobile!.value = prefs.getString(SPKeys().mobile)!;
          avatar!.value = prefs.getString(SPKeys().avatar)!;
        });
    super.onInit();
  }
}
