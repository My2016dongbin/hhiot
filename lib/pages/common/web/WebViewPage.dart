import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 与h5 端的一致 不然收不到消息
const String userAgent = 'YgsApp';
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.whiteColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.w),
            padding: EdgeInsets.fromLTRB(32.w, 38.w, 32.w, 38.w),
            color: HhColors.trans,
            child: SizedBox(
              child: Image.asset(
                "assets/images/common/back.png",
                width: 16.w,
                height: 26.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              color: HhColors.blackTextColor,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: HhColors.whiteColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}