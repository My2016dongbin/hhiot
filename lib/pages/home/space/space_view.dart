import 'dart:io';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/EventBusUtils.dart';
import '../../../utils/HhColors.dart';
import 'space_controller.dart';

class SpacePage extends StatelessWidget {
  final logic = Get.find<SpaceController>();

  SpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return WillPopScope(
      onWillPop: () {
        Get.back();
        logic.picture.value = false;
        return Future.value(true);
        },
      child: Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
          () => Container(
            height: 1.sh,
            width: 1.sw,
            color: HhColors.backColorF5,
            padding: EdgeInsets.zero,
            child: logic.testStatus.value ? buildSpace() : const SizedBox(),
          ),
        ),
      ),
    );
  }

  buildSpace() {
    return Stack(
      children: [
        ///背景色
        Container(
          height: 160.w,
          color: HhColors.whiteColor,
        ),
        ///title
        InkWell(
          onTap: () {
            Get.back();
            logic.picture.value = false;
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
              "添加空间",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child:
          BouncingWidget(
            duration: const Duration(milliseconds: 100),
            scaleFactor: 1.2,
            onPressed: (){
              //隐藏输入法
              FocusScope.of(logic.context).requestFocus(FocusNode());
              if(logic.nameController!.text.isEmpty){
                EventBusUtil.getInstance().fire(HhToast(title: '空间名称不能为空'));
                return;
              }
              logic.createSpace();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0,90.w,20.w,0),
              padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 8.w),
              decoration: BoxDecoration(
                color: HhColors.mainBlueColor,
                borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Text(
                "确定",
                style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 24.sp),
              ),
            ),
          ),
        ),
        ///添加
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 180.w, 20.w, 20.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20.w))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5.w,),
                    Text(
                      "空间名称",
                      style: TextStyle(
                          color: HhColors.textBlackColor,
                          fontSize: 28.sp,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: '请输入空间名称',
                          hintStyle: TextStyle(
                              color: HhColors.gray9TextColor, fontSize: 24.sp),
                        ),
                        style:
                        TextStyle(color: HhColors.textColor, fontSize: 24.sp),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.w, 3.w, 0, 0),
                      child: Image.asset(
                        "assets/images/common/back_role.png",
                        width: 25.w,
                        height: 25.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5.w,
                width: 1.sw,
                margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                color: HhColors.grayDDTextColor,
              ),
              SizedBox(
                height: 100.w,
                child:
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    getImageFromGallery(1);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 5.w,),
                      Text(
                        "空间图片",
                        style: TextStyle(
                            color: HhColors.textBlackColor,
                            fontSize: 28.sp,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Text(
                          "",
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 26.sp),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.w, 6.w, 0, 0),
                        child: Image.asset(
                          "assets/images/common/back_role.png",
                          width: 25.w,
                          height: 25.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5.w,
                width: 1.sw,
                margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                color: HhColors.grayDDTextColor,
              ),
              Container(
                height: 0.6.sw,
                width: 1.sw,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                margin: EdgeInsets.only(top: 20.w),
                child: logic.picture.value==true?Image.file(File(logic.file.path)):Image.asset(
                  "assets/images/common/test_video.jpg",
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }


  Future getImageFromGallery(int num) async {
    final List<XFile> pickedFileList = await ImagePicker().pickMultiImage(
      maxWidth: 3000,
      maxHeight: 3000,
      imageQuality: 1,
    );
    if(pickedFileList.isNotEmpty){
      logic.file = pickedFileList[0];
      logic.picture.value = false;
      logic.picture.value = true;
    }
  }
}
