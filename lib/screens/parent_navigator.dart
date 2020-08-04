import 'dart:io';
import 'package:firecast_app/screens/folder_screen.dart';
import 'package:firecast_app/screens/home_screen.dart';
import 'package:firecast_app/screens/video_list_screen.dart';
import 'package:firecast_app/screens/image_list_screen.dart';
import 'package:firecast_app/services/fling_service.dart';
import 'package:firecast_app/services/media_service.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:firecast_app/widgets/confirm_cast_asset.dart';
import 'package:firecast_app/widgets/confirm_exit_app.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';
import 'package:firecast_app/widgets/image_screen.dart';
import 'package:firecast_app/widgets/loading_player.dart';
import 'package:firecast_app/widgets/player_screen.dart';
import 'package:firecast_app/widgets/search_loading.dart';
import 'package:firecast_app/widgets/no_devices_widget.dart';
import 'package:firecast_app/widgets/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fling/remote_media_player.dart';
import 'package:flutter_fling/flutter_fling.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentNavigator extends StatefulWidget {
  @override
  _ParentNavigatorState createState() => _ParentNavigatorState();
}

class _ParentNavigatorState extends State<ParentNavigator>
    with TickerProviderStateMixin {
  bool fireTvConnected = false;
  Widget mMAINBODY = Container();
  MediaService mediaService = MediaService();
  PageState currentPageState = PageState.HOME_SCREEN;
  List<AssetPathEntity> videoFolders = [];
  List<AssetPathEntity> imageFolders = [];
  List<AssetEntity> videoEntities = [];
  List<AssetEntity> videoEntityQueue = [];
  List<AssetEntity> imageEntities = [];
  List<AssetEntity> imageEntityQueue = [];
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

  PanelController exitConfirmPanel = PanelController();

  //PLAYER VALUES
  double currentPlayerPosition = 0;
  String playerLoadingMessage = "";
  bool isPlaying = false;
  bool isMuted = false;

  bool playerRefreshFlag = false;

  FancyDrawerController _navigationController;

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
    if (flingService.getCurrentDevice() != null) {
      imageEntityQueue = imageEntities;
      playerLoadingMessages("Loading Media");
      playerRefreshFlag = true;
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
        onPlayNextMedia: () {
          int index = imageEntityQueue.indexOf(entity);
          if (index > -1 && imageEntityQueue.length > 0) {
            index++;
            if (index == imageEntityQueue.length) {
              index = 0;
            }
            playerScreenPanel.close();
            castImageConfirmScreenLoad(imageEntityQueue[index]);
          }
        },
        onPlayPreviousMedia: () {
          int index = imageEntityQueue.indexOf(entity);
          if (index > -1 && imageEntityQueue.length > 0) {
            index--;
            if (index == -1) {
              index = imageEntityQueue.length - 1;
            }
            playerScreenPanel.close();
            castImageConfirmScreenLoad(imageEntityQueue[index]);
          }
        },
        onStopCast: () async {
          await flingService.stopCast();
          playerScreenPanel.close();
          playerStarted = false;
          NavigationSystem();
        },
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
        onStopCast: () async {
          await flingService.stopCast();
          playerScreenPanel.close();
          playerStarted = false;
          NavigationSystem();
        },
//        onMute: () async {
//          await flingService.muteMedia();
//          isMuted = true;
//          loadPlayerScreen(entity);
//        },
//        onUnMute: () async {
//          await flingService.unMuteMedia();
//          isMuted = false;
//          loadPlayerScreen(entity);
//        },
        onPause: () {
          flingService.pauseMedia();
        },
        onPlay: () {
          flingService.playMedia();
        },
        onCollapsed: () {
          playerScreenPanel.close();
        },
        onPlayPreviousMedia: () {
          int index = videoEntityQueue.indexOf(entity);
          if (index > -1 && videoEntityQueue.length > 0) {
            index--;
            if (index == -1) {
              index = videoEntityQueue.length - 1;
            }
            playerScreenPanel.close();
            castVideoConfirmScreenLoad(videoEntityQueue[index]);
          }
        },
        onPlayNextMedia: () {
          int index = videoEntityQueue.indexOf(entity);
          if (index > -1 && videoEntityQueue.length > 0) {
            index++;
            if (index == videoEntityQueue.length) {
              index = 0;
            }
            playerScreenPanel.close();
            castVideoConfirmScreenLoad(videoEntityQueue[index]);
          }
        },
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
      videoEntityQueue = videoEntities;
      playerRefreshFlag = true;
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
          } else if (state == MediaState.Paused) {
            isPlaying = false;
          } else if (state == MediaState.Seeking) {
          } else if (state == MediaState.ReadyToPlay) {
          } else {}
          if (playerRefreshFlag) {
            loadPlayerScreen(entity, true);
            playerRefreshFlag = false;
          } else
            loadPlayerScreen(entity);
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
      if (pageStates.contains(currentPageState)) {
        pageStates.remove(currentPageState);
      }
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
          navigationController: _navigationController,
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
          },
          navigationController: _navigationController,
        );
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
          },
          navigationController: _navigationController,
        );
      });
    } else if (currentPageState == PageState.VIDEO_LIST_SCREEN) {
      setState(() {
        mMAINBODY = VideoListScreen(
          videoEntities: videoEntities,
          onConfirmLoadVideo: castVideoConfirmScreenLoad,
          playerStarted: playerStarted,
          onFabButtonPressed: () {
            playerScreenPanel.open();
          },
          navigationController: _navigationController,
        );
      });
    } else if (currentPageState == PageState.IMAGE_LIST_SCREEN) {
      setState(() {
        mMAINBODY = ImageListScreen(
          imageEntities: imageEntities,
          onConfirmLoadImage: castImageConfirmScreenLoad,
          playerStarted: playerStarted,
          onFabButtonPressed: () {
            playerScreenPanel.open();
          },
          navigationController: _navigationController,
        );
      });
    }
  }

  Future<bool> backPressed() async {
    print(pageStates);
    if (_navigationController.percentOpen > 0) {
      _navigationController.close();
      return await Future.value(false);
    } else if (exitConfirmPanel.isPanelOpen) {
      exitConfirmPanel.close();
      return await Future.value(false);
    } else if (playerScreenPanel.isPanelOpen) {
      playerScreenPanel.close();
      return await Future.value(false);
    } else if (searchDevicePanel.isPanelOpen) {
      searchDevicePanel.close();
      return await Future.value(false);
    } else if (confirmCastPanel.isPanelOpen) {
      confirmCastPanel.close();
      return await Future.value(false);
    } else if (pageStates.last == PageState.HOME_SCREEN) {
      pageStates.clear();
      pageStates.add(PageState.HOME_SCREEN);
      //SystemNavigator.pop(animated: true);
      exitConfirmPanel.open();
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
    _navigationController = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {}); // Must call setState
      });
    NavigationSystem();
  }

  @override
  void dispose() {
    _navigationController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          textTheme: TextTheme().copyWith(
              bodyText2:
                  TextStyle(color: kPrimaryTextColor, fontFamily: "Roboto"))),
      home: WillPopScope(
        onWillPop: backPressed,
        child: FancyDrawerWrapper(
          hideOnContentTap: true,
          backgroundColor: Colors.white, // Drawer background
          controller: _navigationController, // Drawer controller
          drawerItems: <Widget>[
            Material(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/fire_smal.png"),
                        height: 40.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "FireCast",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                onTap: () {
                  currentPageState = PageState.HOME_SCREEN;
                  _navigationController.close();
                  NavigationSystem();
                },
                child: Ink(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.home, size: 30.0, color: kPrimaryTextColor),
                      SizedBox(width: 10.0),
                      Text("Home",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ), // Home page
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                onTap: () async {
                  _navigationController.close();
                  currentPageState = PageState.FOLDER_VIDEO_SCREEN;
                  NavigationSystem();
                  videoFolders = await mediaService.getVideoAssetFolders();
                  NavigationSystem();
                },
                child: Ink(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.video_library,
                          size: 30.0, color: Colors.indigoAccent),
                      SizedBox(width: 10.0),
                      Text("Videos",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ), //Video Load
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                onTap: () async {
                  _navigationController.close();
                  currentPageState = PageState.FOLDER_IMAGE_SCREEN;
                  NavigationSystem();
                  imageFolders = await mediaService.getImageAssetFolders();
                  NavigationSystem();
                },
                child: Ink(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.collections,
                          size: 30.0, color: Colors.orangeAccent),
                      SizedBox(width: 10.0),
                      Text("Images",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ), //Image Load
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                onTap: () {
                  _navigationController.close();
                  exitConfirmPanel.open();
                },
                child: Ink(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app,
                          size: 30.0, color: kPrimaryTextColor),
                      SizedBox(width: 10.0),
                      Text("Exit",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ), //Exit App
            Material(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.only(top: 50.0),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  onTap: () async {
                    const url = 'https://atdebjoy.com/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      print("URL Launch Error");
                    }
                  },
                  child: Ink(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Text("Made by ",
                            style: TextStyle(
                              fontFamily: "Roboto",
                            )),
                        Text("Debjoy ",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold)),
                        Icon(Icons.favorite, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                onTap: () {
                  _navigationController.close();
                },
                child: Ink(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_backspace,
                        size: 25.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "close",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                            fontSize: 20.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
          itemGap: 0.0,
          child: ParentStack(
            mMAINBODY: AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
//              transitionBuilder: (child, animation) {
//                final offsetAnimation = Tween<Offset>(
//                        begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
//                    .animate(animation);
//                return SlideTransition(
//                  position: offsetAnimation,
//                  child: child,
//                );
//              },
              child: mMAINBODY,
            ),
            confirmCastPanel: confirmCastPanel,
            confirmCastPanelWidget: confirmCastPanelWidget,
            searchDevicePanel: searchDevicePanel,
            searchPanelCurrentState: searchPanelCurrentState,
            playerScreenPanel: playerScreenPanel,
            playerScreenWidget: playerScreenWidget,
            exitConfirmPanel: exitConfirmPanel,
            stopFireTvConnection: stopFireTvConnection,
          ),
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
    @required this.exitConfirmPanel,
    @required this.stopFireTvConnection,
  }) : super(key: key);

  final Widget mMAINBODY;
  final PanelController confirmCastPanel;
  final Widget confirmCastPanelWidget;
  final PanelController searchDevicePanel;
  final Widget searchPanelCurrentState;
  final PanelController playerScreenPanel;
  final Widget playerScreenWidget;
  final PanelController exitConfirmPanel;
  final Function stopFireTvConnection;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        mMAINBODY,
        SlidingUpPanel(
          renderPanelSheet: false,
          minHeight: 0,
          maxHeight: 270,
          backdropEnabled: true,
          controller: exitConfirmPanel,
          panel: ConfirmExitApp(
            onCancelExit: () {
              exitConfirmPanel.close();
            },
            onExitApp: () {
              stopFireTvConnection();
              SystemNavigator.pop(animated: true);
            },
          ),
        ),
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
