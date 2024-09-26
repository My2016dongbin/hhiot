import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/share/manage/share_manage_controller.dart';
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

class ShareManagePage extends StatelessWidget {
  final logic = Get.find<ShareManageController>();

  ShareManagePage({super.key});

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
                    "分享管理",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              ///列表
              logic.testStatus.value ? deviceList() : const SizedBox(),

              ///tab
              Container(
                margin: EdgeInsets.fromLTRB(50.w, 180.w, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: logic.tabsTag.value ? buildTabs() : [],
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
      margin: EdgeInsets.only(top: 240.w),
      child: EasyRefresh(
        onRefresh: () {
          logic.pageNum = 1;
          logic.shareList(logic.pageNum);
        },
        onLoad: () {
          logic.pageNum++;
          logic.shareList(logic.pageNum);
        },
        child: PagedListView<int, dynamic>(
          padding: EdgeInsets.zero,
          pagingController: logic.deviceController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) =>
                CommonUtils().noneWidget(),
            firstPageProgressIndicatorBuilder: (context) => Container(),
            itemBuilder: (context, item, index) => InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                padding: EdgeInsets.all(20.w),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      child: Image.asset(
                        item['productName'] == '浩海一体机'
                            ? "assets/images/common/icon_camera_space.png"
                            : "assets/images/common/ic_gan.png",
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(30.w, 0, 10.w, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parseTitle('${item['shareUrerName']}',item['receiveDetailDOList']??[]),
                              maxLines: 2,
                              style: TextStyle(
                                  color: HhColors.textBlackColor,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.w,
                            ),
                            Text(
                              "时间：${CommonUtils().parseLongTime('${item['createTime']}')}",
                              maxLines: 2,
                              style: TextStyle(
                                  color: HhColors.grayBBTextColor,
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                item['status'] == 0
                                    ? InkWell(
                                        onTap: () {
                                          CommonUtils().showDeleteDialog(
                                              context, '确定要拒绝该设备的分享邀请吗?', () {
                                            Get.back();
                                          }, () {
                                            Get.back();
                                            logic.handleShare("${item['id']}", 2);
                                          }, () {
                                            Get.back();
                                          }, rightStr: "拒绝");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          child: Text(
                                            "拒绝",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: HhColors.mainRedColor,
                                                fontSize: 26.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  width: 20.w,
                                ),
                                item['status'] == 0
                                    ? InkWell(
                                        onTap: () {
                                          CommonUtils().showConfirmDialog(
                                              context, '确定要同意该设备的分享邀请吗?', () {
                                            Get.back();
                                          }, () {
                                            Get.back();
                                            logic.handleShare("${item['id']}", 1);
                                          }, () {
                                            Get.back();
                                          }, rightStr: "同意");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          child: Text(
                                            "同意",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: HhColors.mainBlueColor,
                                                fontSize: 26.sp,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                item['status'] != 0
                                    ? Container(
                                        padding: EdgeInsets.all(10.w),
                                        child: Text(
                                          item['status']==1?"已同意":"已拒绝",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: HhColors.grayBBTextColor,
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
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
    for (int i = 0; i < logic.spaceList.length; i++) {
      dynamic model = logic.spaceList[i];
      list.add(Container(
        margin: EdgeInsets.only(left: i == 0 ? 0 : 30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                logic.tabIndex.value = i;
                logic.pageNum = 1;
                logic.shareList(logic.pageNum);
              },
              child: Text(
                '${model['name']}',
                style: TextStyle(
                    color: logic.tabIndex.value == i
                        ? HhColors.mainBlueColor
                        : HhColors.gray9TextColor,
                    fontSize: logic.tabIndex.value == i ? 32.sp : 28.sp,
                    fontWeight: logic.tabIndex.value == i
                        ? FontWeight.bold
                        : FontWeight.w200),
              ),
            ),
            SizedBox(
              height: 5.w,
            ),
            logic.tabIndex.value == i
                ? Container(
                    height: 4.w,
                    width: 26.w,
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(2.w))),
                  )
                : const SizedBox()
          ],
        ),
      ));
    }

    return list;
  }

  parseTitle(String name, List<dynamic> list) {
    String rt = "";
    if(list.isNotEmpty){
      rt = "$name邀请您共享${list[0]['deviceName']}";
    }else{
      rt = "$name邀请您共享";
    }
    return rt;
  }
}
