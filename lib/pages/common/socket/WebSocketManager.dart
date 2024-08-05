import 'dart:async';
import 'dart:convert';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
 
class WebSocketManager {
  late WebSocketChannel _channel;
  final String _serverUrl; //ws连接路径
  final String _accessToken; //登录携带的token
  bool _isConnected = false; //连接状态
  bool _isManuallyDisconnected = false; //是否为主动断开
  late Timer _heartbeatTimer; //心跳定时器
  late Timer _reconnectTimer; //重新连接定时器
  final Duration _reconnectInterval = const Duration(seconds: 5); //重新连接间隔时间
  final StreamController<String> _messageController = StreamController<String>();
 
  Stream<String> get messageStream => _messageController.stream; //监听的消息
 
  //初始化
  WebSocketManager(this._serverUrl, this._accessToken) {
    print('初始化');
    _heartbeatTimer = Timer(const Duration(seconds: 0), () {});
    _startConnection();
  }
 
  //建立连接
  void _startConnection() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_serverUrl));
      print('建立连接');
      _isConnected = true;
      _channel.stream.listen(
        (data) {
          _isConnected = true;
          print('已连接$data');
          final jsonObj = jsonDecode(data); // 将消息对象转换为 JSON 字符串

          _startHeartbeat();
          _onMessageReceived(data);// 其他消息转发出去
        },
        onError: (error) {
          // 处理连接错误
          print('连接错误: $error');
          _onError(error);
        },
        onDone: _onDone,
      );
      // _sendInitialData(); // 连接成功后发送登录信息();
    } catch (e) {
      // 连接错误处理
      print('连接异常错误: $e');
      _onError(e);
    }
  }
 
  //断开连接
  void disconnect() {
    print('断开连接');
    _isConnected = false;
    _isManuallyDisconnected = true;
    _stopHeartbeat();
    _messageController.close();
    _channel.sink.close();
  }
 
  //开始心跳
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      sendHeartbeat();
    });
  }
 
  //停止心跳
  void _stopHeartbeat() {
    _heartbeatTimer.cancel();
  }
 
  //重置心跳
  void _resetHeartbeat() {
    _stopHeartbeat();
    _startHeartbeat(); //开始心跳
  }
 
  // 发送心跳消息到服务器
  void sendHeartbeat() {
    if (_isConnected) {
      final message = {};
      final jsonString = jsonEncode(message); // 将消息对象转换为 JSON 字符串
      _channel.sink.add(jsonString); // 发送心跳
      print('连接成功发送心跳消息到服务器$message');
    }
  }
 
  // 登录
  void _sendInitialData() async {
    try {
      final message = {
        "cmd": 0,
        "data": {"accessToken": _accessToken}
      };
      final jsonString = jsonEncode(message); // 将消息对象转换为 JSON 字符串
      _channel.sink.add(jsonString); // 发送 JSON 字符串
      print('连接成功-发送登录信息$message');
    } catch (e) {
      // 连接错误处理
      print('连接异常错误: $e');
      _onError(e);
    }
  }
 
  //发送信息
  void sendMessage(dynamic message) {
    final data = {
      "cmd":3,
      "data":message
    };
    final jsonString = jsonEncode(message); // 将消息对象转换为 JSON 字符串
    _channel.sink.add(jsonString); // 发送 JSON 字符串
  }
 
  // 处理接收到的消息
  void _onMessageReceived(dynamic message) {
    HhLog.d('socket 处理接收到的消息 : $message');
    try{
      dynamic messageDecode = jsonDecode(message);
      HhLog.d('socket 处理接收到的消息 : $messageDecode');
      HhLog.d('socket 处理接收到的消息 : ${messageDecode["SessionId"]}');
      if(messageDecode['SessionId']!=null){
        CommonData.sessionId = messageDecode['SessionId'];
        HhLog.d('socket SessionId = ${CommonData.sessionId}');
      }
    }catch(e){

    }
    _messageController.add(message);
  }
 
  //异常
  void _onError(dynamic error) {
    // 处理错误
    print('Error: $error');
    _isConnected = false;
    _stopHeartbeat();
    if (!_isManuallyDisconnected) {
      // 如果不是主动断开连接，则尝试重连
      _reconnect();
    }
  }
 
  //关闭
  void _onDone() {
    print('WebSocket 连接已关闭');
    _isConnected = false;
    _stopHeartbeat();
    if (!_isManuallyDisconnected) {
      // 如果不是主动断开连接，则尝试重连
      _reconnect();
    }
  }
 
  // 重连
  void _reconnect() {
    // 避免频繁重连，启动重连定时器
    _reconnectTimer = Timer(_reconnectInterval, () {
      _isConnected = false;
      _channel.sink.close(); // 关闭之前的连接
      print('重连====================$_serverUrl===$_accessToken');
      _startConnection();
    });
  }
}