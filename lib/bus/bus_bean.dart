class HhToast{
  String title;
  int ?type;//1 success 2 error 3 warn

  HhToast({required this.title,this.type});
}
class HhLoading{
  bool show;
  String ?title;

  HhLoading({required this.show,this.title});
}
class SpaceList{
  SpaceList();
}
class DeviceList{
  DeviceList();
}
class UserInfo{
  UserInfo();
}