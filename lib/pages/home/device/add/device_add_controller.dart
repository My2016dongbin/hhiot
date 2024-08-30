import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/home/device/status/device_status_binding.dart';
import 'package:iot/pages/home/device/status/device_status_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class DeviceAddController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<int> addingStatus = 0.obs;//0添加中 1添加成功 2添加失败
  final Rx<int> addingStep = 0.obs;//0初始 1连接设备成功 2标准认证成功 3设备绑定账号成功
  final PagingController<int, dynamic> deviceController = PagingController(firstPageKey: 0);
  late int pageNum = 1;
  late int pageSize = 100;
  late String snCode = '';
  late String spaceId = '';
  TextEditingController ?snController = TextEditingController();
  TextEditingController ?nameController = TextEditingController();
  List<dynamic> newItems = [];
  StreamSubscription ?spaceListSubscription;
  StreamSubscription ?toastSubscription;

  @override
  void onInit() {
    getSpaceList();
    spaceListSubscription = EventBusUtil.getInstance()
        .on<SpaceList>()
        .listen((event) {
      getSpaceList();
    });
    toastSubscription = EventBusUtil.getInstance()
        .on<HhToast>()
        .listen((event) {
          if(event.title.contains('服务器')){
            addingStatus.value = 2;
          }
    });
    Future.delayed(const Duration(seconds: 1),(){
      if(snCode!=''){
        snController!.text = snCode;
      }
    });
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

  Future<void> getSpaceList() async {
    Map<String, dynamic> map = {};
    map['pageNo'] = '1';
    map['pageSize'] = '100';
    var result = await HhHttp().request(RequestUtils.mainSpaceList,method: DioMethod.get,params: map);
    HhLog.d("getSpaceList -- $result");
    if(result["code"]==0 && result["data"]!=null){
      try{
        newItems = result["data"]["list"];
      }catch(e){
        HhLog.e(e.toString());
      }

      if(pageNum == 1){
        deviceController.itemList = [];
      }
      deviceController.appendLastPage(newItems);
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> createDevice() async {
    Get.to(()=>DeviceStatusPage(),binding: DeviceStatusBinding());
    addingStatus.value = 0;
    addingStep.value = 0;
    futureStep();
    var result = await HhHttp().request(RequestUtils.deviceCreate,method: DioMethod.post,data: {
      "deviceNo":snController!.text,
      "name":nameController!.text==''?null:nameController!.text,
      "spaceId":spaceId,
    });
    HhLog.d("createDevice -- $result");
    if(result["code"]==0 && result["data"]!=null){
      addingStatus.value = 1;
      addingStep.value = 3;
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(HhToast(title: '添加成功',type: 1));
      // Get.back();
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      addingStatus.value = 2;
    }
  }

  void futureStep() {
    if(addingStep.value > 1){
      return;
    }
    Future.delayed(const Duration(seconds: 2),(){
      addingStep.value++;
      futureStep();
    });
  }
}
