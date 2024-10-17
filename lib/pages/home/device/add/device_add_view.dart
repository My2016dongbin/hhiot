import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/location/search/saerch_controller.dart';
import 'package:iot/pages/common/location/search/search_binding.dart';
import 'package:iot/pages/common/location/search/search_view.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class DeviceAddPage extends StatelessWidget {
  final logic = Get.find<DeviceAddController>();
  final logicLocation = Get.find<SearchLocationController>();

  DeviceAddPage({super.key,required String snCode}){
    logic.snCode = snCode;
  }

  @override
  Widget build(BuildContext context) {
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 1.sh,
            width: 1.sw,
            color: HhColors.backColorF5,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                ///title
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
                    padding: EdgeInsets.all(10.w),
                    color: HhColors.trans,
                    child: Image.asset(
                      "assets/images/common/back.png",
                      width: 18.w,
                      height: 30.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 90.w),
                    color: HhColors.trans,
                    child: Text(
                      logic.isEdit.value?"修改设备":"添加设备",
                      style: TextStyle(
                          color: HhColors.blackTextColor,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                logic.isEdit.value?const SizedBox():Align(
                  alignment: Alignment.topRight,
                  child:
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: () async {
                      String? barcodeScanRes = await scanner.scan();
                      if(barcodeScanRes!.isNotEmpty){
                        logic.testStatus.value = false;
                        logic.testStatus.value = true;
                        logic.snController!.text = barcodeScanRes;
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                      color: HhColors.trans,
                      child: Image.asset(
                        "assets/images/common/icon_scanner.png",
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                ///SN码
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 200.w, 0, 0),
                  child: Row(
                    children: [
                      /*Container(
                        margin: EdgeInsets.only(top: 4.w),
                        child: Text(
                          "*",
                          style: TextStyle(
                            color: HhColors.titleColorRed,
                            fontSize: 28.sp,),
                        ),
                      ),*/
                      Text(
                        "设备SN码",
                        style: TextStyle(
                          color: HhColors.blackTextColor,
                          fontSize: 28.sp,),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 90.w,
                  margin: EdgeInsets.fromLTRB(20.w, 270.w, 20.w, 0),
                  padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                  decoration: BoxDecoration(
                      color: HhColors.grayEEBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.snController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:20.w),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            hintText: '请输入SN码',
                            hintStyle: TextStyle(
                                color: HhColors.gray9TextColor, fontSize: 26.sp,fontWeight: FontWeight.w200),
                          ),
                          enabled: !logic.isEdit.value,
                          style:
                          TextStyle(color: logic.isEdit.value?HhColors.gray9TextColor:HhColors.blackTextColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                      logic.isEdit.value?const SizedBox():BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.snController!.text = '';
                        },
                        child: Image.asset(
                          "assets/images/common/ic_close.png",
                          width: 35.w,
                          height: 35.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                ),
                ///名称
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 390.w, 0, 0),
                  child: Row(
                    children: [
                      Text(
                        "",
                        style: TextStyle(
                          color: HhColors.titleColorRed,
                          fontSize: 28.sp,),
                      ),
                      Text(
                        "输入设备名称",
                        style: TextStyle(
                          color: HhColors.blackTextColor,
                          fontSize: 28.sp,),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 90.w,
                  margin: EdgeInsets.fromLTRB(20.w, 460.w, 20.w, 0),
                  padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                  decoration: BoxDecoration(
                      color: HhColors.grayEEBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 10,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.w),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请输入设备名称',
                            hintStyle: TextStyle(
                                color: HhColors.gray9TextColor, fontSize: 26.sp,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.blackTextColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                        ),
                      ),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.nameController!.text = '';
                        },
                        child: Image.asset(
                          "assets/images/common/ic_close.png",
                          width: 35.w,
                          height: 35.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                ),

                ///列表
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 580.w, 0, 0),
                  child: Text(
                    "请选择设备空间",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 28.sp,),
                  ),
                ),
                logic.testStatus.value ? deviceList() : const SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 1.sw,
                    height: 1.w,
                    margin: EdgeInsets.only(bottom: 160.w),
                    color: HhColors.grayDDTextColor,
                  ),
                ),
                ///确定添加按钮
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      // Get.to(()=>DeviceStatusPage(),binding: DeviceStatusBinding());
                      if(logic.snController!.text == ''){
                        EventBusUtil.getInstance().fire(HhToast(title: '请输入设备SN码'));
                        return;
                      }
                      if(logic.nameController!.text == ''){
                        EventBusUtil.getInstance().fire(HhToast(title: '请输入设备名称'));
                        return;
                      }
                      if(!CommonUtils().validateSpaceName(logic.nameController!.text)){
                        EventBusUtil.getInstance().fire(HhToast(title: '设备名称不能包含特殊字符'));
                        return;
                      }
                      if(logic.spaceId == '' || logic.spaceId == 'null'){
                        EventBusUtil.getInstance().fire(HhToast(title: '请选择设备空间'));
                        return;
                      }

                      if(logic.isEdit.value){
                        logic.model["name"] = logic.nameController!.text;
                        logic.model["spaceId"] = logic.spaceId;
                        logic.latitude.value = logicLocation.choose?logicLocation.latitude.value:logic.model["latitude"];
                        logic.longitude.value = logicLocation.choose?logicLocation.longitude.value:logic.model["longitude"];
                        logic.locText.value = logicLocation.choose?logicLocation.locText.value:logic.model["location"];
                        logic.updateDevice();
                      }else{
                        if(logicLocation.locText.value == '' || logicLocation.locText.value == '已搜索'){
                          EventBusUtil.getInstance().fire(HhToast(title: '请选择设备定位'));
                          return;
                        }
                        logic.latitude.value = logicLocation.latitude.value;
                        logic.longitude.value = logicLocation.longitude.value;
                        logic.locText.value = logicLocation.locText.value;
                        logic.createDevice();
                      }
                    },
                    child: Container(
                      height: 80.w,
                      width: 1.sw,
                      margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 50.w),
                      decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.w))),
                      child: Center(
                        child: Text(
                          logic.isEdit.value?"保存":"确定添加",
                          style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 30.sp,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deviceList() {
    return logic.index.value == -1?const SizedBox():Container(
      margin: EdgeInsets.only(top: 625.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 110.w),
            child: Column(
              children: [
                Expanded(
                  child: PagedGridView<int, dynamic>(
                    padding: const EdgeInsets.all(0),
                    pagingController: logic.deviceController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //横轴三个子widget
                        childAspectRatio: 2.5 //宽高比为1时，子widget
                        ),
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) =>
                          InkWell(
                            onTap: (){
                              logic.index.value = -1;
                              logic.index.value = index;
                              logic.spaceId = '${item['id']}';
                            },
                            child: Container(
                              height: 90.w,
                              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                              // padding: EdgeInsets.all(20.w),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: logic.index.value==index?HhColors.backBlueInColor:HhColors.whiteColor,
                                  border:logic.index.value==index?Border.all(color: HhColors.backBlueOutColor):null,
                                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
                              child: Center(
                                child: Text(
                                  "${item['name']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: logic.index.value==index?HhColors.mainBlueColor:HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///新增空间
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    Get.to(()=>SpacePage(),binding: SpaceBinding());
                  },
                  child: Container(
                    height: 80.w,
                    width: 210.w,
                    margin: EdgeInsets.fromLTRB(20.w, 20.w, 0, 0),
                    padding: EdgeInsets.all(20.w),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.w))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/ic_add.png",
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          "新增空间",
                          style: TextStyle(
                              color: HhColors.gray4TextColor,
                              fontSize: 25.sp,fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                ),

                ///选择设备定位
                Container(
                  margin: EdgeInsets.fromLTRB(30.w, 30.w, 0, 0),
                  child: Text(
                    "选择设备定位",
                    style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 28.sp,),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(logic.isEdit.value && logic.model['shareMark']==2){
                      EventBusUtil.getInstance().fire(HhToast(title: '无法修改设备定位',type: 0));
                      return;
                    }

                    Get.to(()=>SearchLocationPage(),binding: SearchLocationBinding());
                  },
                  child: Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(30.w, 30.w, 30.w, 0),
                    padding: EdgeInsets.fromLTRB(20.w, 26.w, 20.w, 26.w),
                    decoration: BoxDecoration(
                      color: HhColors.grayEDBackColor,
                      borderRadius: BorderRadius.circular(12.w)
                    ),
                    child: Row(
                      children: [
                        Text(
                          logic.isEdit.value?(logic.locText.value):((logicLocation.locText.value!=""&&logicLocation.locText.value!='已搜索')?logicLocation.locText.value:logic.location.value),
                          style: TextStyle(
                            color: logic.isEdit.value?HhColors.gray9TextColor:HhColors.blackTextColor,
                            fontSize: 26.sp,fontWeight: FontWeight.bold),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Image.asset(
                          "assets/images/common/icon_blue_loc.png",
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.fill,
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
