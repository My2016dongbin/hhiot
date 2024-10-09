import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/location/search/saerch_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class SearchLocationPage extends StatelessWidget {
  final logic = Get.find<SearchLocationController>();

  SearchLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? loginView() : const SizedBox(),
        ),
      ),
    );
  }

  loginView() {
    return Stack(
      children: [
        // Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
        Container(color: HhColors.whiteColor,width: 1.sw,height: 1.sh,),
        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              '设备定位',
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
            padding: EdgeInsets.all(10.w),
            color: HhColors.trans,
            child: Image.asset(
              "assets/images/common/back.png",
              width: 18.w,
              height: 30.w,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              if(logic.locText.value == "" || logic.locText.value == "已搜索"){
                EventBusUtil.getInstance().fire(HhToast(title: '请选择定位'));
                return;
              }
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
              padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
              decoration: BoxDecoration(
                color: HhColors.mainBlueColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w),),
              ),
              child: Text(
                '确定',
                style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 26.sp,),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 160.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  // height: 90.w,
                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                  padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                  decoration: BoxDecoration(
                      color: HhColors.grayEEBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.asset(
                        "assets/images/common/icon_search.png",
                        width: 45.w,
                        height: 45.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.searchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (s){
                            logic.nameSearch();
                          },
                          decoration: InputDecoration(
                            //contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '搜索位置',
                            hintStyle: TextStyle(
                                color: HhColors.gray9TextColor, fontSize: 26.sp),
                          ),
                          style:
                          TextStyle(color: HhColors.textColor, fontSize: 26.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  logic.searchController!.text = "";
                  logic.searchStatus.value = false;
                },
                child: Container(
                  margin: EdgeInsets.only(right: 30.w),
                  child: Text('取消',style: TextStyle(
                      color: HhColors.gray6TextColor,
                      fontSize: 26.sp
                  ),),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 265.w),
          child: BMFMapWidget(
            onBMFMapCreated: (controller) {
              logic.onBMFMapCreated(controller);
            },
            mapOptions: BMFMapOptions(
                center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                    CommonData.longitude ?? 120.314037),
                zoomLevel: 14,
                mapType: BMFMapType.Standard,
                mapPadding:
                BMFEdgeInsets(left: 30.w, top: 0, right: 30.w, bottom: 0)),
          ),
        ),

        logic.locText.value==""?const SizedBox():Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(60.w,0,60.w,0),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            height: 0.4.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: buildList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  buildList() {
    List<Widget> list = [];
    for(int i = 0; i < logic.searchList.length;i++){
      BMFPoiInfo info = logic.searchList[i];
      list.add(
          InkWell(
            onTap: (){
              logic.locText.value = CommonUtils().parseNull("${info.name}", "定位中..");
              logic.controller?.setCenterCoordinate(
                BMFCoordinate(info.pt!.latitude,info.pt!.longitude), false,
              );
              logic.controller?.setZoomTo(17);

              logic.controller?.cleanAllMarkers();

              logic.latitude.value = info.pt!.latitude;
              logic.longitude.value = info.pt!.longitude;

              logic.userMarker();

              /// 创建BMFMarker
              BMFMarker marker = BMFMarker(
                  position: BMFCoordinate(info.pt!.latitude,info.pt!.longitude),
                  enabled: false,
                  visible: true,
                  identifier: "location",
                  icon: 'assets/images/common/ic_device_online.png');

              /// 添加Marker
              logic.controller?.addMarker(marker);
            },
            child: Container(
              width: 1.sw,
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 20.w),
              margin: EdgeInsets.fromLTRB(20.w,0,20.w,0),
              decoration: const BoxDecoration(
                  color: HhColors.whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      info.name??""
                  ),
                  SizedBox(height: 20.w,),
                  Text(
                      '（${CommonUtils().parseLatLngPoint('${info.pt!.longitude}',2)}，${CommonUtils().parseLatLngPoint('${info.pt!.latitude}',2)}）',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 23.sp),
                  ),
                  SizedBox(height: 30.w,),
                  Container(
                    width: 1.sw,
                    height: 1.w,
                    color: HhColors.backColorF0,
                  ),
                ],
              ),
            ),
          )
      );
    }
    return list;
  }

}
