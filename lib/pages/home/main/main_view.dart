import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/main/search/search_binding.dart';
import 'package:iot/pages/home/main/search/search_view.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main_controller.dart';

class MainPage extends StatelessWidget {
  final logic = Get.find<MainController>();
  final homeLogic = Get.find<HomeController>();
  final messageLogic = Get.find<MessageController>();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return OverlayTooltipScaffold(
      overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: logic.tipController,
      preferredOverlay: GestureDetector(
        onTap: () {
          logic.tipController.dismiss();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: HhColors.mainGrayColor,
        ),
      ),
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: HhColors.backColor,
          body: Obx(
                () => Container(
              height: 1.sh,
              width: 1.sw,
              padding: EdgeInsets.zero,
              child: logic.secondStatus.value?(logic.pageMapStatus.value ? mapPage() : containPage()) : firstPage(),
            ),
          ),
        );
      },
    );
  }

  ///地图视图-搜索
  buildSearchView() {
    return Container(
      width: 0.6.sw,
      height: logic.searchDown.value?0.8.sw:150.w,
      margin: EdgeInsets.fromLTRB(30.w, logic.marginTop + 70.w, 0, 0),
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 20.w),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///搜索框
                Container(
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
                      Image.asset(
                        "assets/images/common/icon_search.png",
                        width: 35.w,
                        height: 35.w,
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
                      ),
                      InkWell(
                        onTap: (){
                          logic.searchDown.value = !logic.searchDown.value;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          child: Image.asset(
                            logic.searchDown.value?"assets/images/common/icon_top_status.png":"assets/images/common/icon_down_status.png",
                            width: 35.w,
                            height: 35.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w,),
                    ],
                  ),
                ),
                ///列表数据
                logic.searchDown.value?Expanded(
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
                                BMFCoordinate(double.parse('${item["latitude"]}'),double.parse('${item["longitude"]}')), false,
                              );
                              logic.controller?.setZoomTo(17);
                              logic.searchDown.value = false;
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                          margin: EdgeInsets.only(top: 10.w),
                                          child: Text(
                                            "${item['spaceName']}",
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 23.sp),
                                          ),
                                        ),
                                      ),
                                      "${item['longitude']}"=="null"?const SizedBox():Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10.w),
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
                ):const SizedBox(),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              logic.restartSearchClick();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 30.w, 0, 30.w),
              child: Image.asset(
                'assets/images/common/icon_map_left.png',
                width: 30.w,
                height: 30.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
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
                        "默认空间",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      /*Container(
                        height: 5.w,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: HhColors.blackTextColor,
                          border: Border.all(color: HhColors.blackTextColor),
                          borderRadius: BorderRadius.all(Radius.circular(2.w)),
                        ),
                      )*/
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
                        Future.delayed(const Duration(seconds: 5),(){
                          logic.refreshMarkers();
                        });
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
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.tipController.start();
                      },
                      child: OverlayTooltipItem(
                        displayIndex: 0,
                        tooltip: (controller) {
                          return BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: (){
                              logic.tipController.dismiss();
                              Get.to(() => SpaceManagePage(),
                                  binding: SpaceManageBinding());
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 30.w),
                              padding: EdgeInsets.fromLTRB(36.w, 38.w, 23.w, 38.w),
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.circular(26.w)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('管理空间', style: TextStyle(color: HhColors.blackColor,fontSize: 26.w,fontWeight: FontWeight.w200),),
                                  SizedBox(width: 30.w,),
                                  Image.asset(
                                    "assets/images/common/ic_setting.png",
                                    width: 30.w,
                                    height: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          );
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
                      ),
                    ),
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
                    Get.to(()=>DeviceDetailPage('${logic.model['deviceNo']}','${logic.model['id']}'),binding: DeviceDetailBinding());
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
                            child: Image.asset(
                              "assets/images/common/test_video.jpg",
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(30.w, 20.w, 0, 0),
                            child: Text(
                              "${logic.model["name"]}",
                              style: TextStyle(
                                  color: HhColors.blackTextColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                            ),
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
                        ),
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
                        '搜索设备、空间、消息...',
                        style: TextStyle(
                            color: HhColors.textColor, fontSize: 28.sp),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    /*Image.asset(
                      "assets/images/common/ic_record.png",
                      width: 44.w,
                      height: 44.w,
                      fit: BoxFit.fill,
                    ),*/
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
                      margin: EdgeInsets.fromLTRB(logic.text.value.contains('未获取')?30.w:55.w, 0, 0, 10.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          logic.text.value.contains('未获取')?const SizedBox():SizedBox(
                            width: 44.w,
                            height: 44.w,
                            child: Stack(
                              children: [
                                SizedBox(
                                    width: 44.w,
                                    height: 44.w,
                                    child: WebViewWidget(controller: logic.webController,)),
                                logic.iconStatus.value?const SizedBox():Image.asset(
                                  "assets/images/common/icon_weather.png",
                                  width: 44.w,
                                  height: 44.w,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                  color: HhColors.trans,
                                    width: 44.w,
                                    height: 44.w),
                              ],
                            ),
                          ),
                          logic.text.value.contains('未获取')?const SizedBox():SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            // logic.text.value.contains('未获取')?logic.text.value:"${logic.temp.value}°${logic.text.value}",
                            logic.text.value.contains('未获取')?logic.text.value:"${logic.dateStr.value} ${logic.cityStr.value}",
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
                                messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value==0?const SizedBox():Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: HhColors.mainRedColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10.w))
                                    ),
                                    width: 25.w + ((3-1) * 6.w),
                                    height: 25.w,
                                    child: Center(child: Text(messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value>99?"99+":"${messageLogic.noticeCountInt.value+messageLogic.warnCountInt.value}",style: TextStyle(color: HhColors.whiteColor,fontSize: 16.sp),)),
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
            ///空间列表滚动
            SizedBox(
              height: 100.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: logic.spaceListStatus.value?Container(
                      margin: EdgeInsets.fromLTRB(40.w, 0, 260.w, 10.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: buildSpaces(),
                        ),
                      ),
                    ):const SizedBox(),
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
                            logic.tipController.start();
                          },
                          child: OverlayTooltipItem(
                            displayIndex: 0,
                            tooltip: (controller) {
                              return BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: (){
                                  logic.tipController.dismiss();
                                  Get.to(() => SpaceManagePage(),
                                      binding: SpaceManageBinding());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 30.w),
                                  padding: EdgeInsets.fromLTRB(36.w, 38.w, 23.w, 38.w),
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.circular(26.w)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('管理空间', style: TextStyle(color: HhColors.blackColor,fontSize: 26.w,fontWeight: FontWeight.w200),),
                                      SizedBox(width: 30.w,),
                                      Image.asset(
                                        "assets/images/common/ic_setting.png",
                                        width: 30.w,
                                        height: 30.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
                  logic.getDeviceList(logic.pageNum);
                },
                onLoad: (){
                  logic.pageNum++;
                  logic.getDeviceList(logic.pageNum);
                },
                child: PagedGridView<int, dynamic>(
                    pagingController: logic.pagingController,
                    padding: EdgeInsets.zero,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) =>
                          gridItemView(context, item, index),
                      noItemsFoundIndicatorBuilder:  (context) =>
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: (){
                                  Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 25.w, 30.w, 0),
                                  padding: EdgeInsets.fromLTRB(25.w, 25.w, 25.w, 25.w),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.circular(20.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/common/ic_camera.png",
                                        width: 100.w,
                                        height: 100.w,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(width: 20.w,),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('添加新设备',style: TextStyle(color: HhColors.textBlackColor,fontSize: 30.sp,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 10.w,),
                                            Text('按步骤将设备添加到APP',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 26.sp),),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/common/icon_go.png",
                                        width: 30.w,
                                        height: 30.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  ///设备列表视图-网格列表itemView
  gridItemView(BuildContext context, dynamic item, int index) {
    return InkWell(
      onTap: (){
        Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
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
            SizedBox(
              height: 0.23.sw,
              width: 0.5.sw,
              child: Stack(
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
                  item['status']==1?const SizedBox():Container(
                    height: 0.23.sw,
                    width: 0.5.sw,
                    decoration: BoxDecoration(
                        color: HhColors.grayEDBackColor.withAlpha(160),
                        borderRadius: BorderRadius.vertical(top:Radius.circular(32.w))),
                  ),
                  item['status']==1?const SizedBox():Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/icon_wifi.png",
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.fill,
                        ),
                        Text('设备离线',style: TextStyle(color: HhColors.whiteColor,fontSize: 26.sp),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 16.w, 16.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      "${item['name']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: HhColors.blackColor,
                          fontSize: 30.sp,),
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  item["shareMark"]==1 || item["shareMark"]==2 ?Column(
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
                          item["shareMark"]==1?"分享中":item["shareMark"]==2?"好友分享":'',
                          style: TextStyle(color: item["shareMark"]==1?HhColors.mainBlueColor:HhColors.textColor, fontSize: 23.sp),
                        ),
                      ),
                    ],
                  ):const SizedBox(),
                  item['deviceCount']==0?const SizedBox():InkWell(
                    onTap: (){
                      showEditDeviceDialog(item);
                    },
                    child: Container(padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
                        child: Text(':',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 30.sp,fontWeight: FontWeight.bold),)),
                  ),
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
            "添加新空间",
            textAlign: TextAlign.center,
            style: TextStyle(color: HhColors.grayEEBackColor, fontSize: 28.sp),
          ),
        ),
      ),
      onPressed: () {
        Get.to(()=>SpacePage(),binding: SpaceBinding());
      },
    );
  }

  ///首次进入页面
  firstPage(){
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
              height: 50.w,
            ),
            ///位置
            SizedBox(
              height: 100.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25.w, 0, 0, 10.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 44.w,
                            height: 44.w,
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_loc.png",
                                  width: 44.w,
                                  height: 44.w,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                    color: HhColors.trans,
                                    width: 44.w,
                                    height: 44.w),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: Text(
                              logic.locText.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 24.sp,fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 180.w,
                          ),
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
                            homeLogic.index.value = 2;
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
            Container(
              margin: EdgeInsets.fromLTRB(30.w, 25.w, 30.w, 0),
              width: 1.sw,
              height: 0.5.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w)
              ),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/common/icon_default.png",
                    width: 1.sw,
                    height: 0.5.sw,
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () async {
                        logic.secondStatus.value = true;
                        /// 初次进入设置
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(SPKeys().second, true);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30.w, 5.w, 30.w, 8.w),
                        decoration: BoxDecoration(
                          color: HhColors.transBlack,
                          borderRadius: BorderRadius.circular(30.w)
                        ),
                        child: Text('进入默认空间',style: TextStyle(color: HhColors.whiteColor,fontSize: 26.sp),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              onPressed: (){
                Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(30.w, 25.w, 30.w, 0),
                padding: EdgeInsets.fromLTRB(25.w, 25.w, 25.w, 25.w),
                width: 1.sw,
                decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/common/ic_camera.png",
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(width: 20.w,),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('添加新设备',style: TextStyle(color: HhColors.textBlackColor,fontSize: 30.sp,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.w,),
                          Text('按步骤将设备添加到APP',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 26.sp),),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/common/icon_go.png",
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  buildSpaces() {
    List<Widget> list = [];
    for(int i = 0;i < logic.spaceList.length;i++){
      dynamic model = logic.spaceList[i];
      list.add(
          InkWell(
            onTap: (){
              logic.spaceListIndex.value = i;
              logic.pageNum = 1;
              logic.getDeviceList(1);
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['name']}",
                    style: TextStyle(
                        color: logic.spaceListIndex.value == i?HhColors.blackTextColor:HhColors.gray9TextColor,
                        fontSize: logic.spaceListIndex.value == i?36.sp:30.sp,
                        fontWeight: logic.spaceListIndex.value == i?FontWeight.bold:FontWeight.w500),
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  logic.spaceListIndex.value == i?Container(
                    height: 5.w,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: HhColors.blackTextColor,
                      border:
                      Border.all(color: HhColors.blackTextColor),
                      borderRadius:
                      BorderRadius.all(Radius.circular(2.w)),
                    ),
                  ):const SizedBox(),
                ],
              ),
            ),
          )
      );
    }
    
    return list;
  }

  void showEditDeviceDialog(item) {
    showCupertinoDialog(context: logic.context, builder: (context) => Center(
      child: Container(
        width: 1.sw,
        height: 160.w,
        margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
        padding: EdgeInsets.fromLTRB(30.w, 35.w, 45.w, 25.w),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Row(
          children: [
            Expanded(
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: (){
                  if(item["shareMark"]==1){
                    return;
                  }
                  Get.back();
                  DateTime date = DateTime.now();
                  String time = date.toIso8601String().substring(0,19).replaceAll("T", " ");
                  Get.to(()=>SharePage(),binding: ShareBinding(),arguments: {
                    "shareType": "2",
                    "expirationTime": time,
                    "appShareDetailSaveReqVOList": [
                      {
                        "spaceId": "${item["spaceId"]}",
                        "spaceName": "${item["spaceName"]}",
                        "deviceId": "${item["id"]}",
                        "deviceName": "${item["name"]}"
                      }
                    ]
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      item["shareMark"]==1?"assets/images/common/icon_edit_share_no.png":"assets/images/common/icon_edit_share.png",
                      width: 45.w,
                      height: 45.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 10.w,),
                    Text('分享',style: TextStyle(color: item["shareMark"]==1?HhColors.grayCCTextColor:HhColors.gray6TextColor,fontSize: 26.sp,
                      decoration: TextDecoration.none,),),
                  ],
                ),
              ),
            ),
            SizedBox(width: 50.w,),
            Expanded(
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {
                  Get.back();
                  Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding(),arguments: item);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/common/icon_edit_edit.png",
                      width: 45.w,
                      height: 45.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 10.w,),
                    Text('修改',style: TextStyle(color: HhColors.gray6TextColor,fontSize: 26.sp,
                      decoration: TextDecoration.none,),),
                  ],
                ),
              ),
            ),
            SizedBox(width: 50.w,),
            Expanded(
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {
                  Get.back();
                  CommonUtils().showDeleteDialog(context, '确定要删除该设备吗?', (){
                    Get.back();
                  }, (){
                    Get.back();
                    logic.deleteDevice(item);
                  }, (){
                    Get.back();
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/common/icon_edit_delete.png",
                      width: 45.w,
                      height: 45.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 10.w,),
                    Text('删除',style: TextStyle(color: HhColors.mainRedColor,fontSize: 26.sp,
                      decoration: TextDecoration.none,),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
