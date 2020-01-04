import 'dart:async';

import 'package:flutter/services.dart';

class Copyapp {
  static const MethodChannel _channel =
      const MethodChannel('jsz_plugin_method');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> getRunning(n) async {
    final int version = await _channel.invokeMethod('getRunning', <String, int>{"num": n});
    return version;
  }
}
