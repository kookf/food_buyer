import 'dart:async';
import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static EventBus? _eventBus;

  //获取单例
  static EventBus getInstance() {
    if (_eventBus == null) {
      _eventBus = EventBus();
    }
    return _eventBus!;
  }

  //返回某事件的订阅者
  static StreamSubscription<T> listen<T>(Function(T event) onData) {
    if (_eventBus == null) {
      _eventBus = EventBus();
    }
    //内部流属于广播模式，可以有多个订阅者
    return _eventBus!.on<T>().listen(onData);
  }

  //发送事件
  static void fire<T>(T e) {
    if (_eventBus == null) {
      _eventBus = EventBus();
    }
    _eventBus!.fire(e);
  }
}
