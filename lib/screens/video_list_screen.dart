import 'dart:typed_data';

import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';

class VideoListScreen extends StatelessWidget {
  VideoListScreen(
      {@required this.videoEntities,
      @required this.onConfirmLoadVideo,
      @required this.playerStarted,
      @required this.onFabButtonPressed,
      @required this.navigationController});
  final List<AssetEntity> videoEntities;
  final Function onConfirmLoadVideo;
  final bool playerStarted;
  final Function onFabButtonPressed;
  final FancyDrawerController navigationController;
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
                            color: kPrimaryTextColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    onTap: () {
                      navigationController.open();
                    },
                    child: Icon(
                      Icons.menu,
                      size: 40.0,
                      color: kPrimaryTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Container(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: videoEntities.length,
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 30.0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: InkWell(
                            onTap: () {
                              onConfirmLoadVideo(videoEntities[index]);
                            },
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
                                        Text(
                                          Utils.shortenTitle(
                                              videoEntities[index].title),
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                          ),
                                        ),
                                        Text(
                                            Utils.convertTimeVideos(
                                                videoEntities[index].duration),
                                            style: TextStyle(
                                              color: kPrimaryTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              fontFamily: "Roboto",
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
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: playerStarted
          ? FloatingActionButton(
              onPressed: onFabButtonPressed,
              backgroundColor: kPrimaryTextColor,
              child: Icon(Icons.cast_connected),
            )
          : null,
    );
  }
}
