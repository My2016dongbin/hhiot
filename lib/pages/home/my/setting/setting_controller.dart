import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<String> ?nickname = ''.obs;
  final Rx<String> ?account = ''.obs;
  final Rx<String> ?mobile = ''.obs;
  final Rx<String> ?email = ''.obs;
  final Rx<String> ?avatar = ''.obs;
  final Rx<bool> picture = false.obs;
  late XFile file;
  late StreamSubscription infoSubscription;

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickname!.value = prefs.getString(SPKeys().nickname)!;
    account!.value = prefs.getString(SPKeys().username)!;
    mobile!.value = prefs.getString(SPKeys().mobile)!;
    email!.value = prefs.getString(SPKeys().email)!;
    avatar!.value = prefs.getString(SPKeys().endpoint)!+prefs.getString(SPKeys().avatar)!;

    infoSubscription =
        EventBusUtil.getInstance().on<UserInfo>().listen((event) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          nickname!.value = prefs.getString(SPKeys().nickname)!;
          account!.value = prefs.getString(SPKeys().account)!;
          mobile!.value = prefs.getString(SPKeys().mobile)!;
          email!.value = prefs.getString(SPKeys().email)!;
          avatar!.value = prefs.getString(SPKeys().endpoint)!+prefs.getString(SPKeys().avatar)!;
        });
    super.onInit();
  }
  // 将文件转换为字节数组
  Future<List<int>> readFileByte(File file) async {
    List<int> bytes = await file.readAsBytes();
    return bytes;
  }
  Future<void> fileUpload() async {
    /*Map<String, dynamic> map = {};
    List<int> byteData = await readFileByte(File(file.path));
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      byteData,
      filename: file.path.split('/').last,
    );
    map['avatarFile'] = multipartFile;
    var result = await HhHttp().request(RequestUtils.headerUpload,method: DioMethod.put,params: map,data: {
      "avatarFile":multipartFile
    });

    HhLog.d("fileUpload -- $result");
    if(result["code"]==0 && result["data"]!=null){

    }else{
      EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }*/

    uploadFile(file.path);
  }
  void uploadFile(String filePath) async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "avatarFile": await MultipartFile.fromFile(filePath,
          filename: "header.jpg"),
    });

    try {
      var response = await dio.put(
        RequestUtils.headerUpload,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${CommonData.token}",
            "Tenant-Id":"${CommonData.tenant}",
          },
        ),
      );
      HhLog.d("上传成功: ${response.data}");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(SPKeys().avatar, response.data["data"]);
      avatar!.value = prefs.getString(SPKeys().endpoint)!+response.data["data"];
      EventBusUtil.getInstance().fire(UserInfo());
    } catch (e) {
      HhLog.d("上传失败: $e");
    }
  }
}
