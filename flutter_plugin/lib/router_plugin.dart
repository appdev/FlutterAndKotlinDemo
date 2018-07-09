import 'dart:async';

import 'package:flutter/services.dart';

class RouterPlugin {

  static const MethodChannel _channel =
  const MethodChannel('router_plugin');

  static void startActivity(String activityClassName,
      [Map<String, dynamic> arguments]) =>
      _channel.invokeMethod("startActivity", {
        "activity": activityClassName,
        "arguments": arguments
      });

  static Future<dynamic> startActivityForResult(String activityClassName, int requestCode,
      [Map<String, dynamic> arguments]) =>
      _channel.invokeMethod("startActivityForResult", {
        "activity": activityClassName,
        "requestCode": requestCode,
        "arguments": arguments
      });

}
