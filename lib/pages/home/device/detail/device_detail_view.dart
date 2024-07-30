import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/home/device/detail/device_detail_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';

class DeviceDetailPage extends StatelessWidget {
  final logic = Get.find<DeviceDetailController>();

  DeviceDetailPage(String deviceNo,String id, {super.key}){
    logic.deviceNo = deviceNo;
    logic.id = id;
  }

  @override
  Widget build(BuildContext context) {
    logic.context = context;
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
                height: 500.w,
                fit: BoxFit.fill,
              ),
              Container(
                width: 1.sw,
                height: 500.w,
                color: HhColors.blackColor,
              ),
              FijkView(width: 1.sw,height: 500.w,player: logic.player,color: HhColors.blackColor,),


              ///title
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(36.w, 100.w, 0, 0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/back_white.png",
                        width: 18.w,
                        height: 30.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "大涧林场-F1双枪机",
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),

              ///tab
              Container(
                height: 90.w,
                color: HhColors.whiteColor,
                margin: EdgeInsets.fromLTRB(0, 500.w, 0, 0),
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
                              height: 70.w,
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
                                      width: 30.w,
                                      height: 30.w,
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
                                            : HhColors.gray9TextColor,
                                        fontSize: logic.tabIndex.value == 0
                                            ? 30.sp
                                            : 26.sp,
                                        fontWeight: logic.tabIndex.value == 0
                                            ? FontWeight.bold
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
                              height: 70.w,
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
                                      width: 30.w,
                                      height: 30.w,
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
                                            : HhColors.gray9TextColor,
                                        fontSize: logic.tabIndex.value == 1
                                            ? 30.sp
                                            : 26.sp,
                                        fontWeight: logic.tabIndex.value == 1
                                            ? FontWeight.bold
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
                margin: EdgeInsets.fromLTRB(0, 600.w, 0, 0),
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
    return Column(
      children: [
        SizedBox(
          width: 1.sw,
          height: 1.sw,
          child: Stack(
            children: [
              ///控制背景阴影
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 0.6.sw,
                  height: 0.6.sw,
                  margin: EdgeInsets.only(bottom: 15.w),
                  decoration: BoxDecoration(
                    color: HhColors.videoControlShadowColor,
                    borderRadius: BorderRadius.all(Radius.circular(0.3.sw))
                  ),
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
                      double x = details.localPosition.dx;
                      double y = details.localPosition.dy;
                      HhLog.d("move $x , $y");
                      ///上
                      if(x > -1*offset && x < 1*offset && y > 0){
                        msg = '上';
                      }
                      ///下
                      if(x > -1*offset && x < 1*offset && y < 0){
                        msg = '下';
                      }
                      ///左
                      if(y > -1*offset && y < 1*offset && x < 0){
                        msg = '左';
                      }
                      ///右
                      if(y > -1*offset && y < 1*offset && x > 0){
                        msg = '右';
                      }
                      EventBusUtil.getInstance().fire(HhToast(title: msg));
                    },
                    onPanEnd: (details) {
                      // runAnimation(details.velocity.pixelsPerSecond);
                      logic.animateAlign = Alignment.center;
                      logic.testStatus.value = false;
                      logic.testStatus.value = true;
                      EventBusUtil.getInstance().fire(HhToast(title: 'STOP'));
                    },
                    child: SizedBox(
                      width: 0.66.sw,
                      height: 0.66.sw,
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/common/video_board.png",
                            width: 0.66.sw,
                            height: 0.66.sw,
                            fit: BoxFit.fill,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 40.w, 0, 0),
                              child: Image.asset(
                                "assets/images/common/top.png",
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 55.w),
                              child: Image.asset(
                                "assets/images/common/bottom.png",
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(45.w, 0, 0, 0),
                              child: Image.asset(
                                "assets/images/common/left.png",
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 45.w, 0),
                              child: Image.asset(
                                "assets/images/common/right.png",
                                width: 60.w,
                                height: 60.w,
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
                                    color: HhColors.textColor, fontSize: 23.sp),
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
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {},
                child: Image.asset(
                  "assets/images/common/ic_video.png",
                  width: 130.w,
                  height: 130.w,
                  fit: BoxFit.fill,
                ),
              ),
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {},
                child: Image.asset(
                  "assets/images/common/ic_picture.png",
                  width: 130.w,
                  height: 130.w,
                  fit: BoxFit.fill,
                ),
              ),
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {},
                child: Image.asset(
                  "assets/images/common/ic_yy.png",
                  width: 130.w,
                  height: 130.w,
                  fit: BoxFit.fill,
                ),
              ),
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {},
                child: Image.asset(
                  "assets/images/common/ic_voice.png",
                  width: 130.w,
                  height: 130.w,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  historyPage() {
    return PagedListView<int, Device>(
      pagingController: logic.deviceController,
      builderDelegate: PagedChildBuilderDelegate<Device>(
        itemBuilder: (context, item, index) => InkWell(
          onTap: () {},
          child: Container(
            height: 180.w,
            margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: HhColors.trans,
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.w))),
                    child: Image.asset(
                      "assets/images/common/test_video.jpg",
                      width: 250.w,
                      height: 150.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40.w, 10.w, 0, 50.w),
                  child: Text(
                    '${item.desc}',
                    style: TextStyle(
                        color: HhColors.textBlackColor,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40.w, 55.w, 0, 0),
                    child: Text(
                      '${item.name}',
                      style: TextStyle(
                          color: HhColors.textBlackColor,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 4.w,
                    margin: EdgeInsets.fromLTRB(15.w, 42.w, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.blueEAColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(3.w))),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    margin: EdgeInsets.fromLTRB(10.w, 20.w, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(7.w))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void runAnimation(Offset pixelsPerSec) {
    logic.animationController.addListener(() {
      logic.dragAlignment.value = logic.animation.value;
    });
    final size = Get.size;
    logic.animation = logic.animationController.drive(
      AlignmentTween(
        begin: logic.animateAlign,
        end: Alignment.center,
      ),
    );
    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final unitsPerSecX = pixelsPerSec.dx / size.width;
    final unitsPerSecY = pixelsPerSec.dy / size.height;
    final unitsPerSec = Offset(unitsPerSecX, unitsPerSecY);
    final unitVelocity = unitsPerSec.distance;

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    logic.animationController.animateWith(simulation);
  }
}
