import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class MessageController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final title = "消息".obs;
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

  @override
  void onInit() {
    fetchPageDevice(pageNumLeft);
    fetchPageWarn(pageNumRight);
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

  Future<void> fetchPageWarn(int pageKey) async {
    Map<String, dynamic> map = {};
    map['messageType'] = '2';
    var result = await HhHttp()
        .request(RequestUtils.message, method: DioMethod.get, params: map);
    HhLog.d("fetchPageWarn -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = result["data"]["list"];

      if (pageNumRight == 1) {
        warnController.itemList = [];
      }
      warnController.appendLastPage(newItems);
      //fetchPageWarnFuck(pageKey);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> fetchPageDevice(int pageKey) async {
    Map<String, dynamic> map = {};
    // map['messageType'] = '1';
    var result = await HhHttp()
        .request(RequestUtils.message, method: DioMethod.get, params: map);
    HhLog.d("fetchPageDevice -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      List<dynamic> newItems = result["data"]["list"];

      if (pageNumLeft == 1) {
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
      //fetchPageDeviceFuck(pageKey);
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }
}
