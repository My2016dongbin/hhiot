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
  final Rx<int> tabIndex = 0.obs;
  final Rx<int> fireLevel = 0.obs;//防火等级
  final Rx<int> circle = 0.obs;//枪球联动 0关 1开
  final Rx<int> version = 0.obs;//固件版本号
  final Rx<int> playing = 0.obs;//播放1 停止0
  final Rx<int> voice = 85.obs;//音量
  final Rx<int> speed = 60.obs;//滑动速度
  final Rx<bool> close = false.obs;//息屏开关
  final Rx<int> direction = 0.obs;//滑动方向 0向上  1向下
  final Rx<String> name = ''.obs;
  late String deviceNo = '24070888';
  late WebSocketManager manager;
  late TextEditingController showContentController = TextEditingController();
  late List<dynamic> warnSettingList = [];
  late String id;
  TextEditingController? time1Controller = TextEditingController();
  TextEditingController? time2Controller = TextEditingController();
  TextEditingController? time3Controller = TextEditingController();

  @override
  Future<void> onInit() async {
    Future.delayed(const Duration(seconds: 1),(){
      getDeviceInfo();
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
}
