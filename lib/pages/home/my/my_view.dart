import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/manage/device_manage_binding.dart';
import 'package:iot/pages/home/device/manage/device_manage_view.dart';
import 'package:iot/pages/home/my/help/help_binding.dart';
import 'package:iot/pages/home/my/help/help_view.dart';
import 'package:iot/pages/home/my/network/network_binding.dart';
import 'package:iot/pages/home/my/network/network_view.dart';
import 'package:iot/pages/home/my/setting/setting_binding.dart';
import 'package:iot/pages/home/my/setting/setting_view.dart';
import 'package:iot/pages/home/space/manage/space_manage_binding.dart';
import 'package:iot/pages/home/space/manage/space_manage_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import '../../../utils/HhColors.dart';
import 'my_controller.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class MyPage extends StatelessWidget {
  final logic = Get.find<MyController>();

  MyPage({super.key});

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
          child: BouncingWidget(
            duration: const Duration(milliseconds: 100),
            scaleFactor: 1.2,
            onPressed: () async {
              String? barcodeScanRes = await scanner.scan();
              HhLog.d("barCode $barcodeScanRes");
              if(barcodeScanRes!.isNotEmpty){
                dynamic model = jsonDecode(barcodeScanRes);
                if(model["type"] == "share"){
                  String requestUrl = RequestUtils.base + model["shareUrl"];
                  logic.getShareDetail(requestUrl);
                }else{
                  Get.to(()=>DeviceAddPage(snCode: barcodeScanRes,),binding: DeviceAddBinding());
                }
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 90.w, 115.w, 0),
              child: Image.asset(
                "assets/images/common/icon_scanner.png",
                width: 45.w,
                height: 45.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: BouncingWidget(
            duration: const Duration(milliseconds: 100),
            scaleFactor: 1.2,
            onPressed: () {
              Get.to(() => SettingPage(), binding: SettingBinding());
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 90.w, 40.w, 0),
              child: Image.asset(
                "assets/images/common/icon_set.png",
                width: 45.w,
                height: 45.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 120.w),
          child: EasyRefresh(
            onRefresh: () {
              logic.getSpaceList();
              logic.deviceList();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ///头像等信息
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.to(() => SettingPage(), binding: SettingBinding());
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.fromLTRB(36.w, 70.w, 0.w, 0),
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(50.w))),
                          child: Image.network(
                            logic.avatar!.value,
                            // 'https://i-blog.csdnimg.cn/blog_migrate/5e75d62a5497d2d0da5f65ba2a2e1748.png',
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                              return Image.asset(
                                "assets/images/common/user.png",
                                width: 100.w,
                                height: 100.w,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => SettingPage(), binding: SettingBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(150.w, 80.w, 0, 0),
                          child: Text(
                            logic.nickname!.value,
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => SettingPage(), binding: SettingBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(150.w, 124.w, 0, 0),
                          child: Text(
                            CommonUtils().mobileString(logic.mobile!.value),
                            style: TextStyle(color: HhColors.gray6TextColor, fontSize: 23.sp),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///设备&&空间
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w, 40.w, 20.w, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(() => DeviceManagePage(),
                                    binding: DeviceManageBinding());
                              },
                              child: Container(
                                height: 160.w,
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(14.w))),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        margin: EdgeInsets.fromLTRB(30.w, 0.w, 0.w, 0.w),
                                        decoration: BoxDecoration(
                                            color: HhColors.whiteColor,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(50.w))),
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
                                          "${logic.deviceNum}",
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(130.w, 45.w, 0.w, 0.w),
                                        child: Text(
                                          "设备管理",
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 23.sp),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                Get.to(() => SpaceManagePage(),
                                    binding: SpaceManageBinding());
                              },
                              child: Container(
                                height: 160.w,
                                margin: EdgeInsets.only(left: 10.w),
                                decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(14.w))),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        margin: EdgeInsets.fromLTRB(30.w, 0.w, 0.w, 0.w),
                                        decoration: BoxDecoration(
                                            color: HhColors.whiteColor,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(50.w))),
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
                                          "${logic.spaceNum}",
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold),
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
                              ),
                            ))
                      ],
                    ),
                  ),

                  ///菜单
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(14.w))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///空间网络
                        InkWell(
                          onTap: () {
                            // Get.to(() => NetWorkPage(), binding: NetWorkBinding());
                            EventBusUtil.getInstance().fire(HhToast(title: '暂未开放'));
                          },
                          child: Container(
                            height: 110.w,
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.w),
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
                                    margin: EdgeInsets.only(left: 70.w),
                                    child: Text(
                                      "空间网络",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 65.w),
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
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 30.w, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 25.w,
                                      height: 25.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),

                        ///设置

                        InkWell(
                          onTap: () {
                            Get.to(() => SettingPage(), binding: SettingBinding());
                          },
                          child: Container(
                            height: 110.w,
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.w),
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
                                    margin: EdgeInsets.only(left: 70.w),
                                    child: Text(
                                      "设置",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 30.w, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 25.w,
                                      height: 25.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                      color: HhColors.grayDDTextColor,
                                    ))
                              ],
                            ),
                          ),
                        ),

                        ///帮助与反馈
                        InkWell(
                          onTap: () {
                            // Get.to(() => HelpPage(), binding: HelpBinding());
                            EventBusUtil.getInstance().fire(HhToast(title: '暂未开放'));
                          },
                          child: Container(
                            height: 110.w,
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.w),
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
                                    margin: EdgeInsets.only(left: 70.w),
                                    child: Text(
                                      "帮助与反馈",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor,
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 6.w, 30.w, 0),
                                    child: Image.asset(
                                      "assets/images/common/back_role.png",
                                      width: 25.w,
                                      height: 25.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 0.4.sh,),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
