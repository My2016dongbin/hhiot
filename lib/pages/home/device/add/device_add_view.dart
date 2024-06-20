import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/home/device/add/device_add_controller.dart';
import 'package:iot/pages/home/device/status/device_status_binding.dart';
import 'package:iot/pages/home/device/status/device_status_view.dart';
import 'package:iot/pages/home/space/space_binding.dart';
import 'package:iot/pages/home/space/space_view.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceAddPage extends StatelessWidget {
  final logic = Get.find<DeviceAddController>();

  DeviceAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => Container(
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
                    "添加设备",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () async {
                    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                        "#6666ff",
                        "取消",
                        true,
                        ScanMode.DEFAULT);
                    if(barcodeScanRes.isNotEmpty){
                      logic.testStatus.value = false;
                      logic.testStatus.value = true;
                      logic.snController!.text = barcodeScanRes;
                    }
                    /*FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)
                        ?.listen((barcode) {
                      /// barcode to be used
                      if(barcode.isNotEmpty){
                        logic.testStatus.value = false;
                        logic.testStatus.value = true;
                        logic.snController!.text = barcode;
                      }
                    });*/
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 95.w, 36.w, 0),
                    color: HhColors.trans,
                    child: Image.asset(
                      "assets/images/common/icon_search.png",
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
                    Text(
                      "*",
                      style: TextStyle(
                        color: HhColors.titleColorRed,
                        fontSize: 36.sp,),
                    ),
                    Text(
                      "输入SN码",
                      style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 36.sp,),
                    ),
                  ],
                ),
              ),
              Container(
                height: 90.w,
                margin: EdgeInsets.fromLTRB(20.w, 280.w, 20.w, 0),
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
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.snController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20.w),
                          border: InputBorder.none,
                          hintText: '请输入SN码',
                          hintStyle: TextStyle(
                              color: HhColors.gray9TextColor, fontSize: 26.sp),
                        ),
                        style:
                        TextStyle(color: HhColors.blackTextColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: (){
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
                margin: EdgeInsets.fromLTRB(30.w, 400.w, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "*",
                      style: TextStyle(
                        color: HhColors.titleColorRed,
                        fontSize: 36.sp,),
                    ),
                    Text(
                      "输入设备名称",
                      style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 36.sp,),
                    ),
                  ],
                ),
              ),
              Container(
                height: 90.w,
                margin: EdgeInsets.fromLTRB(20.w, 480.w, 20.w, 0),
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
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20.w),
                          border: InputBorder.none,
                          hintText: '请输入设备名称',
                          hintStyle: TextStyle(
                              color: HhColors.gray9TextColor, fontSize: 26.sp),
                        ),
                        style:
                        TextStyle(color: HhColors.blackTextColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: (){
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
                margin: EdgeInsets.fromLTRB(30.w, 600.w, 0, 0),
                child: Text(
                  "请选择设备空间",
                  style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 36.sp,),
                ),
              ),
              logic.testStatus.value ? deviceList() : const SizedBox(),
              ///新增空间
              InkWell(
                onTap: (){
                  Get.to(()=>SpacePage(),binding: SpaceBinding());
                },
                child: Container(
                  height: 90.w,
                  width: 220.w,
                  margin: EdgeInsets.fromLTRB(20.w, 940.w, 0, 0),
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
                        width: 35.w,
                        height: 35.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "新增空间",
                        style: TextStyle(
                            color: HhColors.gray6TextColor,
                            fontSize: 24.sp,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
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
                child: InkWell(
                  onTap: (){
                    Get.to(()=>DeviceStatusPage(),binding: DeviceStatusBinding());
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
                        "添加设备",
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
    );
  }

  deviceList() {
    return logic.index.value == -1?const SizedBox():Container(
      margin: EdgeInsets.only(top: 610.w),
      child: PagedGridView<int, Device>(
        pagingController: logic.deviceController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //横轴三个子widget
            childAspectRatio: 2 //宽高比为1时，子widget
            ),
        builderDelegate: PagedChildBuilderDelegate<Device>(
          itemBuilder: (context, item, index) => InkWell(
            onTap: (){
              logic.index.value = -1;
              logic.index.value = index;
            },
            child: Container(
              height: 90.w,
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: logic.index.value==index?HhColors.backBlueInColor:HhColors.whiteColor,
                  border:logic.index.value==index?Border.all(color: HhColors.backBlueOutColor):null,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
              child: Center(
                child: Text(
                  "${item.name}",
                  style: TextStyle(
                      color: logic.index.value==index?HhColors.mainBlueColor:HhColors.gray9TextColor,
                      fontSize: 24.sp),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
