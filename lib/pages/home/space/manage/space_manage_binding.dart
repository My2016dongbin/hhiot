import 'package:get/get.dart';
import 'package:iot/pages/home/device/list/device_list_controller.dart';
import 'package:iot/pages/home/space/manage/space_manage_controller.dart';

class SpaceManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpaceManageController());
  }
}
