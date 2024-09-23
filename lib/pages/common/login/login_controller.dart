import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> tenantStatus = false.obs;
  final Rx<bool> accountStatus = false.obs;
  final Rx<bool> passwordStatus = false.obs;
  final Rx<bool> passwordShowStatus = false.obs;
  final Rx<bool> confirmStatus = false.obs;
  final Rx<bool> userType = true.obs;///true企业  false个人用户
  TextEditingController? tenantController = TextEditingController();
  TextEditingController? accountController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  late StreamSubscription showToastSubscription;
  late StreamSubscription showLoadingSubscription;
  late String? account;
  late String? password;
  late String? tenantName;

  @override
  Future<void> onInit() async {
    /*Future.delayed(const Duration(seconds: 2),(){
      Get.off(HomePage(),binding: HomeBinding());
    });*/

    showToastSubscription =
        EventBusUtil.getInstance().on<HhToast>().listen((event) {

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
                  event.type==0?const SizedBox():SizedBox(height: 40.w,),
                  event.type==0?const SizedBox():Image.asset(
                    event.type==1?'assets/images/common/icon_success.png':event.type==2?'assets/images/common/icon_error.png':'assets/images/common/icon_warn.png',
                    height: 40.w,
                    width: 40.w,
                    fit: BoxFit.fill,
                  ),
                  event.type==0?const SizedBox():SizedBox(height: 40.w,),
                  event.type==0?SizedBox(height: 15.w,):const SizedBox(),
                  Text(
                    event.title,
                    style: TextStyle(
                        color: HhColors.textColor,
                        fontSize: 26.sp),
                  ),
                  event.type==0?SizedBox(height: 10.w,):const SizedBox(),
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
    });
    showLoadingSubscription =
        EventBusUtil.getInstance().on<HhLoading>().listen((event) {
          if (event.show) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(SPKeys().token);
    account = prefs.getString(SPKeys().account);
    password = prefs.getString(SPKeys().password);
    tenantName = prefs.getString(SPKeys().tenantName);
    if (account != null && password != null) {
      accountController?.text = account!;
      passwordController?.text = password!;
    }
    tenantController?.text = tenantName!;

    super.onInit();
  }

  Future<void> getTenant() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '正在登录..'));
    Map<String, dynamic> map = {};
    map['name'] = tenantController!.text;
    var tenantResult = await HhHttp().request(
      RequestUtils.tenantId,
      method: DioMethod.get,
      params: map,
    );
    HhLog.d("tenant -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]}');
      await prefs.setString(SPKeys().tenantName, tenantController!.text);
      CommonData.tenant = '${tenantResult["data"]}';
      CommonData.tenantName = tenantController!.text;
      login();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString("租户信息不存在"/*tenantResult["msg"]*/),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }
  Future<void> getTenantId() async {
    Map<String, dynamic> map = {};
    map['name'] = tenantController!.text;
    var tenantResult = await HhHttp().request(
      RequestUtils.tenantId,
      method: DioMethod.get,
      params: map,
    );
    HhLog.d("tenant -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]}');
      await prefs.setString(SPKeys().tenantName, tenantController!.text);
      CommonData.tenant = '${tenantResult["data"]}';
      CommonData.tenantName = tenantController!.text;
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString("租户信息不存在"/*tenantResult["msg"]*/),type: 2));
    }
  }

  Future<void> login() async {
    var result = await HhHttp().request(
      RequestUtils.login,
      method: DioMethod.post,
      data: {
        "username": accountController?.text,
        "password": passwordController?.text,
        "tenantName": "${CommonData.tenantName}"
      },
    );
    HhLog.d("login -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().token, result["data"]["accessToken"]);
      await prefs.setString(SPKeys().account, accountController!.text);
      await prefs.setString(SPKeys().password, passwordController!.text);
      CommonData.token = result["data"]["accessToken"];

      info();

    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> info() async {
    var result = await HhHttp().request(
      RequestUtils.userInfo,
      method: DioMethod.get,
      data: {},
    );
    HhLog.d("info -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().endpoint, '${result["data"]["endpoint"]}');
      CommonData.endpoint = '${result["data"]["endpoint"]}';
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

      EventBusUtil.getInstance().fire(HhToast(title: '登录成功',type: 1));

      Future.delayed(const Duration(seconds: 1), () {
        Get.offAll(() => HomePage(), binding: HomeBinding());
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }
}
