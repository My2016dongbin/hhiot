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
import 'package:iot/pages/home/device/device_view.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_controller.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/space/manage/space_manage_controller.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/HhColors.dart';

class SpaceManagePage extends StatelessWidget {
  final logic = Get.find<SpaceManageController>();

  SpaceManagePage({super.key});

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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 90.w),
                  color: HhColors.trans,
                  child: Text(
                    "空间管理",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ///列表
              logic.testStatus.value?deviceList():const SizedBox(),


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
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 1.sw,
                  height: 140.w,
                  color: HhColors.whiteColor,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 1.sw,
                  height: 1.w,
                  margin: EdgeInsets.only(bottom: 140.w),
                  color: HhColors.grayDDTextColor,
                ),
              ),
              ///新增空间按钮
              Align(
                alignment: Alignment.bottomCenter,
                child:
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    Get.to(()=>SpacePage(),binding: SpaceBinding());
                  },
                  child: Container(
                    height: 80.w,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 30.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.w))),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 3.w, 6.w, 0),
                            child: Image.asset(
                              "assets/images/common/icon_add_space.png",
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            "新增空间",
                            style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 30.sp,),
                          ),
                        ],
                      ),
                    ),
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
      margin: EdgeInsets.only(top: 100.w),
      child: EasyRefresh(
        onRefresh: (){
          logic.pageNum = 1;
          logic.getSpaceList(logic.pageNum);
        },
        onLoad: (){
          logic.pageNum++;
          logic.getSpaceList(logic.pageNum);
        },
        child: PagedGridView<int, dynamic>(
            pagingController: logic.pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) =>
                  gridItemView(context, item, index),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //横轴三个子widget
                childAspectRatio: 1.3 //宽高比为1时，子widget
            )),
      ),
    );
  }

  gridItemView(BuildContext context, dynamic item, int index) {
    return
      InkWell(
        onTap: (){
          Get.to(()=>DeviceListPage(id: "${item['id']}",),binding: DeviceListBinding());
        },
      child: Container(
        clipBehavior: Clip.hardEdge, //裁剪
        margin: EdgeInsets.fromLTRB(index%2==0?30.w:15.w, 30.w, index%2==0?15.w:30.w, 0),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(32.w))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 0.25.sw,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(32.w))),
              child: Image.asset(
                "assets/images/common/test_video.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 16.w, 16.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      "${item['name']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: HhColors.blackColor,
                        fontSize: 30.sp,),
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12.w, 2.w, 12.w, 2.w),
                        decoration: BoxDecoration(
                            color: HhColors.grayEFBackColor,
                            borderRadius: BorderRadius.all(Radius.circular(8.w))
                        ),
                        child: Text(
                          "${item['deviceCount']}个设备",
                          style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                        ),
                      ),
                    ],
                  ),
                  item['deviceCount']==0?const SizedBox():Image.asset(
                    "assets/images/common/icon_red.png",
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.fill,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
