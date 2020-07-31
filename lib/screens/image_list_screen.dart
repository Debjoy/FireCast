import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';

class ImageListScreen extends StatelessWidget {
  ImageListScreen(
      {@required this.imageEntities,
      @required this.onConfirmLoadImage,
      @required this.playerStarted,
      @required this.onFabButtonPressed,
      @required this.navigationController});
  final List<AssetEntity> imageEntities;
  final Function onConfirmLoadImage;
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
                    Icons.collections,
                    color: Colors.orange,
                    size: 30.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Images",
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
                      itemCount: (imageEntities.length / 3).ceil(),
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 30.0),
                      itemBuilder: (context, index) {
                        int index1 = index * 3;
                        int index2 = (index * 3) + 1;
                        int index3 = (index * 3) + 2;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              index1 < imageEntities.length
                                  ? Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          onConfirmLoadImage(
                                              imageEntities[index1]);
                                        },
                                        child: ImageLoader(
                                          assetEntity: imageEntities[index1],
                                          isImageFiles: true,
                                        ),
                                      ),
                                    )
                                  : Expanded(child: Container()),
                              SizedBox(
                                width: 10.0,
                              ),
                              index2 < imageEntities.length
                                  ? Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          onConfirmLoadImage(
                                              imageEntities[index2]);
                                        },
                                        child: ImageLoader(
                                          assetEntity: imageEntities[index2],
                                          isImageFiles: true,
                                        ),
                                      ),
                                    )
                                  : Expanded(child: Container()),
                              SizedBox(
                                width: 10.0,
                              ),
                              index3 < imageEntities.length
                                  ? Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          onConfirmLoadImage(
                                              imageEntities[index3]);
                                        },
                                        child: ImageLoader(
                                          assetEntity: imageEntities[index3],
                                          isImageFiles: true,
                                        ),
                                      ),
                                    )
                                  : Expanded(child: Container()),
                            ],
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
              child: Icon(
                Icons.cast_connected,
              ),
            )
          : null,
    );
  }
}
