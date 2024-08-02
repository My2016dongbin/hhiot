import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/login_binding.dart';
import 'package:iot/pages/common/login/login_view.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';

class CommonUtils{
  String msgString(String s){
    s = s.substring(s.indexOf(':')+1,s.length);
    return s;
  }
  String subString(String s,int num){
    try{
      s = s.substring(0,num);
    }catch(e){
      HhLog.e(e.toString());
    }
    return s;
  }
  Widget noneWidget({double? top}){
    return Column(
      children: [
        SizedBox(height: top??0.5.sw,),
        Image.asset('assets/images/common/ic_none.png',fit: BoxFit.fill,
          height: 0.4.sw,
          width: 0.5.sw,),
        Text('暂无数据',style: TextStyle(
            color: HhColors.grayBBTextColor,
            fontSize: 26.sp
        ),),
      ],
    );
  }
  Widget noneWidgetSmall({double? top}){
    return Column(
      children: [
        SizedBox(height: top??0.2.sw,),
        Image.asset('assets/images/common/ic_none.png',fit: BoxFit.fill,
          height: 0.2.sw,
          width: 0.2.sw,),
        Text('暂无数据',style: TextStyle(
            color: HhColors.grayBBTextColor,
            fontSize: 20.sp
        ),),
      ],
    );
  }

  ///通用Dialog（取消/确认）
  showCommonDialog(context,title,leftClick,rightClick,{String? leftStr,String? rightStr,String? hint}){
    showCupertinoDialog(context: context, builder: (BuildContext context) {
      return Container(
        child: Center(
          child: Container(
            height: hint==null?240.w:270.w,
            margin: EdgeInsets.fromLTRB(0.15.sw, 0, 0.15.sw, 0),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.w))),
              color: HhColors.whiteColor,
              shadowColor: HhColors.lineColor,
              elevation: 5,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment:Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 60.w),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(color: HhColors.whiteColor,child: Text("$title",style: TextStyle(color: HhColors.titleColor_99,fontSize: 26.sp),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)),
                          Offstage(offstage: hint==null,child: SizedBox(height: 20.h,)),
                          Offstage(offstage: hint==null,child: Material(color: HhColors.whiteColor,child: Text("$hint",style: TextStyle(color: HhColors.titleColor_33,fontSize: 26.sp),maxLines: 1,overflow: TextOverflow.ellipsis,))),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment:Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.w),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CommonButton(
                              height: 65.w,
                              fontSize: 26.sp,
                              backgroundColor: HhColors.whiteColor,
                              margin: EdgeInsets.fromLTRB(30.w, 0, 20.w, 0),
                              solid:true,
                              borderRadius: 35.w,
                              solidColor: HhColors.grayEDBackColor,
                              textColor: HhColors.titleColor_99,
                              text: leftStr??"取消", onPressed: leftClick,
                            ),
                          ),
                          Expanded(
                            child: CommonButton(
                              height: 65.w,
                              fontSize: 26.sp,
                              backgroundColor: HhColors.mainBlueColor,
                              margin: EdgeInsets.fromLTRB(20.w, 0, 30.w, 0),
                              borderRadius: 35.w,
                              textColor: HhColors.whiteColor,
                              text: rightStr??"确定", onPressed: rightClick,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, );
  }

  String mobileString(String s){
    if(s.length == 11){
      s =  "${s.substring(0,3)}****${s.substring(7,s.length)}";
    }
    return s;
  }

  tokenDown(){
    int now = DateTime.now().millisecondsSinceEpoch;
    if(now - CommonData.time > 2000){
      CommonData.time = now;
      Get.offAll(() => LoginPage(), binding: LoginBinding());
      Future.delayed(const Duration(seconds: 1),(){
        EventBusUtil.getInstance().fire(HhToast(title: '登录信息失效,请重新登录'));
      });
    }
  }
}

///通用Button
class CommonButton extends StatelessWidget{
  String text;
  double? width;
  double? height;
  double? widthPercent;
  EdgeInsets? margin;
  EdgeInsets? padding;
  double? fontSize;
  bool? solid;
  Color? backgroundColor;
  Color? solidColor;
  Color? textColor;
  double? borderRadius;
  double? elevation;
  Function onPressed;
  Alignment? textAlign;
  Function? onPointerDown;
  Function? onPointerUp;
  LinearGradient? gradient;
  String? image;

  CommonButton({required this.text, required this.onPressed, this.width, this.textAlign,  this.height,  this.image,  this.gradient, this.widthPercent,  this.margin,this.onPointerDown,  this.onPointerUp,    this.padding,  this.fontSize,  this.solid, this.backgroundColor, this.solidColor, this.textColor,
    this.borderRadius,this.elevation});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Listener(
      onPointerDown: (down){
        onPointerDown!();
      },
      onPointerUp: (up){
        onPointerUp!();
      },
      child:
      Container(
        height: height??85.w,
        width: width!=null?width:widthPercent!=null?screenWidth*widthPercent!:screenWidth,
        margin: margin??EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: (solid!=null&&solid!)||solidColor!=null?BoxDecoration(
          border: Border.all(color: solidColor??HhColors.transYellow,width: 1),
          borderRadius: BorderRadius.circular(borderRadius??10.w),
        ):null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius??10.w),
          child: Material(elevation: elevation??0.6,
            color: gradient!=null?null: ( backgroundColor??((solid!=null&&solid!)||solidColor!=null?HhColors.whiteColor:HhColors.transYellow) ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius??10.w))),
            child: InkWell(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: gradient
                  ),
                  alignment: textAlign??Alignment.center,padding:padding,child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  image==null?SizedBox():Container(
                      margin: EdgeInsets.fromLTRB(0, 5.w, 10.w, 0),
                      child: Image.asset("${image??""}",width: 36.w,height: 36.w,)
                  ),
                  Text(text,style: TextStyle(color: textColor??HhColors.whiteColor,fontSize: fontSize??16),maxLines: 1,textAlign: TextAlign.center,),
                ],
              )
              ),
              onTap: (){
                onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}