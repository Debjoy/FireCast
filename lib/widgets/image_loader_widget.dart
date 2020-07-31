import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  final AssetEntity assetEntity;
  final bool isImageFiles;
  final bool isCastImageMode;
  ImageLoader(
      {@required this.assetEntity,
      @required this.isImageFiles,
      this.isCastImageMode = false,
      Key key})
      : super(key: key);
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  @override
  ImageLoader get widget => super.widget;
  Uint8List imageData;
  AssetEntity assetEntity;
  bool imageFailed = false;
  bool isCastImageMode = false;
  bool isImageFiles;
  bool isCorrupt = false;
  @override
  void initState() {
    super.initState();
    assetEntity = widget.assetEntity;
    isImageFiles = widget.isImageFiles;
    isCastImageMode = widget.isCastImageMode;
    loadImage();
  }

  loadImage() async {
    String extension =
        assetEntity.title.substring(assetEntity.title.lastIndexOf(".") + 1);
    if (extension != "mkv") {
      Uint8List data = await assetEntity.thumbData;

      setState(() {
        if (data == null) {
          imageFailed = true;
        }
        imageData = data;
      });
    }
    {
      setState(() {
        isCorrupt = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (!isImageFiles || isCastImageMode) ? 60.0 : 80.0,
      width: (!isImageFiles || isCastImageMode) ? 80.0 : null,
      decoration: BoxDecoration(
        color:
            isImageFiles ? Colors.orangeAccent[100] : Colors.indigoAccent[100],
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        image: (imageData != null && !imageFailed)
            ? (new DecorationImage(
                fit: BoxFit.cover, image: MemoryImage(imageData, scale: 0.5)))
            : null,
      ),
      child: imageData == null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Icon(
                isCorrupt
                    ? Icons.broken_image
                    : (isImageFiles ? Icons.image : Icons.videocam),
                color: Colors.white70,
              ),
            )
          : null,
    );
  }
}

class PlayerImageLoader extends StatefulWidget {
  final AssetEntity assetEntity;
  final bool isImageFiles;
  PlayerImageLoader(
      {@required this.assetEntity, @required this.isImageFiles, Key key})
      : super(key: key);
  @override
  _PlayerImageLoaderState createState() => _PlayerImageLoaderState();
}

class _PlayerImageLoaderState extends State<PlayerImageLoader> {
  @override
  PlayerImageLoader get widget => super.widget;
  Uint8List imageData;
  AssetEntity assetEntity;
  bool imageFailed = false;
  bool isImageFiles;
  @override
  void initState() {
    super.initState();
    assetEntity = widget.assetEntity;
    isImageFiles = widget.isImageFiles;
    loadImage();
  }

  loadImage() async {
    Uint8List data = await assetEntity.thumbData;
    setState(() {
      if (data == null) {
        imageFailed = true;
      }
      imageData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color:
            isImageFiles ? Colors.orangeAccent[100] : Colors.indigoAccent[100],
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        image: (imageData != null && !imageFailed)
            ? (new DecorationImage(
                fit: BoxFit.cover, image: MemoryImage(imageData, scale: 0.5)))
            : null,
      ),
      child: imageData == null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Icon(
                isImageFiles ? Icons.image : Icons.videocam,
                color: Colors.white70,
              ),
            )
          : null,
    );
  }
}
