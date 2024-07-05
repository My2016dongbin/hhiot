import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/pages/home/main/search/search_controller.dart';

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
        ///历史搜索记录列表
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
        ),
      ],
    );
  }

}
