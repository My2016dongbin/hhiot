import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class MessageController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "消息".obs;
  late BuildContext context;
  late DateTime start ;
  late DateTime end ;
  final Rx<bool> pageStatus = true.obs;
  final Rx<bool> tabStatus = false.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<String> dateStr = "日期".obs;
  final Rx<String> warnCount = "99+".obs;
  final Rx<String> noticeCount = "99+".obs;
  final Rx<String> test = 'test'.obs;
  final PagingController<int, dynamic> deviceController =
      PagingController(firstPageKey: 1);
  final PagingController<int, dynamic> warnController =
      PagingController(firstPageKey: 1);
  late int pageNumLeft = 1;
  late int pageNumRight = 1;
  late int pageSize = 20;
  late TextEditingController deviceNameController = TextEditingController();
  List<String> dateListLeft = [];
  List<String> dateListRight = [];
  final Rx<int> chooseListLeftNumber = 0.obs;
  final Rx<int> chooseListRightNumber = 0.obs;
  final RxList<dynamic> spaceList = [].obs;
  List<num> chooseListLeft = [];
  List<num> chooseListRight = [];
  final Rx<bool> editLeft = false.obs;
  final Rx<bool> editRight = false.obs;
  final Rx<bool> isChooseSpace = false.obs;
  final Rx<bool> isChooseType = false.obs;
  final Rx<bool> isChooseDate = false.obs;
  final TooltipController tipController = TooltipController();
  final Rx<int> typeSelectIndex = 0.obs;
  final Rx<int> spaceSelectIndex = 0.obs;
  final List<dynamic> typeList = [
    {
      "name":"全部",
      "type":null,
    },
    {
      "name":"传感器开箱报警",
      "type":"openSensor",
    },
    {
      "name":"箱盖开箱报警",
      "type":"openCap",
    },
    {
      "name":"人员入侵报警",
      "type":"human",
    },
    {
      "name":"设备倾斜报警",
      "type":"tilt",
    },
    {
      "name":"车辆入侵报警",
      "type":"car",
    },
  ];

  @override
  void onInit() {
    fetchPageLeft(1);
    fetchPageRight(1);
    getSpaceList();
    super.onInit();
  }

  Future<void> fetchPageRight(int pageKey) async {
    Map<String, dynamic> map = {};
    map['pageNo'] = pageKey;
    map['pageSize'] = pageSize;
    var result = await HhHttp()
        .request(RequestUtils.message, method: DioMethod.get, params: map);
    // HhLog.d("fetchPageRight --  ${RequestUtils.message}");
    // HhLog.d("fetchPageRight --  $map");
    // HhLog.d("fetchPageRight --  ${CommonData.token}");
    HhLog.d("fetchPageRight --  $pageKey , $result");
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = result["data"]["list"];
      int number = result["data"]["total"];
      noticeCount.value = number>99?"99+":"$number";

      if (pageKey == 1) {
        warnController.itemList = [];
        chooseListRight = [];
        chooseListRightNumber.value = 0;
      }
      warnController.appendLastPage(newItems);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> fetchPageLeft(int pageKey) async {
    Map<String, dynamic> map = {};
    map['pageNo'] = pageKey;
    map['pageSize'] = pageSize;
    map['deviceName'] = deviceNameController.text;
    try{
      map['spaceId'] = spaceList.value[spaceSelectIndex.value]["id"];
    }catch(e){
      HhLog.e("$e");
    }
    map['alarmType'] = typeList[typeSelectIndex.value]["type"];//openSensor 传感器开箱报警；openCap 箱盖开箱报警；human 人员入侵报警；tilt 设备倾斜报警；car 车辆入侵报警
    if(dateStr.value!="日期"){
      map['createTime'] = "${start.toIso8601String().substring(0,10)} 00:00:00,${end.toIso8601String().substring(0,10)} 23:59:59";
    }
    var result = await HhHttp()
        .request(RequestUtils.messageAlarm, method: DioMethod.get, params: map);
    HhLog.d("fetchPageLeft map --  $map");
    HhLog.d("fetchPageLeft --  $pageKey , $result");
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = result["data"]["list"]??[];
      int number = result["data"]["total"]??0;
      warnCount.value = number>99?"99+":"$number";

      if (pageKey == 1) {
        deviceController.itemList = [];
        chooseListLeft = [];
        chooseListLeftNumber.value = 0;
      }
      deviceController.appendLastPage(newItems);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getSpaceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        List<dynamic> listS =  result["data"]["list"];
        spaceList.value.add({
          "name":"全部",
          "id":null,
        });
        spaceList.value.addAll(listS);

      }catch(e){
        HhLog.e(e.toString());
      }
    }
  }

  Future<void> readAll() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> mapR = {};
    mapR['ids'] = null;
    var resultR = await HhHttp()
        .request(RequestUtils.rightRead, method: DioMethod.post, params: mapR);
    HhLog.d("readRight --  ${chooseListRight.toString()} , $resultR");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (resultR["code"] == 0 && resultR["data"] == true) {
      EventBusUtil.getInstance().fire(HhToast(title: "已全部标记为已读",type: 0));
      editRight.value = false;
      pageStatus.value = false;
      pageStatus.value = true;
      pageNumRight = 1;
      fetchPageRight(1);
    } else {
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(resultR["msg"])));
    }


    Map<String, dynamic> map = {};
    map['ids'] = null;
    var result = await HhHttp()
        .request(RequestUtils.leftRead, method: DioMethod.post, params: map);
    HhLog.d("readLeft --  ${chooseListLeft.toString()} , $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] == true) {
      editLeft.value = false;
      pageStatus.value = false;
      pageStatus.value = true;

      dateListLeft = [];
      pageNumLeft = 1;
      fetchPageLeft(1);
    } else {
      // EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> readRight() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['ids'] = chooseListRight;
    var result = await HhHttp()
        .request(RequestUtils.rightRead, method: DioMethod.post, params: map);
    HhLog.d("readRight --  ${chooseListRight.toString()} , $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] == true) {
      EventBusUtil.getInstance().fire(HhToast(title: "操作成功",type: 0));
      editRight.value = false;
      pageStatus.value = false;
      pageStatus.value = true;
      pageNumRight = 1;
      fetchPageRight(1);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> readLeft() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['ids'] = chooseListLeft;
    var result = await HhHttp()
        .request(RequestUtils.leftRead, method: DioMethod.post, params: map);
    HhLog.d("readLeft --  ${chooseListLeft.toString()} , $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] == true) {
      EventBusUtil.getInstance().fire(HhToast(title: "操作成功",type: 0));
      editLeft.value = false;
      pageStatus.value = false;
      pageStatus.value = true;

      dateListLeft = [];
      pageNumLeft = 1;
      fetchPageLeft(1);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> deleteRight() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['ids'] = chooseListRight;
    var result = await HhHttp()
        .request(RequestUtils.rightDelete, method: DioMethod.delete, params: map);
    HhLog.d("deleteRight --  ${chooseListRight.toString()} , $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] == true) {
      EventBusUtil.getInstance().fire(HhToast(title: "操作成功",type: 0));
      editRight.value = false;
      pageStatus.value = false;
      pageStatus.value = true;
      pageNumRight = 1;
      fetchPageRight(1);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
  Future<void> deleteLeft() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    Map<String, dynamic> map = {};
    map['ids'] = chooseListLeft;
    var result = await HhHttp()
        .request(RequestUtils.leftDelete, method: DioMethod.delete, params: map);
    HhLog.d("deleteLeft --  ${chooseListLeft.toString()} , $result");
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    if (result["code"] == 0 && result["data"] == true) {
      EventBusUtil.getInstance().fire(HhToast(title: "操作成功",type: 0));
      editLeft.value = false;
      pageStatus.value = false;
      pageStatus.value = true;

      dateListLeft = [];
      pageNumLeft = 1;
      fetchPageLeft(1);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
