
class RequestUtils{
  static const base = 'http://172.16.50.87:10005';//debug

  static const login = '$base/admin-api/system/auth/login';//密码登录
  static const codeSend = '$base/admin-api/system/auth/send-sms-code';//发送验证码
  static const codeLogin = '$base/admin-api/system/auth/sms-login';//验证码登录
  static const userInfo = '$base/admin-api/system/user/profile/get';//个人信息查询
  static const weatherLocation = '$base/admin-api/mid/weather-now/getWeatherByLocation';//查询定位天气
}