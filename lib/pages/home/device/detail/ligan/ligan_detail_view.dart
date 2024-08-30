import 'dart:ui';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/location/location_controller.dart';
import 'package:iot/pages/common/socket/socket_page/socket_controller.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:web_socket_channel/io.dart';

class LiGanDetailPage extends StatelessWidget {
  final logic = Get.find<LiGanDetailController>();

  LiGanDetailPage(String deviceNo, String id, {super.key}) {
    logic.deviceNo = deviceNo;
    logic.id = id;
  }

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
        Container(
          color: HhColors.backColor,
          width: 1.sw,
          height: 1.sh,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 160.w,
            color: HhColors.whiteColor,
          ),
        ),

        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              "设置",
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
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 160.w, 20.w, 30.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Tab页
                Container(
                  margin: EdgeInsets.only(top: 20.w),
                  height: 100.w,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 0;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '呼叫音',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 0
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 28.sp,
                                ),
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 0
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 1;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '走字屏',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 1
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 28.sp,
                                ),
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 1
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 2;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '编辑',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 2
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 28.sp,
                                ),
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 2
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                logic.tabIndex.value == 0
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///呼叫音
                          //可用提示音
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '可用提示音',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                logic.playing.value == 1 ?Expanded(
                                    child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: (){
                                          logic.playing.value = 0;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10.w, 3.w, 10.w, 3.w),
                                          decoration: BoxDecoration(
                                              color: HhColors.whiteColor,
                                              border: Border.all(color: HhColors.grayBBTextColor,width: 1.w),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(5.w))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                      "assets/images/common/icon_pause.png",
                                                  height: 22.w,
                                                  width: 22.w),
                                              SizedBox(width: 5.w,),
                                              Text('停止播放',
                                                  style: TextStyle(
                                                      color: HhColors.mainBlueColor,
                                                      fontSize: 23.sp,)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )):const SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '名称',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '描述',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '操作',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 20.w, 20.w, 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '摄像机位置类型',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.playing.value = 1;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          child: Text(
                                            '播放',
                                            style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Text(
                                        '上传',
                                        style: TextStyle(
                                          color: HhColors.mainBlueColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 20.w, 20.w, 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '设备场景预设照片',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.playing.value = 1;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          child: Text(
                                            '播放',
                                            style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Text(
                                        '上传',
                                        style: TextStyle(
                                          color: HhColors.mainBlueColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 20.w, 20.w, 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '点位名称',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.playing.value = 1;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          child: Text(
                                            '播放',
                                            style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Text(
                                        '上传',
                                        style: TextStyle(
                                          color: HhColors.mainBlueColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //设备提示音
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '设备提示音',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: (){

                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10.w, 3.w, 10.w, 3.w),
                                              margin: EdgeInsets.only(right: logic.playing.value == 1 ?160.w:0),
                                              decoration: BoxDecoration(
                                                  color: HhColors.whiteColor,
                                                  border: Border.all(color: HhColors.grayBBTextColor,width: 1.w),
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(5.w))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/common/icon_refresh.png",
                                                      height: 22.w,
                                                      width: 22.w),
                                                  SizedBox(width: 5.w,),
                                                  Text('刷新',
                                                      style: TextStyle(
                                                        color: HhColors.mainBlueColor,
                                                        fontSize: 23.sp,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        logic.playing.value == 1 ?Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: (){
                                              logic.playing.value = 0;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10.w, 3.w, 10.w, 3.w),
                                              decoration: BoxDecoration(
                                                  color: HhColors.whiteColor,
                                                  border: Border.all(color: HhColors.grayBBTextColor,width: 1.w),
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(5.w))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/common/icon_pause.png",
                                                      height: 22.w,
                                                      width: 22.w),
                                                  SizedBox(width: 5.w,),
                                                  Text('停止播放',
                                                      style: TextStyle(
                                                        color: HhColors.mainBlueColor,
                                                        fontSize: 23.sp,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ):const SizedBox(),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '名称',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '描述',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '操作',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 20.w, 20.w, 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '摄像机位置类型',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.playing.value = 1;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          child: Text(
                                            '播放',
                                            style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Text(
                                        '上传',
                                        style: TextStyle(
                                          color: HhColors.mainBlueColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 20.w, 20.w, 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '设备场景预设照片',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.playing.value = 1;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          child: Text(
                                            '播放',
                                            style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Text(
                                        '上传',
                                        style: TextStyle(
                                          color: HhColors.mainBlueColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 20.w, 20.w, 20.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '点位名称',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.playing.value = 1;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.w),
                                          child: Text(
                                            '播放',
                                            style: TextStyle(
                                              color: HhColors.mainBlueColor,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Text(
                                        '上传',
                                        style: TextStyle(
                                          color: HhColors.mainBlueColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //配置提示音
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '配置提示音',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '人形检测',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '提示音',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '漂洋过海来看你',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '音量',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(value: logic.voice.value*1.0, max: 100,min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voice.value = int.parse(s.substring(0,s.indexOf(".")));
                                            },),
                                          Text(
                                            '${logic.voice.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 26.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '播放时间',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '12:00-14:00',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '车辆检测',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '提示音',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '滴滴滴',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '音量',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Row(
                                      mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(value: logic.voice.value*1.0, max: 100,min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                            String s = "$value";
                                            logic.voice.value = int.parse(s.substring(0,s.indexOf(".")));
                                          },),
                                          Text(
                                            '${logic.voice.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 26.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '播放时间段',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '12:00-14:00',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),

                logic.tabIndex.value == 1
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///走字屏
                          //显示设置
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '显示设置',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '滑动速度',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(value: logic.speed.value*1.0, max: 100,min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.speed.value = int.parse(s.substring(0,s.indexOf(".")));
                                            },),
                                          /*Text(
                                            '${logic.speed.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 26.sp,
                                            ),
                                          )*/
                                        ],
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '滑动方向',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            30.w, 30.w, 30.w, 30.w),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                logic.direction.value = 0;
                                              },
                                              child: Image.asset(
                                                  logic.direction.value == 0
                                                      ? "assets/images/common/yes.png"
                                                      : "assets/images/common/no.png",
                                                  height: 32.w,
                                                  width: 32.w),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              '向上',
                                              style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 26.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30.w,
                                            ),
                                            InkWell(
                                              onTap: (){
                                                logic.direction.value = 1;
                                              },
                                              child: Image.asset(
                                                  logic.direction.value == 1
                                                      ? "assets/images/common/yes.png"
                                                      : "assets/images/common/no.png",
                                                  height: 32.w,
                                                  width: 32.w),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              '向下',
                                              style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 26.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '显示内容',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                                Container(
                                margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.backColor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(16.w))),
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    maxLength: 100,
                                    cursorColor: HhColors.titleColor_99,
                                    controller: logic.showContentController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15.w),
                                      border: InputBorder.none,
                                      counterText: '',
                                      hintText: '此处设置显示内容',
                                      hintStyle: TextStyle(
                                          color: HhColors.grayCCTextColor, fontSize: 26.sp,fontWeight: FontWeight.w200),
                                    ),
                                    style:
                                    TextStyle(color: HhColors.textBlackColor, fontSize: 26.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //息屏设置
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '息屏设置',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '息屏开关',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 26.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                value: logic.close.value,
                                                onChanged: (s) {
                                                  logic.close.value = s;
                                                },
                                                activeColor:
                                                HhColors.mainBlueColor,
                                                inactiveThumbColor:
                                                HhColors.mainBlueColor,
                                                inactiveTrackColor:
                                                HhColors.whiteColor,
                                                focusColor:
                                                HhColors.mainBlueColor,
                                                trackOutlineColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color?>(
                                                        (Set<MaterialState>
                                                    states) {
                                                      return HhColors.mainBlueColor;
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 25.w, 20.w, 25.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '息屏时间',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '12:00-14:00',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),

                logic.tabIndex.value == 2
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///编辑
                          //报警设置
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '报警设置',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '枪机1',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                value: logic.warnGANG1.value,
                                                onChanged: (s) {
                                                  logic.warnGANG1.value = s;
                                                },
                                                activeColor:
                                                    HhColors.mainBlueColor,
                                                inactiveThumbColor:
                                                    HhColors.mainBlueColor,
                                                inactiveTrackColor:
                                                    HhColors.whiteColor,
                                                focusColor:
                                                    HhColors.mainBlueColor,
                                                trackOutlineColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  /*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*/
                                                  return HhColors.mainBlueColor;
                                                }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '枪机2',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                  value: logic.warnGANG2.value,
                                                  onChanged: (s) {
                                                    logic.warnGANG2.value = s;
                                                  },
                                                  activeColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveThumbColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveTrackColor:
                                                      HhColors.whiteColor,
                                                  focusColor:
                                                      HhColors.mainBlueColor,
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    /*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*/
                                                    return HhColors
                                                        .mainBlueColor;
                                                  })),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '枪机3',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                  value: logic.warnGANG3.value,
                                                  onChanged: (s) {
                                                    logic.warnGANG3.value = s;
                                                  },
                                                  activeColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveThumbColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveTrackColor:
                                                      HhColors.whiteColor,
                                                  focusColor:
                                                      HhColors.mainBlueColor,
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    /*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*/
                                                    return HhColors
                                                        .mainBlueColor;
                                                  })),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '球机',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                  value: logic.warnBALL.value,
                                                  onChanged: (s) {
                                                    logic.warnBALL.value = s;
                                                  },
                                                  activeColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveThumbColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveTrackColor:
                                                      HhColors.whiteColor,
                                                  focusColor:
                                                      HhColors.mainBlueColor,
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    /*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*/
                                                    return HhColors
                                                        .mainBlueColor;
                                                  })),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '传感器',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                  value: logic.warnSENSOR.value,
                                                  onChanged: (s) {
                                                    logic.warnSENSOR.value = s;
                                                  },
                                                  activeColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveThumbColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveTrackColor:
                                                      HhColors.whiteColor,
                                                  focusColor:
                                                      HhColors.mainBlueColor,
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    /*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*/
                                                    return HhColors
                                                        .mainBlueColor;
                                                  })),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '开盖报警',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Switch(
                                                  value: logic.warnOPEN.value,
                                                  onChanged: (s) {
                                                    logic.warnOPEN.value = s;
                                                  },
                                                  activeColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveThumbColor:
                                                      HhColors.mainBlueColor,
                                                  inactiveTrackColor:
                                                      HhColors.whiteColor,
                                                  focusColor:
                                                      HhColors.mainBlueColor,
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color?>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    /*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*/
                                                    return HhColors
                                                        .mainBlueColor;
                                                  })),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //数据上报间隔
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '数据上报间隔',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '太阳能控制器',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          maxLength: 10,
                                          cursorColor: HhColors.titleColor_99,
                                          controller: logic.time1Controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            //contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          style: TextStyle(
                                              color: HhColors.gray6TextColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        '分',
                                        style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '一体式气象站',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          maxLength: 10,
                                          cursorColor: HhColors.titleColor_99,
                                          controller: logic.time2Controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            //contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          style: TextStyle(
                                              color: HhColors.gray6TextColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        '分',
                                        style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '土壤传感器',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          maxLength: 10,
                                          cursorColor: HhColors.titleColor_99,
                                          controller: logic.time3Controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            //contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          style: TextStyle(
                                              color: HhColors.gray6TextColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        '分',
                                        style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // child: ,
                          ),
                          //防火等级
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '防火等级',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 0;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 0
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '极高风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 1;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 1
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '高风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 2;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 2
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '较高风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 3;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 3
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '较低风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 4;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 4
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '低风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //枪球联动
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '枪球联动',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    logic.circle.value = 0;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.circle.value == 0
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '关闭',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.circle.value = 1;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.circle.value == 1
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '开启',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //固件版本号
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '固件版本号',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    logic.version.value = 0;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.version.value == 0
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          'V1.0.2387837',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.version.value = 1;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.version.value == 1
                                                ? "assets/images/common/yes.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          'V1.0.2387830',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //设备重启
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '设备重启',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showReStartDialog();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20.w),
                              padding:
                                  EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.w))),
                              child: Text(
                                '设备重启',
                                style: TextStyle(
                                  color: HhColors.blackColor,
                                  fontSize: 28.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showReStartDialog() {
    CommonUtils().showCommonDialog(logic.context, "确定要重启设备吗？", () {
      Get.back();
    }, () {
      Get.back();
      EventBusUtil.getInstance().fire(HhLoading(show: true));
      Future.delayed(const Duration(seconds: 1), () {
        EventBusUtil.getInstance().fire(HhLoading(show: false));
      });
    });
  }
}
