import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../utils/HhColors.dart';
import '../home_controller.dart';
import 'message_controller.dart';

class MessagePage extends StatelessWidget {
  final logic = Get.find<MessageController>();
  final logicHome = Get.find<HomeController>();

  MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
          () => Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Container(
                  height: 160.w,
                  width: 1.sw,
                  color: HhColors.whiteColor,
                ),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    logicHome.index.value = 0;
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
                    padding: EdgeInsets.all(10.w),
                    color: HhColors.whiteColor,
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
                    margin: EdgeInsets.only(top: 80.w),
                    child: ToggleSwitch(
                      minWidth: 90,
                      minHeight: 32,
                      fontSize: 25.sp,
                      activeBgColor: const [HhColors.mainBlueColor],
                      inactiveBgColor: HhColors.grayXXTextColor,
                      initialLabelIndex: logic.tabIndex.value,
                      cornerRadius: 4.0,
                      totalSwitches: 2,
                      labels: const ['设备信息', '报警信息'],
                      onToggle: (index) {
                        logic.tabIndex.value = index!;
                      },
                    ),
                  ),
                ),
                logic.tabIndex.value==0 ? deviceMessage() : warnMessage(),
              ],
            ),
          ),
        ));
  }

  deviceMessage() {
    return Container(
      margin: EdgeInsets.only(top: 120.w),
      child: EasyRefresh(
        onRefresh: (){
          logic.pageNumLeft = 1;
          logic.fetchPageDevice(logic.pageNumLeft);
        },
        onLoad: (){
          logic.pageNumLeft++;
          logic.fetchPageDevice(logic.pageNumLeft);
        },
        child: PagedListView<int, dynamic>(
          pagingController: logic.deviceController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(),
            itemBuilder: (context, item, index) => Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Stack(
                children: [
                  Container(
                    height: 10.w,
                    width: 10.w,
                    margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                    decoration: BoxDecoration(
                      color: HhColors.backRedInColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                    child: Text(
                      '${item['name']}',
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                    child: Text(
                      '${item['content']}',
                      style: TextStyle(
                          color: HhColors.textColor, fontSize: 22.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${item['time']}',
                      style: TextStyle(
                          color: HhColors.textColor, fontSize: 22.sp),
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
  warnMessage() {
    return Container(
      margin: EdgeInsets.only(top: 120.w),
      child: EasyRefresh(
        onRefresh: (){
          logic.pageNumRight = 1;
          logic.fetchPageWarn(logic.pageNumRight);
        },
        onLoad: (){
          logic.pageNumRight++;
          logic.fetchPageWarn(logic.pageNumRight);
        },
        child: PagedListView<int, dynamic>(
          pagingController: logic.warnController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(),
            itemBuilder: (context, item, index) => Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Stack(
                children: [
                  Container(
                    height: 10.w,
                    width: 10.w,
                    margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.backRedInColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                    child: Text(
                      "${item['name']}",
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                    child: Text(
                      '${item['content']}',
                      style: TextStyle(
                          color: HhColors.textColor, fontSize: 22.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${item['time']}',
                      style: TextStyle(
                          color: HhColors.textColor, fontSize: 22.sp),
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
