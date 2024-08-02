import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/ligan_detail_view.dart';
import 'package:iot/pages/home/device/list/device_list_binding.dart';
import 'package:iot/pages/home/device/list/device_list_view.dart';
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
                    hintText: '搜索设备、事件、和视频',
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
        /*///历史搜索记录列表
        Container(
          margin: EdgeInsets.only(top: 270.w),
          color: HhColors.backColorF5,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(25.w, 25.w, 0, 0),
                  child: Text(
                    "历史搜索记录",
                    style: TextStyle(
                        color: HhColors.gray9TextColor,
                        fontSize: 23.sp),
                  ),
                ),
                InkWell(
                  onTap: (){
                    logic.searchController!.text = "林场";
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(25.w, 25.w, 0, 0),
                    color: HhColors.trans,
                    child: Text(
                      "林场",
                      style: TextStyle(
                          color: HhColors.textBlackColor2,
                          fontSize: 24.sp),
                    ),
                  ),
                ),
                Container(
                  height: 1.w,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(25.w, 20.w, 25.w, 0),
                  color: HhColors.grayDDTextColor,
                ),
                InkWell(
                  onTap: (){
                    logic.searchController!.text = "护林房";
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(25.w, 25.w, 0, 0),
                    color: HhColors.trans,
                    child: Text(
                      "护林房",
                      style: TextStyle(
                          color: HhColors.textBlackColor2,
                          fontSize: 24.sp),
                    ),
                  ),
                ),
                Container(
                  height: 1.w,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(25.w, 20.w, 25.w, 0),
                  color: HhColors.grayDDTextColor,
                ),
              ],
            ),
          ),
        ),*/
        logic.listStatus.value?Container(
          margin: EdgeInsets.only(top: 270.w),
          child: EasyRefresh(
            onRefresh: (){
              logic.mainSearch();
            },
            child: SingleChildScrollView(
              key: const Key("out"),
              child: Column(
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
            height: 160.w,
            margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
            padding: EdgeInsets.all(20.w),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20.w))
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
                    margin: EdgeInsets.fromLTRB(100.w, 0, 0, item['productName']==""?0:50.w),
                    child: Text(
                      '${item['name']}',
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                item['productName']==""?const SizedBox():Container(
                  margin: EdgeInsets.fromLTRB(100.w, 80.w, 0, 0),
                  child: Text(
                    '${item['productName']}-${item['categoryName']}',
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 22.sp),
                  ),
                ),
                ///分享
                item['shared']==true?Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right:70.w),
                    padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                    child: Text(
                      '已共享*1',
                      style: TextStyle(
                          color: HhColors.whiteColor, fontSize: 23.sp),
                    ),
                  ),
                ):const SizedBox(),
                /*Align(
                      alignment: Alignment.centerRight,
                      child:
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          Get.to(()=>SharePage(),binding: ShareBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: item['shared']==true?0:80.w),
                          child: Image.asset(
                            item['shared']==true?"assets/images/common/shared.png":"assets/images/common/share.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),*/
                item['shared']==true?const SizedBox():Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    "assets/images/common/close.png",
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.fill,
                  ),
                ),
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
      for(int i = 0;i < ((logic.spaceList.length%2==0)?(logic.spaceList.length/2):(logic.spaceList.length/2+1)); i++){
        dynamic itemLeft = logic.spaceList[i*2];//0 2 4
        dynamic itemRight = {};
        try{
          itemRight = logic.spaceList[i*2+1];//1 3 5
        }catch(e){
          itemRight = {};
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
                        margin: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 15.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${itemLeft['name']}",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10.w,),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(12.w, 2.w, 12.w, 2.w),
                                    decoration: BoxDecoration(
                                        color: HhColors.grayEFBackColor,
                                        borderRadius: BorderRadius.all(Radius.circular(8.w))
                                    ),
                                    child: Text(
                                      "${itemLeft['deviceCount']??"0"}个设备",
                                      style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            (itemLeft['deviceCount']==0 || itemLeft['deviceCount']=='' || itemLeft['deviceCount']==null)?const SizedBox():Image.asset(
                              "assets/images/common/icon_red.png",
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.fill,
                            )
                          ],
                        ),
                      )
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
                        margin: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 15.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${itemRight['name']}",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10.w,),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(12.w, 2.w, 12.w, 2.w),
                                    decoration: BoxDecoration(
                                        color: HhColors.grayEFBackColor,
                                        borderRadius: BorderRadius.all(Radius.circular(8.w))
                                    ),
                                    child: Text(
                                      "${itemRight['deviceCount']??"0"}个设备",
                                      style: TextStyle(color: HhColors.textColor, fontSize: 23.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            (itemRight['deviceCount']==0 || itemRight['deviceCount']=='' || itemRight['deviceCount']==null)?const SizedBox():Image.asset(
                              "assets/images/common/icon_red.png",
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.fill,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        );
      }
      HhLog.d("space--");
      ///我的消息
      list.add(logic.messageList.isEmpty?const SizedBox():Container(
        margin: EdgeInsets.fromLTRB(40.w, 30.w, 0, 30.w),
        child: Text('我的消息',style: TextStyle(color: HhColors.blackTextColor,fontSize: 36.sp,fontWeight: FontWeight.bold),),
      ));
      for(int i = 0;i < logic.messageList.length; i++){
        dynamic item = logic.messageList[i];
        list.add(Container(
          margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
          padding: EdgeInsets.all(20.w),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10.w))
          ),
          child: Stack(
            children: [
              Container(
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
                  "${item['name']}",
                  style: TextStyle(
                      color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                child: Text(
                  '${item['content']}',
                  style: TextStyle(
                      color: HhColors.textColor, fontSize: 22.sp),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${item['time']}',
                  style: TextStyle(
                      color: HhColors.textColor, fontSize: 22.sp),
                ),
              ),
            ],
          ),
        ));
      }
      HhLog.d("message--");
    }catch(e){
      HhLog.e(e.toString());
    }
    return list;
  }

}
