import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/event_class.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/HhLog.dart';

import '../../../utils/EventBusUtils.dart';
import '../../common/model/model_class.dart';

class MainController extends GetxController {
  final index = 0.obs;
  final marginTop = 120.w;
  final unreadMsgCount = 0.obs;
  final title = "主页".obs;
  final Rx<double?> latitude = CommonData.latitude.obs;
  final Rx<double?> longitude = CommonData.longitude.obs;
  BMFMapController ?controller;
  StreamSubscription ?pushTouchSubscription;
  final Rx<bool> searchStatus = false.obs;
  final Rx<bool> videoStatus = true.obs;
  final Rx<bool> pageMapStatus = false.obs;
  TextEditingController ?searchController = TextEditingController();
  final PagingController<int, MainGridModel> pagingController = PagingController(firstPageKey: 0);
  static const pageSize = 20;
  late BuildContext context;

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
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
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

  void fetchPage(int pageKey) {
    List<MainGridModel> newItems = [
      MainGridModel("青岛林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 10, false),
      MainGridModel("城阳林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 6, true),
      MainGridModel("高新林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 8, true),
      MainGridModel("崂山林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 2, false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
    }
  }
}
