import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';

class SpaceController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> picture = false.obs;
  TextEditingController ?nameController = TextEditingController();
  late BuildContext context;
  late XFile file;


  Future<void> createSpace() async {
    EventBusUtil.getInstance().fire(HhLoading(show: true,title: '正在添加..'));
    var result = await HhHttp().request(RequestUtils.spaceCreate,method: DioMethod.post,data: {
      'name':nameController!.text,
    });
    HhLog.d("createSpace -- $result");
    if(result["code"]==0 && result["data"]!=null){
      EventBusUtil.getInstance().fire(HhToast(title: '添加成功'));
      EventBusUtil.getInstance().fire(SpaceList());
      Get.back();
      picture.value = false;
    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
    Future.delayed(const Duration(seconds: 1),(){
      EventBusUtil.getInstance().fire(HhLoading(show: false));
    });
  }
}
