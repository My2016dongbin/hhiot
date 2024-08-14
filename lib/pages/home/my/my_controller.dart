import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late BuildContext context;
  final Rx<String> ?nickname = ''.obs;
  final Rx<String> ?mobile = ''.obs;
  final Rx<String> ?avatar = ''.obs;
  final Rx<int> ?deviceNum = 0.obs;
  final Rx<int> ?spaceNum = 0.obs;
  late StreamSubscription infoSubscription;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    mobile!.value = prefs.getString(SPKeys().mobile)!;
    avatar!.value = prefs.getString(SPKeys().avatar)!;

    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          nickname!.value = prefs.getString(SPKeys().nickname)!;
          mobile!.value = prefs.getString(SPKeys().mobile)!;
          avatar!.value = prefs.getString(SPKeys().avatar)!;
        });
    getSpaceList();
    deviceList();
    super.onInit();
  }


  Future<void> getSpaceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        List<dynamic> spaceList = result["data"]["list"];
        spaceNum!.value = spaceList.length;
      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }

  Future<void> deviceList() async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true,title: '数据加载中..'));
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.deviceList,method: DioMethod.get,params: map);
    HhLog.d("deviceList $result");
    // Future.delayed(const Duration(seconds: 1),(){
    //   EventBusUtil.getInstance().fire(HhLoading(show: false));
    // });
    if(result["code"]==0 && result["data"]!=null){
      try{
        List<dynamic> deviceList = result["data"]["list"];
        deviceNum!.value = deviceList.length;
      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }
}
