import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<double> longitude = 0.0.obs;
  final Rx<double> latitude = 0.0.obs;
  BMFMapController ?controller;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void onBMFMapCreated(BMFMapController controller_) {
    controller = controller_;
    // controller?.setMapOnClickedMapBlankCallback(callback: (BMFCoordinate coordinate) {
    //   controller?.cleanAllMarkers();
    //
    //   latitude.value = coordinate.latitude;
    //   longitude.value = coordinate.longitude;
    //
    //   /// 创建BMFMarker
    //   BMFMarker marker = BMFMarker(
    //       position: BMFCoordinate(coordinate.latitude,coordinate.longitude),
    //       enabled: false,
    //       visible: true,
    //       identifier: "location",
    //       icon: 'assets/images/common/ic_device_online.png');
    //
    //   /// 添加Marker
    //   controller?.addMarker(marker);
    // });
  }

  Future<void> userEdit() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '正在保存..'));
    var tenantResult = await HhHttp().request(
      RequestUtils.userEdit,
      method: DioMethod.put,
      data: {}
    );
    HhLog.d("userEdit -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {

    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }
}
