import 'dart:ui';
import 'package:firecast_app/demo/demo_hosting.dart';
import 'package:firecast_app/demo/demo_multimedia.dart';
import 'package:firecast_app/demo/fling_test.dart';
import 'package:firecast_app/screens/home_screen.dart';
import 'package:firecast_app/screens/parent_navigator.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firecast_app/keepalive/app_retain_widget.dart';
import 'package:firecast_app/keepalive/background_main.dart';

void main() {
  runApp(MyApp());

  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AppRetainWidget(
      child: ParentNavigator(),
    );
  }
}
