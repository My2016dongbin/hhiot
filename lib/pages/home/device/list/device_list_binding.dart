import 'package:get/get.dart';
import 'package:iot/pages/home/device/list/device_list_controller.dart';

class DeviceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeviceListController());
  }
}
