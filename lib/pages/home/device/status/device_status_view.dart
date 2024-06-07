import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/device/status/device_status_controller.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceStatusPage extends StatelessWidget {
  final logic = Get.find<DeviceStatusController>();

  DeviceStatusPage({super.key});

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
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ///title
              InkWell(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(36.w, 100.w, 0, 0),
                  color: HhColors.trans,
                  child: Image.asset(
                    "assets/images/common/back.png",
                    width: 18.w,
                    height: 30.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:90.w),
                  color: HhColors.trans,
                  child: Text(
                    "添加设备",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              ///状态图
              Align(
                alignment:Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:400.w),
                  color: HhColors.trans,
                  child: Image.asset(
                    "assets/images/common/status_yes.png",
                    width: 0.53.sw,
                    height: 0.3.sw,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:430.w+0.3.sw),
                  color: HhColors.trans,
                  child: Text(
                    "添加设备成功",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 36.sp,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ///流程
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(240.w,520.w+0.3.sw,0,0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/yes.png",
                        width: 26.w,
                        height: 26.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        "连接设备成功",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 26.sp),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(240.w,580.w+0.3.sw,0,0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/yes.png",
                        width: 26.w,
                        height: 26.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        "连接认证成功",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 26.sp),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(240.w,640.w+0.3.sw,0,0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/yes.png",
                        width: 26.w,
                        height: 26.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        "设备绑定账号成功",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 26.sp),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 1.sw,
                  height: 1.w,
                  margin: EdgeInsets.only(bottom: 160.w),
                  color: HhColors.grayDDTextColor,
                ),
              ),
              ///确定添加按钮
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: (){
                    showToast('设备添加成功',
                      context: logic.context,
                      animation: StyledToastAnimation.slideFromBottomFade,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.bottom,
                      animDuration: const Duration(seconds: 1),
                      duration: const Duration(seconds: 2),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.linear,
                    );
                    Get.to(DeviceListPage());
                  },
                  child: Container(
                    height: 80.w,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.w))),
                    child: Center(
                      child: Text(
                        "完成",
                        style: TextStyle(
                          color: HhColors.whiteColor,
                          fontSize: 30.sp,),
                      ),
                    ),
                  ),
                ),
              ),

              logic.index.value==0?const SizedBox():const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
