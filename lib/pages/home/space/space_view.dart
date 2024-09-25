import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/location/location_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import '../../../utils/HhColors.dart';
import 'space_controller.dart';

class SpacePage extends StatelessWidget {
  final logic = Get.find<SpaceController>();
  final logicLocation = Get.find<LocationController>();

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
        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              '添加空间',
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
              ///修改内容
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      maxLength: 30,
                      cursorColor: HhColors.titleColor_99,
                      controller: logic.accountController,
                      keyboardType: logic.pageStatus.value?TextInputType.number:TextInputType.text,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        counterText: '',
                        hintText: '请输入空间名称',
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
                  if(logic.accountController!.text.isEmpty){
                    EventBusUtil.getInstance().fire(HhToast(title: '请输入空间名称'));
                    return;
                  }
                  Future.delayed(const Duration(milliseconds: 500),(){
                    logic.createSpace();
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
    );
  }

}
