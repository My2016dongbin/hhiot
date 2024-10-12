import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> name = ''.obs;
  final Rx<bool> recordTag = false.obs;
  late BuildContext context;
  late String deviceNo;
  late String id;
  late int shareMark;
  late String deviceId;
  late String nickname = '';
  late Rx<String> productName = ''.obs;
  FijkPlayer player = FijkPlayer();
  late WebSocketManager manager;
  late String? endpoint;
  late dynamic item = {};

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), () {
      getDeviceInfo();
    });
    super.onInit();
  }


  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['shareMark'] = shareMark;
    var result = await HhHttp().request(
        RequestUtils.deviceInfo, method: DioMethod.get, params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      item = result["data"];
      name.value = CommonUtils().parseNull(result["data"]["name"] ?? '', "");
      productName.value = result["data"]["productName"] ?? '';
    } else {
      EventBusUtil.getInstance().fire(
          HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  String parseDate(date) {
    String s = '$date';
    try {
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
      s = format.format(DateTime.fromMillisecondsSinceEpoch(date));
    } catch (e) {
      HhLog.e(e.toString());
    }
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
      recordTag.value = false;
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
    // WebSocketManager('ws://172.16.50.85:6002/$nickname', '');
    WebSocketManager('ws://117.132.5.139:18030/$nickname', '');
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

  Future<void> initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    endpoint = prefs.getString(SPKeys().endpoint);
  }

}
