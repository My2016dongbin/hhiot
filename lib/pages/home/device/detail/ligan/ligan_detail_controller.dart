import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/socket/WebSocketManager.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class LiGanDetailController extends GetxController {
  late BuildContext context;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> warnGANG1 = false.obs;
  final Rx<bool> warnGANG2 = false.obs;
  final Rx<bool> warnGANG3 = false.obs;
  final Rx<bool> warnBALL = false.obs;
  final Rx<bool> warnSENSOR = false.obs;
  final Rx<bool> warnOPEN = false.obs;
  final Rx<bool> energyAction = false.obs;
  final Rx<bool> weatherAction = false.obs;
  final Rx<bool> soilAction = false.obs;
  final Rx<String> energyDelay = ''.obs;
  final Rx<String> weatherDelay = ''.obs;
  final Rx<String> soilDelay = ''.obs;
  final Rx<String> deviceVer = ''.obs;
  final Rx<int> deviceFireLevel = 999.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<int> fireLevel = 0.obs;//防火等级
  final Rx<int> circle = 0.obs;//枪球联动 0关 1开
  final Rx<int> version = 0.obs;//固件版本号
  final Rx<int> playing = 0.obs;//播放1 停止0
  final Rx<int> voiceHuman = 3.obs;//音量
  final Rx<int> voiceCar = 3.obs;//音量
  final Rx<int> voiceCap = 3.obs;//音量
  final Rx<int> speed = 6.obs;//滑动速度
  final Rx<bool> close = false.obs;//息屏开关
  final Rx<int> direction = 0.obs;//滑动方向 0向上  1向下
  final Rx<String> name = ''.obs;
  final Rx<String> ledContent = ''.obs;
  final Rx<String> ledTime = ''.obs;
  late List<dynamic> voiceTopList = [];
  final Rx<bool> voiceTopStatus = true.obs;
  late List<dynamic> versionList = [];
  final Rx<bool> versionStatus = true.obs;
  late List<dynamic> voiceBottomList = [];
  final Rx<bool> voiceBottomStatus = true.obs;
  late dynamic config = {};
  late String deviceNo = '24070888';
  late WebSocketManager manager;
  late TextEditingController showContentController = TextEditingController();
  late List<dynamic> warnSettingList = [];
  late String id;
  TextEditingController? time1Controller = TextEditingController();
  TextEditingController? time2Controller = TextEditingController();
  TextEditingController? time3Controller = TextEditingController();

  final Rx<bool> personStatus = false.obs;
  final Rx<String> personStart = ''.obs;
  final Rx<String> personEnd = ''.obs;
  final Rx<bool> carStatus = false.obs;
  final Rx<String> carStart = ''.obs;
  final Rx<String> carEnd = ''.obs;
  final Rx<bool> openStatus = false.obs;
  final Rx<String> openStart = ''.obs;
  final Rx<String> openEnd = ''.obs;
  final Rx<bool> closeStatus = false.obs;
  final Rx<String> closeStart = ''.obs;
  final Rx<String> closeEnd = ''.obs;

  @override
  Future<void> onInit() async {
    Future.delayed(const Duration(seconds: 1),(){
      getDeviceInfo();
      getDeviceConfig();
      getVoiceUse();
      getVersion();
    });
    super.onInit();
  }

  Future<void> getDeviceInfo() async {
    Map<String, dynamic> map = {};
    map['id'] = id;
    var result = await HhHttp().request(RequestUtils.deviceInfo,method: DioMethod.get,params: map);
    HhLog.d("getDeviceInfo -- $id");
    HhLog.d("getDeviceInfo -- $result");
    if(result["code"]==0 && result["data"]!=null){
      name.value = "${result["data"]["spaceName"]}-${result["data"]["name"]}";
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getVoiceUse() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    var result = await HhHttp().request(RequestUtils.deviceVoiceTop,method: DioMethod.get);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("getVoiceUse -- $result");
    if(result["code"]==0 && result["data"]!=null){
      voiceTopList = result["data"]["list"];
      voiceTopStatus.value = false;
      voiceTopStatus.value = true;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> getVersion() async {
    var result = await HhHttp().request(RequestUtils.deviceVersion,method: DioMethod.get);
    HhLog.d("getVersion -- $result");
    if(result["code"]==0 && result["data"]!=null){
      versionList = result["data"]["list"];
      versionStatus.value = false;
      versionStatus.value = true;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> postScreenTop() async {
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "ledSetParam",
      "speed": speed.value,
      "direction": direction.value==1?"down":"up",
      "content": showContentController.text
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("postScreenTop -- $data");
    HhLog.d("postScreenTop -- $result");
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> postScreenBottom() async {
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "ledSetSwitch",
      "switchType": close.value?1:0,
      "time": ledTime.value,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("postScreenBottom -- $data");
    HhLog.d("postScreenBottom -- $result");
    /*if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/
  }

  Future<void> getDeviceConfig() async {
    Map<String, dynamic> map = {};
    map['deviceNo'] = deviceNo;
    var result = await HhHttp().request(RequestUtils.deviceConfig,method: DioMethod.get,params: map);
    HhLog.d("getDeviceConfig -- $deviceNo");
    HhLog.d("getDeviceConfig -- $result");
    if(result["code"]==0 && result["data"]!=null){
      config = result["data"];
      try{
        personStart.value = "${config["audioHumanTime"]}".substring(0,8);
        personEnd.value = "${config["audioHumanTime"]}".substring(9,17);
      }catch(e){
        //
      }
      try{
        carStart.value = "${config["audioCarTime"]}".substring(0,8);
        carEnd.value = "${config["audioCarTime"]}".substring(9,17);
      }catch(e){
        //
      }
      try{
        openStart.value = "${config["audioOpenTime"]}".substring(0,8);
        openEnd.value = "${config["audioOpenTime"]}".substring(9,17);
      }catch(e){
        //
      }
      try{
        closeStart.value = "${config["ledTime"]}".substring(0,8);
        closeEnd.value = "${config["ledTime"]}".substring(9,17);
      }catch(e){
        //
      }
      voiceBottomList = result["data"]["audioArray"];
      voiceBottomStatus.value = false;
      voiceBottomStatus.value = true;
      warnGANG1.value = config["gcam1Enable"] == "ON";
      warnGANG2.value = config["gcam2Enable"] == "ON";
      warnGANG3.value = config["gcam3Enable"] == "ON";
      warnBALL.value = config["scam1Enable"] == "ON";
      warnSENSOR.value = config["sensorEnable"] == "ON";
      warnOPEN.value = config["capEnable"] == "ON";
      energyAction.value = config["energyAction"] == "ON";
      weatherAction.value = config["weatherAction"] == "ON";
      soilAction.value = config["soilAction"] == "ON";
      energyDelay.value = '${config["energyDelay"]}';
      weatherDelay.value = '${config["weatherDelay"]}';
      soilDelay.value = '${config["soilDelay"]}';
      time1Controller!.text = energyDelay.value;
      time2Controller!.text = weatherDelay.value;
      time3Controller!.text = soilDelay.value;
      deviceVer.value = '${config["deviceVer"]}';
      deviceFireLevel.value = config["deviceFireLevel"];
      fireLevel.value = deviceFireLevel.value;
      direction.value = config["ledDirection"]=="down"?1:0;
      speed.value = config["ledSpeed"];
      ledContent.value = config["ledContent"];
      showContentController.text = ledContent.value;
      close.value = config["ledEnable"]==1;
      ledTime.value = config["ledTime"];
      voiceHuman.value = config["audioHumanVolume"];
      voiceCar.value = config["audioCarVolume"];
      voiceCap.value = config["audioOpenVolume"];
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> uploadVoice(String name,String url) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "start",
      "cmdType": "audioSetData",
      "url": url,
      "name": name,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("uploadVoice -- $data");
    HhLog.d("uploadVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "上传成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> playVoice(String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "play",
      "cmdType": "audioSetData",
      "name": name
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("playVoice -- $data");
    HhLog.d("playVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "播放成功",type: 1));
      playing.value = 1;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> stopVoice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "stop",
      "cmdType": "audioSetData"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("stopVoice -- $data");
    HhLog.d("stopVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "已停止播放",type: 1));
      playing.value = 0;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> deleteVoice(String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "switchType": "delet",
      "cmdType": "audioSetData",
      "name": name
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("deleteVoice -- $data");
    HhLog.d("deleteVoice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> voiceSubmitHuman() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioHumanEnable"],
      "alarmType": "human",
      "name": config["audioHumanName"],
      "volume": voiceHuman.value,
      "time": config["audioHumanTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("voiceSubmitHuman -- $data");
    HhLog.d("voiceSubmitHuman -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> voiceSubmitCar() async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioCarEnable"],
      "alarmType": "car",
      "name": config["audioCarName"],
      "volume": voiceCar.value,
      "time": config["audioCarTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("voiceSubmitCar -- $data");
    HhLog.d("voiceSubmitCar -- $result");
    // EventBusUtil.getInstance().fire(HhLoading(show: false));
    /*if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/
  }
  Future<void> voiceSubmitCap() async {
    // EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "audioSetParam",
      "switchType": config["audioOpenEnable"],
      "alarmType": "open",
      "name": config["audioOpenName"],
      "volume": voiceCap.value,
      "time": config["audioOpenTime"]
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("voiceSubmitCap -- $data");
    HhLog.d("voiceSubmitCap -- $result");
    // EventBusUtil.getInstance().fire(HhLoading(show: false));
    /*if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "删除成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/
  }
  Future<void> settingLevel() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetLevel",
      "value": fireLevel.value
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("settingLevel -- $data");
    HhLog.d("settingLevel -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> resetDevice() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetReboot"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("resetDevice -- $data");
    HhLog.d("resetDevice -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "重启下发成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> versionUpdate() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "deviceSetOTA",
      "url": "${versionList[version.value]["url"]}",
      "version": "${versionList[version.value]["version"]}"
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "下发成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> warnSet(String value,String type) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "alarmSetSwitch",
      "value": value,
      "switchType": type
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> warnUploadSet(String value,String type,int delay,String time) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "deviceNo": deviceNo,
      "cmdType": "dataSetSwitch",
      "value": value,
      "switchType": type,
      "delay": delay,
      "time": time,
    };
    var result = await HhHttp().request(RequestUtils.deviceConfigScreenTop,method: DioMethod.post,data: data);
    HhLog.d("versionUpdate -- $data");
    HhLog.d("versionUpdate -- $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if(result["code"]==0){
      EventBusUtil.getInstance().fire(HhToast(title: "设置成功",type: 1));
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
