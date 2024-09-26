import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/company_login_binding.dart';
import 'package:iot/pages/common/login/company/company_login_view.dart';
import 'package:iot/pages/common/login/login_binding.dart';
import 'package:iot/pages/common/login/login_view.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_binding.dart';
import 'package:iot/pages/home/my/setting/edit_user/edit_view.dart';
import 'package:iot/pages/home/my/setting/password/password_binding.dart';
import 'package:iot/pages/home/my/setting/password/password_view.dart';
import 'package:iot/pages/home/my/setting/phone/phone_binding.dart';
import 'package:iot/pages/home/my/setting/phone/phone_view.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingPage extends StatelessWidget {
  final logic = Get.find<SettingController>();
  SettingPage({super.key});


  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? myPage() : const SizedBox(),
        ),
      ),
    );
  }

  myPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HhColors.backColorF5, HhColors.backColorF5]),
          ),
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
              "设置",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 160.w, 20.w, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///个人信息
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 30.w, 0, 20.w),
                  child: Text(
                    "个人信息",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///头像
                      SizedBox(
                        height:150.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "头像",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: (){
                                  getImageFromGallery(1);
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin:EdgeInsets.only(right: 65.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius: BorderRadius.all(Radius.circular(50.w))
                                  ),
                                  child: logic.picture.value==true?Image.file(File(logic.file.path),
                                    width: 100.w,
                                    height: 100.w,
                                    fit: BoxFit.fill,)
                                      :Image.network(
                                      logic.avatar!.value,
                                      width: 100.w,
                                      height: 100.w,
                                      fit: BoxFit.fill,
                                      errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                                        return Image.asset(
                                          "assets/images/common/user.png",
                                          width: 100.w,
                                          height: 100.w,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                      ///昵称
                      InkWell(
                        onTap: (){
                          Get.to(() => EditPage(keys: 'nickname',titles: '修改昵称',), binding: EditBinding());
                        },
                        child: SizedBox(
                          height:110.w,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin:EdgeInsets.only(left: 30.w),
                                  child: Text(
                                    "昵称",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 28.sp,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.only(right: 65.w),
                                  child: Text(
                                    logic.nickname!.value,
                                    style: TextStyle(
                                        color: HhColors.gray9TextColor,
                                        fontSize: 26.sp),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                  child: Image.asset(
                                    "assets/images/common/back_role.png",
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child:Container(
                                    height: 0.5.w,
                                    width: 1.sw,
                                    margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                    color: HhColors.grayDDTextColor,
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      ///账号
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "账号",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  logic.account!.value,
                                  style: TextStyle(
                                      color: HhColors.grayCCTextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            /*Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),*/
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///安全设置
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "安全设置",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///安全手机
                      InkWell(
                        onTap: (){
                          Get.to(() => PhonePage(keys: 'phone',titles: '修改手机号',), binding: PhoneBinding());
                        },
                        child: SizedBox(
                          height:110.w,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin:EdgeInsets.only(left: 30.w),
                                  child: Text(
                                    "安全手机",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 28.sp,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.only(right: 65.w),
                                  child: Text(
                                    CommonUtils().mobileString(logic.mobile!.value),
                                    style: TextStyle(
                                        color: HhColors.gray9TextColor,
                                        fontSize: 26.sp),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                  child: Image.asset(
                                    "assets/images/common/back_role.png",
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                      ///安全邮箱
                      InkWell(
                        onTap: (){
                          Get.to(() => EditPage(keys: 'email',titles: '修改邮箱',), binding: EditBinding());
                        },
                        child: SizedBox(
                          height:110.w,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin:EdgeInsets.only(left: 30.w),
                                  child: Text(
                                    "安全邮箱",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 28.sp,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.only(right: 65.w),
                                  child: Text(
                                    CommonUtils().mobileString(logic.email!.value),
                                    style: TextStyle(
                                        color: HhColors.gray9TextColor,
                                        fontSize: 26.sp),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                  child: Image.asset(
                                    "assets/images/common/back_role.png",
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                      ///安全邮箱
                      SizedBox(
                        height:110.w,
                        child: InkWell(
                          onTap: (){
                            Get.to(() => PasswordPage(keys: 'password',titles: '修改密码',), binding: PasswordBinding());
                          },
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin:EdgeInsets.only(left: 30.w),
                                  child: Text(
                                    "设置新密码",
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 28.sp,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.only(right: 65.w),
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        color: HhColors.gray9TextColor,
                                        fontSize: 26.sp),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                  child: Image.asset(
                                    "assets/images/common/back_role.png",
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///地区和语言
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "地区和语言",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///地区
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "地区",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "中国大陆",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                      ///多语言
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "多语言",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "简体中文",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                ///其他设置
                Container(
                  margin: EdgeInsets.fromLTRB(15.w, 20.w, 0, 20.w),
                  child: Text(
                    "其他设置",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 28.sp),
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(14.w))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///清除缓存
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "清除缓存",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "无缓存",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                      ///关于我们
                      SizedBox(
                        height:110.w,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:EdgeInsets.only(left: 30.w),
                                child: Text(
                                  "关于我们",
                                  style: TextStyle(
                                      color: HhColors.textBlackColor,
                                      fontSize: 28.sp,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.only(right: 65.w),
                                child: Text(
                                  "版本V1.0.1",
                                  style: TextStyle(
                                      color: HhColors.gray9TextColor,
                                      fontSize: 26.sp),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:EdgeInsets.fromLTRB(0,6.w,30.w,0),
                                child: Image.asset(
                                  "assets/images/common/back_role.png",
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                  height: 0.5.w,
                                  width: 1.sw,
                                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                                  color: HhColors.grayDDTextColor,
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () async {
                    CommonUtils().showConfirmDialog(logic.context, '退出后不能接收信息，确定要退出?', (){
                      Get.back();
                    }, () async {
                      Get.back();
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.remove(SPKeys().token);
                      CommonData.tenant = CommonData.tenantDef;
                      CommonData.tenantName = CommonData.tenantNameDef;
                      CommonData.token = null;
                      CommonUtils().toLogin();
                    },(){
                      Get.back();
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 90.w,
                    margin:EdgeInsets.fromLTRB(0, 50.w, 0, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(14.w))
                    ),
                    child: Center(
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                            color: HhColors.titleColorRed,
                            fontSize: 28.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

      logic.fileUpload();
    }
  }
}
