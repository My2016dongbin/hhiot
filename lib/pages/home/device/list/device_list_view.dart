import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/device_view.dart';
import 'package:iot/pages/home/device/list/device_list_controller.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceListPage extends StatelessWidget {
  final logic = Get.find<DeviceListController>();

  DeviceListPage({super.key});

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
              ///back
              InkWell(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(25.w))),
                  margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
                  padding: EdgeInsets.all(10.w),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/back.png",
                          width: 12.w,
                          height: 20.w,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ///icon
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 100.w, 30.w, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          Get.to(()=>SharePage(),binding: ShareBinding());
                        },
                        child: Image.asset(
                          "assets/images/common/icon_shared_space.png",
                          width: 45.w,
                          height: 45.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 30.w,),
                      Image.asset(
                        "assets/images/common/icon_map_space.png",
                        width: 45.w,
                        height: 45.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 30.w,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          Get.to(()=>DeviceAddPage(),binding: DeviceAddBinding());
                        },
                        child: Image.asset(
                          "assets/images/common/icon_add_space.png",
                          width: 45.w,
                          height: 45.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ///title
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.w, 180.w, 0, 0),
                  color: HhColors.trans,
                  child: Text(
                    "大涧林场·设备列表",
                    style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 36.sp,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ///温度
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.w, 330.w, 0, 0),
                  color: HhColors.trans,
                  child: Row(
                    children: [
                      SizedBox(width: 40.w,),
                      Expanded(child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/icon_wd_space.png",
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10.w,),
                          Text(
                            "23.5°C",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 32.sp,fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      Expanded(child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/icon_sd_space.png",
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10.w,),
                          Text(
                            "23.5",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 32.sp,fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      Expanded(child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/icon_dq_space.png",
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10.w,),
                          Text(
                            "23.5°C",
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 32.sp,fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.w, 385.w, 0, 0),
                  color: HhColors.trans,
                  child: Row(
                    children: [
                      SizedBox(width: 40.w,),
                      Expanded(child: Text(
                        "当前温度",
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 26.sp),
                      )),
                      Expanded(child: Text(
                        "湿度",
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 26.sp),
                      )),
                      Expanded(child: Text(
                        "地区温度",
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 26.sp),
                      )),
                    ],
                  ),
                ),
              ),
              ///列表
              logic.testStatus.value?deviceList():const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  deviceList() {
    return Container(
      margin: EdgeInsets.only(top: 380.w),
      child: PagedListView<int, Device>(
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<Device>(
          itemBuilder: (context, item, index) =>
              InkWell(
                onTap: (){
                  Get.to(()=>DeviceDetailPage(),binding: DeviceDetailBinding());
                },
            child: Container(
              height: 160.w,
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.w))
                      ),
                      child: Image.asset(
                        "assets/images/common/icon_camera_space.png",
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(100.w, 0, 0, item.desc==""?0:50.w),
                      child: Text(
                        '${item.name}',
                        style: TextStyle(
                            color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  item.desc==""?const SizedBox():Container(
                    margin: EdgeInsets.fromLTRB(100.w, 80.w, 0, 0),
                    child: Text(
                      '${item.desc}',
                      style: TextStyle(
                          color: HhColors.textColor, fontSize: 22.sp),
                    ),
                  ),
                  ///分享
                  item.shared==true?Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right:70.w),
                      padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                      decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.w))
                      ),
                      child: Text(
                        '已共享*1',
                        style: TextStyle(
                            color: HhColors.whiteColor, fontSize: 23.sp),
                      ),
                    ),
                  ):const SizedBox(),
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        Get.to(()=>SharePage(),binding: ShareBinding());
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: item.shared==true?0:80.w),
                        child: Image.asset(
                          item.shared==true?"assets/images/common/shared.png":"assets/images/common/share.png",
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  item.shared==true?const SizedBox():Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      "assets/images/common/close.png",
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
