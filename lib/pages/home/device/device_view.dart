import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
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
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_view.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'device_controller.dart';

class DevicePage extends StatelessWidget {
  final logic = Get.find<DeviceController>();
  final logicHome = Get.find<HomeController>();

  DevicePage({super.key});

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
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ///title
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: (){
                  logicHome.index.value = 0;
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
                    "智能设备",
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
                  scrollDirection: Axis.horizontal,
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
      margin: EdgeInsets.only(top: 260.w),
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
          padding: EdgeInsets.zero,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) =>Column(
              children: [
                SizedBox(height:0.4.sw,),
                Image.asset('assets/images/common/no_message.png',fit: BoxFit.fill,
                  height: 0.32.sw,
                  width: 0.6.sw,),
                SizedBox(height: 100.w,),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    width: 1.sw,
                    height: 90.w,
                    margin: EdgeInsets.fromLTRB(60.w, 20.w, 60.w, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(50.w))),
                    child: Center(
                      child: Text(
                        "没有设备？去添加",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.grayEEBackColor, fontSize: 26.sp),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(()=>DeviceAddPage(snCode: ""),binding: DeviceAddBinding());
                  },
                ),
              ],
            ),
            itemBuilder: (context, item, index) =>
                InkWell(
                  onTap: (){
                    Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
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
                        margin: EdgeInsets.fromLTRB(100.w, 0, 0, 50.w),
                        child: Text(
                          CommonUtils().parseNull('${item['name']}',""),
                          style: TextStyle(
                              color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(100.w, 80.w, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          item['spaceName']==""?const SizedBox():Container(
                            constraints: BoxConstraints(maxWidth: 0.25.sw),
                            child: Text(
                              CommonUtils().parseNull('${item['spaceName']}', ""),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: HhColors.textColor, fontSize: 22.sp),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.w, 0, 60.w, 0),
                            padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                            decoration: BoxDecoration(
                                color: item['activeStatus']==1?HhColors.transBlueColors:HhColors.transRedColors,
                                border: Border.all(color: item['activeStatus']==1?HhColors.mainBlueColor:HhColors.mainRedColor,width: 1.w),
                                borderRadius: BorderRadius.all(Radius.circular(8.w)),
                            ),
                            child: Text(
                              item['activeStatus']==1?'在线':"离线",
                              style: TextStyle(
                                  color: item['activeStatus']==1?HhColors.mainBlueColor:HhColors.mainRedColor, fontSize: 23.sp),
                            ),
                          ),
                          item['shared']==true?Container(
                            margin: EdgeInsets.only(left:10.w),
                            padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                            decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                            child: Text(
                              '分享中*1',
                              style: TextStyle(
                                  color: HhColors.whiteColor, fontSize: 23.sp),
                            ),
                          ):const SizedBox(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child:
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          DateTime date = DateTime.now();
                          String time = date.toIso8601String().substring(0,19).replaceAll("T", " ");
                          Get.to(()=>SharePage(),binding: ShareBinding(),arguments: {
                            "shareType": "2",
                            "expirationTime": time,
                            "appShareDetailSaveReqVOList": [
                              {
                                "spaceId": "${item["spaceId"]}",
                                "spaceName": "${item["spaceName"]}",
                                "deviceId": "${item["id"]}",
                                "deviceName": "${item["name"]}"
                              }
                            ]
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 0.w),
                          child: Image.asset(
                            item['shared']==true?"assets/images/common/shared.png":"assets/images/common/share.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    /*item['shared']==true?const SizedBox():Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        "assets/images/common/close.png",
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.fill,
                      ),
                    ),*/
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
                InkWell(
                  onTap: (){
                    logic.tabIndex.value = i;
                    logic.pageNum = 1;
                    logic.deviceList(logic.pageNum);
                  },
                  child: Text(
                    '${model['name']}',
                    style: TextStyle(
                        color: logic.tabIndex.value==i?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==i?32.sp:28.sp,fontWeight: logic.tabIndex.value==i?FontWeight.bold:FontWeight.w500),
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
