import 'dart:io';

import 'package:firecast_app/screens/folder_screen.dart';
import 'package:firecast_app/screens/home_screen.dart';
import 'package:firecast_app/screens/video_list_screen.dart';
import 'package:firecast_app/screens/image_list_screen.dart';
import 'package:firecast_app/services/fling_service.dart';
import 'package:firecast_app/services/media_service.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:firecast_app/widgets/confirm_cast_asset.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';
import 'package:firecast_app/widgets/image_screen.dart';
import 'package:firecast_app/widgets/loading_player.dart';
import 'package:firecast_app/widgets/player_screen.dart';
import 'package:firecast_app/widgets/search_loading.dart';
import 'package:firecast_app/widgets/no_devices_widget.dart';
import 'package:firecast_app/widgets/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fling/remote_media_player.dart';
import 'package:flutter_fling/flutter_fling.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  bool playerStarted = false;

  PanelController searchDevicePanel = PanelController();
  Widget searchPanelCurrentState = SearchLoading();

  PanelController confirmCastPanel = PanelController();
  Widget confirmCastPanelWidget = Container();
  AssetEntity tempSelectedAssetEntity;

  PanelController playerScreenPanel = PanelController();
  Widget playerScreenWidget = Container();

  //PLAYER VALUES
  double currentPlayerPosition = 0;
  String playerLoadingMessage = "";
  bool isPlaying = false;
  bool isMuted = false;

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
    playerStarted = false;
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

  castImageConfirmScreenLoad(AssetEntity entity) async {
    setState(() {
      confirmCastPanelWidget = ConfirmAsset(
        assetEntity: entity,
        image: ImageLoader(
          assetEntity: entity,
          isImageFiles: true,
          isCastImageMode: true,
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

  castImage(AssetEntity entity) async {
    //TODO: check if connected
    if (flingService.getCurrentDevice() != null) {
      playerLoadingMessages("Loading Media");
      playerStarted = true;
      NavigationSystem();
      setState(() {
        confirmCastPanel.close();
        playerScreenPanel.open();
      });
      File tempFile = await entity.file;

      await flingService.startMedia(tempFile.path,
          (state, condition, position) {
        if (state == MediaState.PreparingMedia) {
          playerLoadingMessages("Preparing Media");
        } else if (state == MediaState.ReadyToPlay) {
          playerLoadingMessages("Ready to Play");
        } else if (state == MediaState.Error || state == MediaState.NoSource) {
          playerLoadingMessages(state.toString());
        } else {
          loadImagePlayerScreen(entity);
        }
        if (condition == MediaCondition.Good ||
            condition == MediaCondition.WarningBandwidth ||
            condition == MediaCondition.WarningContent) {
          //loadImagePlayerScreen(entity);
        }
      });
    } else {
      findFireTvOrCloseFireTV();
    }
  }

  loadImagePlayerScreen(AssetEntity entity) {
    setState(() {
      playerScreenWidget = ImageScreen(
        assetEntity: entity,
        onCollapse: () {
          playerScreenPanel.close();
        },
        onPlayNextMedia: () {}, //TODO: Play Next Media
        onPlayPreviousMedia: () {}, //TODO: Play Previous Media
        doHardRefresh: true,
      );
    });
  }

  loadPlayerScreen(AssetEntity entity, [bool hardRefresh = false]) {
    setState(() {
      playerScreenWidget = PlayerScreen(
        assetEntity: entity,
        currentPlayerPosition: currentPlayerPosition,
        isMuted: isMuted,
        isPlaying: isPlaying,
        onPositionChanged: (value) {
          currentPlayerPosition = value;
          loadPlayerScreen(entity);
        },
        onPositionChangeEnd: (value) {
          flingService.seekMediaTo((value * 1000).toInt());
        },
        onSeekBackward: () {
          flingService.seekBackward();
        },
        onSeekForward: () {
          flingService.seekForward();
        },
        onMute: () async {
          await flingService.muteMedia();
          isMuted = true;
          loadPlayerScreen(entity);
        },
        onUnMute: () async {
          await flingService.unMuteMedia();
          isMuted = false;
          loadPlayerScreen(entity);
        },
        onPause: () {
          flingService.pauseMedia();
        },
        onPlay: () {
          flingService.playMedia();
        },
        onCollapsed: () {
          playerScreenPanel.close();
        },
        onPlayPreviousMedia: () {}, //TODO: Play previous Media
        onPlayNextMedia: () {}, //TODO: play next media
        doHardRefresh: hardRefresh,
      );
    });
  }

  playerLoadingMessages(String message) {
    setState(() {
      playerLoadingMessage = message;
      playerScreenWidget = LoadingPlayerScreen(
        message: playerLoadingMessage,
        onCollapsePlayer: () {
          playerScreenPanel.close();
        },
        key: UniqueKey(),
      );
    });
  }

  castVideo(AssetEntity entity) async {
    if (flingService.getCurrentDevice() != null) {
      //loadPlayerScreen(entity, true);
      playerStarted = true;
      NavigationSystem();
      playerLoadingMessages("Loading Media");
      isPlaying = false;
      isMuted = false;
      currentPlayerPosition = 0;
      setState(() {
        confirmCastPanel.close();
        playerScreenPanel.open();
      });
      File tempFile = await entity.file;

      print("halabala" + tempFile.path);
      await flingService.startMedia(tempFile.path,
          (state, condition, position) {
        if (state == MediaState.PreparingMedia) {
          playerLoadingMessages("Preparing Media");
        } else if (state == MediaState.Error || state == MediaState.NoSource) {
          playerLoadingMessages(state.toString());
        } else {
          currentPlayerPosition = position / 1000;
          if (state == MediaState.Playing) {
            isPlaying = true;
            loadPlayerScreen(entity);
          } else if (state == MediaState.Paused) {
            isPlaying = false;
            loadPlayerScreen(entity);
          } else if (state == MediaState.Seeking) {
            loadPlayerScreen(entity);
          } else if (state == MediaState.ReadyToPlay) {
            loadPlayerScreen(entity, true);
          } else {
            loadPlayerScreen(entity);
          }
        }
        if (condition == MediaCondition.Good ||
            condition == MediaCondition.WarningBandwidth ||
            condition == MediaCondition.WarningContent) {}
      });
    } else
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
          playerStarted: playerStarted,
          onFabButtonPressed: () {
            playerScreenPanel.open();
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
            playerStarted: playerStarted,
            onFabButtonPressed: () {
              playerScreenPanel.open();
            });
      });
    } else if (currentPageState == PageState.FOLDER_IMAGE_SCREEN) {
      setState(() {
        mMAINBODY = FolderScreen(
            loadVideoList: loadVideoListPage,
            loadImageList: loadImageListPage,
            assetFolders: imageFolders,
            folderMode: FolderMode.IMAGE,
            playerStarted: playerStarted,
            onFabButtonPressed: () {
              playerScreenPanel.open();
            });
      });
    } else if (currentPageState == PageState.VIDEO_LIST_SCREEN) {
      setState(() {
        mMAINBODY = VideoListScreen(
            videoEntities: videoEntities,
            onConfirmLoadVideo: castVideoConfirmScreenLoad,
            playerStarted: playerStarted,
            onFabButtonPressed: () {
              playerScreenPanel.open();
            });
      });
    } else if (currentPageState == PageState.IMAGE_LIST_SCREEN) {
      setState(() {
        mMAINBODY = ImageListScreen(
            imageEntities: imageEntities,
            onConfirmLoadImage: castImageConfirmScreenLoad,
            playerStarted: playerStarted,
            onFabButtonPressed: () {
              playerScreenPanel.open();
            });
      });
    }
  }

  Future<bool> backPressed() async {
    print(pageStates);
    if (playerScreenPanel.isPanelOpen) {
      playerScreenPanel.close();
      return await Future.value(false);
    } else if (searchDevicePanel.isPanelOpen) {
      searchDevicePanel.close();
      return await Future.value(false);
    } else if (confirmCastPanel.isPanelOpen) {
      confirmCastPanel.close();
      return await Future.value(false);
    }
    if (pageStates.last == PageState.HOME_SCREEN) {
      pageStates.clear();
      pageStates.add(PageState.HOME_SCREEN);
      //SystemNavigator.pop()
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
        child: MaterialApp(
          home: ParentStack(
              mMAINBODY: mMAINBODY,
              confirmCastPanel: confirmCastPanel,
              confirmCastPanelWidget: confirmCastPanelWidget,
              searchDevicePanel: searchDevicePanel,
              searchPanelCurrentState: searchPanelCurrentState,
              playerScreenPanel: playerScreenPanel,
              playerScreenWidget: playerScreenWidget),
        ),
      ),
    );
  }
}

class ParentStack extends StatelessWidget {
  const ParentStack({
    Key key,
    @required this.mMAINBODY,
    @required this.confirmCastPanel,
    @required this.confirmCastPanelWidget,
    @required this.searchDevicePanel,
    @required this.searchPanelCurrentState,
    @required this.playerScreenPanel,
    @required this.playerScreenWidget,
  }) : super(key: key);

  final Widget mMAINBODY;
  final PanelController confirmCastPanel;
  final Widget confirmCastPanelWidget;
  final PanelController searchDevicePanel;
  final Widget searchPanelCurrentState;
  final PanelController playerScreenPanel;
  final Widget playerScreenWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        SlidingUpPanel(
          renderPanelSheet: false,
          backdropEnabled: true,
          controller: playerScreenPanel,
          isDraggable: false,
          maxHeight: MediaQuery.of(context).size.height,
          minHeight: 0,
          panel: playerScreenWidget,
        ),
      ],
    );
  }
}
