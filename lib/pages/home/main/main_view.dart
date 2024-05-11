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
                  mapPadding:
                      BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0)),
            ),
            Obx(
              () => Align(
                alignment: Alignment.topLeft,
                child: logic.searchStatus.value!
                    ? buildSearchView()
                    : Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: logic.onSearchClick,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.w)),
                                  ),
                                  margin: EdgeInsets.fromLTRB(
                                      0.08.sw, 0.15.sw, 0, 0),
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/common/shared.png",
                                        width: 50.w,
                                        height: 50.w,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        "搜索",
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 18.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchView() {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: logic.restartSearchClick,
              child: Container(
                decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(16.w)),
                ),
                margin: EdgeInsets.fromLTRB(0.08.sw, 0.15.sw, 0, 0),
                padding: EdgeInsets.all(10.w),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            border: Border.all(color: HhColors.mainBlueColor),
                            borderRadius: BorderRadius.all(Radius.circular(20.w))),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/common/shared.png",
                              width: 35.w,
                              height: 35.w,
                              fit: BoxFit.fill,
                            ),
                            TextField(
                              maxLines: 1,
                              cursorColor: HhColors.titleColor_99,
                              controller: logic.searchController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(0.w, 0, 0, 0),
                                border: InputBorder.none,
                                hintText: '请输入名称',
                                hintStyle: TextStyle(
                                    color: HhColors.gray9TextColor, fontSize: 18.sp),
                              ),
                              style: TextStyle(
                                  color: HhColors.blackTextColor, fontSize: 18.sp),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
