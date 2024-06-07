import 'package:get/get.dart';
import 'package:iot/pages/home/device/list/device_list_controller.dart';
import 'package:iot/pages/home/my/help/help_controller.dart';

class HelpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpController());
  }
}
