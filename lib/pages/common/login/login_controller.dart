import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> accountStatus = false.obs;
  final Rx<bool> passwordStatus = false.obs;
  final Rx<bool> passwordShowStatus = false.obs;
  final Rx<bool> confirmStatus = false.obs;
  TextEditingController ?accountController = TextEditingController();
  TextEditingController ?passwordController = TextEditingController();

  @override
  void onInit() {
    /*Future.delayed(const Duration(seconds: 2),(){
      Get.off(HomePage(),binding: HomeBinding());
    });*/
    super.onInit();
  }
}
