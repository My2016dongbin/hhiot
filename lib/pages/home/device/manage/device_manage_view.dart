import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/manage/device_manage_controller.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceManagePage extends StatelessWidget {
  final logic = Get.find<DeviceManageController>();

  DeviceManagePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  margin: EdgeInsets.only(top:90.w),
                  color: HhColors.trans,
                  child: Text(
                    "设备管理",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ///列表
              logic.testStatus.value?deviceList():const SizedBox(),
              ///tab
              Container(
                margin: EdgeInsets.fromLTRB(50.w, 180.w, 0, 0),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: (){
                              logic.tabIndex.value = 0;
                            },
                            child: Text(
                              '全部',
                              style: TextStyle(
                                  color: logic.tabIndex.value==0?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==0?32.sp:26.sp,fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 5.w,),
                          logic.tabIndex.value==0?Container(
                            height: 4.w,
                            width: 26.w,
                            decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(Radius.circular(2.w))
                            ),
                          ):const SizedBox()
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: (){
                                logic.tabIndex.value = 1;
                              },
                              child: Text(
                                '空间1',
                                style: TextStyle(
                                    color: logic.tabIndex.value==1?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==1?32.sp:26.sp,fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5.w,),
                            logic.tabIndex.value==1?Container(
                              height: 4.w,
                              width: 26.w,
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(Radius.circular(2.w))
                              ),
                            ):const SizedBox()
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: (){
                                logic.tabIndex.value = 2;
                              },
                              child: Text(
                                '空间2',
                                style: TextStyle(
                                    color: logic.tabIndex.value==2?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==2?32.sp:26.sp,fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5.w,),
                            logic.tabIndex.value==2?Container(
                              height: 4.w,
                              width: 26.w,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  deviceList() {
    return Container(
      margin: EdgeInsets.only(top: 200.w),
      child: PagedListView<int, Device>(
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<Device>(
          itemBuilder: (context, item, index) => InkWell(
            onTap: (){
              Get.to(()=>DeviceDetailPage(),binding: DeviceDetailBinding());
            },
            child: Container(
              height: 180.w,
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
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
                    child: InkWell(
                      onTap: (){
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
