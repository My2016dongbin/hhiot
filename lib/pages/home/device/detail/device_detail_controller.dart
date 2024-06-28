import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player/video_player.dart';

class DeviceDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> tabIndex = 0.obs;
  final PagingController<int, Device> deviceController = PagingController(firstPageKey: 0);
  static const pageSize = 20;
  late VideoPlayerController controller;
  late DragController dragController;

  @override
  void onInit() {
    deviceController.addPageRequestListener((pageKey) {
      fetchPageDevice(pageKey);
    });
    controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {

      });
    dragController = DragController();

    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("检测到画面变化", "08:59:06", "", "",true,true),
      Device("区域入侵", "19:36:06", "", "",false,true),
      Device("检测到画面变化", "10:59:06", "", "",false,false),
      Device("区域入侵", "12:59:06", "", "",false,false),
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
