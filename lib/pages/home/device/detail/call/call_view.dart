import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/call/call_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';

class CallPage extends StatelessWidget {
  final logic = Get.find<CallController>();

  CallPage(String deviceNo, String id, int shareMark, {super.key}) {
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
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
          () => Container(
            height: 1.sh,
            width: 1.sw,
            color: HhColors.backColorF5,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                ///背景
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: CommonUtils().gradientColors()),
                  ),
                ),
                logic.testStatus.value?Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/icon_share_camera.png",
                        width: 200.w,
                        height: 200.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20.w,),
                      Text(
                        CommonUtils().parseNull("浩海高塔一体机", ""),
                        style: TextStyle(
                            color: HhColors.gray6TextColor,
                            fontSize: 26.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w200),
                      ),
                      SizedBox(height: 100.w,),
                      Text(
                        CommonUtils().parseNull("管理员", ""),
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 26.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.w,),
                      Text(
                        "请求与您对讲...",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 26.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 200.w,),
                    ],
                  ),
                ):const SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 100.w),
                    child: Row(
                      children: [
                        SizedBox(width: 100.w,),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            try{
                              logic.manager.stopRecording();
                              logic.chatClose();
                            }catch(e){
                              //
                            }
                            Get.back();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/common/icon_call_no.png",
                                width: 140.w,
                                height: 140.w,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                "挂断",
                                style: TextStyle(
                                    color: HhColors.mainRedColor,
                                    fontSize: 26.sp,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.chatStatus();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/common/icon_call_yes.png",
                                width: 140.w,
                                height: 140.w,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                "接听",
                                style: TextStyle(
                                    color: HhColors.titleColorGreen,
                                    fontSize: 26.sp,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 100.w,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //复写返回监听
  Future<bool> onBackPressed() {
    bool exit = false;

    return Future.value(exit);
  }
}