import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_view.dart';
import 'package:iot/pages/home/device/manage/device_manage_controller.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
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
                    children: logic.tabsTag.value?buildTabs():[],
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
      child: EasyRefresh(
        onRefresh: (){
          logic.pageNum = 1;
          logic.deviceList(logic.pageNum);
        },
        onLoad: (){
          logic.pageNum++;
          logic.deviceList(logic.pageNum);
        },
        child: PagedListView<int, dynamic>(
          pagingController: logic.deviceController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) =>CommonUtils().noneWidget(),
            itemBuilder: (context, item, index) =>
                InkWell(
                  onTap: (){
                    Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
                    /*if(item['productName']=='浩海一体机'){
                      Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
                    }else if(item['productName']=='智慧立杆'){
                      Get.to(()=>LiGanDetailPage('${item['deviceNo']}','${item['id']}'),binding: LiGanDetailBinding());
                    }*/
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
                          item['productName']=='浩海一体机'?"assets/images/common/icon_camera_space.png":"assets/images/common/ic_gan.png",
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(100.w, 0, 0, item['productName']==""?0:50.w),
                        child: Text(
                          '${item['name']}',
                          style: TextStyle(
                              color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    item['productName']==""?const SizedBox():Container(
                      margin: EdgeInsets.fromLTRB(100.w, 80.w, 0, 0),
                      child: Text(
                        '${item['productName']}-${item['categoryName']}',
                        style: TextStyle(
                            color: HhColors.textColor, fontSize: 22.sp),
                      ),
                    ),
                    ///分享
                    item['shared']==true?Align(
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
                    /*Align(
                      alignment: Alignment.centerRight,
                      child:
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          Get.to(()=>SharePage(),binding: ShareBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: item['shared']==true?0:80.w),
                          child: Image.asset(
                            item['shared']==true?"assets/images/common/shared.png":"assets/images/common/share.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),*/
                    item['shared']==true?const SizedBox():Align(
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
      ),
    );
  }


  List<Widget> buildTabs() {
    List<Widget> list = [];
    for(int i = 0;i < logic.spaceList.length;i++){
      dynamic model = logic.spaceList[i];
      list.add(
          Container(
            margin: EdgeInsets.only(left: i==0?0:30.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    logic.tabIndex.value = i;
                    logic.pageNum = 1;
                    logic.deviceList(logic.pageNum);
                  },
                  child: Text(
                    '${model['name']}',
                    style: TextStyle(
                        color: logic.tabIndex.value==i?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==i?32.sp:28.sp,fontWeight: logic.tabIndex.value==i?FontWeight.bold:FontWeight.w200),
                  ),
                ),
                SizedBox(height: 5.w,),
                logic.tabIndex.value==i?Container(
                  height: 4.w,
                  width: 26.w,
                  decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.w))
                  ),
                ):const SizedBox()
              ],
            ),
          )
      );
    }

    return list;
  }
}
