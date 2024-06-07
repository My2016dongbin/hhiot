import 'package:get/get.dart';
import 'package:iot/pages/common/launch/launch_controller.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/home_controller.dart';

class LaunchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LaunchController());
    Get.lazyPut(() => HomeController());
  }
}
