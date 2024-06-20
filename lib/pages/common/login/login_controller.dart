import 'package:get/get.dart';
import 'package:iot/pages/common/launch/launch_view.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/HhLog.dart';

class LoginController extends GetxController {
  final Rx<bool> testStatus = true.obs;

  @override
  void onInit() {
    /*Future.delayed(const Duration(seconds: 2),(){
      Get.off(HomePage(),binding: HomeBinding());
    });*/
    super.onInit();
  }
}
