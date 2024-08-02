import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> ?nickname = ''.obs;
  final Rx<String> ?account = ''.obs;
  final Rx<String> ?mobile = ''.obs;
  final Rx<String> ?email = ''.obs;
  final Rx<String> ?avatar = ''.obs;
  final Rx<bool> picture = false.obs;
  late XFile file;
  late StreamSubscription infoSubscription;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    account!.value = prefs.getString(SPKeys().account)!;
    mobile!.value = prefs.getString(SPKeys().mobile)!;
    email!.value = prefs.getString(SPKeys().email)!;
    avatar!.value = prefs.getString(SPKeys().avatar)!;

    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          nickname!.value = prefs.getString(SPKeys().nickname)!;
          account!.value = prefs.getString(SPKeys().account)!;
          mobile!.value = prefs.getString(SPKeys().mobile)!;
          email!.value = prefs.getString(SPKeys().email)!;
          avatar!.value = prefs.getString(SPKeys().avatar)!;
        });
    super.onInit();
  }

  Future<void> fileUpload() async {
    Map<String, dynamic> map = {};
    map['path'] = File(file.path);
    FormData({
      "path":MultipartFile(file.path,filename: "fireName.png")
    });
    var result = await HhHttp().request(RequestUtils.fileUpload,method: DioMethod.post,params: map,data: {
      "path":MultipartFile(file.path,filename: "fireName.png")
    });
    HhLog.d("fileUpload -- $result");
    if(result["code"]==0 && result["data"]!=null){

    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
