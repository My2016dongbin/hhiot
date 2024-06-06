import 'package:get/get.dart';

import '../home_controller.dart';
import 'space_controller.dart';

class SpaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpaceController());
  }
}
