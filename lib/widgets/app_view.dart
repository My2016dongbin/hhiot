import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class AppView extends StatelessWidget {
  const AppView({Key? key, required this.builder}) : super(key: key);
  final Widget Function(Locale? locale, TransitionBuilder builder) builder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (ctrl) => ScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => builder(ctrl.getLocale(), _builder()),
      ),
    );
  }

  static TransitionBuilder _builder() => EasyLoading.init(
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              //textScaleFactor: Config.textScaleFactor,
            ),
            child: FlutterEasyLoading(
              child: GestureDetector(
                onTap: () {
                  //全局空白焦点
                  FocusScopeNode focusScopeNode = FocusScope.of(context);
                  if (!focusScopeNode.hasPrimaryFocus &&
                      focusScopeNode.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                  //easyLoading
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: widget!,
              ),
            ),
          );
        },
      );
}

class AppController extends GetxController {

  Locale? getLocale() {
    var local = Get.locale;
    var index = 1;//DataSp.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = const Locale('zh', 'CN');
        break;
      case 2:
        local = const Locale('en', 'US');
        break;
    }
    return local;
  }
}
