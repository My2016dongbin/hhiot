import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/login/code/code_controller.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';

class CodePage extends StatelessWidget {
  final logic = Get.find<CodeController>();

  CodePage({super.key});

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
          child: logic.testStatus.value ? codeView() : const SizedBox(),
        ),
      ),
    );
  }

  codeView() {
    return Stack(
      children: [
        Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
        Align(
          alignment: Alignment.topLeft,
            child: InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0.04.sw, 0.06.sh, 0, 0),
                padding: EdgeInsets.all(20.w),
                color: HhColors.trans,
                  child: Image.asset('assets/images/common/back.png',width:20.w,height: 32.w,fit: BoxFit.fill,)
              ),
            )
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh, 0, 0),
            child: Text('请输入验证码',style: TextStyle(color: HhColors.blackColor,fontSize: 40.sp,fontWeight: FontWeight.bold),),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh+66.w, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('已发送验证码至',style: TextStyle(color: HhColors.gray6TextColor,fontSize: 23.sp,),),
                  SizedBox(width: 5.w,),
                  Text('188****8888',style: TextStyle(color: HhColors.gray6TextColor,fontSize: 23.sp,),),
                ],
              )
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh+110.w, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('如未收到，请',style: TextStyle(color: HhColors.gray6TextColor,fontSize: 23.sp,),),
                  Text('55s',style: TextStyle(color: HhColors.titleColorRed,fontSize: 23.sp,),),
                  Text('后获取',style: TextStyle(color: HhColors.gray6TextColor,fontSize: 23.sp,),),
                ],
              )
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh+180.w, 0.1.sw, 0),
            height: 300.w,
            child: Pinput(
              length: 6,
              onCompleted: (pin){
                HhLog.e("pin $pin");
                logic.code = pin;
                if(pin.length == 6){
                  ///验证
                  showToast('登录成功',
                    context: logic.context,
                    animation: StyledToastAnimation.slideFromBottomFade,
                    reverseAnimation: StyledToastAnimation.fade,
                    position: StyledToastPosition.bottom,
                    animDuration: const Duration(seconds: 1),
                    duration: const Duration(seconds: 2),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.linear,
                  );
                  Future.delayed(const Duration(seconds: 1),(){
                    Get.off(HomePage(),binding: HomeBinding());
                  });
                }
              },
            ),
          ),
        )
      ],
    );
  }

}
