import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class CodeController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  late String code = '';
  late BuildContext context;
  late String mobile;
  final Rx<int> time = 10.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1),(){
      sendCode();
    });
    super.onInit();
  }

  Future<void> sendCode() async {
    var result = await HhHttp().request(
      RequestUtils.codeSend,
      method: DioMethod.post,
      data: {'mobile':mobile,'scene':21},
    );
    HhLog.d("sendCode -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      time.value = 10;
      runCode();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> sendLogin() async {
    var result = await HhHttp().request(
      RequestUtils.codeLogin,
      method: DioMethod.post,
      data: {'code':code},
    );
    HhLog.d("sendLogin -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '登录成功'));
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAll(HomePage(), binding: HomeBinding());
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void runCode() {
    Future.delayed(const Duration(seconds: 1),(){
      time.value--;
      if(time.value > 0){
        runCode();
      }else{

      }
    });
  }
}
