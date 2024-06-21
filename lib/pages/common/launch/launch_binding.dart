import 'package:get/get.dart';
import 'package:iot/pages/common/launch/launch_controller.dart';
import 'package:iot/pages/common/login/login_controller.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/device/device_controller.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/main/main_controller.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/my/my_controller.dart';

class LaunchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LaunchController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => DeviceController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => MyController());
  }
}
