import 'package:get/get.dart';
import 'package:iot/pages/common/login/code/code_controller.dart';
import 'package:iot/pages/common/login/login_controller.dart';
import 'package:iot/pages/common/login/personal/personal_login_controller.dart';
import 'package:iot/pages/home/device/device_controller.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/main/main_controller.dart';
import 'package:iot/pages/home/message/message_controller.dart';
import 'package:iot/pages/home/my/my_controller.dart';

class PersonalLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalLoginController());
    Get.lazyPut(() => MainController());
  }
}
