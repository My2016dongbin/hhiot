class MainGridModel{
  String ?name;
  String ?picUrl;
  String ?videoUrl;
  int ?count;
  bool ?status;

  MainGridModel(this.name, this.picUrl, this.videoUrl, this.count, this.status);
}
class DeviceMessage{
  String ?name;
  String ?content;
  String ?time;
  bool ?status;

  DeviceMessage(this.name, this.content, this.time, this.status);
}
class WarnMessage{
  String ?name;
  String ?content;
  String ?time;
  bool ?status;

  WarnMessage(this.name, this.content, this.time, this.status);
}

class SearchModel{

}

class DeviceModel{

}

class MessageModel{

}