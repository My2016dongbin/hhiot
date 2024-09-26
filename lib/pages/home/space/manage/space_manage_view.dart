import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/pages/home/space/manage/edit/edit_binding.dart';
import 'package:iot/pages/home/space/manage/edit/edit_view.dart';
import 'package:iot/pages/home/space/manage/space_manage_controller.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class SpaceManagePage extends StatelessWidget {
  final logic = Get.find<SpaceManageController>();

  SpaceManagePage({super.key});

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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 90.w),
                  color: HhColors.trans,
                  child: Text(
                    "管理空间",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              ///列表
              logic.testStatus.value ? deviceList() : const SizedBox(),

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
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    Get.to(() => SpacePage(), binding: SpaceBinding());
                  },
                  child: Container(
                    height: 80.w,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 30.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(50.w))),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*Container(
                            margin: EdgeInsets.fromLTRB(0, 3.w, 6.w, 0),
                            child: Image.asset(
                              "assets/images/common/icon_add_space.png",
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.fill,
                            ),
                          ),*/
                          Text(
                            "添加新空间",
                            style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 30.sp,
                            ),
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
      margin: EdgeInsets.only(top: 150.w),
      child: EasyRefresh(
        onRefresh: () {
          logic.pageNum = 1;
          logic.getSpaceList(logic.pageNum);
        },
        onLoad: () {
          logic.pageNum++;
          logic.getSpaceList(logic.pageNum);
        },
        child: PagedListView<int, dynamic>(
          padding: EdgeInsets.zero,
          pagingController: logic.pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(
              image: 'assets/images/common/no_message.png',
              info: '暂无消息',
              mid: 50.w,
              height: 0.32.sw,
              width: 0.6.sw,
            ),
            itemBuilder: (context, item, index) =>
                gridItemView(context, item, index),
          ),
        ),
      ),
    );
  }

  gridItemView(BuildContext context, dynamic item, int index) {
    return InkWell(
      onTap: () {
        // Get.to(()=>DeviceListPage(id: "${item['id']}",),binding: DeviceListBinding());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 0),
            padding: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 20.w),
            clipBehavior: Clip.hardEdge,
            //裁剪
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20.w))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///空间名
                Container(
                  margin: EdgeInsets.only(bottom: 30.w),
                  child: Row(
                    children: [
                      Text(
                        "${item['name']}",
                        style: TextStyle(
                            color: HhColors.blackColor,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      const Expanded(child: SizedBox()),
                      item['name'] == '默认空间'
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Get.to(() => EditPage(),
                                    binding: EditBinding(), arguments: item);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Text(
                                  "修改",
                                  style: TextStyle(
                                    color: HhColors.mainBlueColor,
                                    fontSize: 26.sp,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                ///设备列表

                Container(
                  color: HhColors.grayAATextColor,
                  height: 0.5.w,
                  width: 1.sw,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 25.w, 0, 20.w),
                  child: Row(
                    children: [
                      Text(
                        "高塔一体机",
                        style: TextStyle(
                            color: HhColors.blackColor,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w200),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        "修改",
                        style: TextStyle(
                          color: HhColors.mainBlueColor,
                          fontSize: 26.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///删除空间
          item['name'] == '默认空间'
              ? const SizedBox()
              : Container(
            height: 1.w,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.w)),
            margin: EdgeInsets.fromLTRB(40.w, 0, 40.w, 0),
            child: DottedDashedLine(
              height: 0,
              width: 1.sw,
              axis: Axis.horizontal,
              dashColor: HhColors.grayDDTextColor,
            ),
          ),
          item['name'] == '默认空间'
              ? const SizedBox()
              : InkWell(
            onTap: () {
              CommonUtils().showDeleteDialog(
                  context, "确定要删除“${item['name']}”?\n请选择如何删除空间", () {
                Get.back();
                // logic.deleteChangeSpace(item['id'],item['id'],1);
                showChooseSpaceDialog(item);
              }, () {
                Get.back();
                logic.deleteChangeSpace(item['id'],null,2);
              }, () {
                Get.back();
              }, leftStr: '设备转移后删除', rightStr: '全部删除');
            },
            child: Container(
              width: 1.sw,
              height: 100.w,
              margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
              child: Center(
                  child: Text(
                '删除空间',
                style: TextStyle(color: HhColors.mainRedColor, fontSize: 26.sp),
              )),
            ),
          ),
        ],
      ),
    );
  }

  void showChooseSpaceDialog(dynamic item) {
    showModalBottomSheet(context: logic.context, builder: (a){
      bool choose = false;
      return Container(
        width: 1.sw,
        decoration: BoxDecoration(
            color: HhColors.trans,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.w,),
            Expanded(
              child: Container(
                width: 1.sw,
                height: 90.w,
                margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 25.w),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.w))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30.w,),
                    Text('空间删除后，将设备转移至',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 23.sp),),
                    SizedBox(height: 40.w,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: buildDialogSpace(item),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              child: Container(
                width: 1.sw,
                height: 90.w,
                margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 50.w),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.w))),
                child: Center(
                  child: Text(
                    "取消",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HhColors.blackColor, fontSize: 28.sp),
                  ),
                ),
              ),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ),
      );
    },isDismissible: false,enableDrag: false,backgroundColor: HhColors.trans);
  }

  buildDialogSpace(dynamic item) {
    List<Widget> list = [];
    for(int i = 0;i < logic.spaceList.length;i++){
      dynamic model = logic.spaceList[i];
      if(model['id'] != item['id']){
        list.add(
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 25.w, 20.w),
              child: Row(
                children: [
                  Text(
                    "${model['name']}",
                    style: TextStyle(
                        color: HhColors.blackColor,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Get.back();
                      logic.deleteChangeSpace(item['id'],model['id'],1);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      child: Text(
                        "转移",
                        style: TextStyle(
                          color: HhColors.mainBlueColor,
                          fontSize: 26.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }
    }
    return list;
  }
}
