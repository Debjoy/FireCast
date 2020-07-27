import 'package:firecast_app/screens/folder_screen.dart';
import 'package:firecast_app/screens/home_screen.dart';
import 'package:firecast_app/screens/video_list_screen.dart';
import 'package:firecast_app/screens/image_list_screen.dart';
import 'package:firecast_app/services/fling_service.dart';
import 'package:firecast_app/services/media_service.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:firecast_app/widgets/confirm_cast_asset.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';
import 'package:firecast_app/widgets/search_loading.dart';
import 'package:firecast_app/widgets/no_devices_widget.dart';
import 'package:firecast_app/widgets/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fling/remote_media_player.dart';
import 'package:flutter_fling/flutter_fling.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class ParentNavigator extends StatefulWidget {
  @override
  _ParentNavigatorState createState() => _ParentNavigatorState();
}

class _ParentNavigatorState extends State<ParentNavigator> {
  bool fireTvConnected = false;
  Widget mMAINBODY = Container();
  MediaService mediaService = MediaService();
  PageState currentPageState = PageState.HOME_SCREEN;
  List<AssetPathEntity> videoFolders = [];
  List<AssetPathEntity> imageFolders = [];
  List<AssetEntity> videoEntities = [];
  List<AssetEntity> imageEntities = [];
  List<PageState> pageStates = [];
  FlingService flingService = FlingService();
  List<RemoteMediaPlayer> flingDevices;

  PanelController searchDevicePanel = PanelController();
  Widget searchPanelCurrentState = SearchLoading();

  PanelController confirmCastPanel = PanelController();
  Widget confirmCastPanelWidget = Container();
  AssetEntity tempSelectedAssetEntity;

  selectPlayerByIndex(int index) {
    flingService.selectDevice(flingDevices[index]);
    if (flingService.getCurrentDevice() != null) {
      fireTvConnected = true;
      searchDevicePanel.close();
      NavigationSystem();
    }
  }

  findFireTvOrCloseFireTV() async {
    if (flingService.getCurrentDevice() == null) {
      searchDevicePanel.open();
      fireTvConnected = false;
      setState(() {
        searchPanelCurrentState = SearchLoading();
      });
      print("start search");

      await FlutterFling.startDiscoveryController((status, player) {
        flingDevices = List();
        if (status == PlayerDiscoveryStatus.Found) {
          setState(() {
            flingDevices.add(player);
            searchPanelCurrentState = DeviceList(
              deviceList: flingDevices,
              onDeviceClick: selectPlayerByIndex,
            );
          });
        } else {
          stopFireTvConnection();
          setState(() {
            //TODO:ALSO DISCONNECT EVERYTHING HERE
            flingDevices.remove(player);
            searchPanelCurrentState = NoDevices(
              onFindAgain: () {
                findFireTvOrCloseFireTV();
              },
            );
          });
        }
      });
    } else {
      stopFireTvConnection();
    }
  }

  stopFireTvConnection() async {
    fireTvConnected = false;
    await flingService.disposeController();
    flingDevices = List();
    NavigationSystem();
  }

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

  castVideoConfirmScreenLoad(AssetEntity entity) {
    setState(() {
      confirmCastPanelWidget = ConfirmAsset(
        assetEntity: entity,
        image: ImageLoader(
          assetEntity: entity,
          isImageFiles: false,
          key: UniqueKey(),
        ),
        isImage: false,
        castAsset: castVideo,
        onCancel: () {
          confirmCastPanel.close();
        },
      );
      confirmCastPanel.open();
    });
  }

  castImageConfirmScreenLoad(AssetEntity entity) {
    setState(() {
      confirmCastPanelWidget = ConfirmAsset(
        assetEntity: entity,
        image: ImageLoader(
          assetEntity: entity,
          isImageFiles: false,
          key: UniqueKey(),
        ),
        isImage: true,
        castAsset: castImage,
        onCancel: () {
          confirmCastPanel.close();
        },
      );
      confirmCastPanel.open();
    });
    print(entity.title);
  }

  castImage(AssetEntity entity) {
    //TODO: check if connected
    print(entity.title);
  }

  castVideo(AssetEntity entity) {
    if (flingService.getCurrentDevice() != null)
      print(entity.title);
    else
      findFireTvOrCloseFireTV();
  }

  // ignore: non_constant_identifier_names
  void NavigationSystem() {
    if (pageStates.length == 0 || currentPageState != pageStates.last) {
      pageStates.add(currentPageState);
    }
    if (currentPageState == PageState.HOME_SCREEN) {
      setState(() {
        mMAINBODY = HomeScreen(
          selectedDevice: flingService.getCurrentDevice(),
          isConnected: fireTvConnected,
          goToVideos: () async {
            currentPageState = PageState.FOLDER_VIDEO_SCREEN;
            NavigationSystem();
            videoFolders = await mediaService.getVideoAssetFolders();
            NavigationSystem();
          },
          goToImages: () async {
            currentPageState = PageState.FOLDER_IMAGE_SCREEN;
            NavigationSystem();
            imageFolders = await mediaService.getImageAssetFolders();
            NavigationSystem();
          },
          findDevices: () {
            //fireTvConnected = !fireTvConnected;
            //NavigationSystem();
            findFireTvOrCloseFireTV();
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
          onConfirmLoadVideo: castVideoConfirmScreenLoad,
        );
      });
    } else if (currentPageState == PageState.IMAGE_LIST_SCREEN) {
      setState(() {
        mMAINBODY = ImageListScreen(
          imageEntities: imageEntities,
          onConfirmLoadImage: castImageConfirmScreenLoad,
        );
      });
    }
  }

  Future<bool> backPressed() async {
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
        onWillPop: backPressed,
        child: Stack(
          children: <Widget>[
            mMAINBODY,
            SlidingUpPanel(
              renderPanelSheet: false,
              minHeight: 0,
              maxHeight: 300,
              backdropEnabled: true,
              controller: confirmCastPanel,
              panel: confirmCastPanelWidget,
            ),
            SlidingUpPanel(
              renderPanelSheet: false,
              backdropEnabled: true,
              controller: searchDevicePanel,
              isDraggable: false,
              maxHeight: 300,
              minHeight: 0,
              panel: searchPanelCurrentState,
            ),
          ],
        ),
      ),
    );
  }
}
