import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> name = ''.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<bool> playTag = true.obs;
  final Rx<bool> recordTag = false.obs;
  final Rx<bool> videoTag = false.obs;
  final Rx<bool> voiceTag = true.obs;
  final Rx<int> liveIndex = 0.obs;
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 20;
  late DragController dragController;
  late BuildContext context;
  late String deviceNo;
  late String id;
  late String deviceId;
  late String channelNumber;
  late String commandLast;
  late String command = "";
  late int controlTime = 0;
  late String nickname='';
  late Rx<String> productName = ''.obs;
  FijkPlayer player = FijkPlayer();
  late WebSocketManager manager;

  late List<dynamic> liveList = [];
  late Animation<Alignment> animation;
  late AnimationController animationController;
  late Alignment animateAlign = Alignment.center;
  final Rx<Alignment> dragAlignment = Rx<Alignment>(Alignment.center);
  late String? endpoint;
  late dynamic item = {};

  @override
  void onInit() {
    dragController = DragController();
    Future.delayed(const Duration(seconds: 1),(){
      getDeviceStream();
      getDeviceInfo();
      getDeviceHistory();
    });
    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("人员入侵报警", "08:59:06", "", "",true,true),
      Device("区域入侵", "19:36:06", "", "",false,true),
      Device("人员入侵报警", "10:59:06", "", "",false,false),
      Device("区域入侵", "12:59:06", "", "",false,false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> getDeviceStream() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    var result = await HhHttp().request(RequestUtils.deviceStream,method: DioMethod.get,params: map);
    HhLog.d("getDeviceStream -- $deviceNo");
    HhLog.d("getDeviceStream -- $result");
    if(result["code"]==0 && result["data"]!=null){
      liveList = result["data"];
      try{
        deviceId = result["data"][liveIndex.value]["deviceId"];
        channelNumber = result["data"][liveIndex.value]["number"];
        HhLog.d('$deviceId , $channelNumber');
        getPlayUrl(deviceId,channelNumber);
      }catch(e){
        HhLog.e(e.toString());
      }
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getPlayUrl(String ids,String number) async {
    dynamic data = {
      'deviceId':ids,
      'channelNumber':number,
      // 'deviceId':'2096e4bf4af411efa74f2a37f6c892cc',
      // 'channelNumber':'24070888001320000082',
      'streamProtocol': "RTSP",
      'streamType': 0,
      'transMode': "TCP"
    };
    var result = await HhHttp().request(RequestUtils.devicePlayUrl,method: DioMethod.post,data: data);
    HhLog.d("getPlayUrl data -- $data");
    HhLog.d("getPlayUrl result -- $result");
    if(result["code"]==200 && result["data"]!=null){
      try{
        String url = /*RequestUtils.rtsp + */result["data"][0]['url'];
        playTag.value = false;
        player.release();
        player = FijkPlayer();
        player.setDataSource(
            url,
            autoPlay: true);
        Future.delayed(const Duration(seconds: 1),(){
          playTag.value = true;
        });
      }catch(e){
        HhLog.e(e.toString());
      }
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["message"])));
    }
  }

  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    var result = await HhHttp().request(RequestUtils.deviceInfo,method: DioMethod.get,params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if(result["code"]==0 && result["data"]!=null){
      item = result["data"];
      name.value = CommonUtils().parseNull(result["data"]["name"]??'', "");
      productName.value = result["data"]["productName"]??'';
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceHistory() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: "数据加载中.."));
    Map<String, dynamic> map = {};
    map['deviceId'] = id;
    map['pageNo'] = pageNum;
    map['pageSize'] = pageSize;
    var result = await HhHttp().request(RequestUtils.deviceHistory,method: DioMethod.get,params: map);
    HhLog.d("getDeviceHistory -- $pageNum");
    HhLog.d("getDeviceHistory -- $result");
    Future.delayed(const Duration(seconds: 1),(){
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
    if(result["code"]==0 && result["data"]!=null){
      List<dynamic> newItems = [];
      try{
        newItems = result["data"]["list"];
      }catch(e){
        HhLog.e(e.toString());
      }

      if(pageNum == 1){
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  String parseDate(date) {
    String s = '$date';
    try{
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      s = format.format(DateTime.fromMillisecondsSinceEpoch(date));
    }catch(e){
      HhLog.e(e.toString());
    }
    return s;
  }

  String parseType(type) {
    String s = '人员入侵报警';

    return s;
  }

  Future<void> chatStatus() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatStatus, method: DioMethod.get, params: map);
    HhLog.d("chatStatus socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      nickname = tenantResult["data"];
      connect();
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  Future<void> connect() async {
    HhLog.d("socket nickname $nickname");
    /*final channel =
        IOWebSocketChannel.connect('ws://172.16.50.85:6002/$nickname');

    channel.stream.listen((event) {
      HhLog.e("socket listen $nickname -- ${event.toString()}");
    });
    channel.sink.add({"CallType": "Active", "Dest": "000001"});*/

    manager =
        WebSocketManager('ws://172.16.50.85:6002/$nickname', '');
    manager.sendMessage({"CallType": "Active", "Dest": deviceNo});
    CommonData.deviceNo = deviceNo;
  }

  void chatClose() {
    chatClosePost();
    dynamic o = {"CallType": "Close", "SessionId": CommonData.sessionId};
    // manager.sendMessage(jsonEncode(o));
    manager.sendMessage(o);
    manager.disconnect();
    manager = WebSocketManager('', '');
  }

  Future<void> chatClosePost() async {
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatCreate, method: DioMethod.post, data: {
      "deviceNo": deviceNo,
      "state": '0',
      "sessionId": CommonData.sessionId,
    });
    HhLog.d("chatClose socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(title: '对讲已结束'));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  Future<void> controlPost(int action) async {
    dynamic data = {
      "action": action,//0 开始  1 结束
      "channelNumber": channelNumber,
      "command": command,
      "deviceId": deviceId,
      "speed": 10,
    };
    var tenantResult = await HhHttp()
        .request(RequestUtils.videoControl, method: DioMethod.post, data: data);
    HhLog.d("controlPost data -- $data");
    HhLog.d("controlPost result -- $tenantResult");
    /*if (tenantResult["code"] == 200 && tenantResult["data"] != null) {
      // EventBusUtil.getInstance().fire(HhToast(title: ''));
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["data"][0]["msg"])));
    }*/

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
      Get.back();
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    endpoint = prefs.getString(SPKeys().endpoint);
  }

}
