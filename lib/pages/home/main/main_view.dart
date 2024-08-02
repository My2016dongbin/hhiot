import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/common/socket/socket_page/socket_binding.dart';
import 'package:iot/pages/common/socket/socket_page/socket_view.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/main/search/search_binding.dart';
import 'package:iot/pages/home/main/search/search_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/routes/app_navigator.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/CustomRoute.dart';
import '../../../utils/HhColors.dart';
import '../../common/common_data.dart';
import '../../common/model/model_class.dart';
import '../my/my_view.dart';
import 'main_controller.dart';

class MainPage extends StatelessWidget {
  final logic = Get.find<MainController>();
  final homeLogic = Get.find<HomeController>();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.pageMapStatus.value ? mapPage() : containPage(),
        ),
      ),
    );
  }

  ///地图视图-搜索
  buildSearchView() {
    return Container(
      width: 0.6.sw,
      height: 0.8.sw,
      margin: EdgeInsets.fromLTRB(30.w, logic.marginTop + 70.w, 0, 0),
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 50.w, 20.w),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: HhColors.trans_77,

              ///控制阴影的位置
              offset: Offset(0, 10),

              ///控制阴影的大小
              blurRadius: 24.0,
            ),
          ],
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///搜索框
          Container(
            // height: 80.w,
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                border: Border.all(color: HhColors.mainBlueColor),
                borderRadius: BorderRadius.all(Radius.circular(50.w))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: logic.restartSearchClick,
                  child: Image.asset(
                    "assets/images/common/icon_search.png",
                    width: 35.w,
                    height: 35.w,
                    fit: BoxFit.fill,
                  ),
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
                      // if(logic.searchController!.text.isEmpty){
                      //   EventBusUtil.getInstance().fire(HhToast(title: '请输入名称'));
                      //   return;
                      // }
                      logic.deviceSearch();
                    },
                    decoration: InputDecoration(
                      //contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: '请输入名称',
                      hintStyle: TextStyle(
                          color: HhColors.gray9TextColor, fontSize: 24.sp),
                    ),
                    style:
                        TextStyle(color: HhColors.textColor, fontSize: 24.sp),
                  ),
                )
              ],
            ),
          ),
          ///列表数据
          Expanded(
            child: PagedListView<int, dynamic>(
              pagingController: logic.deviceController,
              padding: EdgeInsets.zero,
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                noItemsFoundIndicatorBuilder: (context) =>CommonUtils().noneWidgetSmall(),
                itemBuilder: (context, item, index) =>
                    InkWell(
                      onTap: (){
                        HhLog.d("touch ${item["latitude"]},${item["longitude"]}");
                        logic.controller?.setCenterCoordinate(
                          BMFCoordinate(item["latitude"],item["longitude"]), false,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                                color: HhColors.blueBackColor,
                                borderRadius: BorderRadius.all(Radius.circular(20.w))),
                            margin: EdgeInsets.fromLTRB(10.w, 20.w, 10.w, 10.w),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "${item['name']}",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 26.sp,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 50.w),
                                    child: Text(
                                      "${item['spaceName']}",
                                      style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 23.sp),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 90.w),
                                    child: Text(
                                      "(${CommonUtils().subString("${item['longitude']}", 8)},${CommonUtils().subString("${item['latitude']}", 8)})",
                                      style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 23.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 0.5.w,
                            width: 1.sw,
                            margin: EdgeInsets.fromLTRB(20.w, 5.w, 20.w, 0),
                            color: HhColors.grayDDTextColor,
                          )
                        ],
                      ),
                    )
              ),
            ),
          ),
          /*Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
                color: HhColors.blueBackColor,
                borderRadius: BorderRadius.all(Radius.circular(20.w))),
            margin: EdgeInsets.fromLTRB(10.w, 20.w, 10.w, 10.w),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "WF1000U单目摄像头",
                    style: TextStyle(
                        color: HhColors.textBlackColor,
                        fontSize: 26.sp,fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 50.w),
                    child: Text(
                      "崂山区崂山水库西侧50米",
                      style: TextStyle(
                          color: HhColors.gray9TextColor,
                          fontSize: 23.sp),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 90.w),
                    child: Text(
                      "(120.55,36.40)",
                      style: TextStyle(
                          color: HhColors.gray9TextColor,
                          fontSize: 23.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5.w,
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(20.w, 5.w, 20.w, 0),
            color: HhColors.grayDDTextColor,
          ),
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20.w))),
            margin: EdgeInsets.fromLTRB(10.w, 20.w, 10.w, 10.w),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "WF1000U单目摄像头",
                    style: TextStyle(
                        color: HhColors.textBlackColor,
                        fontSize: 26.sp,fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 50.w),
                    child: Text(
                      "崂山区崂山水库西侧50米",
                      style: TextStyle(
                          color: HhColors.gray9TextColor,
                          fontSize: 23.sp),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 90.w),
                    child: Text(
                      "(120.55,36.40)",
                      style: TextStyle(
                          color: HhColors.gray9TextColor,
                          fontSize: 23.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  ///主页-地图视图
  mapPage() {
    return Stack(
      children: [
        BMFMapWidget(
          onBMFMapCreated: (controller) {
            logic.onBMFMapCreated(controller);
          },
          mapOptions: BMFMapOptions(
              center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                  CommonData.longitude ?? 120.314037),
              zoomLevel: 12,
              mapType: BMFMapType.Standard,
              mapPadding:
                  BMFEdgeInsets(left: 30.w, top: 0, right: 30.w, bottom: 0)),
        ),
        Container(
          height: 160.w,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [HhColors.backTransColor1, HhColors.backTransColor3]),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(40.w, 0, 0, 10.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "我的空间",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      Container(
                        height: 5.w,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: HhColors.blackTextColor,
                          border: Border.all(color: HhColors.blackTextColor),
                          borderRadius: BorderRadius.all(Radius.circular(2.w)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        logic.pageMapStatus.value = false;
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.w),
                        padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 10.w),
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(40.w)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/ic_jk.png",
                              width: 36.w,
                              height: 36.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Text(
                              "空间",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 24.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        //Get.to(()=>SharePage(),binding: ShareBinding());
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(30.w, 0, 20.w, 10.w),
                        child: Image.asset(
                          "assets/images/common/icon_menu.png",
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: logic.searchStatus.value
              ? buildSearchView()
              : Column(
                  children: [
                    Row(
                      children: [
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: logic.onSearchClick,
                          child: Container(
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w)),
                              boxShadow: const [
                                BoxShadow(
                                  color: HhColors.trans_77,

                                  ///控制阴影的位置
                                  offset: Offset(0, 10),

                                  ///控制阴影的大小
                                  blurRadius: 24.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.fromLTRB(
                                30.w, logic.marginTop + 70.w, 0, 0),
                            padding:
                                EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 10.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_search.png",
                                  width: 50.w,
                                  height: 50.w,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height: 5.w,
                                ),
                                Text(
                                  "搜索",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: HhColors.blackTextColor,
                                      fontSize: 20.sp),
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
        logic.videoStatus.value
            ? Align(
                alignment: Alignment.bottomCenter,
                child:
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    logic.videoStatus.value = !logic.videoStatus.value;
                  },
                  child: Container(
                    width: 0.9.sw,
                    height: 0.4.sw,
                    margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 30.w),
                    clipBehavior: Clip.hardEdge,
                    //裁剪
                    decoration: BoxDecoration(
                        color: HhColors.trans,
                        borderRadius: BorderRadius.all(Radius.circular(30.w))),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 0.9.sw,
                            height: 0.4.sw,
                            color: HhColors.blackColor,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 20.w, 20.w, 0),
                            padding:
                                EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                            decoration: BoxDecoration(
                                color: HhColors.blackColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w))),
                            child: Text(
                              "进入",
                              style: TextStyle(
                                  color: HhColors.whiteColor, fontSize: 24.sp),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  ///主页-我的空间视图
  containPage() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [HhColors.backTransColor1, HhColors.backTransColor3]),
          ),
        ),
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HhColors.backTransColor1,
                      HhColors.backTransColor3
                    ]),
              ),
            ),
            ///搜索
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              onPressed: () {
                Get.to(()=>SearchPage(),binding: SearchBinding());
              },
              child: Container(
                height: 85.w,
                margin: EdgeInsets.fromLTRB(20.w, logic.marginTop, 20.w, 0),
                decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(40.w)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                    ),
                    Image.asset(
                      "assets/images/common/icon_search.png",
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Text(
                        '搜索设备、事件、和视频',
                        style: TextStyle(
                            color: HhColors.textColor, fontSize: 28.sp),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Image.asset(
                      "assets/images/common/ic_record.png",
                      width: 44.w,
                      height: 44.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 40.w,
                    )
                  ],
                ),
              ),
            ),
            ///天气
            SizedBox(
              height: 100.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(55.w, 0, 0, 10.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/icon_weather.png",
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "${logic.temp.value}°${logic.text.value}",
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                fontSize: 24.sp),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset(
                            "assets/images/common/back_role.png",
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.fill,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          //TODO Socket测试
                          homeLogic.index.value = 2;
                          // Get.to(()=>SocketPage(),binding: SocketBinding());
                        },
                          child: Container(
                            width: 55.w,
                            height: 50.w,
                            margin: EdgeInsets.only(bottom: 10.w),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Image.asset(
                                    "assets/images/common/icon_message_main.png",
                                    width: 45.w,
                                    height: 45.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                /*Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    "assets/images/common/icon_red1.png",
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),*/
                                logic.count.value=='0'?const SizedBox():Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: HhColors.mainRedColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10.w))
                                    ),
                                    width: 25.w + ((logic.count.value.length-1) * 6.w),
                                    height: 25.w,
                                    child: Center(child: Text(logic.count.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 16.sp),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(30.w, 0, 20.w, 10.w),
                            child: Image.asset(
                              "assets/images/common/ic_add.png",
                              width: 45.w,
                              height: 45.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ///我的空间
            SizedBox(
              height: 100.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(40.w, 0, 0, 10.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "我的空间",
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.w,
                          ),
                          Container(
                            height: 5.w,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: HhColors.blackTextColor,
                              border:
                                  Border.all(color: HhColors.blackTextColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.w)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.pageMapStatus.value = true;
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.w),
                            padding:
                                EdgeInsets.fromLTRB(16.w, 6.w, 16.w, 6.w),
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.w)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_map.png",
                                  width: 30.w,
                                  height: 30.w,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 3.h,
                                ),
                                Text(
                                  "地图",
                                  style: TextStyle(
                                      color: HhColors.mainBlueColor,
                                      fontSize: 24.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: (){
                            //Get.to(()=>SharePage(),binding: ShareBinding());
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(30.w, 0, 20.w, 10.w),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: HhColors.trans,
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            child: Image.asset(
                              "assets/images/common/icon_menu.png",
                              width: 55.w,
                              height: 50.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ///GridView
            Expanded(
              child: EasyRefresh(
                onRefresh: (){
                  logic.pageNum = 1;
                  logic.getSpaceList(logic.pageNum);
                },
                onLoad: (){
                  logic.pageNum++;
                  logic.getSpaceList(logic.pageNum);
                },
                child: PagedGridView<int, dynamic>(
                    pagingController: logic.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) =>
                          gridItemView(context, item, index),
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //横轴n个子widget
                        childAspectRatio: 1.3 //宽高比
                    )),
              ),
            ),
            buttonView()
          ],
        ),

      ],
    );
  }

  ///我的空间视图-网格列表itemView
  gridItemView(BuildContext context, dynamic item, int index) {
    return InkWell(
      onTap: (){
        Get.to(()=>DeviceListPage(id: "${item['id']}",),binding: DeviceListBinding());
      },
      child: Container(
        clipBehavior: Clip.hardEdge, //裁剪
        margin: EdgeInsets.fromLTRB(index%2==0?30.w:15.w, 30.w, index%2==0?15.w:30.w, 0),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(32.w))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 0.23.sw,
              width: 0.5.sw,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(32.w))),
              child: Image.asset(
                "assets/images/common/test_video.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 16.w, 10.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${item['name']}",
                    style: TextStyle(
                        color: HhColors.blackColor,
                        fontSize: 30.sp,),
                  ),
                  SizedBox(width: 10.w,),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(12.w, 2.w, 12.w, 2.w),
                          decoration: BoxDecoration(
                            color: HhColors.grayEFBackColor,
                            borderRadius: BorderRadius.all(Radius.circular(8.w))
                          ),
                          child: Text(
                            "${item['deviceCount']}个设备",
                            style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  item['deviceCount']==0?const SizedBox():Image.asset(
                    "assets/images/common/icon_red.png",
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///我的空间视图-添加空间按钮
  buttonView() {
    return
      BouncingWidget(
        duration: const Duration(milliseconds: 100),
        scaleFactor: 1.2,
      child: Container(
        width: 1.sw,
        height: 90.w,
        margin: EdgeInsets.fromLTRB(50.w, 20.w, 50.w, 50.w),
        decoration: BoxDecoration(
            color: HhColors.mainBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(50.w))),
        child: Center(
          child: Text(
            "没有我的空间？去添加",
            textAlign: TextAlign.center,
            style: TextStyle(color: HhColors.grayEEBackColor, fontSize: 26.sp),
          ),
        ),
      ),
      onPressed: () {
        Get.to(()=>SpacePage(),binding: SpaceBinding());
      },
    );
  }
}
