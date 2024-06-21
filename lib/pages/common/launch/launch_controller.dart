import 'package:get/get.dart';
import 'package:iot/pages/common/login/login_binding.dart';
import 'package:iot/pages/common/login/login_view.dart';
import 'package:iot/utils/HhLog.dart';

class LaunchController extends GetxController {
  final Rx<bool> testStatus = true.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2),(){
      // Get.off(HomePage(),binding: HomeBinding());
      Get.off(LoginPage(),binding: LoginBinding());
    });
    super.onInit();
  }
}
