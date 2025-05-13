import 'package:easy_refresh/easy_refresh.dart';
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

class WarnSettingController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, dynamic> pagingController = PagingController(firstPageKey: 0);
  late BuildContext context;
  late List<dynamic> spaceList = [];
  late EasyRefreshController easyController = EasyRefreshController();
  final Rx<int> chooseListLeftNumber = 0.obs;

  @override
  void onInit() {
    //获取类型列表
    getWarnType();

    super.onInit();
  }

  Future<void> getWarnType() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = 1;
    map['pageSize'] = -1;
    map['label'] = "";
    map['dictType'] = "alarm_type";
    var result = await HhHttp()
        .request(RequestUtils.alarmType, method: DioMethod.get,params: map);
    HhLog.d("getWarnType --  $result");
    if (result["code"] == 0) {
      dynamic data = result["data"];
      if(data!=null){
        spaceList = data["list"];
        pagingController.itemList = [];
        pagingController.appendLastPage(spaceList);
      }
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void commitSetting() {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: "正在保存.."));
    Future.delayed(const Duration(milliseconds: 2000),(){
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
  }

}
