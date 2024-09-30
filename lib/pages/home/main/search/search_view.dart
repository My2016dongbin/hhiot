import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_view.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/pages/home/main/search/search_controller.dart';
import 'package:iot/utils/HhLog.dart';

class SearchPage extends StatelessWidget {
  final logic = Get.find<SearchedController>();

  SearchPage({super.key});

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
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? buildSearch() : const SizedBox(),
        ),
      ),
    );
  }

  buildSearch() {
    return Stack(
      children: [
        ///背景色
        Container(
          height: 270.w,
          color: HhColors.whiteColor,
        ),
        ///title
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(26.w, 80.w, 0, 0),
            padding: EdgeInsets.all(20.w),
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
              "搜索",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          // height: 90.w,
          margin: EdgeInsets.fromLTRB(20.w, 160.w, 100.w, 0),
          padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
          decoration: BoxDecoration(
              color: HhColors.grayEEBackColor,
              borderRadius: BorderRadius.all(Radius.circular(50.w))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/common/icon_search.png",
                width: 35.w,
                height: 35.w,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  cursorColor: HhColors.titleColor_99,
                  controller: logic.searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (s){
                    logic.mainSearch();
                  },
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '搜索设备、空间、消息...',
                    hintStyle: TextStyle(
                        color: HhColors.gray9TextColor, fontSize: 24.sp),
                  ),
                  style:
                  TextStyle(color: HhColors.textColor, fontSize: 24.sp),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              logic.mainSearch();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(20.w, 180.w, 20.w, 0),
              padding: EdgeInsets.fromLTRB(15.w, 5.w, 15.w, 5.w),
              child: Text(
                "搜索",
                style: TextStyle(
                    color: HhColors.gray6TextColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        logic.listStatus.value?Container(
          margin: EdgeInsets.only(top: 270.w),
          child: EasyRefresh(
            onRefresh: (){
              logic.mainSearch();
            },
            child: SingleChildScrollView(
              key: const Key("out"),
              child: (logic.deviceList.isEmpty&&logic.spaceList.isEmpty&&logic.messageList.isEmpty)?SizedBox(
                child: Center(child: CommonUtils().noneWidget(image: 'assets/images/common/no_search.png',info: '没有找到匹配的结果',height: 0.5.sw,top: 0.4.sw),),
              ):Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: getListWidgets(),
              ),
            ),
          ),
        ):const SizedBox(),

      ],
    );
  }

  getListWidgets() {
    List<Widget> list = [];
    try{
      ///我的设备
      list.add(logic.deviceList.isEmpty?const SizedBox():Container(
        margin: EdgeInsets.fromLTRB(40.w, 30.w, 0, 30.w),
        child: Text('我的设备',style: TextStyle(color: HhColors.blackTextColor,fontSize: 36.sp,fontWeight: FontWeight.bold),),
      ));
      for(int i = 0;i < logic.deviceList.length; i++){
        dynamic item = logic.deviceList[i];
        list.add(InkWell(
          onTap: (){
            Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
            /*if(item['productName']=='浩海一体机'){
              Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
            }else if(item['productName']=='智慧立杆'){
              Get.to(()=>LiGanDetailPage('${item['deviceNo']}','${item['id']}'),binding: LiGanDetailBinding());
            }*/
          },
          child: Container(
            height: 180.w,
            margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
            padding: EdgeInsets.all(20.w),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                    child: Image.asset(
                      item['productName']=='浩海一体机'?"assets/images/common/icon_camera_space.png":"assets/images/common/ic_gan.png",
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(100.w, 0, 0, 50.w),
                    child: Text(
                      CommonUtils().parseNull('${item['name']}',""),
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(100.w, 80.w, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      item['spaceName']==""?const SizedBox():Container(
                        constraints: BoxConstraints(maxWidth: 0.25.sw),
                        child: Text(
                          CommonUtils().parseNull('${item['spaceName']}', ""),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: HhColors.textColor, fontSize: 22.sp),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.w, 0, 60.w, 0),
                        padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                        decoration: BoxDecoration(
                          color: item['activeStatus']==1?HhColors.transBlueColors:HhColors.transRedColors,
                          border: Border.all(color: item['activeStatus']==1?HhColors.mainBlueColor:HhColors.mainRedColor,width: 1.w),
                          borderRadius: BorderRadius.all(Radius.circular(8.w)),
                        ),
                        child: Text(
                          item['activeStatus']==1?'在线':"离线",
                          style: TextStyle(
                              color: item['activeStatus']==1?HhColors.mainBlueColor:HhColors.mainRedColor, fontSize: 23.sp),
                        ),
                      ),
                      CommonData.personal?(item['shared']==true?Container(
                        margin: EdgeInsets.only(left:10.w),
                        padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(Radius.circular(5.w))
                        ),
                        child: Text(
                          '分享中*1',
                          style: TextStyle(
                              color: HhColors.whiteColor, fontSize: 23.sp),
                        ),
                      ):const SizedBox()):const SizedBox(),
                    ],
                  ),
                ),
                CommonData.personal?Align(
                  alignment: Alignment.centerRight,
                  child:
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      DateTime date = DateTime.now();
                      String time = date.toIso8601String().substring(0,19).replaceAll("T", " ");
                      Get.to(()=>SharePage(),binding: ShareBinding(),arguments: {
                        "shareType": "2",
                        "expirationTime": time,
                        "appShareDetailSaveReqVOList": [
                          {
                            "spaceId": "${item["spaceId"]}",
                            "spaceName": "${item["spaceName"]}",
                            "deviceId": "${item["id"]}",
                            "deviceName": "${item["name"]}"
                          }
                        ]
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 0.w),
                      child: Image.asset(
                        item['shared']==true?"assets/images/common/shared.png":"assets/images/common/share.png",
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
        ));
      }
      HhLog.d("device--");
      ///我的空间
      list.add(logic.spaceList.isEmpty?const SizedBox():Container(
        margin: EdgeInsets.fromLTRB(40.w, 30.w, 0, 30.w),
        child: Text('我的空间',style: TextStyle(color: HhColors.blackTextColor,fontSize: 36.sp,fontWeight: FontWeight.bold),),
      ));
      for(int i = 0;i < ((logic.spaceList.length%2==0)?(logic.spaceList.length/2)-1:(logic.spaceList.length/2+1-1)); i++){
        dynamic itemLeft = logic.spaceList[i*2];//0 2 4
        dynamic itemRight = {};
        HhLog.d("space -- ${i*2}");
        if(logic.spaceList.length>(i*2+1)){
          itemRight = logic.spaceList[i*2+1];//1 3 5
          HhLog.d("space -- ${i*2+1}");
        }
        list.add(
          Row(
            children: [
              InkWell(
                onTap: (){
                  Get.to(()=>DeviceListPage(id: "${itemLeft['id']}",),binding: DeviceListBinding());
                },
                child: Container(
                  clipBehavior: Clip.hardEdge, //裁剪
                  width: 0.44.sw,
                  margin: EdgeInsets.fromLTRB(0.04.sw, 30.w, 0.02.sw, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(32.w))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 0.25.sw,
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.vertical(top:Radius.circular(32.w))),
                        child: Image.asset(
                          "assets/images/common/test_video.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20.w, 16.w, 16.w, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                "${itemLeft['name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: HhColors.blackColor,
                                  fontSize: 30.sp,),
                              ),
                            ),
                            SizedBox(width: 8.w,),

                          ],
                        ),
                      ),
                      SizedBox(height: 20.w,),
                    ],
                  ),
                ),
              ),
              itemRight['name'] == null?const SizedBox():InkWell(
                onTap: (){
                  Get.to(()=>DeviceListPage(id: "${itemRight['id']}",),binding: DeviceListBinding());
                },
                child: Container(
                  clipBehavior: Clip.hardEdge, //裁剪
                  width: 0.44.sw,
                  margin: EdgeInsets.fromLTRB(0.02.sw, 30.w, 0.04.sw, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(32.w))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 0.25.sw,
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.vertical(top:Radius.circular(32.w))),
                        child: Image.asset(
                          "assets/images/common/test_video.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20.w, 16.w, 16.w, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                "${itemRight['name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: HhColors.blackColor,
                                  fontSize: 30.sp,),
                              ),
                            ),
                            SizedBox(width: 8.w,),

                          ],
                        ),
                      ),
                      SizedBox(height: 20.w,),
                    ],
                  ),
                ),
              ),
            ],
          )
        );
      }
      HhLog.d("space--");
      HhLog.d("logic.messageList-- ${logic.messageList}");
      ///我的消息
      list.add(logic.messageList.isEmpty?const SizedBox():Container(
        margin: EdgeInsets.fromLTRB(40.w, 30.w, 0, 30.w),
        child: Text('我的消息',style: TextStyle(color: HhColors.blackTextColor,fontSize: 36.sp,fontWeight: FontWeight.bold),),
      ));
      /*for(int i = 0;i < logic.messageList.length; i++){
        dynamic item = logic.messageList[i];
        list.add(
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 130.w,
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                            "assets/images/common/icon_message_back.png",
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,
                          ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                            return Image.asset(
                              "assets/images/common/test_video.jpg",
                              width: 200.w,
                              height: 130.w,
                              fit: BoxFit.fill,
                            );
                          },
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,),
                        ),
                        item['alarmType']=='tilt'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_y.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_open.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 130.w,
                      child: Stack(
                        children: [
                          item['status'] == true?const SizedBox():Container(
                            height: 10.w,
                            width: 10.w,
                            margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                            decoration: BoxDecoration(
                                color: HhColors.backRedInColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                            child: Text(
                              parseLeftType("${item['alarmType']}"),
                              style: TextStyle(
                                  color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CommonUtils().parseNull('${item['deviceName']}',""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                                SizedBox(height: 5.w,),
                                Text(
                                  CommonUtils().parseNull('${item['spaceName']}', ""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.w),
                              child: Text(
                                CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textColor, fontSize: 22.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }*/
      list.add(logic.messageList.isEmpty?const SizedBox():Container(
        constraints: BoxConstraints(
          minHeight: 1.sh,
          maxHeight: 1000.sh
        ),
        child: ListView.builder(padding: EdgeInsets.zero,physics: const NeverScrollableScrollPhysics(),itemCount: logic.messageList.length,itemBuilder: (BuildContext context, int index){
          dynamic item = logic.messageList[index];
          return messageItem(context,index,item);
        }),
      ));
      HhLog.d("message--");
    }catch(e){
      HhLog.e(e.toString());
    }
    return list;
  }


  String parseLeftType(String s) {
    if(s == "openCap"){
      return "箱盖开箱报警";
    }
    if(s == "human"){
      return "人员入侵报警";
    }
    if(s == "car"){
      return "车辆入侵报警";
    }
    if(s == "openSensor"){
      return "传感器开箱报警";
    }
    if(s == "tilt"){
      return "设备倾斜报警";
    }
    return "报警";
  }

  messageItem(BuildContext context, int index, dynamic item) {
  /*
    if(item["messageType"] == "deviceShare"){
      return Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
        padding: EdgeInsets.all(20.w),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10.w))
        ),
        child: Stack(
          children: [
            item['status']==true?const SizedBox():Container(
              height: 10.w,
              width: 10.w,
              margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
              decoration: BoxDecoration(
                  color: HhColors.backRedInColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
              child: Text(
                parseRightType("${item['messageType']}"),
                style: TextStyle(
                    color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "时间:${CommonUtils().parseLongTime('${item['createTime']}')}",
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                  SizedBox(height: 8.w,),
                  Text(
                    '${item['content']}',
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if(item["messageType"] == "deviceAlarm"){
      return Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
        padding: EdgeInsets.all(20.w),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10.w))
        ),
        child: Row(
          children: [
            SizedBox(
              width: 200.w,
              height: 130.w,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                      "assets/images/common/icon_message_back.png",
                      width: 200.w,
                      height: 130.w,
                      fit: BoxFit.fill,
                    ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                      return Image.asset(
                        "assets/images/common/test_video.jpg",
                        width: 200.w,
                        height: 130.w,
                        fit: BoxFit.fill,
                      );
                    },
                      width: 200.w,
                      height: 130.w,
                      fit: BoxFit.fill,),
                  ),
                  item['alarmType']=='tilt'?Align(
                    alignment:Alignment.center,
                    child: Image.asset(
                      "assets/images/common/icon_message_y.png",
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.fill,
                    ),
                  ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                    alignment:Alignment.center,
                    child: Image.asset(
                      "assets/images/common/icon_message_open.png",
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.fill,
                    ),
                  ):const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 130.w,
                child: Stack(
                  children: [
                    item['status'] == true?const SizedBox():Container(
                      height: 10.w,
                      width: 10.w,
                      margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                      decoration: BoxDecoration(
                          color: HhColors.backRedInColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.w))
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                      child: Text(
                        parseLeftType("${item['alarmType']}"),
                        style: TextStyle(
                            color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CommonUtils().parseNull('${item['deviceName']}',""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HhColors.textColor, fontSize: 22.sp),
                          ),
                          SizedBox(height: 5.w,),
                          Text(
                            CommonUtils().parseNull('${item['spaceName']}', ""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HhColors.textColor, fontSize: 22.sp),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 5.w),
                        child: Text(
                          CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                          style: TextStyle(
                              color: HhColors.textColor, fontSize: 22.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

*/

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
      padding: EdgeInsets.all(20.w),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10.w))
      ),
      child: Stack(
        children: [
          item['status']==true?const SizedBox():Container(
            height: 10.w,
            width: 10.w,
            margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
            decoration: BoxDecoration(
                color: HhColors.backRedInColor,
                borderRadius: BorderRadius.all(Radius.circular(5.w))
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
            child: Text(
              parseRightType("${item['messageType']}"),
              style: TextStyle(
                  color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "时间:${CommonUtils().parseLongTime('${item['createTime']}')}",
                  style: TextStyle(
                      color: HhColors.textColor, fontSize: 22.sp),
                ),
                SizedBox(height: 8.w,),
                Text(
                  '${item['content']}',
                  style: TextStyle(
                      color: HhColors.textColor, fontSize: 22.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildMessage() {
    List<Widget> list = [];
    for(int i = 0;i < logic.messageList.length; i++){
        dynamic item = logic.messageList[i];
        list.add(
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 130.w,
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                            "assets/images/common/icon_message_back.png",
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,
                          ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                            return Image.asset(
                              "assets/images/common/test_video.jpg",
                              width: 200.w,
                              height: 130.w,
                              fit: BoxFit.fill,
                            );
                          },
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,),
                        ),
                        item['alarmType']=='tilt'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_y.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_open.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 130.w,
                      child: Stack(
                        children: [
                          item['status'] == true?const SizedBox():Container(
                            height: 10.w,
                            width: 10.w,
                            margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                            decoration: BoxDecoration(
                                color: HhColors.backRedInColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                            child: Text(
                              parseLeftType("${item['alarmType']}"),
                              style: TextStyle(
                                  color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CommonUtils().parseNull('${item['deviceName']}',""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                                SizedBox(height: 5.w,),
                                Text(
                                  CommonUtils().parseNull('${item['spaceName']}', ""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.w),
                              child: Text(
                                CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textColor, fontSize: 22.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }
    return list;
  }


  String parseRightType(String s) {
    if(s == "deviceAlarm"){
      return "设备报警通知";
    }
    return "通知";
  }

}
