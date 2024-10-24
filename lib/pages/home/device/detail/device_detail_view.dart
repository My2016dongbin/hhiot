import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/call/call_binding.dart';
import 'package:iot/pages/home/device/detail/call/call_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_controller.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:screenshot/screenshot.dart';

class DeviceDetailPage extends StatelessWidget {
  final logic = Get.find<DeviceDetailController>();

  DeviceDetailPage(String deviceNo, String id, int shareMark, {super.key}) {
    logic.deviceNo = deviceNo;
    logic.id = id;
    logic.shareMark = shareMark;
  }

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    logic.initData();
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.light, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.light, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => Container(
          height: 1.sh,
          width: 1.sw,
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ///背景图
              Image.asset(
                "assets/images/common/test_video.jpg",
                width: 1.sw,
                height: 254.w * 3,
                fit: BoxFit.fill,
              ),
              Container(
                width: 1.sw,
                height: 254.w * 3,
                color: HhColors.blackColor,
              ),
              logic.playTag.value
                  ? Container(
                      margin: EdgeInsets.only(top: 0.w * 3),
                      child: ScreenRecorder(
                        width: 1.sw,
                        height: 254.w * 3,
                        background: Colors.white,
                        controller: logic.recordController,
                        child: Screenshot(
                          controller: logic.screenshotController,
                          child: FijkView(
                              width: 1.sw,
                              height: 254.w * 3,
                              player: logic.player,
                              color: HhColors.blackColor,
                              fit: FijkFit.fill),
                        ),
                      ),
                    )
                  : const SizedBox(),

              ///title
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(23.w * 3, 59.h * 3, 0, 0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/back_white.png",
                        height: 17.w*3,
                        width: 10.w*3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 12.w * 3,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.5.sw),
                        child: Text(
                          logic.name.value,
                          style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 16.sp * 3,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(width: 5.w*3,),
                      logic.videoTag.value?Container(
                        padding: EdgeInsets.fromLTRB(6.w*3, 2.w*3, 10.w*3, 2.w*3),
                        decoration: BoxDecoration(
                          color:HhColors.mainRedColor,
                          borderRadius: BorderRadius.circular(11.w*3),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/common/luxiang.png",
                              width: 12.w * 3,
                              height: 12.w * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 2.w*3,),
                            Text(
                              "${CommonUtils().parseZero(logic.videoMinute.value)}:${CommonUtils().parseZero(logic.videoSecond.value)}",
                              style: TextStyle(
                                  color: HhColors.whiteColor,
                                  fontSize: 13.sp * 3,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                ),
              ),

              ///setting
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    if (logic.item['deviceNo'] == null) {
                      EventBusUtil.getInstance()
                          .fire(HhToast(title: '设备信息加载中..请稍候', type: 0));
                      return;
                    }
                    showEditDeviceDialog(logic.item);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 57.w * 3, 14.w * 3, 0),
                    child: Image.asset(
                      "assets/images/common/icon_video_set.png",
                      width: 24.w * 3,
                      height: 24.w * 3,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              ///tab
              Container(
                height: 45.w * 3,
                color: HhColors.whiteColor,
                margin: EdgeInsets.fromLTRB(0, 259.w * 3, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BouncingWidget(
                            duration: const Duration(milliseconds: 300),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.tabIndex.value = 0;
                            },
                            child: Container(
                              height: 40.w * 3,
                              color: HhColors.trans,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5.w),
                                    child: Image.asset(
                                      logic.tabIndex.value == 0
                                          ? "assets/images/common/icon_live.png"
                                          : "assets/images/common/icon_live_.png",
                                      width: 16.w * 3,
                                      height: 16.w * 3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    '实时视频',
                                    style: TextStyle(
                                        color: logic.tabIndex.value == 0
                                            ? HhColors.mainBlueColor
                                            : HhColors.gray6TextColor,
                                        fontSize: logic.tabIndex.value == 0
                                            ? 14.sp * 3
                                            : 14.sp * 3,
                                        fontWeight: logic.tabIndex.value == 0
                                            ? FontWeight.w500
                                            : FontWeight.w200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          logic.tabIndex.value == 0
                              ? Container(
                                  height: 4.w,
                                  width: 140.w,
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w))),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BouncingWidget(
                            duration: const Duration(milliseconds: 300),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.tabIndex.value = 1;
                            },
                            child: Container(
                              height: 40.w * 3,
                              color: HhColors.trans,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 3.w),
                                    child: Image.asset(
                                      logic.tabIndex.value == 1
                                          ? "assets/images/common/icon_msg_.png"
                                          : "assets/images/common/icon_msg.png",
                                      width: 16.w * 3,
                                      height: 16.w * 3,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text(
                                    '历史消息',
                                    style: TextStyle(
                                        color: logic.tabIndex.value == 1
                                            ? HhColors.mainBlueColor
                                            : HhColors.gray6TextColor,
                                        fontSize: logic.tabIndex.value == 1
                                            ? 14.sp * 3
                                            : 14.sp * 3,
                                        fontWeight: logic.tabIndex.value == 1
                                            ? FontWeight.w500
                                            : FontWeight.w200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          logic.tabIndex.value == 1
                              ? Container(
                                  height: 4.w,
                                  width: 140.w,
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w))),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 305.w * 3, 0, 0),
                child: logic.tabIndex.value == 0 ? livePage() : historyPage(),
              ),

              logic.testStatus.value ? const SizedBox() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  livePage() {
    final size = MediaQuery.of(logic.context).size;
    return Stack(
      children: [
        SizedBox(
          width: 1.sw,
          height: 1.sw,
          child: Stack(
            children: [
              logic.liveStatus.value
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: buildCameraTabs(),
                        ),
                      ),
                    )
                  : const SizedBox(),

              ///控制背景阴影
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 220.w * 3,
                  height: 220.w * 3,
                  // margin: EdgeInsets.only(bottom: 15.w),
                  decoration: BoxDecoration(
                      color: HhColors.videoControlShadowColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(110.w * 3))),
                ),
              ),

              ///控制拖动按钮
              Align(
                  alignment: logic.animateAlign,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      logic.animateAlign += Alignment(
                        details.delta.dx / (size.width / 2),
                        details.delta.dy / (size.height / 2),
                      );
                      logic.testStatus.value = false;
                      logic.testStatus.value = true;

                      String msg = '';
                      double offset = 20;
                      double x = details.delta.dx;
                      double y = details.delta.dy;
                      int time = DateTime.now().millisecondsSinceEpoch;
                      if (time - logic.controlTime > 1000) {
                        HhLog.d(
                            "move ${details.delta.dx} , ${details.delta.dy}");
                        logic.controlTime = time;
                        if (x > 0 && y < 0) {
                          msg = "右上";
                          logic.commandLast = logic.command;
                          logic.command = "RIGHT_UP";
                        }
                        if (x > 0 && y == 0) {
                          msg = "右";
                          logic.commandLast = logic.command;
                          logic.command = "RIGHT";
                        }
                        if (x > 0 && y > 0) {
                          msg = "右下";
                          logic.commandLast = logic.command;
                          logic.command = "RIGHT_DOWN";
                        }
                        if (x == 0 && y > 0) {
                          msg = "下";
                          logic.commandLast = logic.command;
                          logic.command = "DOWN";
                        }
                        if (x < 0 && y > 0) {
                          msg = "左下";
                          logic.commandLast = logic.command;
                          logic.command = "LEFT_DOWN";
                        }
                        if (x < 0 && y == 0) {
                          msg = "左";
                          logic.commandLast = logic.command;
                          logic.command = "LEFT";
                        }
                        if (x < 0 && y < 0) {
                          msg = "左上";
                          logic.commandLast = logic.command;
                          logic.command = "LEFT_UP";
                        }
                        if (x == 0 && y < 0) {
                          msg = "上";
                          logic.commandLast = logic.command;
                          logic.command = "UP";
                        }
                        // EventBusUtil.getInstance().fire(HhToast(title: msg));
                        logic.controlPost(0);
                      }
                    },
                    onPanEnd: (details) {
                      logic.animateAlign = Alignment.center;
                      logic.testStatus.value = false;
                      logic.testStatus.value = true;
                      // EventBusUtil.getInstance().fire(HhToast(title: 'STOP'));
                      logic.controlPost(1);
                    },
                    child: SizedBox(
                      width: 240.w * 3,
                      height: 240.w * 3,
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/common/video_board.png",
                            width: 240.w * 3,
                            height: 240.w * 3,
                            fit: BoxFit.fill,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 20.w * 3, 0, 0),
                              child: Image.asset(
                                "assets/images/common/top.png",
                                width: 25.w * 3,
                                height: 25.w * 3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 30.w * 3),
                              child: Image.asset(
                                "assets/images/common/bottom.png",
                                width: 25.w * 3,
                                height: 25.w * 3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(25.w * 3, 0, 0, 0),
                              child: Image.asset(
                                "assets/images/common/left.png",
                                width: 25.w * 3,
                                height: 25.w * 3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 23.w * 3, 0),
                              child: Image.asset(
                                "assets/images/common/right.png",
                                width: 25.w * 3,
                                height: 25.w * 3,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10.w),
                              child: Text(
                                "切换角度",
                                style: TextStyle(
                                    color: HhColors.gray6TextColor,
                                    fontSize: 14.sp * 3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 20.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  logic.functionItem.value.contains('录像')
                      ? BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.videoTag.value = !logic.videoTag.value;
                            if (logic.videoTag.value) {
                              //开启录像
                              logic.startRecord();
                            } else {
                              //关闭录像
                              logic.stopRecord();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 13.w * 3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/ic_video.png",
                                  width: 58.w * 3,
                                  height: 58.w * 3,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  logic.videoTag.value ? '正在录像' : '录像',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 14.sp * 3),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  logic.functionItem.value.contains('截图')
                      ? BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.saveImageToGallery();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 13.w * 3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/ic_picture.png",
                                  width: 58.w * 3,
                                  height: 58.w * 3,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  '拍照',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 14.sp * 3),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  logic.functionItem.value.contains('对讲')
                      ? BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.recordTag.value = !logic.recordTag.value;
                            if (logic.recordTag.value) {
                              //开始
                              logic.chatStatus();
                            } else {
                              //结束
                              logic.manager.stopRecording();
                              logic.chatClose();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 13.w * 3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /*logic.recordTag.value?Container(
                              width: 230.w,
                              height: 80.w,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.circular(20.w)
                              ),
                              child:  PolygonWaveform(
                                samples: [1,2,3,444,9999,66,89,6,4,999999,13120],
                                height: 230.w,
                                width: 80.w,
                              )):const SizedBox(),*/
                                Image.asset(
                                  logic.recordTag.value
                                      ? "assets/images/common/ic_yy_ing.png"
                                      : "assets/images/common/ic_yy.png",
                                  width: 58.w * 3,
                                  height: 58.w * 3,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  logic.recordTag.value ? '正在对讲' : '对讲',
                                  style: TextStyle(
                                      color: logic.recordTag.value
                                          ? HhColors.mainBlueColor
                                          : HhColors.blackTextColor,
                                      fontSize: 14.sp * 3),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  logic.functionItem.value.contains('设置')
                      ? BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            Get.to(
                                () => LiGanDetailPage(logic.deviceNo, logic.id),
                                binding: LiGanDetailBinding());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 13.w * 3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/common/icon_setting_video.png",
                                  width: 58.w * 3,
                                  height: 58.w * 3,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  '设置',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 14.sp * 3),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  historyPage() {
    return EasyRefresh(
      onRefresh: () {
        logic.pageNum = 1;
        logic.getDeviceHistory();
      },
      onLoad: () {
        logic.pageNum++;
        logic.getDeviceHistory();
      },
      child: PagedListView<int, dynamic>(
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          noItemsFoundIndicatorBuilder: (context) =>
              CommonUtils().noneWidget(top: 0.3.sw),
          itemBuilder: (context, item, index) => InkWell(
            onTap: () {},
            child: Container(
              height: 70.w * 3,
              margin: EdgeInsets.fromLTRB(14.w * 3, 0, 14.w * 3, 0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.trans,
                  borderRadius: BorderRadius.all(Radius.circular(6.w * 3))),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.w))),
                      child: Image.network(
                        '${logic.endpoint}${item['alarmImageUrl']}',
                        width: 109.w * 3,
                        height: 59.w * 3,
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/common/test_video.jpg",
                            width: 109.w * 3,
                            height: 59.w * 3,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w * 3, 10.w, 0, 50.w),
                    child: Text(
                      logic.parseDate(item['alarmTimestamp']),
                      style: TextStyle(
                          color: HhColors.textBlackColor,
                          fontSize: 15.sp * 3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.w * 3, 30.w * 3, 0, 0),
                      child: Text(
                        logic.parseType(item['alarmType']),
                        style: TextStyle(
                            color: HhColors.textBlackColor,
                            fontSize: 14.sp * 3,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 1.5.w * 3,
                      margin: EdgeInsets.fromLTRB(6.w * 3, 20.w * 3, 0, 0),
                      decoration: BoxDecoration(
                          color: HhColors.blueEAColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(3.w))),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 6.w * 3,
                      height: 6.w * 3,
                      margin: EdgeInsets.fromLTRB(10.w, 10.w * 3, 0, 0),
                      decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(3.w * 3))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditDeviceDialog(dynamic item) {
    showCupertinoDialog(
        context: logic.context,
        builder: (context) => Center(
              child: Container(
                width: 1.sw,
                height: 70.w * 3,
                margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                padding: EdgeInsets.fromLTRB(30.w, 35.w, 45.w, 25.w),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.w))),
                child: Row(
                  children: [
                    CommonData.personal
                        ? Expanded(
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: () {
                                if (item["shareMark"] == 2) {
                                  return;
                                }
                                Get.back();
                                DateTime date = DateTime.now();
                                String time = date
                                    .toIso8601String()
                                    .substring(0, 19)
                                    .replaceAll("T", " ");
                                Get.to(() => SharePage(),
                                    binding: ShareBinding(),
                                    arguments: {
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
                                    item["shareMark"] == 2
                                        ? "assets/images/common/icon_edit_share_no.png"
                                        : "assets/images/common/icon_edit_share.png",
                                    width: 24.w * 3,
                                    height: 24.w * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: 2.w * 3,
                                  ),
                                  Text(
                                    '分享',
                                    style: TextStyle(
                                        color: item["shareMark"] == 2
                                            ? HhColors.grayCCTextColor
                                            : HhColors.blackTextColor,
                                        fontSize: 14.sp * 3,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    CommonData.personal
                        ? SizedBox(
                            width: 50.w,
                          )
                        : const SizedBox(),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          Get.to(
                              () => DeviceAddPage(
                                    snCode: '',
                                  ),
                              binding: DeviceAddBinding(),
                              arguments: item);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_edit_edit.png",
                              width: 24.w * 3,
                              height: 24.w * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.w * 3,
                            ),
                            Text(
                              '修改',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          logic.resetDevice();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_video_reset.png",
                              width: 24 * 3.w,
                              height: 24 * 3.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.w * 3,
                            ),
                            Text(
                              '重启',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          CommonUtils().showDeleteDialog(
                              context,
                              logic.shareMark == 2
                                  ? '确定要删除“${item['name']}”?\n此设备是好友分享给你的设备'
                                  : '确定要删除“${item['name']}”?\n删除设备后无法恢复', () {
                            Get.back();
                          }, () {
                            Get.back();
                            logic.deleteDevice(item);
                          }, () {
                            Get.back();
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_edit_delete.png",
                              width: 24.w * 3,
                              height: 24.w * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.w * 3,
                            ),
                            Text(
                              '删除',
                              style: TextStyle(
                                  color: HhColors.mainRedColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        barrierDismissible: true);
  }

  buildCameraTabs() {
    List<Widget> list = [];
    for (int i = 0; i < logic.liveList.length; i++) {
      dynamic live = logic.liveList[i];
      list.add(InkWell(
        onTap: () {
          logic.liveIndex.value = i;
          logic.deviceId = logic.liveList[logic.liveIndex.value]["deviceId"];
          logic.channelNumber = logic.liveList[logic.liveIndex.value]["number"];
          logic.getPlayUrl(logic.deviceId, logic.channelNumber);
        },
        child: Container(
            padding:
                EdgeInsets.fromLTRB(13.w * 3, 10.w * 3, 12.w * 3, 10.w * 3),
            margin: EdgeInsets.fromLTRB(10.w * 3, 10.w * 3, 0, 0),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w * 3)),
                border: Border.all(
                    color: HhColors.grayDDTextColor, width: 0.5.w * 3)),
            child: Text(
              '${live['positionName']}',
              style: TextStyle(
                  color: logic.liveIndex.value == i
                      ? HhColors.mainBlueColor
                      : HhColors.blackColor,
                  fontSize: 14.sp * 3),
            )),
      ));
    }
    list.add(SizedBox(
      width: 10.w * 3,
    ));
    return list;
  }
}
