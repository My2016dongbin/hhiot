import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/SPKeys.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../utils/HhColors.dart';
import '../home_controller.dart';
import 'message_controller.dart';

class MessagePage extends StatelessWidget {
  final logic = Get.find<MessageController>();
  final logicHome = Get.find<HomeController>();

  MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return OverlayTooltipScaffold(
      overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 1000),
      controller: logic.tipController,
      preferredOverlay: GestureDetector(
        onTap: () {
          logic.tipController.dismiss();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: HhColors.mainGrayColor,
        ),
      ),
      builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: HhColors.backColor,
            body: Obx(
                  () => Container(
                height: 1.sh,
                width: 1.sw,
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Container(
                      height: 160.w,
                      width: 1.sw,
                      color: HhColors.whiteColor,
                    ),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logicHome.index.value = 0;
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
                        padding: EdgeInsets.all(10.w),
                        color: HhColors.whiteColor,
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
                        height: 100.w,
                        margin: EdgeInsets.only(top: 75.w),
                        child: Row(
                          children: [
                            SizedBox(width: 100.w,),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                logic.tabIndex.value = 0;
                                resetEdit();
                                logic.pageNumRight = 1;
                                logic.fetchPageRight(1);
                              },
                              child: Container(
                                width: 130.w,
                                padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.topRight,
                                        child: Container(
                                            color: HhColors.trans,
                                            margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==0?0:10.w, 40.w, 0),
                                            child: Text("报警",style: TextStyle(color: logic.tabIndex.value==0?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==0?36.sp:28.sp,fontWeight: logic.tabIndex.value==0?FontWeight.bold:FontWeight.w200),))),
                                    logic.warnCount.value=="0"?const SizedBox():Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: HhColors.mainRedColor,
                                            borderRadius: BorderRadius.all(Radius.circular(20.w))
                                        ),
                                        width: 36.w + ((logic.noticeCount.value.length-1) * 8.w),
                                        height: 30.w,
                                        child: Center(child: Text(logic.warnCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 18.sp),)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                logic.tabIndex.value = 1;
                                resetEdit();
                                logic.dateListLeft = [];
                                logic.pageNumLeft = 1;
                                logic.fetchPageLeft(1);
                              },
                              child: Container(
                                width: 130.w,
                                padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.topRight,
                                        child: Container(
                                            color: HhColors.trans,
                                            margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==1?0:10.w, 40.w, 0),
                                            child: Text("通知",style: TextStyle(color: logic.tabIndex.value==1?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==1?36.sp:28.sp,fontWeight: logic.tabIndex.value==1?FontWeight.bold:FontWeight.w200),))),
                                    logic.noticeCount.value=="0"?const SizedBox():Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: HhColors.mainRedColor,
                                            borderRadius: BorderRadius.all(Radius.circular(20.w))
                                        ),
                                        width: 36.w + ((logic.noticeCount.value.length-1) * 8.w),
                                        height: 30.w,
                                        child: Center(child: Text(logic.noticeCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 18.sp),)),
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
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 85.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                CommonUtils().showDeleteDialog(context, "确定要已读所有消息记录？", (){
                                  Get.back();
                                }, (){
                                  logic.readAll();
                                  Get.back();
                                },(){
                                  Get.back();
                                },leftStr: "取消",rightStr: "确定");
                              },
                              child: Image.asset(
                                "assets/images/common/icon_clear_message.png",
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 15.w,),

                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: (){
                                logic.tipController.start();
                              },
                              child: OverlayTooltipItem(
                                displayIndex: 0,
                                tooltip: (controller) {
                                  return BouncingWidget(
                                    duration: const Duration(milliseconds: 100),
                                    scaleFactor: 1.2,
                                    onPressed: (){
                                      logic.tipController.dismiss();
                                      if(logic.tabIndex.value==0){
                                        // logic.editLeft.value = true;
                                        logic.editLeft.value = !logic.editLeft.value;
                                      }else{
                                        // logic.editRight.value = true;
                                        logic.editRight.value = !logic.editRight.value;
                                      }
                                      logic.pageStatus.value = false;
                                      logic.pageStatus.value = true;
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10.w),
                                      padding: EdgeInsets.fromLTRB(36.w, 38.w, 23.w, 38.w),
                                      decoration: BoxDecoration(
                                          color: HhColors.whiteColor,
                                          borderRadius: BorderRadius.circular(26.w)
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('管理消息', style: TextStyle(color: HhColors.blackColor,fontSize: 26.w,fontWeight: FontWeight.w200),),
                                          SizedBox(width: 30.w,),
                                          Image.asset(
                                            "assets/images/common/ic_setting.png",
                                            width: 30.w,
                                            height: 30.w,
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/common/icon_more_message.png",
                                  width: 50.w,
                                  height: 50.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 30.w,),
                          ],
                        ),
                      ),
                    ),

                    logic.pageStatus.value ? (logic.tabIndex.value==0 ? leftMessage() : rightMessage()):const SizedBox(),
                  ],
                ),
              ),
            ));
      },
    );
  }

  leftMessage() {
    DateTime dateTime = DateTime.now();
    String today = CommonUtils().parseLongTimeYearDay("${dateTime.millisecondsSinceEpoch}");
    return Container(
      margin: EdgeInsets.only(top: 160.w),
      child: Column(
        children: [
          ///筛选
          Container(
            width: 1.sw,
            height: 90.w,
            color: HhColors.whiteColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 20.w,),
                  Container(
                    width: 280.w,
                      padding:EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          border: Border.all(width: 0.5.w,color: HhColors.gray9TextColor)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/icon_search.png",
                            width: 30.w,
                            height: 30.w,
                            fit: BoxFit.fill,
                          ),
                          // Text('请输入设备名称',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 23.sp),),
                          Expanded(
                            child: SizedBox(
                              height: 40.w,
                              child: TextField(
                                // maxLines: 1,
                                maxLength: 8,
                                cursorColor: HhColors.titleColor_99,
                                controller: logic.deviceNameController,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (s){
                                  logic.dateListLeft = [];
                                  logic.pageNumLeft = 1;
                                  logic.fetchPageLeft(1);
                                },
                                decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.fromLTRB(0, 0.w, 0, 20.w),
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: '请输入设备名称',
                                  hintStyle: TextStyle(
                                      color: HhColors.gray9TextColor, fontSize: 23.sp),
                                  floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                ),
                                style:
                                TextStyle(color: HhColors.gray9TextColor, fontSize: 23.sp),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  InkWell(
                    onTap: (){
                      logic.isChooseType.value = false;
                      logic.isChooseDate.value = false;
                      logic.isChooseSpace.value = !logic.isChooseSpace.value;
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 40.w),
                        padding:EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            border: Border.all(width: logic.isChooseSpace.value?1.5.w:0.5.w,color: logic.isChooseSpace.value?HhColors.mainBlueColor:HhColors.gray9TextColor)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${logic.spaceList.value[logic.spaceSelectIndex.value]["name"]}',style: TextStyle(color: logic.isChooseSpace.value?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 23.sp),),
                            Image.asset(
                              "assets/images/common/icon_down_status.png",
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.fill,
                            ),
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: (){
                      logic.isChooseSpace.value = false;
                      logic.isChooseDate.value = false;
                      logic.isChooseType.value = !logic.isChooseType.value;
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 40.w),
                        padding:EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            border: Border.all(width: logic.isChooseType.value?1.5.w:0.5.w,color: logic.isChooseType.value?HhColors.mainBlueColor:HhColors.gray9TextColor)
                        ),child: Row(
                      mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${logic.typeList[logic.typeSelectIndex.value]["name"]}',style: TextStyle(color: logic.isChooseType.value?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 23.sp),),
                            Image.asset(
                              "assets/images/common/icon_down_status.png",
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.fill,
                            ),
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: (){
                      logic.isChooseSpace.value = false;
                      logic.isChooseType.value = false;
                      logic.isChooseDate.value = !logic.isChooseDate.value;
                      if(logic.isChooseDate.value){
                        chooseDate();
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 40.w),
                        padding:EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            border: Border.all(width: logic.isChooseDate.value?1.5.w:0.5.w,color: logic.isChooseDate.value?HhColors.mainBlueColor:HhColors.gray9TextColor)
                        ),child: Row(
                      mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_date_message.png",
                              width: 32.w,
                              height: 32.w,
                              fit: BoxFit.fill,
                            ),
                            Text('${logic.dateStr}',style: TextStyle(color: logic.isChooseDate.value?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 21.sp),),
                          ],
                        )),
                  ),
                  SizedBox(width: 20.w,),
                ],
              ),
            ),
          ),
          //空间
          logic.isChooseSpace.value?Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: buildSpaceListView(),
              ),
              Stack(
                children: [
                  Container(
                    height: 100.w,
                    width: 1.sw,
                    color: HhColors.whiteColor,
                  ),
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    child: Container(
                      width: 1.sw,
                      height: 80.w,
                      margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                      decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius: BorderRadius.all(Radius.circular(50.w))),
                      child: Center(
                        child: Text(
                          "确定",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: HhColors.whiteColor, fontSize: 28.sp),
                        ),
                      ),
                    ),
                    onPressed: () {
                      logic.isChooseSpace.value = false;
                      logic.dateListLeft = [];
                      logic.pageNumLeft = 1;
                      logic.fetchPageLeft(1);
                    },
                  )
                ],
              )
            ],
          ):const SizedBox(),
          //类型
          logic.isChooseType.value?Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                children: buildTypeListView(),
              ),
              Stack(
                children: [
                  Container(
                    height: 100.w,
                    width: 1.sw,
                    color: HhColors.whiteColor,
                  ),
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    child: Container(
                      width: 1.sw,
                      height: 80.w,
                      margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                      decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius: BorderRadius.all(Radius.circular(50.w))),
                      child: Center(
                        child: Text(
                          "确定",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: HhColors.whiteColor, fontSize: 28.sp),
                        ),
                      ),
                    ),
                    onPressed: () {
                      logic.isChooseType.value = false;
                      logic.dateListLeft = [];
                      logic.pageNumLeft = 1;
                      logic.fetchPageLeft(1);
                    },
                  )
                ],
              )
            ],
          ):const SizedBox(),
          ///报警列表
          Expanded(
            child: EasyRefresh(
              onRefresh: (){
                logic.dateListLeft = [];
                logic.pageNumLeft = 1;
                logic.fetchPageLeft(1);
              },
              onLoad: (){
                logic.pageNumLeft++;
                logic.fetchPageLeft(logic.pageNumLeft);
              },
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.deviceController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message_search.png',info: '没有找到匹配的结果',mid: 50.w,
                    height: 0.32.sw,
                    width: 0.4.sw,),
                  itemBuilder: (context, item, index) {
                    if(item["showDate"]==null){
                      if(logic.dateListLeft.contains(CommonUtils().parseLongTimeYearDay('${item['createTime']}'))){
                        item["showDate"] = 0;
                      }else{
                        item["showDate"] = 1;
                        logic.dateListLeft.add(CommonUtils().parseLongTimeYearDay('${item['createTime']}'));
                      }
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        item["showDate"]==1?Container(
                          margin: EdgeInsets.fromLTRB(22.w, 20.w, 20.w, 0),
                          child: Row(
                            children: [
                              Text(
                                today == CommonUtils().parseLongTimeYearDay('${item['createTime']}')?'今天':CommonUtils().parseLongTimeDay('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5.w,),
                              Expanded(
                                child: Text(
                                  '————————————————————————————————————————————————————————————————————————————',
                                  maxLines: 1,
                                  style: TextStyle(
                                      letterSpacing: 10.w,
                                      color: HhColors.grayCCTextColor, fontSize: 20.sp),
                                ),
                              ),
                            ],
                          ),
                        ):const SizedBox(),
                        InkWell(
                          onTap: (){
                            if(logic.editLeft.value){
                              item["selected"] == 1?item["selected"]=0:item["selected"]=1;
                              logic.pageStatus.value = false;
                              logic.pageStatus.value = true;
                              if(item["selected"] == 1){
                                if(!logic.chooseListLeft.contains(item["id"])){
                                  logic.chooseListLeft.add(item["id"]);
                                }
                              }else{
                                if(logic.chooseListLeft.contains(item["id"])){
                                  logic.chooseListLeft.remove(item["id"]);
                                }
                              }
                              logic.chooseListLeftNumber.value = logic.chooseListLeft.length;
                              HhLog.d("list -- ${logic.chooseListLeft}");
                            }
                          },
                          child: Row(
                            children: [
                              logic.editLeft.value?Container(
                                padding: EdgeInsets.fromLTRB(20.w, 20.w, 0, 20.w),
                                child: Image.asset(
                                  item["selected"] == 1?"assets/images/common/yes.png":"assets/images/common/no.png",
                                  width: 36.w,
                                  height: 36.w,
                                  fit: BoxFit.fill,
                                ),
                              ):const SizedBox(),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                                  padding: EdgeInsets.all(20.w),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10.w))
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200.w,
                                        height: 130.w,
                                        child: Stack(
                                          children: [
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12.w),
                                              ),
                                              child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                                                "assets/images/common/icon_message_back.png",
                                                width: 200.w,
                                                height: 130.w,
                                                fit: BoxFit.fill,
                                              ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                                                return Image.asset(
                                                  "assets/images/common/test_video.jpg",
                                                  width: 200.w,
                                                  height: 130.w,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                                width: 200.w,
                                                height: 130.w,
                                                fit: BoxFit.fill,),
                                            ),
                                            item['alarmType']=='tilt'?Align(
                                              alignment:Alignment.center,
                                              child: Image.asset(
                                                "assets/images/common/icon_message_y.png",
                                                width: 50.w,
                                                height: 50.w,
                                                fit: BoxFit.fill,
                                              ),
                                            ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                                              alignment:Alignment.center,
                                              child: Image.asset(
                                                "assets/images/common/icon_message_open.png",
                                                width: 50.w,
                                                height: 50.w,
                                                fit: BoxFit.fill,
                                              ),
                                            ):const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 130.w,
                                          child: Stack(
                                            children: [
                                              item['status'] == true?const SizedBox():Container(
                                                height: 10.w,
                                                width: 10.w,
                                                margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                                                decoration: BoxDecoration(
                                                    color: HhColors.backRedInColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(5.w))
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                                                child: Text(
                                                  parseLeftType("${item['alarmType']}"),
                                                  style: TextStyle(
                                                      color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      CommonUtils().parseNull('${item['deviceName']}',""),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: HhColors.textColor, fontSize: 22.sp),
                                                    ),
                                                    SizedBox(height: 5.w,),
                                                    Text(
                                                      CommonUtils().parseNull('${item['spaceName']}', ""),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: HhColors.textColor, fontSize: 22.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 5.w),
                                                  child: Text(
                                                    CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                                                    style: TextStyle(
                                                        color: HhColors.textColor, fontSize: 22.sp),
                                                  ),
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
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          ///编辑操作面板
          logic.editLeft.value?Container(
            height: 100.w,
            width: 1.sw,
            color: HhColors.whiteColor,
            child: Row(
              children: [
                SizedBox(width: 20.w,),
                Text(
                  '已选：',
                  style: TextStyle(
                      color: HhColors.gray6TextColor, fontSize: 22.sp),
                ),
                Text(
                  '${logic.chooseListLeftNumber.value}条',
                  style: TextStyle(
                      color: HhColors.gray6TextColor, fontSize: 22.sp),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.0,
                        onPressed: (){
                          if(logic.chooseListLeftNumber.value == 0){
                            EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                            return;
                          }
                          logic.readLeft();
                        },
                        child: Container(
                          padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                          decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.circular(12.w)
                          ),
                          child: Text(
                            '全部已读',
                            style: TextStyle(
                                color: HhColors.whiteColor, fontSize: 22.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.0,
                        onPressed: (){
                          if(logic.chooseListLeftNumber.value == 0){
                            EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                            return;
                          }

                          CommonUtils().showDeleteDialog(logic.context, "确定要删除所选消息记录？", (){
                            Get.back();
                          }, (){
                            logic.deleteLeft();
                            Get.back();
                          },(){
                            Get.back();
                          },leftStr: "取消",rightStr: "删除");
                        },
                        child: Container(
                          padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                          decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            border: Border.all(color: HhColors.mainBlueColor,width: 0.5.w),
                            borderRadius: BorderRadius.circular(12.w)
                          ),
                          child: Text(
                            '全部删除',
                            style: TextStyle(
                                color: HhColors.mainBlueColor, fontSize: 22.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                    ],
                  ),
                ),
              ],
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }

  rightMessage() {
    return Column(
      children: [
        ///通知列表
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 160.w),
            child: EasyRefresh(
              onRefresh: (){
                logic.pageNumRight = 1;
                logic.fetchPageRight(1);
              },
              onLoad: (){
                logic.pageNumRight++;
                logic.fetchPageRight(logic.pageNumRight);

              },
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.warnController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message.png',info: '暂无消息',mid: 50.w,
                    height: 0.32.sw,
                    width: 0.4.sw,),
                  itemBuilder: (context, item, index) {
                    return InkWell(
                      onTap: (){
                        if(logic.editRight.value){
                          item["selected"] == 1?item["selected"]=0:item["selected"]=1;
                          logic.pageStatus.value = false;
                          logic.pageStatus.value = true;
                          if(item["selected"] == 1){
                            if(!logic.chooseListRight.contains(item["id"])){
                              logic.chooseListRight.add(item["id"]);
                            }
                          }else{
                            if(logic.chooseListRight.contains(item["id"])){
                              logic.chooseListRight.remove(item["id"]);
                            }
                          }
                          logic.chooseListRightNumber.value = logic.chooseListRight.length;
                          HhLog.d("list right -- ${logic.chooseListRight}");
                        }
                      },
                      child: Row(
                        children: [
                          logic.editRight.value?Container(
                            padding: EdgeInsets.fromLTRB(20.w, 20.w, 0, 20.w),
                            child: Image.asset(
                              item["selected"] == 1?"assets/images/common/yes.png":"assets/images/common/no.png",
                              width: 36.w,
                              height: 36.w,
                              fit: BoxFit.fill,
                            ),
                          ):const SizedBox(),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                              padding: EdgeInsets.all(20.w),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.w))
                              ),
                              child: Stack(
                                children: [
                                  item['status']==true?const SizedBox():Container(
                                    height: 10.w,
                                    width: 10.w,
                                    margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                                    decoration: BoxDecoration(
                                        color: HhColors.backRedInColor,
                                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                                    child: Text(
                                      parseRightType("${item['messageType']}"),
                                      style: TextStyle(
                                          color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "时间:${CommonUtils().parseLongTime('${item['createTime']}')}",
                                          style: TextStyle(
                                              color: HhColors.textColor, fontSize: 22.sp),
                                        ),
                                        SizedBox(height: 8.w,),
                                        Text(
                                          '${item['content']}',
                                          style: TextStyle(
                                              color: HhColors.textColor, fontSize: 22.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        ///编辑操作面板
        logic.editRight.value?Container(
          height: 100.w,
          width: 1.sw,
          color: HhColors.whiteColor,
          child: Row(
            children: [
              SizedBox(width: 20.w,),
              Text(
                '已选：',
                style: TextStyle(
                    color: HhColors.gray6TextColor, fontSize: 22.sp),
              ),
              Text(
                '${logic.chooseListRightNumber.value}条',
                style: TextStyle(
                    color: HhColors.gray6TextColor, fontSize: 22.sp),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.0,
                      onPressed: (){
                        if(logic.chooseListRightNumber.value == 0){
                          EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                          return;
                        }
                        logic.readRight();
                      },
                      child: Container(
                        padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.circular(12.w)
                        ),
                        child: Text(
                          '全部已读',
                          style: TextStyle(
                              color: HhColors.whiteColor, fontSize: 22.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w,),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.0,
                      onPressed: (){
                        if(logic.chooseListRightNumber.value == 0){
                          EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                          return;
                        }
                        CommonUtils().showDeleteDialog(logic.context, "确定要删除所选消息记录？", (){
                          Get.back();
                        }, (){
                          logic.deleteRight();
                          Get.back();
                        },(){
                          Get.back();
                        },leftStr: "取消",rightStr: "删除");
                      },
                      child: Container(
                        padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            border: Border.all(color: HhColors.mainBlueColor,width: 0.5.w),
                            borderRadius: BorderRadius.circular(12.w)
                        ),
                        child: Text(
                          '全部删除',
                          style: TextStyle(
                              color: HhColors.mainBlueColor, fontSize: 22.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w,),
                  ],
                ),
              ),
            ],
          ),
        ):const SizedBox(),
      ],
    );

      /*Container(
        margin: EdgeInsets.only(top: 160.w),
        child: EasyRefresh(
          controller: logic.rightRefreshController,
          onRefresh: (){
            logic.pageNumRight = 1;
            logic.fetchPageRight(1);
          },
          onLoad: (){
            logic.pageNumRight++;
            logic.fetchPageRight(logic.pageNumRight);
            logic.rightRefreshController.finishLoad();

          },
          child: PagedListView<int, dynamic>(
            padding: EdgeInsets.zero,
            pagingController: logic.warnController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/no_message.png',info: '暂无消息',mid: 50.w,
                height: 0.32.sw,
                width: 0.6.sw,),
              itemBuilder: (context, item, index) => Container(
                margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                padding: EdgeInsets.all(20.w),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 10.w,
                      width: 10.w,
                      margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                      decoration: BoxDecoration(
                          color: HhColors.backRedInColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.w))
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                      child: Text(
                        "${item['messageType']}",
                        style: TextStyle(
                            color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 40.w, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "时间:${item['id']}",
                            style: TextStyle(
                                color: HhColors.textColor, fontSize: 22.sp),
                          ),
                          SizedBox(height: 8.w,),
                          Text(
                            '${item['content']}',
                            style: TextStyle(
                                color: HhColors.textColor, fontSize: 22.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );*/
  }

  void resetEdit() {
    logic.editLeft.value = false;
    logic.editRight.value = false;
  }

  String parseRightType(String s) {
    if(s == "deviceAlarm"){
      return "设备报警通知";
    }
    return "通知";
  }

  String parseLeftType(String s) {
    if(s == "openCap"){
      return "箱盖开箱报警";
    }
    if(s == "human"){
      return "人员入侵报警";
    }
    if(s == "car"){
      return "车辆入侵报警";
    }
    if(s == "openSensor"){
      return "传感器开箱报警";
    }
    if(s == "tilt"){
      return "设备倾斜报警";
    }
    return "报警";
  }

  buildSpaceListView() {
    List<Widget> list = [];
    for(int i = 0; i < logic.spaceList.value.length; i++){
      dynamic type = logic.spaceList.value[i];
      list.add(
        InkWell(
          onTap: (){
            logic.spaceSelectIndex.value = i;
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 15.w, 20.w, 15.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${type["name"]}',style: TextStyle(color: logic.spaceSelectIndex.value == i?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 23.sp),),
                SizedBox(width: 10.w,),
                logic.spaceSelectIndex.value == i?Image.asset(
                  "assets/images/common/icon_yes.png",
                  width: 30.w,
                  height: 30.w,
                  fit: BoxFit.fill,
                ):const SizedBox(),
              ],
            ),
          ),
        )
      );
    }
    return list;
  }

  buildTypeListView() {
    List<Widget> list = [];
    for(int i = 0; i < logic.typeList.length; i++){
      dynamic type = logic.typeList[i];
      list.add(
        InkWell(
          onTap: (){
            logic.typeSelectIndex.value = i;
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 15.w, 20.w, 15.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${type["name"]}',style: TextStyle(color: logic.typeSelectIndex.value == i?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 23.sp),),
                SizedBox(width: 10.w,),
                logic.typeSelectIndex.value == i?Image.asset(
                  "assets/images/common/icon_yes.png",
                  width: 30.w,
                  height: 30.w,
                  fit: BoxFit.fill,
                ):const SizedBox(),
              ],
            ),
          ),
        )
      );
    }
    return list;
  }

  void chooseDate() {
    showModalBottomSheet(context: logic.context, builder: (a){
      bool choose = false;
      return Container(
        width: 1.sw,
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.w,),
            Stack(
              children: [
                Container(margin: EdgeInsets.only(top: 15.w),
                    child: Center(child: Text('选择日期',style: TextStyle(color: HhColors.blackColor,fontSize: 26.sp),))),
                Align(
                  alignment: Alignment.topRight,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      logic.isChooseDate.value = false;
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.w, 20.w, 30.w, 20.w),
                      child: Image.asset(
                        "assets/images/common/ic_x.png",
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      logic.dateStr.value="日期";

                      Get.back();
                      logic.isChooseDate.value = false;
                      logic.dateListLeft = [];
                      logic.pageNumLeft = 1;
                      logic.fetchPageLeft(1);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(50.w, 20.w, 20.w, 20.w),
                      child: Text('重置',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 23.sp),),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: RangeDatePicker(
                centerLeadingDate: true,
                minDate: DateTime(2000, 10, 10),
                maxDate: DateTime(2099, 10, 30),
                onRangeSelected: (value) {
                  choose = true;
                  logic.start = value.start;
                  logic.end = value.end;
                  HhLog.d("RangeDatePicker ${value.start.toIso8601String()} , ${value.end.toIso8601String()}");
                },
                slidersColor: HhColors.blackColor,
                leadingDateTextStyle:TextStyle(color: HhColors.blackColor,fontSize: 32.sp,fontWeight: FontWeight.bold),
                splashColor: HhColors.mainBlueColor,
                highlightColor: HhColors.mainBlueColor,
                currentDateTextStyle:TextStyle(color: HhColors.whiteColor,fontSize: 32.sp),
                currentDateDecoration:BoxDecoration(color:HhColors.mainBlueColor.withAlpha(100)),
                disabledCellsTextStyle:TextStyle(color: HhColors.grayEDBackColor,fontSize: 32.sp),
                enabledCellsTextStyle:TextStyle(color: HhColors.gray8TextColor,fontSize: 32.sp),
                selectedCellsTextStyle:TextStyle(color: HhColors.mainBlueColor.withAlpha(100),fontSize: 32.sp),
                selectedCellsDecoration:BoxDecoration(color:HhColors.mainBlueColor.withAlpha(60)),
                singleSelectedCellDecoration:BoxDecoration(color:HhColors.mainBlueColor,borderRadius: BorderRadius.circular(100.w)),
                singleSelectedCellTextStyle: TextStyle(color: HhColors.whiteColor,fontSize: 36.sp),
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              child: Container(
                width: 1.sw,
                height: 80.w,
                margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                decoration: BoxDecoration(
                    color: HhColors.mainBlueColor,
                    borderRadius: BorderRadius.all(Radius.circular(50.w))),
                child: Center(
                  child: Text(
                    "确定",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HhColors.whiteColor, fontSize: 28.sp),
                  ),
                ),
              ),
              onPressed: () {
                if(!choose){
                  EventBusUtil.getInstance().fire(HhToast(title: '请先选择日期'));
                  return;
                }
                logic.dateStr.value = "${logic.start.toIso8601String().substring(0,10)} 00:00:00-${logic.end.toIso8601String().substring(0,10)} 23:59:59";
                Get.back();
                logic.isChooseDate.value = false;
                logic.dateListLeft = [];
                logic.pageNumLeft = 1;
                logic.fetchPageLeft(1);
              },
            )
          ],
        ),
      );
    },isDismissible: false,enableDrag: false);
  }
}
