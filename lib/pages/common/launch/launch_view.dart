import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/launch/launch_controller.dart';
import 'package:iot/utils/HhColors.dart';

class LaunchPage extends StatelessWidget {
  final logic = Get.find<LaunchController>();

  LaunchPage({super.key});

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
          child: logic.testStatus.value ? launchView() : const SizedBox(),
        ),
      ),
    );
  }

  launchView() {
    return Stack(
      children: [
        CommonData.personal?SizedBox(height: 1.sh,width: 1.sw,child: Image.asset('assets/images/common/icon_bg.png',fit: BoxFit.fill,)):const SizedBox(),
        Image.asset(CommonData.personal?'assets/images/common/icon_launch.png':'assets/images/common/icon_launch_blue.png',fit: BoxFit.fill,),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 0.23.sh),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 150.w,
                      height: 150.w,
                      child: Image.asset('assets/images/common/logo.png',fit: BoxFit.fill,)
                  ),
                  SizedBox(height: 10.w,),
                  Text('浩海万联',style: TextStyle(color: HhColors.whiteColor,fontSize: 30.sp),)
                ],
              )
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 0.1.sh),
            child: Text('智能物联设备·一端管理',style: TextStyle(color: HhColors.blackColor,fontSize: 30.sp,/*fontWeight: FontWeight.bold*/),),
          ),
        ),
      ],
    );
  }

}
