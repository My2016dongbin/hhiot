import 'package:flutter/cupertino.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class CommonData{
  static int time = 0;
  static double ?latitude;
  static double ?longitude;
  static String ?token;
  ///false企业 true个人
  static bool personal = false;
  ///false正式版 true测试版
  static bool test = false;
  static String ?tenantName = personal?'haohai':null;
  static String ?tenant = personal?'1':null;
  static String ?tenantTitle = '';
  static String ?tenantUserType;
  static String ?tenantNameDef = personal?'haohai':null;
  static String ?tenantDef = personal?'1':null;
  static String ?deviceNo;
  static String ?sessionId;
  static String ?endpoint = "http://36.110.47.66:18034/admin-file";
  static String info = "";
  static String loadingInfo = "正在加载，请稍后…";
  static const String loadingInfoFinal = "正在加载，请稍后…";
  static int versionTime = 0;
  static BuildContext? context;

  static String html = "assets/file/privacy.html";
  static String webSocketUrl = "ws://117.132.5.139:18034/websocket/";//"ws://192.168.1.2:18034/websocket/";
  static const String mqttIP = 'ws://117.132.5.139:18034/wsUrl/mqtt';//192.168.1.66
  static const int mqttPORT = 18034;//11889
  static String mqttAccount = "admin";
  static String mqttPassword = "QIyG0!bhfS";
  static String chatTopic = "/device/pole/chat/";//$id
  static String alarmTopic = "/deviceAlarm/";//$id


  ///高德地图key
  static AMapApiKey aMapApiKey = const AMapApiKey(iosKey: "92cac573ce3997ea190f80b335ad8c95",androidKey: "16e6b6954bbc4b78f2a9384f79ee03f1");


}