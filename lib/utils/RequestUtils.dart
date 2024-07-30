
class RequestUtils{
  static const base = 'http://172.16.50.87:10005';//debug

  static const login = '$base/admin-api/system/auth/login';//密码登录
  static const tenantId = '$base/admin-api/system/tenant/get-id-by-name';//获取租户id
  static const codeSend = '$base/admin-api/system/auth/send-sms-code';//发送验证码
  static const codeLogin = '$base/admin-api/system/auth/sms-login';//验证码登录
  static const userInfo = '$base/admin-api/system/user/profile/get';//个人信息查询
  static const weatherLocation = '$base/admin-api/mid/weather-now/getWeatherByLocation';//查询定位天气
  static const unReadCount = '$base/admin-api/system/message-log/getUnReadMessageCount';//主页未读消息数量查询
  static const mainSpaceList = '$base/admin-api/mid/space/page';//主页空间列表
  static const spaceCreate = '$base/admin-api/mid/space/create';//添加空间
  static const message = '$base/admin-api/system/message-log/page';//主页-消息-设备信息&&报警信息查询
  static const spaceInfo = '$base/admin-api/mid/space/get';//主页-空间-空间信息
  static const deviceInfo = '$base/admin-api/mid/device-base/get';//设备详情
  static const deviceStream = '$base/admin-api/mid/device-base/findChannelListByDeviceNo';//设备通道查询
  static const devicePlayUrl = '$base/admin-api/mid/videoAggregation/devicePreviewUrl';//设备视频流查询
  static const deviceCreate = '$base/admin-api/mid/device-base/create';//设备添加
  static const deviceList = '$base/admin-api/mid/device-base/page';//设备查询


  /*
    Map<String, dynamic> map = {};
    map['pageNo'] = '$pageKey';
    Future<void> getUnRead() async {
      var result = await HhHttp().request(RequestUtils.unReadCount,method: DioMethod.get,params:map);
      HhLog.d("getUnRead -- $result");
      if(result["code"]==0 && result["data"]!=null){
        count.value = '${result["data"]}';
      }else{
        EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
      }
    }
  */
}