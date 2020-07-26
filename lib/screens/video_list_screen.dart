import 'dart:typed_data';

import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              ImageLoader(
                                assetEntity: videoEntities[index],
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
                                      Text(videoEntities[index]
                                          .duration
                                          .toString()),
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

class ImageLoader extends StatefulWidget {
  final AssetEntity assetEntity;
  ImageLoader({@required this.assetEntity});
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  @override
  ImageLoader get widget => super.widget;
  Uint8List imageData;
  AssetEntity assetEntity;
  @override
  void initState() {
    super.initState();
    assetEntity = widget.assetEntity;
    loadImage();
  }

  loadImage() async {
    Uint8List data = await assetEntity.thumbData;
    setState(() {
      imageData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 80.0,
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        image: (imageData != null)
            ? (new DecorationImage(
                fit: BoxFit.cover, image: MemoryImage(imageData, scale: 0.5)))
            : null,
      ),
      child: imageData == null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          : null,
    );
  }
}
