import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/location/location_controller.dart';
import 'package:iot/pages/common/socket/socket_page/socket_controller.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:web_socket_channel/io.dart';

class LiGanDetailPage extends StatelessWidget {
  final logic = Get.find<LiGanDetailController>();

  LiGanDetailPage(String deviceNo,String id, {super.key}){
  logic.deviceNo = deviceNo;
  logic.id = id;
  }

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? loginView() : const SizedBox(),
        ),
      ),
    );
  }

  loginView() {
    return Stack(
      children: [
        // Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
        Container(color: HhColors.backColor,width: 1.sw,height: 1.sh,),
        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              logic.name.value,
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
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
        Container(
          margin: EdgeInsets.fromLTRB(30.w, 160.w, 30.w, 30.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ///图片
                Center(child: Container(
                  margin: EdgeInsets.only(top: 20.w),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.w))
                  ),
                    child: Image.asset('assets/images/common/ic_ligan.jpg',height: 0.55.sw,width: 0.55.sw,fit: BoxFit.fill,))
                ),
                ///Tab页
                Container(
                  margin: EdgeInsets.only(top: 20.w),
                  height: 100.w,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.w))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            logic.tabIndex.value = 0;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.w,),
                              Text('呼叫音',style: TextStyle(
                                  color: logic.tabIndex.value == 0?HhColors.mainBlueColor:HhColors.gray9TextColor,
                                  fontSize: 28.sp,
                              ),),
                              SizedBox(height: 20.w,),
                              logic.tabIndex.value == 0?Container(height: 6.w,width: 100.w,decoration: BoxDecoration(color: HhColors.mainBlueColor,borderRadius: BorderRadius.all(Radius.circular(3.w))),):SizedBox(height: 6.w,),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            logic.tabIndex.value = 1;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.w,),
                              Text('走字屏',style: TextStyle(
                                  color: logic.tabIndex.value == 1?HhColors.mainBlueColor:HhColors.gray9TextColor,
                                  fontSize: 28.sp,
                              ),),
                              SizedBox(height: 20.w,),
                              logic.tabIndex.value == 1?Container(height: 6.w,width: 100.w,decoration: BoxDecoration(color: HhColors.mainBlueColor,borderRadius: BorderRadius.all(Radius.circular(3.w))),):SizedBox(height: 6.w,),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            logic.tabIndex.value = 2;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.w,),
                              Text('编辑',style: TextStyle(
                                  color: logic.tabIndex.value == 2?HhColors.mainBlueColor:HhColors.gray9TextColor,
                                  fontSize: 28.sp,
                              ),),
                              SizedBox(height: 20.w,),
                              logic.tabIndex.value == 2?Container(height: 6.w,width: 100.w,decoration: BoxDecoration(color: HhColors.mainBlueColor,borderRadius: BorderRadius.all(Radius.circular(3.w))),):SizedBox(height: 6.w,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ///设置项
                Container(
                  margin: EdgeInsets.only(top: 30.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 30.w,width: 5.w,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(3.w))
                      ),),
                      Text('报警设置',style: TextStyle(
                        color: HhColors.blackColor,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.w),
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('枪机1',style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(value: logic.warnGANG1.value, onChanged: (s){
                                      logic.warnGANG1.value = s;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),height: 1.w,color: HhColors.backColor,),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('枪机2',style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(value: logic.warnGANG2.value, onChanged: (s){
                                      logic.warnGANG2.value = s;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),height: 1.w,color: HhColors.backColor,),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('枪机3',style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(value: logic.warnGANG3.value, onChanged: (s){
                                      logic.warnGANG3.value = s;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),height: 1.w,color: HhColors.backColor,),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('球机',style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(value: logic.warnBALL.value, onChanged: (s){
                                      logic.warnBALL.value = s;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),height: 1.w,color: HhColors.backColor,),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('传感器',style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(value: logic.warnSENSOR.value, onChanged: (s){
                                      logic.warnSENSOR.value = s;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),height: 1.w,color: HhColors.backColor,),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('开盖报警',style: TextStyle(
                                color: HhColors.blackColor,
                                fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(value: logic.warnOPEN.value, onChanged: (s){
                                      logic.warnOPEN.value = s;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 30.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 30.w,width: 5.w,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(Radius.circular(3.w))
                        ),),
                      Text('数据上报间隔',style: TextStyle(
                          color: HhColors.blackColor,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.w),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('太阳能控制器',style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                maxLength: 10,
                                cursorColor: HhColors.titleColor_99,
                                controller: logic.time1Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: '',
                                  hintStyle: TextStyle(
                                      color: HhColors.grayCCTextColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                                ),
                                style:
                                TextStyle(color: HhColors.gray6TextColor, fontSize: 28.sp,fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text('分',style: TextStyle(
                                color: HhColors.gray9TextColor,
                                fontSize: 28.sp,
                            ),),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                        child: Row(
                          children: [
                            Text('太阳能控制器',style: TextStyle(
                              color: HhColors.blackColor,
                              fontSize: 28.sp,
                            ),),
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                maxLength: 10,
                                cursorColor: HhColors.titleColor_99,
                                controller: logic.time1Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: '',
                                  hintStyle: TextStyle(
                                      color: HhColors.grayCCTextColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                                ),
                                style:
                                TextStyle(color: HhColors.gray6TextColor, fontSize: 28.sp,fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text('分',style: TextStyle(
                                color: HhColors.gray9TextColor,
                                fontSize: 28.sp,
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // child: ,
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }

}
