
class RequestUtils{
  static const base = 'http://172.16.50.87:10008';//debug
  // static const base = 'http://117.132.5.139:18033/iot-api';//debug 外网

  static const login = '$base/admin-api/system/auth/login';//密码登录
  static const tenantId = '$base/admin-api/system/tenant/get-id-by-name';//获取租户id
  static const codeSend = '$base/admin-api/system/auth/send-sms-code';//发送验证码
  static const codeLogin = '$base/admin-api/system/auth/sms-login';//验证码登录
  static const userInfo = '$base/admin-api/system/user/profile/get';//个人信息查询
  static const codeRegisterSend = '$base/admin-api/system/auth/send-sms-code-register';//发送验证码-注册
  static const codeRegister = '$base/admin-api/system/auth/register';//注册
  static const weatherLocation = '$base/admin-api/mid/weather-now/getWeatherByLocation';//查询定位天气
  static const unReadCount = '$base/admin-api/system/message-log/getUnReadMessageCount';//主页未读消息数量查询
  static const mainSpaceList = '$base/admin-api/mid/space/page';//主页空间列表
  static const spaceCreate = '$base/admin-api/mid/space/create';//添加空间
  static const message = '$base/admin-api/system/message-log/page';//主页-消息-设备信息&&报警信息查询
  static const spaceInfo = '$base/admin-api/mid/space/get';//主页-空间-空间信息
  static const deviceInfo = '$base/admin-api/mid/device-base/get';//设备详情
  static const deviceHistory = '$base/admin-api/mid/device-alarm-info/page';//设备详情-历史消息
  static const deviceStream = '$base/admin-api/mid/device-base/findChannelListByDeviceNo';//设备通道查询
  static const devicePlayUrl = '$base/admin-api/mid/videoAggregation/devicePreviewUrl';//设备视频流查询
  static const deviceCreate = '$base/admin-api/mid/device-base/create';//设备添加
  static const deviceList = '$base/admin-api/mid/device-base/page';//设备查询
  static const userEdit = '$base/admin-api/system/user/profile/update';//修改个人信息
  static const mainSearch = '$base/admin-api/mid/space/getListByKeyWord';//主页查询空间设备及消息
  static const fileUpload = '$base/admin-api/infra/file/upload';//文件上传
  static const headerUpload = '$base/admin-api/system/user/profile/update-avatar';//个人头像上传
  static const password = '$base/admin-api/system/user/profile/update-password';//修改个人密码
  static const codeSendPersonal = '$base/admin-api/system/captcha/get';//发送验证码
  static const codeCheckPersonal = '$base/admin-api/system/captcha/check';//校验验证码

  ///Socket
  static const chatStatus = '$base/admin-api/mid/device-info/chatState';//获取设备通话状态GET
  static const chatCreate = '$base/admin-api/mid/device-info/chatState';//调用语音服务创建会话POST

  static const shareCreate = '$base/app-api/mid/share-log/create';//分享创建
  static const shareReceive = '$base/app-api/mid/receive-log/create';//分享接收


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