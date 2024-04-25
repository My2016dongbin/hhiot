import 'package:get/get.dart';

import 'device/device_controller.dart';
import 'home_controller.dart';
import 'main/main_controller.dart';
import 'message/message_controller.dart';
import 'my/my_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => DeviceController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => MyController());
  }
}
