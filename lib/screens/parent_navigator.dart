import 'package:firecast_app/screens/folder_screen.dart';
import 'package:firecast_app/screens/home_screen.dart';
import 'package:firecast_app/screens/video_list_screen.dart';
import 'package:firecast_app/screens/image_list_screen.dart';
import 'package:firecast_app/services/media_service.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class ParentNavigator extends StatefulWidget {
  @override
  _ParentNavigatorState createState() => _ParentNavigatorState();
}

class _ParentNavigatorState extends State<ParentNavigator> {
  bool fireTvConnected = true;
  Widget mMAINBODY = Container();
  MediaService mediaService = MediaService();
  PageState currentPageState = PageState.HOME_SCREEN;
  List<AssetPathEntity> videoFolders;
  List<AssetPathEntity> imageFolders;
  List<AssetEntity> videoEntities;
  List<AssetEntity> imageEntities;
  List<PageState> pageStates = [];

  loadVideoListPage(int index) async {
    currentPageState = PageState.VIDEO_LIST_SCREEN;
    videoEntities = await videoFolders[index].assetList;
    NavigationSystem();
  }

  loadImageListPage(int index) async {
    currentPageState = PageState.IMAGE_LIST_SCREEN;
    imageEntities = await imageFolders[index].assetList;
    print(index);
    NavigationSystem();
  }

  // ignore: non_constant_identifier_names
  void NavigationSystem() {
    if (pageStates.length == 0 || currentPageState != pageStates.last) {
      pageStates.add(currentPageState);
    }
    if (currentPageState == PageState.HOME_SCREEN) {
      setState(() {
        mMAINBODY = HomeScreen(
          isConnected: fireTvConnected,
          goToVideos: () async {
            videoFolders = await mediaService.getVideoAssetFolders();
            currentPageState = PageState.FOLDER_VIDEO_SCREEN;
            NavigationSystem();
          },
          goToImages: () async {
            imageFolders = await mediaService.getImageAssetFolders();
            currentPageState = PageState.FOLDER_IMAGE_SCREEN;
            NavigationSystem();
          },
          findDevices: () {
            fireTvConnected = !fireTvConnected;
            NavigationSystem();
          },
        );
      });
    } else if (currentPageState == PageState.FOLDER_VIDEO_SCREEN) {
      setState(() {
        mMAINBODY = FolderScreen(
          loadVideoList: loadVideoListPage,
          loadImageList: loadImageListPage,
          assetFolders: videoFolders,
          folderMode: FolderMode.VIDEO,
        );
      });
    } else if (currentPageState == PageState.FOLDER_IMAGE_SCREEN) {
      setState(() {
        mMAINBODY = FolderScreen(
          loadVideoList: loadVideoListPage,
          loadImageList: loadImageListPage,
          assetFolders: imageFolders,
          folderMode: FolderMode.IMAGE,
        );
      });
    } else if (currentPageState == PageState.VIDEO_LIST_SCREEN) {
      setState(() {
        mMAINBODY = VideoListScreen(
          videoEntities: videoEntities,
        );
      });
    } else if (currentPageState == PageState.IMAGE_LIST_SCREEN) {
      setState(() {
        mMAINBODY = ImageListScreen(
          imageEntities: imageEntities,
        );
      });
    }
  }

  Future<bool> backpressed() async {
    print(pageStates);
    if (pageStates.last == PageState.HOME_SCREEN) {
      pageStates.clear();
      pageStates.add(PageState.HOME_SCREEN);
      return await Future.value(false);
    } else {
      pageStates.removeLast();
      currentPageState = pageStates.last;
      NavigationSystem();
      return await Future.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
    NavigationSystem();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          textTheme: TextTheme()
              .copyWith(bodyText2: TextStyle(color: kPrimaryTextColor))),
      home: WillPopScope(
        onWillPop: backpressed,
        child: Stack(
          children: <Widget>[
            mMAINBODY,
            SlidingUpPanel(
              minHeight: 0,
              panel: Center(
                child: Text("This is the sliding Widget 1"),
              ),
            ),
            SlidingUpPanel(
              minHeight: 0,
              panel: Center(
                child: Text("This is the sliding Widget 2"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
