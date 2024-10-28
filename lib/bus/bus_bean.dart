class HhToast{
  String title;
  int ?type;//1 success 2 error 3 warn
  int ?color;//0 white

  HhToast({required this.title,this.type,this.color});
}
class HhLoading{
  bool show;
  String ?title;

  HhLoading({required this.show,this.title});
}
class LocText{
  String ?text;

  LocText({required this.text});
}
class CatchRefresh{
  CatchRefresh();
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
class Message{
  Message();
}
class DeviceInfo{
  DeviceInfo();
}
class Share{
  dynamic model;
  Share({required this.model});
}