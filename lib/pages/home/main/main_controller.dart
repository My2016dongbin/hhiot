import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:get/get.dart';
import 'package:iot/bus/event_class.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/HhLog.dart';

import '../../../utils/EventBusUtils.dart';

class MainController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "主页".obs;
  final Rx<double?> latitude = CommonData.latitude.obs;
  final Rx<double?> longitude = CommonData.longitude.obs;
  BMFMapController ?controller;
  StreamSubscription ?pushTouchSubscription;
  final Rx<bool?> searchStatus = true.obs;
  TextEditingController ?searchController;

  @override
  void onInit() {
    pushTouchSubscription = EventBusUtil.getInstance()
        .on<Location>()
        .listen((event) {
      if (CommonData.latitude != null && CommonData.latitude! > 0) {
        controller!.updateMapOptions(BMFMapOptions(
            center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                CommonData.longitude ?? 120.314037),
            zoomLevel: 12,
            mapType: BMFMapType.Standard,
            mapPadding: BMFEdgeInsets(
                left: 30, top: 0, right: 30, bottom: 0)));
      }
    });
    super.onInit();
  }


  void onBMFMapCreated(BMFMapController controller_) {
    controller = controller_;
  }

  void onSearchClick() {
    searchStatus.value = true;
  }
  void restartSearchClick() {
    searchStatus.value = false;
  }
}
