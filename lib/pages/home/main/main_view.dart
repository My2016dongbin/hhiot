import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../utils/HhColors.dart';
import '../../common/common_data.dart';
import 'main_controller.dart';

class MainPage extends StatelessWidget {
  final logic = Get.find<MainController>();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(() => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.pageMapStatus.value?mapPage():containPage(),
        ),
      ),
    );
  }

  buildSearchView() {
    return Container(
      width: 0.6.sw,
      margin: EdgeInsets.fromLTRB(
          30.w, logic.marginTop+70.w, 0, 0),
      padding: EdgeInsets.fromLTRB(20.w,20.w,50.w,20.w),
      decoration: BoxDecoration(
          boxShadow:const [ BoxShadow(
            color: HhColors.trans_77,
            ///控制阴影的位置
            offset: Offset(0, 10),
            ///控制阴影的大小
            blurRadius: 24.0,
          ),
          ],
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80.w,
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                border: Border.all(color: HhColors.mainBlueColor),
                borderRadius: BorderRadius.all(Radius.circular(50.w))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: logic.restartSearchClick,
                  child: Image.asset(
                    "assets/images/common/shared.png",
                    width: 35.w,
                    height: 35.w,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 5.w,),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    cursorColor: HhColors.titleColor_99,
                    controller: logic.searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      //contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: '请输入名称',
                      hintStyle: TextStyle(
                          color: HhColors.gray9TextColor, fontSize: 24.sp),
                    ),
                    style: TextStyle(
                        color: HhColors.textColor, fontSize: 24.sp),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  mapPage() {
    return Stack(
      children: [
        BMFMapWidget(
          onBMFMapCreated: (controller) {
            logic.onBMFMapCreated(controller);
          },
          mapOptions: BMFMapOptions(
              center: BMFCoordinate(CommonData.latitude ?? 36.30865,
                  CommonData.longitude ?? 120.314037),
              zoomLevel: 12,
              mapType: BMFMapType.Standard,
              mapPadding:
              BMFEdgeInsets(left: 30.w, top: 0, right: 30.w, bottom: 0)),
        ),
        Container(
          height: 160.w,
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [HhColors.backTransColor1,HhColors.backTransColor3]),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(40.w, 0, 0, 10.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("我的空间",style: TextStyle(color: HhColors.blackTextColor,fontSize: 36.sp,fontWeight: FontWeight.bold),),
                      SizedBox(
                        height: 2.w,
                      ),
                      Container(
                        height: 5.w,width: 20.w,
                        decoration: BoxDecoration(
                          color: HhColors.blackTextColor,
                          border: Border.all(color: HhColors.blackTextColor),
                          borderRadius: BorderRadius.all(Radius.circular(2.w)),),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap:(){
                        logic.pageMapStatus.value = false;
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.w),
                        padding: EdgeInsets.fromLTRB(15.w,10.w,15.w,10.w),
                        decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(40.w)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/shared.png",
                              width: 36.w,
                              height: 36.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Text(
                              "空间",
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 24.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w,0,20.w,10.w),
                      child: Image.asset(
                        "assets/images/common/shared.png",
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: logic.searchStatus.value
              ? buildSearchView()
              : Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: logic.onSearchClick,
                    child: Container(
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.w)),
                        boxShadow:const [ BoxShadow(
                          color: HhColors.trans_77,
                          ///控制阴影的位置
                          offset: Offset(0, 10),
                          ///控制阴影的大小
                          blurRadius: 24.0,
                        ),
                        ],
                      ),
                      margin: EdgeInsets.fromLTRB(
                          30.w, logic.marginTop+70.w, 0, 0),
                      padding: EdgeInsets.fromLTRB(16.w,10.w,16.w,10.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/shared.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Text(
                            "搜索",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: HhColors.blackTextColor,
                                fontSize: 20.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        logic.videoStatus.value?Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: (){
              logic.videoStatus.value = !logic.videoStatus.value;
            },
            child: Container(
              width: 0.7.sw,
              height: 0.4.sw,
              margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 30.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.trans,
                  borderRadius: BorderRadius.all(Radius.circular(30.w))
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "assets/images/common/test_video.jpg",
                      width: 0.7.sw,
                      height: 0.4.sw,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20.w, 20.w, 0),
                      padding: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                      decoration: BoxDecoration(
                          color: HhColors.blackColor,
                          borderRadius: BorderRadius.all(Radius.circular(30.w))
                      ),
                      child: Text("进入",style: TextStyle(color: HhColors.whiteColor,fontSize: 24.sp),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ):const SizedBox(),
      ],
    );
  }

  containPage() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [HhColors.backTransColor1,HhColors.backTransColor3]),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [HhColors.backTransColor1,HhColors.backTransColor3]),
                ),
              ),
              InkWell(
                onTap: (){

                },
                child: Container(
                  height: 80.w,
                  margin: EdgeInsets.fromLTRB(20.w, logic.marginTop, 20.w, 0),
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(40.w)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 25.w,),
                      Image.asset(
                        "assets/images/common/shared.png",
                        width: 35.w,
                        height: 35.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 15.w,),
                      Expanded(
                        child: Text('搜索设备、事件、和视频',
                          style: TextStyle(
                              color: HhColors.textColor, fontSize: 24.sp),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                      Image.asset(
                        "assets/images/common/shared.png",
                        width: 35.w,
                        height: 35.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 30.w,)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(55.w, 0, 0, 10.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/test_video.jpg",
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 10.w,),
                            Text("2°多云",style: TextStyle(color: HhColors.blackTextColor,fontSize: 24.sp),),
                            SizedBox(width: 5.w,),
                            Image.asset(
                              "assets/images/common/shared.png",
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.fill,
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10.w),
                            child: Image.asset(
                              "assets/images/common/shared.png",
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w,0,20.w,10.w),
                            child: Image.asset(
                              "assets/images/common/shared.png",
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(40.w, 0, 0, 10.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("我的空间",style: TextStyle(color: HhColors.blackTextColor,fontSize: 36.sp,fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 2.w,
                            ),
                            Container(
                              height: 5.w,width: 20.w,
                              decoration: BoxDecoration(
                                color: HhColors.blackTextColor,
                                border: Border.all(color: HhColors.blackTextColor),
                                borderRadius: BorderRadius.all(Radius.circular(2.w)),),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap:(){
                              logic.pageMapStatus.value = true;
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.w),
                              padding: EdgeInsets.fromLTRB(15.w,10.w,15.w,10.w),
                              decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.all(Radius.circular(40.w)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/common/shared.png",
                                    width: 36.w,
                                    height: 36.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    width: 5.h,
                                  ),
                                  Text(
                                    "地图",
                                    style: TextStyle(
                                        color: HhColors.mainBlueColor,
                                        fontSize: 24.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w,0,20.w,10.w),
                            child: Image.asset(
                              "assets/images/common/shared.png",
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
