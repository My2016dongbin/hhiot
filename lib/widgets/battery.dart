import 'package:flutter/material.dart';

class BatteryWidget extends StatelessWidget {
  final double width;
  final double height;
  final int batteryLevel; // 0~100

  const BatteryWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.batteryLevel,
  })  : assert(batteryLevel >= 0 && batteryLevel <= 100),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 定义内边距
    final double padding = width * 0.1;
    final double innerWidth = width - padding * 2;
    final double innerHeight = height - padding * 2;

    // 电量高度
    final double levelHeight = innerHeight * (batteryLevel / 100);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(width * 0.2),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: innerWidth,
            height: levelHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(innerWidth * 0.2),
            ),
          ),
        ),
      ),
    );
  }
}
