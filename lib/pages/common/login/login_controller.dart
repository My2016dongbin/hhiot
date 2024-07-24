import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/EventBusUtils.dart';

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
  late StreamSubscription showToastSubscription;
  late StreamSubscription showLoadingSubscription;

  @override
  Future<void> onInit() async {
    /*Future.delayed(const Duration(seconds: 2),(){
      Get.off(HomePage(),binding: HomeBinding());
    });*/

    showToastSubscription = EventBusUtil.getInstance()
        .on<HhToast>()
        .listen((event) {
      showToast(event.title,
        context: context,
        animation: StyledToastAnimation.slideFromBottomFade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
    });
    showLoadingSubscription = EventBusUtil.getInstance()
        .on<HhLoading>()
        .listen((event) {
      if(event.show){
        EasyLoading.show(status: '${event.title}');
      }else{
        EasyLoading.dismiss();
      }
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(SPKeys().token);
    final String? account = prefs.getString(SPKeys().account);
    final String? password = prefs.getString(SPKeys().password);
    if(account!=null && password!=null){
      accountController?.text = account;
      passwordController?.text = password;
    }

    super.onInit();
  }

  Future<void> login() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在登录..'));
    var result = await HhHttp().request(RequestUtils.login,method: DioMethod.post,data: {"username":accountController?.text,"password":/*"R^d8hv3gwLyI"*/passwordController?.text,"tenantName":"haohai"},);
    HhLog.d("login -- $result");
    if(result["code"]==0 && result["data"]!=null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().token, result["data"]["accessToken"]);
      await prefs.setString(SPKeys().account, accountController!.text);
      await prefs.setString(SPKeys().password, passwordController!.text);
      CommonData.token = result["data"]["accessToken"];

      info();

      /*EventBusUtil.getInstance().fire(HhToast(title: '登录成功'));

      Future.delayed(const Duration(seconds: 1),(){
        Get.off(HomePage(),binding: HomeBinding());
      });*/
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> info() async {
    var result = await HhHttp().request(RequestUtils.userInfo,method: DioMethod.get,data: {},);
    HhLog.d("info -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0 && result["data"]!=null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().id, '${result["data"]["id"]}');
      await prefs.setString(SPKeys().nickname, '${result["data"]["nickname"]}');
      await prefs.setString(SPKeys().email, '${result["data"]["email"]}');
      await prefs.setString(SPKeys().mobile, '${result["data"]["mobile"]}');
      await prefs.setString(SPKeys().sex, '${result["data"]["sex"]}');
      await prefs.setString(SPKeys().avatar, '${result["data"]["avatar"]}');
      await prefs.setString(SPKeys().roles, '${result["data"]["roles"]}');
      await prefs.setString(SPKeys().socialUsers, '${result["data"]["socialUsers"]}');
      await prefs.setString(SPKeys().posts, '${result["data"]["posts"]}');

      EventBusUtil.getInstance().fire(HhToast(title: '登录成功'));

      Future.delayed(const Duration(seconds: 1),(){
        Get.off(HomePage(),binding: HomeBinding());
      });
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
