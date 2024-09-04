import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/company_login_binding.dart';
import 'package:iot/pages/common/login/company/company_login_view.dart';
import 'package:iot/pages/common/login/login_binding.dart';
import 'package:iot/pages/common/login/login_view.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  late BuildContext? context;

  @override
  Future<void> onInit() async {
    permission();
    super.onInit();
  }

  Future<void> info() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '自动登录中..'));
    var result = await HhHttp().request(
      RequestUtils.userInfo,
      method: DioMethod.get,
      data: {},
    );
    HhLog.d("info -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().id, '${result["data"]["id"]}');
      await prefs.setString(SPKeys().username, '${result["data"]["username"]}');
      await prefs.setString(SPKeys().nickname, '${result["data"]["nickname"]}');
      await prefs.setString(SPKeys().email, '${result["data"]["email"]}');
      await prefs.setString(SPKeys().mobile, '${result["data"]["mobile"]}');
      await prefs.setString(SPKeys().sex, '${result["data"]["sex"]}');
      await prefs.setString(SPKeys().avatar, '${result["data"]["avatar"]}');
      await prefs.setString(SPKeys().roles, '${result["data"]["roles"]}');
      await prefs.setString(
          SPKeys().socialUsers, '${result["data"]["socialUsers"]}');
      await prefs.setString(SPKeys().posts, '${result["data"]["posts"]}');

      Future.delayed(const Duration(seconds: 2), () {
        Get.off(() => HomePage(), binding: HomeBinding());
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      // Future.delayed(const Duration(seconds: 2), () {
      //   Get.offAll(() => LoginPage(), binding: LoginBinding());
      // });
      CommonUtils().tokenDown();
    }
  }

  Future<void> next() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SPKeys().token);
    String? tenant = prefs.getString(SPKeys().tenant);
    String? tenantName = prefs.getString(SPKeys().tenantName);
    if (token != null) {
      //获取个人信息
      CommonData.token = token;
      CommonData.tenant = tenant;
      CommonData.tenantName = tenantName;
      info();
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        // Get.off(HomePage(),binding: HomeBinding());
        CommonUtils().toLogin();
      });
    }
  }

  Future<void> permission() async {
    /*if (await Permission.contacts.request().isGranted) {

    }*/
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.microphone,
    ].request();
    if(statuses[Permission.location] != PermissionStatus.denied && statuses[Permission.storage] != PermissionStatus.denied && statuses[Permission.camera] != PermissionStatus.denied&& statuses[Permission.microphone] != PermissionStatus.denied){
      next();
    }else{

      showToastWidget(
        Container(
          padding: EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 25.w),
          decoration: BoxDecoration(
              color: HhColors.blackColor,
              borderRadius: BorderRadius.all(Radius.circular(16.w))),
          constraints: BoxConstraints(
              minWidth: 0.36.sw
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40.w,),
              Image.asset(
                'assets/images/common/icon_warn.png',
                height: 40.w,
                width: 40.w,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 40.w,),
              Text(
                '请授权',
                style: TextStyle(
                    color: HhColors.textColor,
                    fontSize: 26.sp),
              ),
            ],
          ),
        ),
        context: context,
        animation: StyledToastAnimation.slideFromBottomFade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      Future.delayed(const Duration(seconds: 1),(){
        SystemNavigator.pop();
      });
    }
  }
}
