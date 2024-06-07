import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';

class DeviceManageController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, Device> deviceController = PagingController(firstPageKey: 0);
  static const pageSize = 20;

  @override
  void onInit() {
    deviceController.addPageRequestListener((pageKey) {
      fetchPageDevice(pageKey);
    });
    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("F1-HH160双枪机", "红外报警-光感报警", "", "",true,true),
      Device("F1-HH160双枪机", "红外报警-光感报警", "", "",false,true),
      Device("智能语音卡口", "", "", "",false,false),
      Device("智能语音卡口", "", "", "",false,false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }
}
