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

class DeviceDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> name = ''.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<bool> playTag = true.obs;
  final Rx<bool> recordTag = false.obs;
  final Rx<int> liveIndex = 0.obs;
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 20;
  late DragController dragController;
  late BuildContext context;
  late String deviceNo;
  late String id;
  late String nickname='';
  late Rx<String> productName = ''.obs;
  FijkPlayer player = FijkPlayer();
  late WebSocketManager manager;

  late List<dynamic> liveList = [];
  late Animation<Alignment> animation;
  late AnimationController animationController;
  late Alignment animateAlign = Alignment.center;
  final Rx<Alignment> dragAlignment = Rx<Alignment>(Alignment.center);

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
      Device("检测到画面变化", "08:59:06", "", "",true,true),
      Device("区域入侵", "19:36:06", "", "",false,true),
      Device("检测到画面变化", "10:59:06", "", "",false,false),
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
        HhLog.d('${result["data"][liveIndex.value]["deviceId"]} , ${result["data"][liveIndex.value]["number"]}');
        getPlayUrl('${result["data"][liveIndex.value]["deviceId"]}','${result["data"][liveIndex.value]["number"]}');
      }catch(e){
        HhLog.e(e.toString());
      }
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getPlayUrl(String ids,String number) async {
    var result = await HhHttp().request(RequestUtils.devicePlayUrl,method: DioMethod.post,data: {
      'deviceId':ids,
      'channelNumber':number,
      // 'deviceId':'2096e4bf4af411efa74f2a37f6c892cc',
      // 'channelNumber':'24070888001320000082',
      'streamProtocol': "RTSP",
      'streamType': 0,
      'transMode': "TCP"
    });
    HhLog.d("getPlayUrl -- $result");
    if(result["code"]==200 && result["data"]!=null){
      try{
        String url = result["data"][0]['url'];
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
      name.value = "${result["data"]["spaceName"]}-${result["data"]["name"]}";
      productName.value = result["data"]["productName"];
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
    String s = '检测到画面变化';

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

}
