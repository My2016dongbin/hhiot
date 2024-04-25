import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class HomeController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledCount = 0.obs;
  final _errorController = PublishSubject<String>();

  Function()? onScrollToUnreadMessage;

  switchTab(index) {
    this.index.value = index;
    // IMViews.showToast(index.toString());
    var  brightness = Platform.isAndroid ? Brightness.dark : Brightness.dark;
    // switch(index){
    //   case 0:
    //   // 状态栏透明（Android）
    //     brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    //     break;
    //   case 1:
    //     break;
    //   case 2:
    //     break;
    //   case 3:
    //     break;
    //     default:
    //       break;
    //
    // }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));

  }

  scrollToUnreadMessage(index) {
    onScrollToUnreadMessage?.call();
  }



  @override
  void onClose() {
    _errorController.close();
    super.onClose();
  }
}
