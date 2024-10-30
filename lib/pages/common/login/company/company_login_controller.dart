import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/code/code_binding.dart';
import 'package:iot/pages/common/login/code/code_view.dart';
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
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

class CompanyLoginController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> pageStatus = false.obs;
  final Rx<bool> tenantStatus = false.obs;
  final Rx<bool> accountStatus = false.obs;
  final Rx<bool> passwordStatus = false.obs;
  final Rx<bool> passwordShowStatus = false.obs;
  final Rx<bool> confirmStatus = false.obs;
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

    showToastSubscription =
        EventBusUtil.getInstance().on<HhToast>().listen((event) {
          if(event.title.isEmpty || event.title == "null"){
            return;
          }
          showToastWidget(
            Container(
              margin: EdgeInsets.fromLTRB(20.w*3, 15.w*3, 20.w*3, 25.w*3),
              padding: EdgeInsets.fromLTRB(30.w*3, event.type==0?18.h*3:25.h*3, 30.w*3, 18.h*3),
              decoration: BoxDecoration(
                  color: HhColors.blackColor.withAlpha(200),
                  borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
              constraints: BoxConstraints(
                  minWidth: 117.w*3
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // event.type==0?const SizedBox():SizedBox(height: 16.w*3,),
                  event.type==0?const SizedBox():Image.asset(
                    event.type==1?'assets/images/common/icon_success.png':event.type==2?'assets/images/common/icon_error.png':event.type==3?'assets/images/common/icon_lock.png':'assets/images/common/icon_warn.png',
                    height: 20.w*3,
                    width: 20.w*3,
                    fit: BoxFit.fill,
                  ),
                  event.type==0?const SizedBox():SizedBox(height: 16.h*3,),
                  // SizedBox(height: 16.h*3,),
                  Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 16.sp*3),
                  ),
                  // SizedBox(height: 10.h*3,)
                  // event.type==0?SizedBox(height: 10.h*3,):SizedBox(height: 10.h*3,),
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
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['name'] = tenantController!.text;
    var tenantResult = await HhHttp().request(
      RequestUtils.tenantId,
      method: DioMethod.get,
      params: map,
    );
    HhLog.d("tenant map -- $map");
    HhLog.d("tenant CommonData.tenant -- ${CommonData.tenant}");
    HhLog.d("tenant CommonData.tenantName -- ${CommonData.tenantName}");
    HhLog.d("tenant -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]['id']}');
      await prefs.setString(SPKeys().tenantName, tenantController!.text);
      CommonData.tenant = '${tenantResult["data"]["id"]}';
      CommonData.tenantUserType = '${tenantResult["data"]["userType"]}';
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
      CommonData.tenantName = tenantController!.text;
      login();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(/*"租户信息不存在"*/tenantResult["msg"]),type: 2));
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    }
  }

  Future<void> searchTenant() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['username'] = accountController!.text;
    var result = await HhHttp().request(
        RequestUtils.tenantSearch,
        method: DioMethod.get,
        params: map
    );
    HhLog.d("searchTenant -- ${RequestUtils.tenantSearch}");
    HhLog.d("searchTenant -- $map");
    HhLog.d("searchTenant -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${result["data"]['id']}');
      await prefs.setString(SPKeys().tenantName, tenantController!.text);
      CommonData.tenant = '${result["data"]['id']}';
      CommonData.tenantUserType = '${result["data"]['userType']}';
      CommonData.tenantTitle = '${result["data"]['name']}';//暂用租户名称
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
      await prefs.setString(SPKeys().tenantTitle, CommonData.tenantTitle!);
      login();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
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
    HhLog.d("tenant id -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SPKeys().tenant, '${tenantResult["data"]['id']}');
      await prefs.setString(SPKeys().tenantName, tenantController!.text);
      CommonData.tenant = '${tenantResult["data"]["id"]}';
      CommonData.tenantUserType = '${tenantResult["data"]["userType"]}';
      await prefs.setString(SPKeys().tenantUserType, CommonData.tenantUserType!);
      CommonData.tenantName = tenantController!.text;
      sendCode();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString("租户信息不存在"/*tenantResult["msg"]*/),type: 2));
    }
  }

  Future<void> sendCode() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在发送短信..'));
    var result = await HhHttp().request(
      RequestUtils.codeSend,
      method: DioMethod.post,
      data: {'mobile':accountController!.text,'scene':21},
    );
    HhLog.d("sendCode -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] != null) {
      Get.to(()=>CodePage(accountController!.text),binding: CodeBinding());
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }

  Future<void> login() async {
    dynamic data = {
      "username": accountController?.text,
      "password": passwordController?.text
    };
    HhLog.d("logins data -- $data");
    HhLog.d("logins tenant -- ${CommonData.tenant}");
    HhLog.d("logins tenantUserType -- ${CommonData.tenantUserType}");
    var result = await HhHttp().request(
      RequestUtils.login,
      method: DioMethod.post,
      data: data,
    );
    HhLog.d("logins RequestUtils -- ${RequestUtils.login}");
    HhLog.d("logins tenant -- ${CommonData.tenant}");
    HhLog.d("logins data -- $data");
    HhLog.d("logins result -- $result");
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


      XgFlutterPlugin().setTags(["${result["data"]["id"]}"]);
      XgFlutterPlugin().setAccount("${result["data"]["id"]}",AccountType.UNKNOWN);
      XgFlutterPlugin().setAccount("${CommonData.token}",AccountType.UNKNOWN);
      EventBusUtil.getInstance().fire(HhToast(title: '登录成功',type: 1));

      Future.delayed(const Duration(seconds: 1), () {
        Get.offAll(() => HomePage(), binding: HomeBinding(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000));
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"]),type: 2));
    }
  }
}
