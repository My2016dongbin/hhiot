import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_utils/flutter_baidu_mapapi_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/hh_app_bar.dart';
import '../../../utils/HhColors.dart';
import '../../common/common_data.dart';
import 'main_controller.dart';

class MainPage extends StatelessWidget {
  final logic = Get.find<MainController>();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
           BMFMapWidget(
                  onBMFMapCreated: (controller) {
                    logic.onBMFMapCreated(controller);
                  },
                  mapOptions: BMFMapOptions(
                      center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                          CommonData.longitude ?? 120.314037),
                      zoomLevel: 12,
                      mapType: BMFMapType.Satellite,
                      mapPadding: BMFEdgeInsets(
                          left: 30, top: 0, right: 30, bottom: 0)),
                ),
          ],
        ),
      ),
    );
  }

}
