import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/code/code_binding.dart';
import 'package:iot/pages/common/login/code/code_view.dart';
import 'package:iot/pages/common/login/login_controller.dart';
import 'package:iot/pages/common/login/personal/forget/personal_forget_binding.dart';
import 'package:iot/pages/common/login/personal/forget/personal_forget_view.dart';
import 'package:iot/pages/common/login/personal/personal_login_controller.dart';
import 'package:iot/pages/common/login/regist/regist_binding.dart';
import 'package:iot/pages/common/login/regist/regist_view.dart';
import 'package:iot/pages/common/web/WebViewPage.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class PersonalLoginPage extends StatelessWidget {
  final logic = Get.find<PersonalLoginController>();

  PersonalLoginPage({super.key});

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
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset('assets/images/common/icon_bg.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(0.1.sw, 0.12.sh, 0, 0),
              child: Text('浩海万联',style: TextStyle(color: HhColors.blackColor,fontSize: 70.sp,fontWeight: FontWeight.bold),),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(0.1.sw, 0.15.sh+66.w, 0, 0),
              child: Text('智  能  安  全  生  活',style: TextStyle(color: HhColors.textBlackColor,fontSize: 40.sp,),)
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.08.sw, 0.16.sh+66.w+150.w, 0.08.sw, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///账号
                Container(
                  height: 100.w,
                  decoration: BoxDecoration(
                      color: HhColors.mainGrayColorTrans,
                      borderRadius: BorderRadius.all(Radius.circular(50.w))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 11,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.accountController,
                          keyboardType: logic.pageStatus.value?TextInputType.number:TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                            border: InputBorder.none,
                            counterText: '',
                            hintText: logic.pageStatus.value?'手机号':'用户名/手机号',
                            hintStyle: TextStyle(
                                color: HhColors.whiteColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.textBlackColor, fontSize: 32.sp,fontWeight: FontWeight.bold),
                          onChanged: (s){
                            logic.accountStatus.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.accountStatus.value? BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.accountController!.clear();
                          logic.accountStatus.value = false;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close.png',height:30.w,width: 30.w,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                      SizedBox(width: 20.w,),
                    ],
                  ),
                ),
                /*Container(
                  color: HhColors.grayCCTextColor,
                  height: 0.5.w,
                ),*/
                SizedBox(height: 36.w,),
                ///密码
                logic.pageStatus.value?const SizedBox():Container(
                  height: 100.w,
                  decoration: BoxDecoration(
                      color: HhColors.mainGrayColorTrans,
                      borderRadius: BorderRadius.all(Radius.circular(50.w))),
                  child: Row(
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
                            contentPadding: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                            border: InputBorder.none,
                            counterText: '',
                            hintText: '密码',
                            hintStyle: TextStyle(
                                color: HhColors.whiteColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.textBlackColor, fontSize: 30.sp,fontWeight: FontWeight.w300),
                          onChanged: (s){
                            logic.passwordStatus.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.passwordStatus.value?
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.passwordController!.clear();
                          logic.passwordStatus.value = false;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close.png',height:30.w,width: 30.w,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                      SizedBox(width: 10.w,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.passwordShowStatus.value = !logic.passwordShowStatus.value;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                            child: Image.asset(logic.passwordShowStatus.value?'assets/images/common/icon_bi.png':'assets/images/common/icon_zheng.png',height:40.w,width: 40.w,fit: BoxFit.fill,)
                        ),
                      ),
                      SizedBox(width: 20.w,),
                    ],
                  ),
                ),
                logic.pageStatus.value?const SizedBox():Container(
                  color: HhColors.grayCCTextColor,
                  height: 0.5.w,
                ),
                SizedBox(height: 26.w,),
                ///协议
                Row(
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.confirmStatus.value = !logic.confirmStatus.value;
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.w),
                          child: Image.asset(logic.confirmStatus.value?'assets/images/common/yes.png':'assets/images/common/no.png',height:28.w,width: 28.w,fit: BoxFit.fill,)
                      ),
                    ),
                    Text('我已阅读并同意',
                      style: TextStyle(color: HhColors.gray9TextColor,fontSize: 21.sp,fontWeight: FontWeight.bold),
                    ),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        // showWebDialog();
                        Get.to(WebViewPage(title: '隐私协议', url: 'https://www.ygspii.cn/page_agreement_regist.html',));
                      },
                      child: Text('《浩海万联平台隐私政策》',
                        style: TextStyle(color: HhColors.backBlueOutColor,fontSize: 21.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ///登录
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());

                    if(logic.pageStatus.value){
                      ///验证码点击
                      if(logic.accountController!.text.isEmpty){
                        EventBusUtil.getInstance().fire(HhToast(title: '手机号不能为空'));
                        return;
                      }
                      if(logic.accountController!.text.length<11){
                        EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
                        return;
                      }
                      if(!logic.confirmStatus.value){
                        EventBusUtil.getInstance().fire(HhToast(title: '请阅读并同意隐私协议'));
                        return;
                      }
                      Future.delayed(const Duration(milliseconds: 500),(){
                        logic.sendCode();
                      });
                    }else{
                      ///登录点击
                      if(logic.accountController!.text.isEmpty){
                        EventBusUtil.getInstance().fire(HhToast(title: '账号不能为空'));
                        return;
                      }
                      if(logic.passwordController!.text.isEmpty){
                        EventBusUtil.getInstance().fire(HhToast(title: '密码不能为空'));
                        return;
                      }
                      if(!logic.confirmStatus.value){
                        EventBusUtil.getInstance().fire(HhToast(title: '请阅读并同意隐私协议'));
                        return;
                      }
                      logic.getTenant();
                    }
                  },
                  child: Container(
                    width: 1.sw,
                    height: 90.w,
                    margin: EdgeInsets.fromLTRB(0, 32.w, 0, 20.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColorTrans,
                        borderRadius: BorderRadius.all(Radius.circular(50.w))),
                    child: Center(
                      child: Text(
                        logic.pageStatus.value?"获取验证码":"登录",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.whiteColor, fontSize: 28.sp,fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                ),
                /*///切换
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    logic.pageStatus.value = !logic.pageStatus.value;
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());
                    logic.accountController!.text = '';
                    if(!logic.pageStatus.value){
                      logic.accountController!.text = logic.account!;
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5.w, 0, 0),
                      padding: EdgeInsets.all(5.w),
                      color: HhColors.trans,
                      child: Text(logic.pageStatus.value?'密码登录':'验证码登录',style: TextStyle(color: HhColors.whiteColor,fontSize: 26.sp,),)
                  ),
                ),
                SizedBox(height: 30.w,),*/
                ///忘记密码
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    Get.to(()=>PersonalForgetPage(),binding: PersonalForgetBinding());
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5.w, 0, 0),
                      padding: EdgeInsets.all(5.w),
                      color: HhColors.trans,
                      child: Text('忘记密码',style: TextStyle(color: HhColors.whiteColor,fontSize: 26.sp,),)
                  ),
                ),
                SizedBox(height: 30.w,),
              ],
            ),
          ),

          ///注册
          Align(
            alignment: Alignment.topRight,
            child: BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              onPressed: (){
                logic.getTenantId();
                Get.to(()=>RegisterPage(),binding: RegisterBinding());
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 90.w, 30.w, 0),
                  padding: EdgeInsets.all(5.w),
                  color: HhColors.trans,
                  child: Text('注册',style: TextStyle(color: HhColors.whiteColor,fontSize: 30.sp,),)
              ),
            ),
          ),
        ],
      ),
    );
  }

  int timeForExit = 0;
  //复写返回监听
  Future<bool> onBackPressed() {
    bool exit = false;
    int time_ = DateTime.now().millisecondsSinceEpoch;
    if (time_ - timeForExit > 2000) {
      EventBusUtil.getInstance().fire(HhToast(title: '再按一次退出程序'));
      timeForExit = time_;
      exit = false;
    } else {
      exit = true;
    }
    return Future.value(exit);
  }

  void showWebDialog() {
    showCupertinoDialog(context: logic.context, builder: (context) => Center(
      child: Container(
        width: 1.sw,
        height: 360.w,
        margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
        padding: EdgeInsets.fromLTRB(30.w, 25.w, 30.w, 25.w),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(CommonData.info,
                style: TextStyle(color: HhColors.textColor,fontSize: 21.sp),
              ),
            ],
          ),
        ),
      ),
    ));
  }

}
