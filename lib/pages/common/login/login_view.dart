import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/login/code/code_binding.dart';
import 'package:iot/pages/common/login/code/code_view.dart';
import 'package:iot/pages/common/login/login_controller.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/HhColors.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginController>();

  LoginPage({super.key});

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
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
              () => Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.zero,
            child: logic.testStatus.value ? loginView() : const SizedBox(),
          ),
        ),
      ),
    );
  }

  loginView() {
    return Stack(
      children: [
        Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh, 0, 0),
            child: Text('欢迎登录浩海物联',style: TextStyle(color: HhColors.blackColor,fontSize: 40.sp,fontWeight: FontWeight.bold),),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh+66.w, 0, 0),
            child: Text('未注册手机号验证后将创建浩海通行证',style: TextStyle(color: HhColors.textBlackColor,fontSize: 23.sp,),)
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh+66.w+100.w, 0.1.sw, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///账号
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      maxLength: 11,
                      cursorColor: HhColors.titleColor_99,
                      controller: logic.accountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        counterText: '',
                        hintText: '请输入手机号码',
                        hintStyle: TextStyle(
                            color: HhColors.grayCCTextColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                      ),
                      style:
                      TextStyle(color: HhColors.textBlackColor, fontSize: 32.sp,fontWeight: FontWeight.bold),
                      onChanged: (s){
                        logic.accountStatus.value = s.isNotEmpty;
                      },
                    ),
                  ),
                  logic.accountStatus.value?InkWell(
                    onTap: (){
                      logic.accountController!.clear();
                      logic.accountStatus.value = false;
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
              SizedBox(height: 30.w,),
              ///密码
              logic.pageStatus.value?const SizedBox():Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      maxLength: 20,
                      cursorColor: HhColors.titleColor_99,
                      controller: logic.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !logic.passwordShowStatus.value,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        counterText: '',
                        hintText: '请输入密码',
                        hintStyle: TextStyle(
                            color: HhColors.grayCCTextColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                      ),
                      style:
                      TextStyle(color: HhColors.textBlackColor, fontSize: 30.sp,fontWeight: FontWeight.w300),
                      onChanged: (s){
                        logic.passwordStatus.value = s.isNotEmpty;
                      },
                    ),
                  ),
                  logic.passwordStatus.value?InkWell(
                    onTap: (){
                      logic.passwordController!.clear();
                      logic.passwordStatus.value = false;
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                        child: Image.asset('assets/images/common/ic_close.png',height:30.w,width: 30.w,fit: BoxFit.fill,)
                    ),
                  ):const SizedBox(),
                  SizedBox(width: 10.w,),
                  InkWell(
                    onTap: (){
                      logic.passwordShowStatus.value = !logic.passwordShowStatus.value;
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                        child: Image.asset(logic.passwordShowStatus.value?'assets/images/common/icon_bi.png':'assets/images/common/icon_zheng.png',height:40.w,width: 40.w,fit: BoxFit.fill,)
                    ),
                  )
                ],
              ),
              logic.pageStatus.value?const SizedBox():Container(
                color: HhColors.grayCCTextColor,
                height: 0.5.w,
              ),
              SizedBox(height: 26.w,),
              ///协议
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      logic.confirmStatus.value = !logic.confirmStatus.value;
                    },
                    child: Container(
                        padding: EdgeInsets.all(5.w),
                        child: Image.asset(logic.confirmStatus.value?'assets/images/common/yes.png':'assets/images/common/no.png',height:28.w,width: 28.w,fit: BoxFit.fill,)
                    ),
                  ),
                  Text('我已阅读并同意',
                    style: TextStyle(color: HhColors.grayBBTextColor,fontSize: 21.sp,fontWeight: FontWeight.bold),
                  ),
                  Text('《FM52隐私协议》',
                    style: TextStyle(color: HhColors.backBlueOutColor,fontSize: 21.sp,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ///登录
              InkWell(
                onTap: (){
                  if(logic.pageStatus.value){
                    ///验证码点击
                    Get.to(()=>CodePage(),binding: CodeBinding());
                  }else{
                    ///登录点击
                    showToast('登录成功',
                      context: logic.context,
                      animation: StyledToastAnimation.slideFromBottomFade,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.bottom,
                      animDuration: const Duration(seconds: 1),
                      duration: const Duration(seconds: 2),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.linear,
                    );
                    Future.delayed(const Duration(seconds: 1),(){
                      Get.off(HomePage(),binding: HomeBinding());
                    });
                  }
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
                      logic.pageStatus.value?"获取验证码":"登录",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: HhColors.whiteColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              ),
              ///切换
              InkWell(
                onTap: (){
                  logic.pageStatus.value = !logic.pageStatus.value;
                },
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 5.w, 0, 0),
                    padding: EdgeInsets.all(5.w),
                    color: HhColors.trans,
                    child: Text(logic.pageStatus.value?'密码登录':'验证码登录',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 26.sp,),)
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  int timeForExit = 0;
  //复写返回监听
  Future<bool> onBackPressed() {
    bool exit = false;
    int time_ = DateTime.now().millisecondsSinceEpoch;
    if (time_ - timeForExit > 2000) {
      showToast('再按一次退出程序',
        context: logic.context,
        animation: StyledToastAnimation.slideFromBottomFade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      // EventBusUtil.getInstance().fire(ShowToast("再按一次退出程序"));
      timeForExit = time_;
      exit = false;
    } else {
      exit = true;
    }
    return Future.value(exit);
  }

}
