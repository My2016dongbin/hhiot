import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/launch/launch_controller.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/device/status/device_status_view.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/HhColors.dart';

class LaunchPage extends StatelessWidget {
  final logic = Get.find<LaunchController>();

  LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    /*return AnimatedSplashScreen.withScreenFunction(
      splash: 'images/common/logo.png',
      screenFunction: () async{
        return HomePage();
      },
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: 1,
    );*/
    return AnimatedSplashScreen(
      splash: 'images/common/logo.png',
      nextScreen: HomePage(),
      splashTransition: SplashTransition.rotationTransition,
      // pageTransitionType: PageTransitionType.scale,
    );
  }

}


  enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
  }
