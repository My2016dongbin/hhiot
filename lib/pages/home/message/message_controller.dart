import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common/model/model_class.dart';

class MessageController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "消息".obs;
  final Rx<bool> tabStatus = false.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<String> test = 'test'.obs;
  final PagingController<int, DeviceMessage> deviceController = PagingController(firstPageKey: 0);
  final PagingController<int, WarnMessage> warnController = PagingController(firstPageKey: 0);
  static const pageSize = 20;

  @override
  void onInit() {
    deviceController.addPageRequestListener((pageKey) {
      fetchPageDevice(pageKey);
    });
    warnController.addPageRequestListener((pageKey) {
      fetchPageWarn(pageKey);
    });
    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<DeviceMessage> newItems = [
      DeviceMessage("边缘盒子网络异常", "边缘盒子网络异常", "15:00", false),
      DeviceMessage("边缘盒子网络异常", "边缘盒子网络异常", "昨天 15:00", true),
      DeviceMessage("边缘盒子网络异常", "边缘盒子网络异常", "2024-06-02 15:00", true)
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }
  void fetchPageWarn(int pageKey) {
    List<WarnMessage> newItems = [
      WarnMessage("青岛市城阳区发现火警", "青岛市城阳区发现火警", "15:00", false),
      WarnMessage("青岛市高新区发现火警", "青岛市高新区发现火警", "昨天 15:00", true),
      WarnMessage("青岛市崂山区发现火警", "青岛市崂山区发现火警", "2024-06-02 15:00", true)
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      warnController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      warnController.appendPage(newItems, nextPageKey);
    }
  }
}
