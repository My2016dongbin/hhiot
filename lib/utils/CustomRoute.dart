import 'package:flutter/material.dart';
class CustomRoute extends PageRouteBuilder{
  final Widget widget;
  int mode;
  int timer;

  CustomRoute(this.widget,this.mode,this.timer)
      :super(
    // 设置过度时间
      transitionDuration:Duration(milliseconds: timer??300),
      // 构造器
      pageBuilder:(
          // 上下文和动画
          BuildContext context,
          Animation<double> animaton1,
          Animation<double> animaton2,
          ){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animaton1,
          Animation<double> animaton2,
          Widget child,
          ){


        if(mode == 0 || mode == null){
          // 渐变效果
          return FadeTransition(
            // 从0开始到1
            opacity: Tween(begin: 0.0,end: 1.0)
                .animate(CurvedAnimation(
              // 传入设置的动画
              parent: animaton1,
              // 设置效果，快进漫出   这里有很多内置的效果
              curve: Curves.fastOutSlowIn,
            )),
            child: child,
          );
        }else if(mode == 1){
          //缩放动画效果
          return ScaleTransition(
            scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
                parent: animaton1,
                curve: Curves.fastOutSlowIn
            )),
            child: child,
          );
        }else if(mode == 2){
          // 旋转加缩放动画效果
          return RotationTransition(
            turns: Tween(begin: 0.0,end: 1.0)
                .animate(CurvedAnimation(
              parent: animaton1,
              curve: Curves.fastOutSlowIn,
            )),
            child: ScaleTransition(
              scale: Tween(begin: 0.0,end: 1.0)
                  .animate(CurvedAnimation(
                  parent: animaton1,
                  curve: Curves.fastOutSlowIn
              )),
              child: child,
            ),
          );
        }else if(mode == 3){
          // 左右滑动动画效果
          return SlideTransition(
            position: Tween<Offset>(
              // 设置滑动的 X , Y 轴
                begin: Offset(1.0, 0.0),
                end: Offset(0.0,0.0)
            ).animate(CurvedAnimation(
                parent: animaton1,
                curve: Curves.fastOutSlowIn
            )),
            child: child,
          );
        }else{
          // 左右滑动动画效果
          return SlideTransition(
            position: Tween<Offset>(
              // 设置滑动的 X , Y 轴
                begin: Offset(-1.0, 0.0),
                end: Offset(0.0,0.0)
            ).animate(CurvedAnimation(
                parent: animaton1,
                curve: Curves.fastOutSlowIn
            )),
            child: child,
          );
        }







      }
  );
}