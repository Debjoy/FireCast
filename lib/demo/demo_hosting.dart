import 'package:firecast_app/services/hosting_service.dart';
import 'package:flutter/material.dart';
import 'package:dhttpd/dhttpd.dart' as server;
import 'package:get_ip/get_ip.dart';

class DemoHosting extends StatefulWidget {
  @override
  _DemoHostingState createState() => _DemoHostingState();
}

class _DemoHostingState extends State<DemoHosting> {
  HostingService hostingService = HostingService();
  String location = "";
  String message = "";
  void startHosting() async {
    location = await hostingService.startHosting("/storage/emulated/0");
    setState(() {
      if (hostingService.serverHttp != null) message = "Server hosted";
    });
  }

  void stopHosting() async {
    await hostingService.stopHosting();
    setState(() {
      if (hostingService.serverHttp == null) message = "Server stopped";
      location = "";
    });
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
                startHosting();
              },
              child: Text("Start Hosting"),
            ),
            Text(location),
            Text(message),
            RaisedButton(
              onPressed: () {
                stopHosting();
              },
              child: Text("Stop Hosting"),
            )
          ],
        ),
      ),
    );
  }
}
