import 'dart:io';

import 'package:firecast_app/services/hosting_service.dart';
import 'package:firecast_app/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DemoMedia extends StatefulWidget {
  @override
  _DemoMediaState createState() => _DemoMediaState();
}

class _DemoMediaState extends State<DemoMedia> {
  String location = "";
  String message = "";

  HostingService hostingService = HostingService();
  void getMedia() async {
    PhotoManager.forceOldApi();
    List<AssetPathEntity> list =
        await PhotoManager.getAssetPathList(type: RequestType.video);
    List<AssetEntity> assetEntity = await list[2].assetList;
    //String mediaUrl = await assetEntity[0].getMediaUrl();
    File file = await assetEntity[0].file;
    //location = await hostingService
    //.startHosting(file.path.substring(0, file.path.lastIndexOf("/")));
    print(file.path);
    print(location);
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
                getMedia();
              },
              child: Text("get Media"),
            ),
            Text(location),
            Text(message),
            RaisedButton(
              onPressed: () {},
              child: Text("Stop Hosting"),
            )
          ],
        ),
      ),
    );
  }
}
