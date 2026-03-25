import 'dart:io';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/bus/event_class.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/EventBusUtils.dart';
import '../../common/model/model_class.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class MainController extends GetxController {
  final index = 0.obs;
  final marginTop = 120.w;
  final unreadMsgCount = 0.obs;
  final title = "主页".obs;
  final Rx<double?> latitude = CommonData.latitude.obs;
  final Rx<double?> longitude = CommonData.longitude.obs;
  late AMapController gdMapController;
  final RxSet<Marker> aMapMarkers = <Marker>{}.obs;
  StreamSubscription? pushTouchSubscription;
  StreamSubscription? spaceListSubscription;
  StreamSubscription? catchSubscription;
  StreamSubscription? deviceListSubscription;
  StreamSubscription? messageSubscription;
  final Rx<bool> containStatus = true.obs;
  final Rx<bool> searchStatus = false.obs;
  final Rx<bool> videoStatus = false.obs;
  final Rx<bool> pageMapStatus = false.obs;
  final Rx<String> dateStr = ''.obs;
  final Rx<String> cityStr = ''.obs;
  final Rx<String> temp = ''.obs;
  final Rx<String> icon = '305'.obs;
  final Rx<bool> iconStatus = false.obs;
  final Rx<String> locText = '定位中...'.obs;
  final Rx<String> text = '未获取到天气信息，请重试'.obs;
  final Rx<String> count = '0'.obs;
  final Rx<bool> searchDown = true.obs;
  final Rx<bool> spaceListStatus = true.obs;
  late List<dynamic> spaceList = [];
  final Rx<int> spaceListIndex = 0.obs;
  final Rx<int> searchListIndex = 0.obs;
  TextEditingController? searchController = TextEditingController();
  final PagingController<int, dynamic> pagingController =
  PagingController(firstPageKey: 1);
  final PagingController<int, dynamic> deviceController =
  PagingController(firstPageKey: 0);
  late EasyRefreshController easyController = EasyRefreshController();
  late String textId = '';
  late int pageNum = 1;
  late int pageSize = 20;
  late BuildContext context;
  late WebViewController webController = WebViewController()
    ..setBackgroundColor(HhColors.trans)..runJavaScript(
        "document.documentElement.style.overflow = 'hidden';"
            "document.body.style.overflow = 'hidden';");
  late List<dynamic> newItems = [];
  late Rx<bool> secondStatus = true.obs;
  final TooltipController tipController = TooltipController();
  late Directory tempDir;

  @override
  Future<void> onInit() async {
    tempDir = await getApplicationCacheDirectory();
    DateTime dateTime = DateTime.now();
    dateStr.value = CommonUtils().parseLongTimeWithLength("${dateTime.millisecondsSinceEpoch}",16);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    secondStatus.value = prefs.getBool(SPKeys().second) == true;
    pushTouchSubscription =
        EventBusUtil.getInstance().on<Location>().listen((event) {
          if (CommonData.latitude != null && CommonData.latitude! > 0) {
            gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(CommonData.latitude!,CommonData.longitude!), 12));
          }
        });
    spaceListSubscription =
        EventBusUtil.getInstance().on<SpaceList>().listen((event) {
          getSpaceList(1,false);
          spaceListIndex.value = 0;
        });
    catchSubscription =
        EventBusUtil.getInstance().on<CatchRefresh>().listen((event) {
          containStatus.value = false;
          containStatus.value = true;
          getSpaceList(1,false);
        });
    deviceListSubscription =
        EventBusUtil.getInstance().on<DeviceList>().listen((event) {
          pageNum = 1;
          getDeviceList(1,false);
        });
    messageSubscription =
        EventBusUtil.getInstance().on<Message>().listen((event) {
          getUnRead();
        });
    //天气信息
    getWeather();
    //未读消息数量
    getUnRead();
    //获取空间列表
    getSpaceList(1,true);
    Future.delayed(const Duration(milliseconds: 3000),(){
      EventBusUtil.getInstance().fire(Version());
    });
    super.onInit();
  }

  late dynamic model;

  /// 创建完成回调
  void onGDMapCreated(AMapController controller) {
    gdMapController = controller;

    if(CommonData.latitude!=null && CommonData.latitude!=0){
      gdMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(CommonData.latitude!,CommonData.longitude!), 14));
    }
    //获取设备检索列表
    deviceSearch();
  }

  void onSearchClick() {
    searchStatus.value = true;
    videoStatus.value = false;
  }

  void restartSearchClick() {
    searchStatus.value = false;
  }

  void fetchPage(int pageKey) {
    List<dynamic> newItems = [
      MainGridModel(
          "青岛林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          10,
          false),
      MainGridModel(
          "城阳林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          6,
          true),
      MainGridModel(
          "高新林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          8,
          true),
      MainGridModel(
          "崂山林场",
          "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img",
          "",
          2,
          false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> getWeather() async {
    Map<String, dynamic> map = {};
    map["location"] = '${CommonData.longitude},${CommonData.latitude}';
    if (CommonData.latitude != null) {
      var result = await HhHttp().request(
        RequestUtils.weatherLocation,
        method: DioMethod.get,
        params: map,
      );
      HhLog.d("getWeather -- $result");
      if (result["code"] == 0 && result["data"] != null) {
        var now = result["data"]['now'];
        if (now != null) {
          temp.value = '${now['temp']}';
          icon.value = '${now['icon']}';
          text.value = '${now['text']}';
          HhLog.d("weatherUrl now['icon'] = ${now['icon']}");
          String weatherUrl = CommonUtils().getHeFengIcon(
              (now['text'] == "晴" ? "FFF68F" : "F5CD5B"), now['icon'], "80");
          HhLog.d("weatherUrl = $weatherUrl");
          webController.setJavaScriptMode(JavaScriptMode.unrestricted);
          webController.loadRequest(Uri.parse(weatherUrl));
          webController.enableZoom(true);
          webController.runJavaScript(
              "document.documentElement.style.overflow = 'hidden';"
              "document.body.style.overflow = 'hidden';");
          webController.setBackgroundColor(HhColors.trans);
          iconStatus.value = false;
          iconStatus.value = true;
        }
      } else {
        EventBusUtil.getInstance()
            .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        getWeather();
      });
    }
  }

  Future<void> getUnRead() async {
    var result = await HhHttp().request(
      RequestUtils.unReadCount,
      method: DioMethod.get,
    );
    HhLog.d("getUnRead -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      count.value = '${result["data"]}';
    } else {
      // EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getSpaceList(int pageKey,bool loading) async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,
        method: DioMethod.get, params: map);
    HhLog.d("getSpaceList -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      spaceList = result["data"]["list"]??[];
      spaceListStatus.value = false;
      spaceListStatus.value = true;

      getDeviceList(1,loading);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceList(int pageKey,bool loading) async {
    if(loading){
      EventBusUtil.getInstance().fire(HhLoading(show: true));
    }
    Map<String, dynamic> map = {};
    if(spaceList.isNotEmpty){
      map['spaceId'] = spaceList[spaceListIndex.value]['id'];
    }
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    map['appSign'] = 1;
    // map['activeStatus'] = '-1';
    var result = await HhHttp().request(RequestUtils.deviceList,method: DioMethod.get,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deviceList --- $pageKey , $result");
    if(result["code"]==0 && result["data"]!=null){
      List<dynamic> newItems = [];
      try{
        newItems = result["data"]["list"]??[];
      }catch(e){
        HhLog.e(e.toString());
      }

      if (pageKey == 1) {
        pagingController.itemList = [];
      }else{
        if(newItems.isEmpty){
          easyController.finishLoad(IndicatorResult.noMore,true);
        }
      }
      pagingController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }


  void updateMarker({bool location = false}){
    aMapMarkers.clear();
    ///用户位置打点
    if(CommonData.latitude!=null && CommonData.latitude!=0){
      LatLng myLoc = LatLng(CommonData.latitude!,CommonData.longitude!);
      Marker mk = Marker(
          anchor: const Offset(0.5, 1.0),
          infoWindowEnable: false,
          position: myLoc,
          icon: BitmapDescriptor.fromIconPath('assets/images/common/icon_point.png'),
          onTap: (v){
            gdMapController.moveCamera(CameraUpdate.newLatLngZoom(myLoc, 16));
          }
      );
      aMapMarkers.add(mk);
    }
    ///设备打点
    List<dynamic> newItems = deviceController.itemList??[];
    for(int i = 0; i < newItems.length; i++){
      try{
        dynamic models = newItems[i];
        LatLng latLng = LatLng(double.parse("${models["latitude"]}"),double.parse("${models["longitude"]}"));
        Marker mk = Marker(
            anchor: const Offset(0.5, 1.0),
            infoWindowEnable: false,
            position: latLng,
            icon: BitmapDescriptor.fromIconPath("${models["status"]}"=="1"?'assets/images/common/ic_device_online2.png':'assets/images/common/ic_device_offline2.png'),
            onTap: (v){
              gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));

              searchDown.value = false;
              searchListIndex.value = i;
              model = models;
              videoStatus.value = false;
              videoStatus.value = true;
            }
        );
        aMapMarkers.add(mk);
        if(i == 0 && !location){
          gdMapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        }
      }catch(e){
        HhLog.e("$e");
      }
    }

    ///用户位置点击
    if(location){
      if(CommonData.latitude!=null && CommonData.latitude!=0){
        LatLng myLoc = LatLng(CommonData.latitude!,CommonData.longitude!);
        gdMapController.moveCamera(CameraUpdate.newLatLngZoom(myLoc, 16));
      }else{
        EventBusUtil.getInstance().fire(HhToast(title: "定位获取中…",type: 0));
      }
    }

  }

  Future<void> deviceSearch() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true, title: '设备加载中..'));
    Map<String, dynamic> map = {};
    map['name'] = searchController!.text;
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    map['appSign'] = 1;
    // map['activeStatus'] = '-1';
    try{
      int spaceId = spaceList[spaceListIndex.value]['id'];
      map['spaceId'] = spaceId;
    }catch(e){
      //
    }
    var result = await HhHttp()
        .request(RequestUtils.deviceList, method: DioMethod.get, params: map);
    HhLog.d("deviceSearch map -- $spaceList");
    HhLog.d("deviceSearch map -- ${spaceListIndex.value}");
    HhLog.d("deviceSearch map -- ${spaceList[spaceListIndex.value]['id']}");
    HhLog.d("deviceSearch map -- $map");
    HhLog.d("deviceSearch result -- $result");
    Future.delayed(const Duration(seconds: 1), () {
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
    if (result["code"] == 0 && result["data"] != null) {
      newItems = [];
      try {
        newItems = result["data"]["list"];
      } catch (e) {
        HhLog.e(e.toString());
      }

      if (pageNum == 1) {
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
      searchDown.value = true;

      ///地图打点
      updateMarker();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> deleteDevice(item) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['id'] = '${item['id']}';
    map['shareMark'] = '${item['shareMark']}';
    var result = await HhHttp().request(RequestUtils.deviceDelete,method: DioMethod.delete,params: map);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("deleteDevice -- $map");
    HhLog.d("deleteDevice -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: '操作成功',type: 0));
      pageNum = 1;
      getDeviceList(1,false);
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  parseCacheImageView(String deviceNo,dynamic item) {
    try{
      // 将图片保存到缓存目录
      final filePath =
          '${tempDir.path}/catch_$deviceNo.png';
      final file = File(filePath);

      FileImage fileImage = FileImage(file);
      // 同步清除指定文件的缓存
      fileImage.evict();
      if(fileImage.file.lengthSync() < 2600){
        //处理白屏问题
        return Image.asset(
          CommonUtils().parseDeviceBackImage(item),
          // "assets/images/common/test_video.jpg",
          fit: BoxFit.fill,
        );
      }
      return Image(image: fileImage,errorBuilder: (c,d,e){
        HhLog.d("parseCacheImageView error $deviceNo");
        return Image.asset(
          CommonUtils().parseDeviceBackImage(item),
          // "assets/images/common/test_video.jpg",
          fit: BoxFit.fill,
        );
      }, fit: BoxFit.fill,);
    }catch(e){
      //
      return Image.asset(
        CommonUtils().parseDeviceBackImage(item),
        // "assets/images/common/test_video.jpg",
        fit: BoxFit.fill,
      );
    }
  }
}
