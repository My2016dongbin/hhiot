import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/res/strings.dart';
import 'package:iot/routes/app_pages.dart';
import 'package:iot/utils/CustomNavigatorObserver.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/widgets/app_view.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

void main() {
  //1334*750
  WidgetsFlutterBinding.ensureInitialized();
  //竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FlutterError.onError = (FlutterErrorDetails details) {
    /*"<user:'${CustomerModel.phone}'>\n<token:'${CustomerModel.token}'>\n${details.stack}"*/
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    /*FlutterBugly.uploadException(
        message: "${details.toStringShort()}",
        detail:
        "<user:'${CustomerModel.phone}'>\n<token:'${CustomerModel.token}'>\n${details.stack}");*/
  };

  /*///使用flutter异常上报
  FlutterBugly.postCatchedException(() {
    runApp(MyApp());
  });*/
  runApp(const HhApp());

  if (Platform.isAndroid) {
    // android沉浸式。
    SystemUiOverlayStyle systemUiOverlayStyle =
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  //全局dialog样式配置
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle //dualRing chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..userInteractions = false
    ..lineWidth = 4
    ..indicatorSize = 50.0
    ..radius = 10.0
    ..fontSize = 12.0
    ..contentPadding = const EdgeInsets.fromLTRB(50, 30, 50, 30)
    ..progressColor = HhColors.mainTabTextSe
    ..indicatorColor = HhColors.titleColor_99
    ..textColor = HhColors.titleColor_99
    ..backgroundColor = HhColors.whiteColor
    ..successWidget = const Text("yes")
    ..maskType = EasyLoadingMaskType.black;

}

class HhApp extends StatefulWidget {
  const HhApp({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<HhApp> {

  @override
  void initState() {
    super.initState();
    ///百度地图sdk初始化鉴权
    /// 设置是否隐私政策
    LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();
    myLocPlugin.setAgreePrivacy(true);
    BMFMapSDK.setAgreePrivacy(true);
    if (Platform.isIOS) {
      BMFMapSDK.setApiKeyAndCoordType(
          'wARV9WoE9vC8q8QE7n7oTTC59541zYTy', BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }
    /*///注册bugly
    FlutterBugly.init(
        androidAppId: "91c90c0246",
        iOSAppId: "ed96239f50");*/
    ///推送注册
    if (Platform.isIOS) {
      XgFlutterPlugin().startXg("1600040310", "IRL5SNBR2DSA");
    }else{
      XgFlutterPlugin().startXg("1500040311", "ADC2K1REPJ75");
    }
    //注册回调
    XgFlutterPlugin().addEventHandler(
      onRegisteredDone: (String msg) async {
        HhLog.e("HomePage -> onRegisteredDone -> $msg");

      },
    );
    //通知类 Push
    XgFlutterPlugin().addEventHandler(
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        HhLog.e("HomePage -> onReceiveNotificationResponse -> $msg");
      },
    );
    //通知类消息点击
    XgFlutterPlugin().addEventHandler(
      xgPushClickAction: (Map<String, dynamic> msg) async {
        HhLog.e("HomePage -> xgPushClickAction -> $msg");
        //EventBusUtil.getInstance().fire(PushTouch());
      },
    );
    EasyLoading.init();
    // 全局设置
    EasyRefresh.defaultHeaderBuilder = () => const CupertinoHeader();
    EasyRefresh.defaultFooterBuilder = () => const CupertinoFooter();
  }

  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (单位dp)
    return AppView(
        builder: (locale, builder) => GetMaterialApp(
          navigatorObservers: [CustomNavigatorObserver.getInstance()],
          title: '物联网平台',
          theme: ThemeData(
            fontFamily: '.SF UI Display', // 使用系统默认字体
            // bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: CXColors.WhiteColor),
            primarySwatch: const MaterialColor(
              0xFF293446,
              <int, Color>{
                50: Color(0xFFE3F2FD),
                100: Color(0xFFBBDEFB),
                200: Color(0xFF90CAF9),
                300: Color(0xFF64B5F6),
                400: Color(0xFF42A5F5),
                500: Color(0xFF67A6F2),
                600: Color(0xFF1E88E5),
                700: Color(0xFF1976D2),
                800: Color(0xFF1565C0),
                900: Color(0xFF0D47A1),
              },
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          builder: builder,
          // home: HomePage(),
          //显示debug
          debugShowCheckedModeBanner: true,
          //配置如下两个国际化的参数
          supportedLocales: const [
            Locale('zh', 'CH'),
            Locale('en', 'US'),
          ],

          enableLog: true,
          //logWriterCallback: Logger.print,
          translations: TranslationService(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // DefaultCupertinoLocalizations.delegate,
          ],
          fallbackLocale: TranslationService.fallbackLocale,
          locale: locale,
          localeResolutionCallback: (locale, list) {
            Get.locale ??= locale;
            return locale;
          },
          getPages: AppPages.routes,
          initialBinding: InitBinding(),
          initialRoute: AppRoutes.launch,
        ));
  }
}


class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}