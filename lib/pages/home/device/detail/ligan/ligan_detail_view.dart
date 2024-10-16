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
import 'package:iot/utils/switch/lite_rolling_switch.dart';
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
                                logic.playing.value == 1
                                    ? Expanded(
                                        child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                logic.playing.value = 0;
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10.w, 3.w, 10.w, 3.w),
                                                decoration: BoxDecoration(
                                                    color: HhColors.whiteColor,
                                                    border: Border.all(
                                                        color: HhColors
                                                            .grayBBTextColor,
                                                        width: 1.w),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.w))),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/common/icon_pause.png",
                                                        height: 22.w,
                                                        width: 22.w),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text('停止播放',
                                                        style: TextStyle(
                                                          color: HhColors
                                                              .mainBlueColor,
                                                          fontSize: 23.sp,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.w))),
                            child: logic.voiceTopStatus.value
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: buildVoiceList(),
                                  )
                                : const SizedBox(),
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
                                        onTap: () {
                                          logic.getVoiceUse();
                                          logic.getDeviceConfig();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10.w, 3.w, 10.w, 3.w),
                                          margin: EdgeInsets.only(
                                              right: logic.playing.value == 1
                                                  ? 160.w
                                                  : 0),
                                          decoration: BoxDecoration(
                                              color: HhColors.whiteColor,
                                              border: Border.all(
                                                  color:
                                                      HhColors.grayBBTextColor,
                                                  width: 1.w),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.w))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  "assets/images/common/icon_refresh.png",
                                                  height: 22.w,
                                                  width: 22.w),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text('刷新',
                                                  style: TextStyle(
                                                    color:
                                                        HhColors.mainBlueColor,
                                                    fontSize: 23.sp,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    logic.playing.value == 1
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                logic.stopVoice();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10.w, 3.w, 10.w, 3.w),
                                                decoration: BoxDecoration(
                                                    color: HhColors.whiteColor,
                                                    border: Border.all(
                                                        color: HhColors
                                                            .grayBBTextColor,
                                                        width: 1.w),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.w))),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/common/icon_pause.png",
                                                        height: 22.w,
                                                        width: 22.w),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text('停止播放',
                                                        style: TextStyle(
                                                          color: HhColors
                                                              .mainBlueColor,
                                                          fontSize: 23.sp,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
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
                              children: buildVoiceListBottom(),
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
                                          '${logic.config["audioHumanName"]}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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
                                          Slider(
                                            value: logic.voiceHuman.value * 1.0,
                                            max: 5,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voiceHuman.value =
                                                  int.parse(s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          Text(
                                            '${logic.voiceHuman.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 26.sp,
                                            ),
                                          )
                                        ],
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
                                          '${logic.config["audioHumanTime"]}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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
                                          '${logic.config["audioCarName"]}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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
                                          Slider(
                                            value: logic.voiceCar.value * 1.0,
                                            max: 5,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voiceCar.value = int.parse(
                                                  s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          Text(
                                            '${logic.voiceCar.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 26.sp,
                                            ),
                                          )
                                        ],
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
                                          '${logic.config["audioCarTime"]}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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
                                          '开盖检测',
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
                                          '${logic.config["audioOpenName"]}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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
                                          Slider(
                                            value: logic.voiceCap.value * 1.0,
                                            max: 5,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voiceCap.value = int.parse(
                                                  s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          Text(
                                            '${logic.voiceCap.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 26.sp,
                                            ),
                                          )
                                        ],
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
                                          '${logic.config["audioOpenTime"]}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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

                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.voiceSubmitHuman();
                              logic.voiceSubmitCar();
                              logic.voiceSubmitCap();
                            },
                            child: Container(
                              width: 1.sw,
                              height: 90.w,
                              margin: EdgeInsets.fromLTRB(0, 30.w, 0, 30.w),
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.w))),
                              child: Center(
                                child: Text(
                                  "确定",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: HhColors.whiteColor,
                                      fontSize: 28.sp,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          )
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
                                          Slider(
                                            value: logic.speed.value * 1.0,
                                            max: 10,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.speed.value = int.parse(
                                                  s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                logic.direction.value = 0;
                                              },
                                              child: Image.asset(
                                                  logic.direction.value == 0
                                                      ? "assets/images/common/yes2.png"
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
                                              onTap: () {
                                                logic.direction.value = 1;
                                              },
                                              child: Image.asset(
                                                  logic.direction.value == 1
                                                      ? "assets/images/common/yes2.png"
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
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      20.w, 10.w, 20.w, 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.backColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.w))),
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    maxLength: 100,
                                    cursorColor: HhColors.titleColor_99,
                                    controller: logic.showContentController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15.w),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                      counterText: '',
                                      hintText: '此处设置显示内容',
                                      hintStyle: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 26.sp,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    onChanged: (s) {
                                      logic.ledContent.value = s;
                                    },
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 26.sp),
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
                                              child: /*Switch(
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
                                              )*/
                                                  SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.close.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.close.value = state;
                                                  },
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
                                          '${logic.ledTime}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 26.sp,
                                          ),
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

                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.postScreenTop();
                              logic.postScreenBottom();
                            },
                            child: Container(
                              width: 1.sw,
                              height: 90.w,
                              margin: EdgeInsets.fromLTRB(0, 30.w, 0, 30.w),
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.w))),
                              child: Center(
                                child: Text(
                                  "确定",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: HhColors.whiteColor,
                                      fontSize: 28.sp,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          )
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
                                              child: /*Switch(
                                                value: logic.warnGANG1.value,
                                                onChanged: (s) {
                                                  logic.warnGANG1.value = s;
                                                  logic.warnSet("gCam1",
                                                      s ? "ON" : "OFF");
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
                                                  *//*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*//*
                                                  return HhColors.mainBlueColor;
                                                }),
                                              )*/SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.warnGANG1.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.warnGANG1.value = state;
                                                    logic.warnSet("gCam1",
                                                        state ? "ON" : "OFF");
                                                  },
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
                                              child: /*Switch(
                                                  value: logic.warnGANG2.value,
                                                  onChanged: (s) {
                                                    logic.warnGANG2.value = s;
                                                    logic.warnSet("gCam2",
                                                        s ? "ON" : "OFF");
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
                                                    *//*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*//*
                                                    return HhColors
                                                        .mainBlueColor;
                                                  }))*/SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.warnGANG2.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.warnGANG2.value = state;
                                                    logic.warnSet("gCam2",
                                                        state ? "ON" : "OFF");
                                                  },
                                                ),
                                              ),
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
                                              child: /*Switch(
                                                  value: logic.warnGANG3.value,
                                                  onChanged: (s) {
                                                    logic.warnGANG3.value = s;
                                                    logic.warnSet("gCam3",
                                                        s ? "ON" : "OFF");
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
                                                    *//*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*//*
                                                    return HhColors
                                                        .mainBlueColor;
                                                  }))*/SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.warnGANG3.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.warnGANG3.value = state;
                                                    logic.warnSet("gCam3",
                                                        state ? "ON" : "OFF");
                                                  },
                                                ),
                                              ),
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
                                              child: /*Switch(
                                                  value: logic.warnBALL.value,
                                                  onChanged: (s) {
                                                    logic.warnBALL.value = s;
                                                    logic.warnSet("sCam1",
                                                        s ? "ON" : "OFF");
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
                                                    *//*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*//*
                                                    return HhColors
                                                        .mainBlueColor;
                                                  }))*/SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.warnBALL.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.warnBALL.value = state;
                                                    logic.warnSet("sCam1",
                                                        state ? "ON" : "OFF");
                                                  },
                                                ),
                                              ),
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
                                              child: /*Switch(
                                                  value: logic.warnSENSOR.value,
                                                  onChanged: (s) {
                                                    logic.warnSENSOR.value = s;
                                                    logic.warnSet("sensor",
                                                        s ? "ON" : "OFF");
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
                                                    *//*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*//*
                                                    return HhColors
                                                        .mainBlueColor;
                                                  }))*/SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.warnSENSOR.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.warnSENSOR.value = state;
                                                    logic.warnSet("sensor",
                                                        state ? "ON" : "OFF");
                                                  },
                                                ),
                                              ),
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
                                              child: /*Switch(
                                                  value: logic.warnOPEN.value,
                                                  onChanged: (s) {
                                                    logic.warnOPEN.value = s;
                                                    logic.warnSet("cap",
                                                        s ? "ON" : "OFF");
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
                                                    *//*if (states.contains(
                                            MaterialState.disabled)) {
                                          return HhColors.mainBlueColor;
                                        }*//*
                                                    return HhColors
                                                        .mainBlueColor;
                                                  }))*/SizedBox(
                                                height: 50.w,
                                                width: 90.w,
                                                child: LiteRollingSwitch(
                                                  value: logic.warnOPEN.value,
                                                  textOn: '',
                                                  textOff: '',
                                                  colorOff: HhColors
                                                      .titleColor_99
                                                      .withAlpha(200),
                                                  colorOn: HhColors
                                                      .mainBlueColor
                                                      .withAlpha(200),
                                                  animationDuration: const Duration(
                                                      milliseconds: 600),
                                                  onChanged: (bool state) {
                                                    logic.warnOPEN.value = state;
                                                    logic.warnSet("cap",
                                                        state ? "ON" : "OFF");
                                                  },
                                                ),
                                              ),
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
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      /*Switch(
                                        value: logic.energyAction.value,
                                        onChanged: (s) {
                                          logic.energyAction.value = s;
                                        },
                                        activeColor: HhColors.mainBlueColor,
                                        inactiveThumbColor:
                                            HhColors.mainBlueColor,
                                        inactiveTrackColor: HhColors.whiteColor,
                                        focusColor: HhColors.mainBlueColor,
                                        trackOutlineColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                          return HhColors.mainBlueColor;
                                        }),
                                      )*/SizedBox(
                                        height: 50.w,
                                        width: 90.w,
                                        child: LiteRollingSwitch(
                                          value: logic.energyAction.value,
                                          textOn: '',
                                          textOff: '',
                                          colorOff: HhColors
                                              .titleColor_99
                                              .withAlpha(200),
                                          colorOn: HhColors
                                              .mainBlueColor
                                              .withAlpha(200),
                                          animationDuration: const Duration(
                                              milliseconds: 600),
                                          onChanged: (bool state) {
                                            logic.energyAction.value = state;
                                          },
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
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (s) {
                                            logic.energyDelay.value = s;
                                          },
                                          style: TextStyle(
                                              color: HhColors.blueTextColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w400),
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
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      /*Switch(
                                        value: logic.weatherAction.value,
                                        onChanged: (s) {
                                          logic.weatherAction.value = s;
                                        },
                                        activeColor: HhColors.mainBlueColor,
                                        inactiveThumbColor:
                                            HhColors.mainBlueColor,
                                        inactiveTrackColor: HhColors.whiteColor,
                                        focusColor: HhColors.mainBlueColor,
                                        trackOutlineColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                          return HhColors.mainBlueColor;
                                        }),
                                      )*/SizedBox(
                                        height: 50.w,
                                        width: 90.w,
                                        child: LiteRollingSwitch(
                                          value: logic.weatherAction.value,
                                          textOn: '',
                                          textOff: '',
                                          colorOff: HhColors
                                              .titleColor_99
                                              .withAlpha(200),
                                          colorOn: HhColors
                                              .mainBlueColor
                                              .withAlpha(200),
                                          animationDuration: const Duration(
                                              milliseconds: 600),
                                          onChanged: (bool state) {
                                            logic.weatherAction.value = state;
                                          },
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
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (s) {
                                            logic.weatherDelay.value = s;
                                          },
                                          style: TextStyle(
                                              color: HhColors.blueTextColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w400),
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
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      /*Switch(
                                        value: logic.soilAction.value,
                                        onChanged: (s) {
                                          logic.soilAction.value = s;
                                        },
                                        activeColor: HhColors.mainBlueColor,
                                        inactiveThumbColor:
                                            HhColors.mainBlueColor,
                                        inactiveTrackColor: HhColors.whiteColor,
                                        focusColor: HhColors.mainBlueColor,
                                        trackOutlineColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                          return HhColors.mainBlueColor;
                                        }),
                                      )*/SizedBox(
                                        height: 50.w,
                                        width: 90.w,
                                        child: LiteRollingSwitch(
                                          value: logic.soilAction.value,
                                          textOn: '',
                                          textOff: '',
                                          colorOff: HhColors
                                              .titleColor_99
                                              .withAlpha(200),
                                          colorOn: HhColors
                                              .mainBlueColor
                                              .withAlpha(200),
                                          animationDuration: const Duration(
                                              milliseconds: 600),
                                          onChanged: (bool state) {
                                            logic.soilAction.value = state;
                                          },
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
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (s) {
                                            logic.soilDelay.value = s;
                                          },
                                          style: TextStyle(
                                              color: HhColors.blueTextColor,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w400),
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
                                BouncingWidget(
                                  duration: const Duration(milliseconds: 100),
                                  scaleFactor: 1.2,
                                  onPressed: () {
                                    int energy = 0;
                                    int weather = 0;
                                    int soil = 0;
                                    try {
                                      energy = int.parse(
                                              logic.time1Controller!.text) *
                                          60;
                                      weather = int.parse(
                                              logic.time2Controller!.text) *
                                          60;
                                      soil = int.parse(
                                              logic.time3Controller!.text) *
                                          60;
                                    } catch (e) {
                                      EventBusUtil.getInstance()
                                          .fire(HhToast(title: "间隔时间格式错误"));
                                      return;
                                    }
                                    logic.warnUploadSet(
                                        "energy",
                                        logic.energyAction.value ? "ON" : "OFF",
                                        energy,
                                        logic.config["energyOpenTime"]);
                                    logic.warnUploadSet(
                                        "weather",
                                        logic.weatherAction.value
                                            ? "ON"
                                            : "OFF",
                                        weather,
                                        logic.config["weatherOpenTime"]);
                                    logic.warnUploadSet(
                                        "soil",
                                        logic.soilAction.value ? "ON" : "OFF",
                                        soil,
                                        logic.config["soilOpenTime"]);
                                  },
                                  child: Container(
                                    width: 1.sw,
                                    height: 90.w,
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 10.w, 30.w, 30.w),
                                    decoration: BoxDecoration(
                                        color: HhColors.whiteColor,
                                        border: Border.all(
                                            color: HhColors.gray9TextColor,
                                            width: 0.5.w),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.w))),
                                    child: Center(
                                      child: Text(
                                        "确定",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 28.sp,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                  ),
                                )
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
                                    logic.fireLevel.value = 5;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 5
                                                ? "assets/images/common/yes2.png"
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
                                    logic.fireLevel.value = 4;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 4
                                                ? "assets/images/common/yes2.png"
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
                                    logic.fireLevel.value = 3;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 3
                                                ? "assets/images/common/yes2.png"
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
                                    logic.fireLevel.value = 2;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 2
                                                ? "assets/images/common/yes2.png"
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
                                    logic.fireLevel.value = 1;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 1
                                                ? "assets/images/common/yes2.png"
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
                          /*//枪球联动
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
                                                ? "assets/images/common/yes2.png"
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
                                                ? "assets/images/common/yes2.png"
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
                          ),*/
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
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      30.w, 30.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '当前版本:',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Text(
                                        '${logic.deviceVer}',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                logic.versionStatus.value
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: buildVersionChild(),
                                      )
                                    : const SizedBox(),
                                BouncingWidget(
                                  duration: const Duration(milliseconds: 100),
                                  scaleFactor: 1.2,
                                  onPressed: () {
                                    logic.versionUpdate();
                                  },
                                  child: Container(
                                    width: 1.sw,
                                    height: 90.w,
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 0, 30.w, 20.w),
                                    decoration: BoxDecoration(
                                        color: HhColors.whiteColor,
                                        border: Border.all(
                                            color: HhColors.gray9TextColor,
                                            width: 0.5.w),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.w))),
                                    child: Center(
                                      child: Text(
                                        "升级",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 28.sp,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                  ),
                                )
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
      logic.resetDevice();
    });
  }

  buildVoiceList() {
    List<Widget> list = [];
    list.add(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 25.w, 20.w, 25.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '名称',
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600),
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
    );
    for (int i = 0; i < logic.voiceTopList.length; i++) {
      dynamic model = logic.voiceTopList[i];
      list.add(
        Container(
          height: 1.w,
          color: HhColors.backColor,
        ),
      );
      list.add(
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 20.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${model["name"]}',
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
                  logic.uploadVoice(model["name"], model["pcmUrl"]);
                },
                child: Text(
                  '上传',
                  style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 26.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
      );
    }
    return list;
  }

  buildVoiceListBottom() {
    List<Widget> list = [];
    list.add(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 25.w, 20.w, 25.w),
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
    );
    for (int i = 0; i < logic.voiceBottomList.length; i++) {
      dynamic model = logic.voiceBottomList[i];
      list.add(
        Container(
          height: 1.w,
          color: HhColors.backColor,
        ),
      );
      list.add(
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 20.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${model["name"]}',
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
                  logic.playVoice(model["name"]);
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
              InkWell(
                onTap: () {
                  logic.deleteVoice(model["name"]);
                },
                child: Text(
                  '删除',
                  style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 26.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
      );
    }
    return list;
  }

  buildVersionChild() {
    List<Widget> list = [];

    for (int i = 0; i < logic.versionList.length; i++) {
      dynamic model = logic.versionList[i];
      list.add(
        Container(
          height: 1.w,
          color: HhColors.backColor,
        ),
      );
      list.add(InkWell(
        onTap: () {
          logic.version.value = i;
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(30.w, 30.w, 30.w, 30.w),
          child: Row(
            children: [
              Image.asset(
                  logic.version.value == i
                      ? "assets/images/common/yes2.png"
                      : "assets/images/common/no.png",
                  height: 20,
                  width: 20),
              SizedBox(
                width: 15.w,
              ),
              Text(
                '${model["version"]}',
                style: TextStyle(
                  color: HhColors.blackColor,
                  fontSize: 28.sp,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return list;
  }
}
