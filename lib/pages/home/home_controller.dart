import 'dart:io';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rxdart/rxdart.dart';

import '../../bus/event_class.dart';
import '../../utils/EventBusUtils.dart';

class HomeController extends GetxController {
  final index = 0.obs;
  late BuildContext context;
  final unreadMsgCount = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledCount = 0.obs;
  final _errorController = PublishSubject<String>();
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();

  Function()? onScrollToUnreadMessage;
  late StreamSubscription showToastSubscription;
  late StreamSubscription showLoadingSubscription;
  late StreamSubscription showShareReceiveSubscription;

  switchTab(index) {
    this.index.value = index;
    // IMViews.showToast(index.toString());
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.dark;
    // switch(index){
    //   case 0:
    //   // 状态栏透明（Android）
    //     brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    //     break;
    //   case 1:
    //     break;
    //   case 2:
    //     break;
    //   case 3:
    //     break;
    //     default:
    //       break;
    //
    // }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
  }

  scrollToUnreadMessage(index) {
    onScrollToUnreadMessage?.call();
  }

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1),(){
      showToastSubscription = EventBusUtil.getInstance()
          .on<HhToast>()
          .listen((event) {

        showToastWidget(
          Container(
            margin: EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 25.w),
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
                  event.type==1?'assets/images/common/icon_success.png':event.type==2?'assets/images/common/icon_error.png':event.type==3?'assets/images/common/icon_lock.png':'assets/images/common/icon_warn.png',
                  height: 40.w,
                  width: 40.w,
                  fit: BoxFit.fill,
                ),
                event.type==0?const SizedBox():SizedBox(height: 40.w,),
                event.type==0?SizedBox(height: 15.w,):const SizedBox(),
                Text(
                  event.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: event.color==0?HhColors.whiteColor:HhColors.textColor,
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
    });
    showLoadingSubscription = EventBusUtil.getInstance()
        .on<HhLoading>()
        .listen((event) {
      if (event.show) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
    showShareReceiveSubscription = EventBusUtil.getInstance()
        .on<Share>()
        .listen((event) {
          dynamic model = event.model;

      showCupertinoDialog(context: context, builder: (context) => Center(
        child: Container(
          width: 1.sw,
          height: 640.w,
          margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
          padding: EdgeInsets.fromLTRB(45.w, 35.w, 45.w, 15.w),
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20.w))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    Get.back();
                  },
                  child: Image.asset(
                    "assets/images/common/ic_x.png",
                    width: 35.w,
                    height: 35.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 25.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        CommonUtils().parseNull("${model['shareUrerName']??''}", ""),
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 32.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.w,),
                      Text(
                        "共享给您",
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 32.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w200),
                      ),
                      SizedBox(height: 20.w,),
                      Image.asset(
                        "assets/images/common/icon_camera_space.png",
                        width: 240.w,
                        height: 240.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20.w,),
                      Text(
                        CommonUtils().parseNull("${model['deviceName']??''}", ""),
                        style: TextStyle(
                            color: HhColors.gray6TextColor,
                            fontSize: 30.sp,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w200),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: (){
                                handleShare("${model['id']??''}", 2,"${model['deviceName']??''}");
                              },
                              child: Container(
                                height: 90.w,
                                margin: EdgeInsets.fromLTRB(0, 30.w, 20.w, 0),
                                decoration: BoxDecoration(
                                    color: HhColors.whiteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                  border: Border.all(color: HhColors.grayEEBackColor,width: 1.w)
                                ),
                                child: Center(
                                  child: Text(
                                    "拒绝",
                                    style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 30.sp,),
                                  ),
                                ),
                              ),
                            ),
                          ),Expanded(
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: (){
                                handleShare("${model['id']??''}", 1,"${model['deviceName']??''}");
                              },
                              child: Container(
                                height: 90.w,
                                margin: EdgeInsets.fromLTRB(20.w, 30.w, 0, 0),
                                decoration: BoxDecoration(
                                    color: HhColors.mainBlueColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20.w))),
                                child: Center(
                                  child: Text(
                                    "同意共享",
                                    style: TextStyle(
                                      color: HhColors.whiteColor,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 30.sp,),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    });
    getLocation();
    super.onInit();
  }

  Future<void> handleShare(String id,int status,String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "id":id,
      "status":status,
    };
    var result = await HhHttp().request(RequestUtils.shareHandle,method: DioMethod.post,data: data);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("handleShare -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: status==2?'操作成功':'“$name”\n已共享至“默认空间”',type: 0,color: 0));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  @override
  void onClose() {
    _errorController.close();
    super.onClose();
  }

  Future<void> getLocation() async {
    if (Platform.isIOS) {
      //接受定位回调
      _myLocPlugin.singleLocationCallback(callback: (BaiduLocation result) {
        //result为定位结果
        HhLog.e("location isIOS ${result.latitude},${result.longitude}");
        CommonData.latitude = result.latitude;
        CommonData.longitude = result.longitude;
      });
    } else if (Platform.isAndroid) {
      //接受定位回调
      _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
        //result为定位结果
        HhLog.e("location isAndroid ${result.latitude},${result.longitude}");
        CommonData.latitude = result.latitude;
        CommonData.longitude = result.longitude;
        EventBusUtil.getInstance().fire(Location());
      });
    }
    //设置定位参数
    Map iosMap = initIOSOptions().getMap();
    Map androidMap = initAndroidOptions().getMap();
    _myLocPlugin.prepareLoc(androidMap, iosMap);
    //开启定位
    if (Platform.isIOS) {
      _myLocPlugin.singleLocation({'isReGeocode': true, 'isNetworkState': true});
    } else if (Platform.isAndroid) {
      _myLocPlugin.startLocation();
    }

    Future.delayed(const Duration(milliseconds: 10000)).then((value) {
      getLocation();
    });
  }

  BaiduLocationAndroidOption initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
// 定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        locationMode: BMFLocationMode.hightAccuracy,
// 是否需要返回地址信息
        isNeedAddress: true,
// 是否需要返回海拔高度信息
        isNeedAltitude: true,
// 是否需要返回周边poi信息
        isNeedLocationPoiList: true,
// 是否需要返回新版本rgc信息
        isNeedNewVersionRgc: true,
// 是否需要返回位置描述信息
        isNeedLocationDescribe: true,
// 是否使用gps
        openGps: true,
// 可选，设置场景定位参数，包括签到场景、运动场景、出行场景
        locationPurpose: BMFLocationPurpose.sport,
// 坐标系
        coordType: BMFLocationCoordType.bd09ll,
// 设置发起定位请求的间隔，int类型，单位ms
// 如果设置为0，则代表单次定位，即仅定位一次，默认为0
        scanspan: 0);
    return options;
  }

  BaiduLocationIOSOption initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
      // 坐标系
      coordType: BMFLocationCoordType.bd09ll,
      // 位置获取超时时间
      locationTimeout: 10,
      // 获取地址信息超时时间
      reGeocodeTimeout: 10,
      // 应用位置类型 默认为automotiveNavigation
      activityType: BMFActivityType.automotiveNavigation,
      // 设置预期精度参数 默认为best
      desiredAccuracy: BMFDesiredAccuracy.best,
      // 是否需要最新版本rgc数据
      isNeedNewVersionRgc: true,
      // 指定定位是否会被系统自动暂停
      pausesLocationUpdatesAutomatically: false,
      // 指定是否允许后台定位,
      // 允许的话是可以进行后台定位的，但需要项目配置允许后台定位，否则会报错，具体参考开发文档
      allowsBackgroundLocationUpdates: true,
      // 设定定位的最小更新距离
      distanceFilter: 10,
    );
    return options;
  }
}
