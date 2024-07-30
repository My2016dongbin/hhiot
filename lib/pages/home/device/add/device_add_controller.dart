import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class DeviceAddController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, Device> deviceController = PagingController(firstPageKey: 0);
  static const pageSize = 20;
  TextEditingController ?snController = TextEditingController();
  TextEditingController ?nameController = TextEditingController();

  @override
  void onInit() {

    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("大涧林场", "", "", "",true,true),
      Device("AA林场", "", "", "",false,true),
      Device("MM林场", "", "", "",false,false),
      Device("SS林场", "", "", "",false,false),
      Device("SG林场", "", "", "",false,false),
      Device("SA林场", "", "", "",false,false),
      Device("大涧林场", "", "", "",true,true),
      Device("AA林场", "", "", "",false,true),
      Device("MM林场", "", "", "",false,false),
      Device("SS林场", "", "", "",false,false),
      Device("SG林场", "", "", "",false,false),
      Device("SA林场", "", "", "",false,false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }

    ///var result = await HhHttp().request("",method: DioMethod.get,data: {},);
  }

  Future<void> getSpaceList() async {//TODO
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList -- $result");
    if(result["code"]==0 && result["data"]!=null){
      // spaceList = result["data"]["list"];
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
