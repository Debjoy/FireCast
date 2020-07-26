import 'dart:typed_data';

import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';

class VideoListScreen extends StatelessWidget {
  VideoListScreen({
    @required this.videoEntities,
  });
  final List<AssetEntity> videoEntities;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.video_library,
                    color: Colors.indigoAccent,
                    size: 30.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Videos",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.menu,
                    size: 40.0,
                    color: kPrimaryTextColor,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: videoEntities.length,
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              ImageLoader(
                                assetEntity: videoEntities[index],
                                isImageFiles: false,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(videoEntities[index].title),
                                      Text(
                                          Utils.convertTimeVideos(
                                              videoEntities[index].duration),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
