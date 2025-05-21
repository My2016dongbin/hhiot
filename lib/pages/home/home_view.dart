import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/mqtt/mqtt_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';

import '../../cell/bottom_bar.dart';
import '../../res/images.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../utils/HhColors.dart';
import 'device/device_view.dart';
import 'home_controller.dart';
import 'main/main_view.dart';
import 'message/message_view.dart';
import 'my/my_view.dart';
class HomePage extends StatelessWidget {
  final logic = Get.find<HomeController>();
  final logicMqtt = Get.find<MqttController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    CommonData.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));

    return Obx(() => WillPopScope(
      onWillPop: onBackPressed,
      child: Container(
        color: HhColors.whiteColor,
        child: SafeArea(
          bottom: true,
          top: false,
          left: false,
          right: false,
          child: Scaffold(
            backgroundColor: HhColors.backColor,
            body: IndexedStack(
              index: logic.index.value,
              children:  [
                MainPage(),
                DevicePage(),
                MessagePage(),
                MyPage(),
              ],
            ),
            bottomNavigationBar: BottomBar(
              index: logic.index.value,
              items: [
                BottomBarItem(
                  selectedImgRes: ImageRes.chatPressed,
                  unselectedImgRes: ImageRes.chat,
                  selectedStyle: Styles.ts_39CD80_10sp_bold,
                  unselectedStyle: Styles.ts_333333_10sp,
                  label: StrRes.chatTab,
                  imgWidth: 22.w*3,
                  imgHeight: 22.h*3,
                  onClick: logic.switchTab,
                  onDoubleClick: logic.scrollToUnreadMessage,
                  count: logic.unreadMsgCount.value,
                ),
                BottomBarItem(
                  selectedImgRes: ImageRes.momentsPressed,
                  unselectedImgRes: ImageRes.moments,
                  selectedStyle: Styles.ts_39CD80_10sp_bold,
                  unselectedStyle: Styles.ts_333333_10sp,
                  label: StrRes.momentTab,
                  imgWidth: 22.w*3,
                  imgHeight: 22.w*3,
                  onClick: logic.switchTab,
                  count: logic.unhandledCount.value,
                ),
                BottomBarItem(
                  selectedImgRes: ImageRes.servicePressed,
                  unselectedImgRes: ImageRes.service,
                  selectedStyle: Styles.ts_39CD80_10sp_bold,
                  unselectedStyle: Styles.ts_333333_10sp,
                  label: StrRes.serviceTab,
                  imgWidth: 22.w*3,
                  imgHeight: 22.w*3,
                  onClick: logic.switchTab,
                ),
                BottomBarItem(
                  selectedImgRes: ImageRes.minePressed,
                  unselectedImgRes: ImageRes.mine,
                  selectedStyle: Styles.ts_39CD80_10sp_bold,
                  unselectedStyle: Styles.ts_333333_10sp,
                  label: StrRes.mineTab,
                  imgWidth: 22.w*3,
                  imgHeight: 22.w*3,
                  onClick: logic.switchTab,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  int timeForExit = 0;
  //复写返回监听
  Future<bool> onBackPressed() {
    bool exit = false;
    int time_ = DateTime.now().millisecondsSinceEpoch;
    if(logic.index.value == 0){
      if (time_ - timeForExit > 2000) {
        EventBusUtil.getInstance().fire(HhToast(title: '再按一次退出程序'));
        timeForExit = time_;
        exit = false;
      } else {
        exit = true;
      }
    }else{
      logic.index.value = 0;
    }
    return Future.value(exit);
  }
}
