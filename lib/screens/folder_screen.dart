import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class FolderScreen extends StatelessWidget {
  FolderScreen(
      {@required this.loadImageList,
      @required this.loadVideoList,
      @required this.assetFolders,
      @required this.folderMode,
      @required this.playerStarted,
      @required this.onFabButtonPressed,
      @required this.navigationController});
  final Function loadImageList;
  final Function loadVideoList;
  final List<AssetPathEntity> assetFolders;
  final FolderMode folderMode;
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
                    folderMode == FolderMode.VIDEO
                        ? Icons.video_library
                        : Icons.collections,
                    color: folderMode == FolderMode.VIDEO
                        ? Colors.indigoAccent
                        : Colors.orange,
                    size: 30.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        folderMode == FolderMode.VIDEO ? "Videos" : "Images",
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
                      itemCount: assetFolders.length,
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 30.0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: InkWell(
                            onTap: () {
                              folderMode == FolderMode.VIDEO
                                  ? loadVideoList(index)
                                  : loadImageList(index);
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.folder,
                                  size: 55.0,
                                  color: folderMode == FolderMode.VIDEO
                                      ? Colors.indigoAccent
                                      : Colors.orange,
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
                                        Container(
                                          child: Text(
                                            assetFolders[index].name == ""
                                                ? "root"
                                                : assetFolders[index].name,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: kPrimaryTextColor,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Roboto"),
                                          ),
                                        ),
                                        Text(
                                          "${assetFolders[index].assetCount} " +
                                              (folderMode == FolderMode.VIDEO
                                                  ? "videos"
                                                  : "images"),
                                          style: TextStyle(
                                              color: kSubTextColor,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
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
