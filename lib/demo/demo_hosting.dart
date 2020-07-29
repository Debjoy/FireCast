import 'dart:io';

import 'package:firecast_app/services/hosting_service.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:http_server/http_server.dart';

class DemoHosting extends StatefulWidget {
  @override
  _DemoHostingState createState() => _DemoHostingState();
}

class _DemoHostingState extends State<DemoHosting> {
  HostingService hostingService = HostingService();
  String location = "";
  String message = "";
  void startHosting() async {
//    location = await hostingService.startHosting("/storage/emulated/0");
//    setState(() {
//      if (hostingService.serverHttp != null) message = "Server hosted";
//    });
    String ipAddress = await GetIp.ipAddress;
    var staticFiles = new VirtualDirectory('/storage/emulated/0')
      ..allowDirectoryListing = true;

    ///storage/3632-3034/Movies/ANIME/Season 4 [Book 4 - Balance]/Book Four - Balance.jpg
    ///storage/3632-3034/DCIM/Camera/IMG_20200324_204828.jpg
    ///
    await HttpServer.bind(ipAddress, 8082).then((server) {
      print('Server Called');
      server.listen(staticFiles.serveRequest);
    });

    print("Server Started");
  }

  void stopHosting() async {
    await hostingService.stopHosting();
    setState(() {});
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
