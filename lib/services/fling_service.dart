import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fling/flutter_fling.dart';
import 'package:flutter_fling/remote_media_player.dart';

import 'hosting_service.dart';

class FlingService {
  static HostingService hostingService = HostingService();
  static List<RemoteMediaPlayer> _flingDevices;
  static RemoteMediaPlayer _selectedPlayer;
  static String _hostedLocation;
  static FlutterFling fling = FlutterFling();

  void selectDevice(RemoteMediaPlayer player) {
    _selectedPlayer = player;
  }

  Future<RemoteMediaPlayer> _getPlayingDevice() async {
    RemoteMediaPlayer selectedDevice;
    try {
      selectedDevice = await FlutterFling.selectedPlayer;
    } on PlatformException {
      print('Failed to get selected device');
    }
    _selectedPlayer = selectedDevice;
    return _selectedPlayer;
  }

  RemoteMediaPlayer getCurrentDevice() {
    return _selectedPlayer;
  }

  startMedia(String fullPath, PlayerStateCallback callback) async {
    String urlPath = fullPath.substring(
        0, fullPath.lastIndexOf("/")); //  /relative/path/to/file
    String fileName = fullPath.substring((fullPath.lastIndexOf("/") == -1)
        ? 0
        : fullPath.lastIndexOf("/")); //  /filename.mp4
    if (!fileName.startsWith("/")) fileName = "/" + fileName;
    print(fileName);
    print(urlPath);
    _hostedLocation =
        await hostingService.startHosting(urlPath); //http://192.168.1.104:8082
    String hostedFileURL =
        _hostedLocation + fileName; //http://192.168.1.104:8082/filename.mp4
    print(hostedFileURL);

    await FlutterFling.play(callback,
            mediaUri:
                hostedFileURL, //https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4
            mediaTitle: fileName,
            player: _selectedPlayer)
        .then((_) => _getPlayingDevice());
  }

  playMedia() async => await FlutterFling.playPlayer();
  pauseMedia() async => await FlutterFling.pausePlayer();
  Future<void> stopCast() async {
    await FlutterFling.stopPlayer();
    _flingDevices = null;
  }

  muteMedia() async => await FlutterFling.mutePlayer(true);
  unMuteMedia() async => await FlutterFling.mutePlayer(false);
  seekForward() async => await FlutterFling.seekForwardPlayer();
  seekBackward() async => await FlutterFling.seekBackPlayer();
  seekMediaTo(int milliseconds) async =>
      await FlutterFling.seekToPlayer(position: milliseconds);

  disposeController() async {
    await FlutterFling.stopPlayer();
    await FlutterFling.stopDiscoveryController();
    _flingDevices = null;
    _selectedPlayer = null;
  }
}
