import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/share/confirm/confirm_binding.dart';
import 'package:iot/pages/common/share/confirm/confirm_view.dart';
import 'package:iot/pages/common/share/share_controller.dart';
import 'package:iot/pages/home/my/setting/setting_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class SharePage extends StatelessWidget {
  final logic = Get.find<ShareController>();

  SharePage({super.key});

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
              "共享设备",
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        /*Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              Get.to(()=>ConfirmPage(),binding: ConfirmBinding());
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 90.w, 20.w, 0),
              color: HhColors.trans,
              child: Text(
                "确认",
                style: TextStyle(
                    color: HhColors.blackTextColor,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),*/

       Expanded(
         child: Container(
           margin: EdgeInsets.only(top: 160.w),
           child: SingleChildScrollView(
             child: Column(
               children: [
                 ///菜单
                 Container(
                   margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                   clipBehavior: Clip.hardEdge,
                   decoration: BoxDecoration(
                       color: HhColors.whiteColor,
                       borderRadius: BorderRadius.all(Radius.circular(20.w))),
                   child: SingleChildScrollView(
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         SizedBox(
                           height: 40.w,
                         ),
                         Container(
                           clipBehavior: Clip.hardEdge,
                           decoration: BoxDecoration(
                               color: HhColors.whiteColor,
                               borderRadius: BorderRadius.all(Radius.circular(20.w))),
                           child: Image.asset(
                             "assets/images/common/icon_share_camera.png",
                             width: 230.w,
                             height: 230.w,
                             fit: BoxFit.fill,
                           ),
                         ),
                         Container(
                           margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Text(
                                 '${logic.arguments["appShareDetailSaveReqVOList"][0]["deviceName"]}',
                                 style: TextStyle(
                                     color: HhColors.blackTextColor, fontSize: 26.sp),
                               ),
                               InkWell(
                                 onTap: () {
                                   /*EventBusUtil.getInstance().fire(HhToast(
                                    title: '分享该设备，您可以输入被分享人的用户名或手机号，在对方同意后该设备则分享成功',
                                    type: 0));*/
                                   showCupertinoDialog(context: logic.context, builder: (context) => Align(
                                     alignment: Alignment.bottomCenter,
                                     child: Container(
                                       width: 1.sw,
                                       height: 180.w,
                                       margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 20.w),
                                       padding: EdgeInsets.fromLTRB(30.w, 30.w, 30.w, 25.w),
                                       decoration: BoxDecoration(
                                           color: HhColors.blackTextColor,
                                           borderRadius: BorderRadius.all(Radius.circular(20.w))),
                                       child: Stack(
                                         children: [
                                           Align(
                                             alignment: Alignment.topRight,
                                             child: BouncingWidget(
                                               duration: const Duration(milliseconds: 100),
                                               scaleFactor: 1.2,
                                               onPressed: () {
                                                 Get.back();
                                               },
                                               child: Container(
                                                 padding: EdgeInsets.only(right: 10.w),
                                                 child: Image.asset(
                                                   "assets/images/common/ic_x_white.png",
                                                   width: 26.w,
                                                   height: 26.w,
                                                   fit: BoxFit.fill,
                                                 ),
                                               ),
                                             ),
                                           ),
                                           SizedBox(height: 10.w,),
                                           Center(
                                             child: Container(
                                               margin: EdgeInsets.fromLTRB(20.w, 20.w, 0, 0),
                                               child: Text('分享该设备，您可以输入被分享人的用户名或手机号，在对方同意后该设备则分享成功',style: TextStyle(color: HhColors.backColorRegister,fontSize: 27.sp,
                                                 decoration: TextDecoration.none,fontWeight: FontWeight.w500),),
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),barrierDismissible: true);
                                 },
                                 child: Container(
                                   padding: EdgeInsets.all(10.w),
                                   child: Image.asset(
                                     "assets/images/common/wenhao.png",
                                     width: 23.w,
                                     height: 23.w,
                                     fit: BoxFit.fill,
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ),
                         Row(
                           children: [
                             Container(
                               margin: EdgeInsets.fromLTRB(30.w, 30.w, 20.w, 20.w),
                               child: Text(
                                 '请输入被分享人的用户名/手机号',
                                 style: TextStyle(
                                     color: HhColors.blackColor,
                                     fontSize: 26.sp,
                                     fontWeight: FontWeight.w500),
                               ),
                             ),
                           ],
                         ),
                         Container(
                           height: 90.w,
                           margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                           padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                           decoration: BoxDecoration(
                               color: HhColors.grayEFBackColor,
                               borderRadius: BorderRadius.all(Radius.circular(20.w))),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Expanded(
                                 child: TextField(
                                   textAlign: TextAlign.start,
                                   maxLines: 1,
                                   cursorColor: HhColors.titleColor_99,
                                   controller: logic.nameController,
                                   keyboardType: TextInputType.text,
                                   enabled: true,
                                   decoration: InputDecoration(
                                     border: InputBorder.none,
                                     hintText: '请输入被分享人的用户名/手机号',
                                     hintStyle: TextStyle(
                                         color: HhColors.gray9TextColor,
                                         fontSize: 26.sp,
                                         fontWeight: FontWeight.w500),
                                   ),
                                   style: TextStyle(
                                       color: HhColors.blackTextColor,
                                       fontSize: 26.sp,
                                       fontWeight: FontWeight.bold),
                                 ),
                               ),
                               SizedBox(
                                 width: 5.w,
                               ),
                             ],
                           ),
                         ),
                         SizedBox(
                           height: 30.w,
                         ),
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 200.w,),

                 ///分享二维码-暂未开放
                 /*Container(
                width: 1.sw,
                margin: EdgeInsets.fromLTRB(20.w, 750.w, 20.w, 0),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.w))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.w,),
                      Text(
                        "由被分享者扫描您的共享码",
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 26.sp),
                      ),
                      SizedBox(height: 40.w,),
                      logic.codeUrl.value == ""?const SizedBox():Image.network("${logic.codeUrl}",
                        width: 260.w,
                        height: 260.w,
                        fit: BoxFit.fill,),
                      SizedBox(height: 60.w,),
                    ],
                  ),
                ),
              ),*/

               ],
             ),
           ),
         ),
       ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 1.sw,
                height: 1.w,
                margin: EdgeInsets.only(bottom:20.w),
                color: HhColors.grayDDTextColor,
              ),

              ///分享完成按钮
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {
                  if (logic.nameController!.text.isEmpty) {
                    EventBusUtil.getInstance()
                        .fire(HhToast(title: '请输入被分享人的用户名/手机号'));
                    return;
                  }
                  CommonUtils().showConfirmDialog(
                      logic.context, '确定要共享“${logic.arguments["appShareDetailSaveReqVOList"][0]["deviceName"]}”?', () {
                    Get.back();
                  }, () {
                    Get.back();
                    logic.shareSend();
                  }, () {
                    Get.back();
                  },rightStr: "共享");
                },
                child: Container(
                  height: 80.w,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 50.w),
                  decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.w))),
                  child: Center(
                    child: Text(
                      "确定",
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 30.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
