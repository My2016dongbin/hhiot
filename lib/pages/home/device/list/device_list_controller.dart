import 'dart:io';

import 'package:flutter/material.dart';
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

class DeviceListController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final Rx<String> name = ''.obs;
  final Rx<String> temp = ''.obs;
  final Rx<String> icon = ''.obs;
  final Rx<String> text = ''.obs;
  final Rx<String> dew = ''.obs;
  final Rx<String> feelsLike = ''.obs;
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 20;
  late String id = '';
  StreamSubscription ?deviceListSubscription;

  @override
  void onInit() {
    deviceListSubscription = EventBusUtil.getInstance()
        .on<SpaceList>()
        .listen((event) {
      //获取设备列表
      deviceList(1);
    });
    Future.delayed(const Duration(seconds: 1),(){
      //获取空间信息
      spaceInfo();
      //获取设备列表
      deviceList(1);
    });
    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("F1-HH160双枪机", "红外报警-光感报警", "", "",true,true),
      Device("F1-HH160双枪机", "红外报警-光感报警", "", "",false,true),
      Device("智能语音卡口", "", "", "",false,false),
      Device("智能语音卡口", "", "", "",false,false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> deviceList(int pageKey) async {
    Map<String, dynamic> map = {};
    map['spaceId'] = id;
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    map['activeStatus'] = '-1';
    var result = await HhHttp().request(RequestUtils.deviceList,method: DioMethod.get,params: map);
    HhLog.d("deviceList -- $result");
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

  Future<void> spaceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    var result = await HhHttp().request(RequestUtils.spaceInfo,method: DioMethod.get,params: map);
    HhLog.d("spaceInfo -- $result");
    HhLog.d("spaceInfo -- $id");
    if(result["code"]==0 && result["data"]!=null){
      name.value = '${result["data"]['name']}';
      getWeather('${result["data"]["latitude"]}','${result["data"]["latitude"]}');
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getWeather(String longitude,String latitude) async {
    Map<String, dynamic> map = {};
    map["location"] = '$longitude,$latitude';
    if(longitude != "null"){
      var result = await HhHttp().request(RequestUtils.weatherLocation,method: DioMethod.get,params:map,);
      HhLog.d("getWeather -- $result");
      if(result["code"]==0 && result["data"]!=null){
        var now = result["data"]['now'];
        if(now != null){
          temp.value = '${now['temp']}';
          icon.value = '${now['icon']}';
          text.value = '${now['text']}';
          dew.value = '${now['dew']}';
          feelsLike.value = '${now['feelsLike']}';
        }
      }else{
        EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      }
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString('该空间未配置位置信息')));
      temp.value = '无数据';
      icon.value = '无数据';
      text.value = '无数据';
      dew.value = '无数据';
      feelsLike.value = '无数据';
    }
  }
}
