//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:web_socket_channel/io.dart';
//
// class WebSocketSingleton {
//   static final WebSocketSingleton _singleton =
//   WebSocketSingleton._internal();
//
//   factory WebSocketSingleton() {
//     return _singleton;
//   }
//
//   WebSocketSingleton._internal();
//
//   IOWebSocketChannel? _channel;
//
//   bool get isConnected => _channel != null;
//
//   void connect(String url) {
//     if (_channel == null) {
//       _channel = IOWebSocketChannel.connect(url);
//     }
//   }
//
//   void disconnect() {
//     destroyHeartBeat();
//     if (_channel != null) {
//       _channel!.sink.close();
//       _channel = null;
//     }
//   }
//
//   void send(dynamic message) {
//     if (_channel != null) {
//       _channel!.sink.add(message.toString());
//
//     }
//   }
//
//   Timer? _heartBeat; // 心跳定时器
//   final int _heartTimes = 3000; // 心跳间隔(毫秒)
//
//   /// 初始化心跳
//   void initHeartBeat() {
//     destroyHeartBeat();
//     var counter = 300;
//     _heartBeat =
//         Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
//           print(isConnected);
//           print(counter--);
//           sentHeart();
//         });
//   }
//   /// 心跳
//   void sentHeart() {
//     var params = {
//       // 'user_id':userId,
//       // 'key':socketKey,
//       'type':-1,
//     };
//     var json = jsonEncode(params);
//     // print(json);
//     send(json);
//   }
//
//   /// 销毁心跳
//   void destroyHeartBeat() {
//     if (_heartBeat != null) {
//       _heartBeat!.cancel();
//       _heartBeat = null;
//     }
//   }
//
//
//   Stream<dynamic> get onMessage {
//     if (_channel != null) {
//       return _channel!.stream;
//     }
//     return const Stream.empty();
//   }
//   void onDone(){
//   }
// }
