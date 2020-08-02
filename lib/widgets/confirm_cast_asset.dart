import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'image_loader_widget.dart';

class ConfirmAsset extends StatelessWidget {
  ConfirmAsset(
      {@required this.assetEntity,
      @required this.image,
      @required this.isImage,
      @required this.castAsset,
      @required this.onCancel});
  final AssetEntity assetEntity;
  final Widget image;
  final bool isImage;
  final Function castAsset;
  final Function onCancel;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: 20.0,
                color: Colors.grey,
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 40.0, right: 40.0),
          child: SingleChildScrollView(
            child: Material(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Selected ${isImage ? "Image" : "Video"}",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryTextColor,
                        fontFamily: "Roboto"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      image,
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(Utils.shortenTitle(assetEntity.title),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryTextColor,
                                      fontFamily: "Roboto")),
                              SizedBox(
                                height: 10.0,
                              ),
                              isImage
                                  ? Container()
                                  : Text(
                                      Utils.convertTimeVideos(
                                          assetEntity.duration),
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        fontSize: 12.0,
                                        fontFamily: "Roboto",
                                      )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Cast the selected ${isImage ? "image" : "video"}?",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryTextColor,
                        fontFamily: "Roboto"),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          onTap: () {
                            castAsset(assetEntity);
                          },
                          child: Ink(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: isImage
                                      ? [
                                          Colors.orangeAccent,
                                          Colors.amberAccent
                                        ]
                                      : [Colors.indigoAccent, Colors.lightBlue],
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Cast",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.cast_connected,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          onTap: onCancel,
                          child: Ink(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              color: Colors.white,
                              border: Border.all(color: kBorderColor, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Cancel",
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto",
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
