import 'package:get/get.dart';
import 'package:iot/pages/common/login/code/code_controller.dart';
import 'package:iot/pages/common/login/login_controller.dart';
import 'package:iot/pages/common/login/regist/regist_controller.dart';
import 'package:iot/pages/home/device/device_controller.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/main/main_controller.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/my/my_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
  }
}
