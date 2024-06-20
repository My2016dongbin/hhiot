import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/HhColors.dart';
class SettingPage extends StatelessWidget {
  final logic = Get.find<SettingController>();
  SettingPage({super.key});


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
                colors: [HhColors.backColorF5, HhColors.backColorF5]),
          ),
        ),
        ///title
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
            padding: EdgeInsets.all(10.w),
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
              "设置",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 160.w, 20.w, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///个人信息
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 30.w, 0, 20.w),
                  child: Text(
                    "个人信息",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///头像
                      SizedBox(
                        height:150.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "头像",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                margin:EdgeInsets.only(right: 65.w),
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
                      ///昵称
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "昵称",
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
                                  "浩海科技",
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
                      ///账号
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "账号",
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
                                  "188****8888",
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
                    ],
                  ),
                ),

                ///安全设置
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "安全设置",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///安全手机
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "安全手机",
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
                                  "188****8888",
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
                      ///安全邮箱
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "安全邮箱",
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
                                  "188****@qq.com",
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
                      ///安全邮箱
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "设置新密码",
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
                                  "",
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
                    ],
                  ),
                ),

                ///地区和语言
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "地区和语言",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///地区
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "地区",
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
                                  "中国大陆",
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
                      ///多语言
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "多语言",
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
                                  "简体中文",
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
                    ],
                  ),
                ),


                ///其他设置
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "其他设置",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///清除缓存
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "清除缓存",
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
                                  "无缓存",
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
                      ///关于我们
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "关于我们",
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
                                  "版本V1.0.1",
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
                    ],
                  ),
                ),

                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    width: 1.sw,
                    height: 90.w,
                    margin:EdgeInsets.fromLTRB(0, 50.w, 0, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(14.w))
                    ),
                    child: Center(
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                            color: HhColors.titleColorRed,
                            fontSize: 28.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
