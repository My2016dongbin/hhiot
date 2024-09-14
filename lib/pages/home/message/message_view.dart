import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
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
                /*Align(
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
                ),*/
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100.w,
                    margin: EdgeInsets.only(top: 75.w),
                    child: Row(
                      children: [
                        SizedBox(width: 100.w,),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.0,
                          onPressed: (){
                            logic.tabIndex.value = 0;
                          },
                          child: Container(
                            width: 130.w,
                            padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(alignment: Alignment.topRight,
                                    child: Container(
                                        color: HhColors.trans,
                                      margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==0?0:10.w, 40.w, 0),
                                        child: Text("报警",style: TextStyle(color: logic.tabIndex.value==0?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==0?36.sp:28.sp,fontWeight: logic.tabIndex.value==0?FontWeight.bold:FontWeight.w200),))),
                                logic.warnCount.value=="0"?const SizedBox():Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HhColors.mainRedColor,
                                        borderRadius: BorderRadius.all(Radius.circular(20.w))
                                    ),
                                    width: 36.w + ((logic.noticeCount.value.length-1) * 8.w),
                                    height: 30.w,
                                    child: Center(child: Text(logic.warnCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 18.sp),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.0,
                          onPressed: (){
                            logic.tabIndex.value = 1;
                          },
                          child: Container(
                            width: 130.w,
                            padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                            color: HhColors.trans,
                            child: Stack(
                              children: [
                                Align(alignment: Alignment.topRight,
                                    child: Container(
                                        color: HhColors.trans,
                                        margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==1?0:10.w, 40.w, 0),
                                        child: Text("通知",style: TextStyle(color: logic.tabIndex.value==1?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==1?36.sp:28.sp,fontWeight: logic.tabIndex.value==1?FontWeight.bold:FontWeight.w200),))),
                                logic.noticeCount.value=="0"?const SizedBox():Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HhColors.mainRedColor,
                                        borderRadius: BorderRadius.all(Radius.circular(20.w))
                                    ),
                                    width: 36.w + ((logic.noticeCount.value.length-1) * 8.w),
                                    height: 30.w,
                                    child: Center(child: Text(logic.noticeCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 18.sp),)),
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 85.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.0,
                          onPressed: (){
                            EventBusUtil.getInstance().fire(HhToast(title: '已全部标记为已读',type: 0));
                          },
                          child: Image.asset(
                            "assets/images/common/icon_clear_message.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(width: 30.w,),
                        Image.asset(
                          "assets/images/common/icon_more_message.png",
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 30.w,),
                      ],
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
      margin: EdgeInsets.only(top: 160.w),
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
          padding: EdgeInsets.zero,
          pagingController: logic.deviceController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/no_message.png',info: '暂无消息',mid: 50.w,
              height: 0.32.sw,
              width: 0.6.sw,),
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
                  item['status'] == true?const SizedBox():Container(
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
                      '设备报警',
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
                      CommonUtils().parseLongTime('${item['createTime']}'),
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
      margin: EdgeInsets.only(top: 160.w),
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
          padding: EdgeInsets.zero,
          pagingController: logic.warnController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/no_message.png',info: '暂无消息',mid: 50.w,
              height: 0.32.sw,
              width: 0.6.sw,),
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
