import 'package:get/get.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/device/detail/device_detail_controller.dart';
import 'package:iot/pages/home/device/list/device_list_controller.dart';
import 'package:iot/pages/home/device/status/device_status_controller.dart';
import 'package:iot/pages/home/space/space_controller.dart';

import 'device/device_controller.dart';
import 'home_controller.dart';
import 'main/main_controller.dart';
import 'main/search/search_controller.dart';
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
    Get.lazyPut(() => SpaceController());
    Get.lazyPut(() => SearchedController());
    Get.lazyPut(() => DeviceListController());
    Get.lazyPut(() => DeviceAddController());
    Get.lazyPut(() => DeviceStatusController());
    Get.lazyPut(() => DeviceDetailController());
  }
}
