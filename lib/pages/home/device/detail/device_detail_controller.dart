import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class DeviceDetailController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> tabIndex = 0.obs;
  final PagingController<int, Device> deviceController = PagingController(firstPageKey: 0);
  static const pageSize = 20;
  late DragController dragController;
  late BuildContext context;
  late String deviceNo;
  late String id;
  final FijkPlayer player = FijkPlayer();

  late Animation<Alignment> animation;
  late AnimationController animationController;
  late Alignment animateAlign = Alignment.center;
  final Rx<Alignment> dragAlignment = Rx<Alignment>(Alignment.center);

  @override
  void onInit() {
    deviceController.addPageRequestListener((pageKey) {
      fetchPageDevice(pageKey);
    });

    player.setDataSource(
        "rtmp://111.17.222.72:11935/live/efb70bbd-4fc9-44a3-9546-715aa079ec82?streamType=2&deviceType=132",
        autoPlay: true);

    dragController = DragController();

    Future.delayed(const Duration(seconds: 1),(){
      getDeviceStream();
      getDeviceInfo();
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
      try{
        HhLog.d('${result["data"][0]["id"]} , ${result["data"][0]["number"]}');
        getPlayUrl('${result["data"][0]["id"]}','${result["data"][0]["number"]}');
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
      'streamProtocol': "WS-FLV",
      'streamType': 0,
      'transMode': "TCP"
    });
    HhLog.d("getPlayUrl -- $result");
    if(result["code"]==0 && result["data"]!=null){
      HhLog.e("url = ${result["data"]["url"]}");
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    var result = await HhHttp().request(RequestUtils.deviceInfo,method: DioMethod.get,params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if(result["code"]==0 && result["data"]!=null){

    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

}
