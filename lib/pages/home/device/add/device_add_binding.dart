import 'package:get/get.dart';
import 'package:iot/pages/common/location/search/saerch_controller.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';

class DeviceAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeviceAddController());
    Get.lazyPut(() => SearchLocationController());
  }
}
