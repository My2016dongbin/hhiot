import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/my/setting/phone/phone_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class PhonePage extends StatelessWidget {
  final logic = Get.find<PhoneController>();

  PhonePage({super.key,required String keys,required String titles}){
    logic.keys = keys;
    logic.titles.value = titles;
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
    return SingleChildScrollView(
      child: Stack(
        children: [
          // Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
          ///title
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 90.w),
              color: HhColors.trans,
              child: Text(
                logic.titles.value,
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
            margin: EdgeInsets.fromLTRB(30.w, 200.w, 30.w, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///手机号
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        maxLength: 11,
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.phoneController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          counterText: '',
                          hintText: '请输入手机号',
                          hintStyle: TextStyle(
                              color: HhColors.grayCCTextColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                        ),
                        style:
                        TextStyle(color: HhColors.textBlackColor, fontSize: 32.sp,fontWeight: FontWeight.bold),
                        onChanged: (s){
                          logic.phoneStatus.value = s.isNotEmpty;
                        },
                      ),
                    ),
                    logic.phoneStatus.value? BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.phoneController!.clear();
                        logic.phoneStatus.value = false;
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.w),
                          child: Image.asset('assets/images/common/ic_close.png',height:30.w,width: 30.w,fit: BoxFit.fill,)
                      ),
                    ):const SizedBox(),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        //隐藏输入法
                        FocusScope.of(logic.context).requestFocus(FocusNode());
                        if(logic.phoneController!.text.length<11){
                          EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
                          return;
                        }
                        if(logic.time.value!=0){
                          return;
                        }
                        Future.delayed(const Duration(milliseconds: 500),(){
                          logic.sendCode();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                        padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                        decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.w),),
                        ),
                        child: Center(
                          child: Text(
                            logic.time.value==0?'发送验证码':"${logic.time.value}s后重新发送",
                            style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 20.sp,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: HhColors.grayCCTextColor,
                  height: 0.5.w,
                ),
                SizedBox(height: 10.w,),
                ///验证码
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        maxLength: 6,
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.codeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          counterText: '',
                          hintText: '请输入验证码',
                          hintStyle: TextStyle(
                              color: HhColors.grayCCTextColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                        ),
                        style:
                        TextStyle(color: HhColors.textBlackColor, fontSize: 32.sp,fontWeight: FontWeight.bold),
                        onChanged: (s){
                          logic.codeStatus.value = s.isNotEmpty;
                        },
                      ),
                    ),
                    logic.codeStatus.value? BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.codeController!.clear();
                        logic.codeStatus.value = false;
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.w),
                          child: Image.asset('assets/images/common/ic_close.png',height:30.w,width: 30.w,fit: BoxFit.fill,)
                      ),
                    ):const SizedBox()
                  ],
                ),
                Container(
                  color: HhColors.grayCCTextColor,
                  height: 0.5.w,
                ),
                SizedBox(height: 26.w,),
                ///保存
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());
                    if(logic.phoneController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入修改手机号'));
                      return;
                    }
                    if(logic.codeController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入验证码'));
                      return;
                    }
                    Future.delayed(const Duration(milliseconds: 500),(){
                      logic.values = logic.phoneController!.text;
                      logic.codeCheck();
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 90.w,
                    margin: EdgeInsets.fromLTRB(0, 32.w, 0, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(16.w))),
                    child: Center(
                      child: Text(
                        "保存",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.whiteColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                      ),
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
