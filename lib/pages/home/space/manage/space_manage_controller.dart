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
import 'package:pinput/pinput.dart';

class SpaceManageController extends GetxController {
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, dynamic> pagingController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 20;
  StreamSubscription ?spaceListSubscription;

  @override
  void onInit() {
    //获取空间列表
    getSpaceList(1);

    spaceListSubscription = EventBusUtil.getInstance()
        .on<SpaceList>()
        .listen((event) {
      getSpaceList(1);
    });
    super.onInit();
  }

  void fetchPage(int pageKey) {
    List<MainGridModel> newItems = [
      MainGridModel("青岛林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 10, false),
      MainGridModel("城阳林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 6, true),
      MainGridModel("高新林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 8, true),
      MainGridModel("崂山林场", "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAOEhRG.img", "", 2, false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextPageKey);
    }
  }

  Future<void> getSpaceList(int pageKey) async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '$pageKey';
    map['pageSize'] = '$pageSize';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList -- $result");
    if(result["code"]==0 && result["data"]!=null){
      List<dynamic> newItems = result["data"]["list"];

      if(pageNum == 1){
        pagingController.itemList = [];
      }
      pagingController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
