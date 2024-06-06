import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/HhColors.dart';
import 'my_controller.dart';
class MyPage extends StatelessWidget {
  final logic = Get.find<MyController>();
  MyPage({super.key});


  @override
  Widget build(BuildContext context) {
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
                colors: [HhColors.backTransColor1, HhColors.backTransColor3]),
          ),
        ),
        ///title
        Container(
          margin: EdgeInsets.fromLTRB(30.w, 90.w, 0, 0),
          child: Text(
            "我的",
            style: TextStyle(
                color: HhColors.blackTextColor,
                fontSize: 34.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 90.w, 115.w, 0),
            child: Image.asset(
              "assets/images/common/shared.png",
              width: 50.w,
              height: 50.w,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 90.w, 40.w, 0),
            child: Image.asset(
              "assets/images/common/ic_setting.png",
              width: 50.w,
              height: 50.w,
              fit: BoxFit.fill,
            ),
          ),
        ),
        ///头像等信息
        Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.fromLTRB(36.w, 190.w, 0.w, 0),
          decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(50.w))
          ),
          child: Image.asset(
            "assets/images/common/user.png",
            width: 100.w,
            height: 100.w,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(150.w, 200.w, 0, 0),
          child: Text(
            "HaoHai_430695",
            style: TextStyle(
                color: HhColors.blackTextColor,
                fontSize: 30.sp,fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(150.w, 245.w, 0, 0),
          child: Text(
            "188****8888",
            style: TextStyle(
                color: HhColors.gray6TextColor,
                fontSize: 23.sp),
          ),
        ),
        ///设备&&空间
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 330.w, 20.w, 0),
          child: Row(
            children: [
              Expanded(child: Container(
                height: 160.w,
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(14.w))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.fromLTRB(30.w, 0.w, 0.w, 0.w),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(50.w))
                        ),
                        child: Image.asset(
                          "assets/images/common/ic_my_left.png",
                          width: 75.w,
                          height: 75.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(130.w, 0.w, 0.w, 45.w),
                        child: Text(
                          "12",
                          style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 40.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(130.w, 45.w, 0.w, 0.w),
                        child: Text(
                          "智能设备",
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 23.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Expanded(child: Container(
                height: 160.w,
                margin: EdgeInsets.only(left: 10.w),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(14.w))
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.fromLTRB(30.w, 0.w, 0.w, 0.w),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(50.w))
                        ),
                        child: Image.asset(
                          "assets/images/common/ic_my_right.png",
                          width: 75.w,
                          height: 75.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(130.w, 0.w, 0.w, 45.w),
                        child: Text(
                          "6",
                          style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 40.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(130.w, 45.w, 0.w, 0.w),
                        child: Text(
                          "空间管理",
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 23.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 510.w, 20.w, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(14.w))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///空间网络
              SizedBox(
                height:110.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:EdgeInsets.only(left: 20.w),
                        child: Image.asset(
                          "assets/images/common/ic_jk.png",
                          width: 36.w,
                          height: 36.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:EdgeInsets.only(left: 70.w),
                        child: Text(
                          "空间网络",
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 28.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin:EdgeInsets.only(right: 65.w),
                        child: Text(
                          "优秀",
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 26.sp),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                        child: Image.asset(
                          "assets/images/common/back_role.png",
                          width: 12.w,
                          height: 20.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:Container(
                        height: 0.5.w,
                        width: 1.sw,
                        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                        color: HhColors.grayDDTextColor,
                      )
                    )
                  ],
                ),
              ),
              ///设置
              SizedBox(
                height:110.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:EdgeInsets.only(left: 20.w),
                        child: Image.asset(
                          "assets/images/common/ic_setting.png",
                          width: 36.w,
                          height: 36.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:EdgeInsets.only(left: 70.w),
                        child: Text(
                          "设置",
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 28.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                        child: Image.asset(
                          "assets/images/common/back_role.png",
                          width: 12.w,
                          height: 20.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child:Container(
                          height: 0.5.w,
                          width: 1.sw,
                          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                          color: HhColors.grayDDTextColor,
                        )
                    )
                  ],
                ),
              ),
              ///帮助与反馈
              SizedBox(
                height:110.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:EdgeInsets.only(left: 20.w),
                        child: Image.asset(
                          "assets/images/common/ic_help.png",
                          width: 36.w,
                          height: 36.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin:EdgeInsets.only(left: 70.w),
                        child: Text(
                          "帮助与反馈",
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 28.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                        child: Image.asset(
                          "assets/images/common/back_role.png",
                          width: 12.w,
                          height: 20.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
