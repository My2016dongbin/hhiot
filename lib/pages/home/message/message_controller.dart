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

class MessageController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "消息".obs;
  final Rx<bool> pageStatus = true.obs;
  final Rx<bool> tabStatus = false.obs;
  final Rx<int> tabIndex = 0.obs;
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
  List<String> chooseListLeft = [];
  List<String> chooseListRight = [];
  final Rx<bool> editLeft = false.obs;
  final Rx<bool> editRight = false.obs;

  @override
  void onInit() {
    fetchPageLeft(1);
    fetchPageRight(1);
    super.onInit();
  }

  void fetchPageDeviceFuck(int pageKey) {
    List<dynamic> newItems = [
      {
        'name': "边缘盒子网络异常",
        'content': "边缘盒子网络异常",
        'time': "15:00",
        'read': false
      },
      {
        'name': "边缘盒子网络异常",
        'content': "边缘盒子网络异常",
        'time': "昨天 15:00",
        'read': true
      },
      {
        'name': "边缘盒子网络异常",
        'content': "边缘盒子网络异常",
        'time': "2024-06-02 15:00",
        'read': true
      },
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }

  void fetchPageWarnFuck(int pageKey) {
    List<dynamic> newItems = [
      {
        'name': "青岛市城阳区发现火警",
        'content': "青岛市城阳区发现火警",
        'time': "15:00",
        'read': false
      },
      {
        'name': "青岛市高新区发现火警",
        'content': "青岛市高新区发现火警",
        'time': "昨天 15:00",
        'read': true
      },
      {
        'name': "青岛市崂山区发现火警",
        'content': "青岛市崂山区发现火警",
        'time': "2024-06-02 15:00",
        'read': true
      }
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      warnController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      warnController.appendPage(newItems, nextPageKey);
    }
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
    var result = await HhHttp()
        .request(RequestUtils.message, method: DioMethod.get, params: map);
    HhLog.d("fetchPageLeft --  $pageKey , $result");
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = result["data"]["list"];

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
}
