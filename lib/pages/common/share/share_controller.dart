import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class ShareController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  late dynamic arguments = {};
  final Rx<bool> testStatus = true.obs;
  final Rx<String> codeUrl = ''.obs;
  TextEditingController ?nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    arguments = Get.arguments;
    shareCreate();
  }


  Future<void> shareCreate() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    HhLog.d("shareCreate map -- $arguments");
    var shareCreateResult = await HhHttp().request(
      RequestUtils.shareCreate,
      method: DioMethod.post,
      data: arguments
    );
    HhLog.d("shareCreate shareCreateResult -- $shareCreateResult");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (shareCreateResult["code"] == 0 && shareCreateResult["data"] != null) {
      codeUrl.value = shareCreateResult["data"]["qrCodeImage"];
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(shareCreateResult["msg"]),type: 2));
    }
  }
}
