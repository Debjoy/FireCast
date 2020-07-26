import 'package:firecast_app/services/fling_service.dart';
import 'package:firecast_app/services/hosting_service.dart';
import 'package:flutter/material.dart';

class FlingTest extends StatefulWidget {
  @override
  _FlingTestState createState() => _FlingTestState();
}

class _FlingTestState extends State<FlingTest> {
  HostingService hostingService = HostingService();
  String location = "";
  String message = "";
  FlingService flingService = FlingService();

  void playMedia() {
    flingService.startMedia(
        "/storage/emulated/0/lol.mp4", (state, condition, position) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                playMedia();
              },
              child: Text("Play Media"),
            ),
            Text(location),
            Text(message),
            RaisedButton(
              onPressed: () {
                //stopHosting();
              },
              child: Text("Nothing"),
            )
          ],
        ),
      ),
    );
  }
}
