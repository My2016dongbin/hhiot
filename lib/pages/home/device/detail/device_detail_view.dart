import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/home/device/detail/device_detail_controller.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:video_player/video_player.dart';

class DeviceDetailPage extends StatelessWidget {
  final logic = Get.find<DeviceDetailController>();

  DeviceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                width: 1.sw,
                height: 500.w,
                child: AspectRatio(
                  aspectRatio: logic.controller.value.aspectRatio,
                  child: VideoPlayer(logic.controller),
                ),
              ),
              InkWell(
                onTap: (){
                  logic.controller.play();
                },
                child: Container(
                  width: 1.sw,
                  height: 500.w,
                  color: HhColors.blackColor,
                ),
              ),
              ///title
              InkWell(
                onTap: (){
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
                      SizedBox(width: 10.w,),
                      Text(
                        "大涧林场-F1双枪机",
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 30.sp,fontWeight: FontWeight.bold),
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
                          InkWell(
                            onTap: (){
                              logic.tabIndex.value = 0;
                            },
                            child: Container(
                              height: 70.w,
                              color: HhColors.trans,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    logic.tabIndex.value==0?"assets/images/common/icon_live.png":"assets/images/common/icon_live_.png",
                                    width: 30.w,
                                    height: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 6.w,),
                                  Text(
                                    '实时视频',
                                    style: TextStyle(
                                        color: logic.tabIndex.value==0?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==0?30.sp:26.sp,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.w,),
                          logic.tabIndex.value==0?Container(
                            height: 4.w,
                            width: 140.w,
                            decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(Radius.circular(2.w))
                            ),
                          ):const SizedBox()
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              logic.tabIndex.value = 1;
                            },
                            child: Container(
                              height: 70.w,
                              color: HhColors.trans,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    logic.tabIndex.value==1?"assets/images/common/icon_msg_.png":"assets/images/common/icon_msg.png",
                                    width: 30.w,
                                    height: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 6.w,),
                                  Text(
                                    '历史消息',
                                    style: TextStyle(
                                        color: logic.tabIndex.value==1?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==1?30.sp:26.sp,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.w,),
                          logic.tabIndex.value==1?Container(
                            height: 4.w,
                            width: 140.w,
                            decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(Radius.circular(2.w))
                            ),
                          ):const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 600.w, 0, 0),
                child: logic.tabIndex.value==0?livePage():historyPage(),
              ),


              logic.testStatus.value?const SizedBox():const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  livePage() {
    return Column(
      children: [
        Container(
          width: 0.66.sw,
          height: 0.66.sw,
          margin: EdgeInsets.fromLTRB(0, 100.w, 0, 100.w),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/common/video_board.png",
                  width: 0.66.sw,
                  height: 0.66.sw,
                  fit: BoxFit.fill,
                ),
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
                    style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/common/ic_video.png",
                width: 130.w,
                height: 130.w,
                fit: BoxFit.fill,
              ),
              Image.asset(
                "assets/images/common/ic_picture.png",
                width: 130.w,
                height: 130.w,
                fit: BoxFit.fill,
              ),
              Image.asset(
                "assets/images/common/ic_yy.png",
                width: 130.w,
                height: 130.w,
                fit: BoxFit.fill,
              ),
              Image.asset(
                "assets/images/common/ic_voice.png",
                width: 130.w,
                height: 130.w,
                fit: BoxFit.fill,
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
          onTap: (){

          },
          child: Container(
            height: 180.w,
            margin: EdgeInsets.fromLTRB(20.w, 0.w, 20.w, 0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: HhColors.trans,
                borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.w))
                    ),
                    child: Image.asset(
                      "assets/images/common/test_video.jpg",
                      width: 240.w,
                      height: 120.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40.w, 25.w, 0, 50.w),
                  child: Text(
                    '${item.desc}',
                    style: TextStyle(
                        color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40.w, 50.w, 0, 0),
                    child: Text(
                      '${item.name}',
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 4.w,
                    margin: EdgeInsets.fromLTRB(13.w, 0, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.blueBackColor,
                        borderRadius: BorderRadius.vertical(top:Radius.circular(4.w))),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    margin: EdgeInsets.fromLTRB(10.w, 40.w, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.w))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
