import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/device_detail_controller.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/device/status/device_status_controller.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceDetailPage extends StatelessWidget {
  final logic = Get.find<DeviceDetailController>();

  DeviceDetailPage({super.key});

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
                                    "assets/images/common/ic_message.png",
                                    width: 30.w,
                                    height: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 6.w,),
                                  Text(
                                    '实时视频',
                                    style: TextStyle(
                                        color: logic.tabIndex.value==0?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==0?32.sp:26.sp,fontWeight: FontWeight.bold),
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
                                    "assets/images/common/ic_message.png",
                                    width: 30.w,
                                    height: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 6.w,),
                                  Text(
                                    '历史消息',
                                    style: TextStyle(
                                        color: logic.tabIndex.value==1?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==1?32.sp:26.sp,fontWeight: FontWeight.bold),
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

              logic.tabIndex.value==0? Container(
                margin: EdgeInsets.fromLTRB(0, 600.w, 0, 0),
                child: Center(child: Text(
                  "实时视频",
                  style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                ),),
              )
                  :Container(
                margin: EdgeInsets.fromLTRB(0, 600.w, 0, 0),
                child: Center(child: Text(
                  "历史消息",
                  style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                ),),
              ),


              logic.testStatus.value?const SizedBox():const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
