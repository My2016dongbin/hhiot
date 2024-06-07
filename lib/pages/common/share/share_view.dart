import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/share/share_controller.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/HhColors.dart';
class SharePage extends StatelessWidget {
  final logic = Get.find<ShareController>();
  SharePage({super.key});


  @override
  Widget build(BuildContext context) {
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
          child: logic.testStatus.value ? myPage() : const SizedBox(),
        ),
      ),
    );
  }

  myPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HhColors.backColorF5, HhColors.backColorF5]),
          ),
        ),
        ///title
        InkWell(
          onTap: () {
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
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              "共享设备",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 180.w, 20.w, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20.w))
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.w,),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.w))
                  ),
                  child: Image.asset(
                    "assets/images/common/test_video.jpg",
                    width: 260.w,
                    height: 260.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: 90.w,
                  margin: EdgeInsets.fromLTRB(20.w, 50.w, 20.w, 0),
                  padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                  decoration: BoxDecoration(
                      color: HhColors.grayEEBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(40.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入设备名称',
                            hintStyle: TextStyle(
                                color: HhColors.gray9TextColor, fontSize: 26.sp),
                          ),
                          style:
                          TextStyle(color: HhColors.blackTextColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.w,),
              ],
            ),
          ),
        ),
        Container(
          width: 1.sw,
          margin: EdgeInsets.fromLTRB(20.w, 680.w, 20.w, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20.w))
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.w,),
                Text(
                  "或者由被分享者扫描您的共享码",
                  style: TextStyle(
                      color: HhColors.gray9TextColor,
                      fontSize: 26.sp),
                ),
                SizedBox(height: 40.w,),
                Image.asset(
                  "assets/images/common/code.jpg",
                  width: 220.w,
                  height: 220.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 60.w,),
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
        ///分享完成按钮
        Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: (){
              Get.back();
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
                  "分享完成",
                  style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 30.sp,),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
