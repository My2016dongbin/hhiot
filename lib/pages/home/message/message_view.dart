import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
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
                InkWell(
                  onTap: (){
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
                      minHeight: 30,
                      fontSize: 24.sp,
                      activeBgColor: const [HhColors.mainBlueColor],
                      inactiveBgColor: HhColors.grayDDTextColor,
                      initialLabelIndex: logic.tabIndex.value,
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
      child: PagedListView<int, DeviceMessage>(
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<DeviceMessage>(
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
                  margin: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
                  child: Image.asset(
                    "assets/images/common/icon_red.png",
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                  child: Text(
                    '${item.name}',
                    style: TextStyle(
                        color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                  child: Text(
                    '${item.content}',
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${item.time}',
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  warnMessage() {
    return Container(
      margin: EdgeInsets.only(top: 120.w),
      child: PagedListView<int, WarnMessage>(
        pagingController: logic.warnController,

        builderDelegate: PagedChildBuilderDelegate<WarnMessage>(
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
                  margin: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
                  child: Image.asset(
                    "assets/images/common/icon_red.png",
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                  child: Text(
                    '${item.name}',
                    style: TextStyle(
                        color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                  child: Text(
                    '${item.content}',
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${item.time}',
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
