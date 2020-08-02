import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fling/remote_media_player.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(
      {@required this.findDevices,
      @required this.isConnected,
      @required this.goToImages,
      @required this.goToVideos,
      @required this.selectedDevice,
      @required this.playerStarted,
      @required this.onFabButtonPressed,
      @required this.navigationController});
  final Function findDevices;
  final bool isConnected;
  final Function goToVideos;
  final Function goToImages;
  final RemoteMediaPlayer selectedDevice;
  final bool playerStarted;
  final Function onFabButtonPressed;
  final FancyDrawerController navigationController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 32.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Hi,",
                          style: TextStyle(
                              fontSize: 50.0,
                              color: kPrimaryTextColor,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("what do you want to watch on your FireTv today?",
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                      )),
                ),
                ConnectionInfo(
                  findDevices: findDevices,
                  goToImages: goToImages,
                  goToVideos: goToVideos,
                  isConnected: isConnected,
                  selectedDevice: selectedDevice,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: playerStarted
          ? FloatingActionButton(
              backgroundColor: kPrimaryTextColor,
              onPressed: onFabButtonPressed,
              child: Icon(Icons.cast_connected),
            )
          : null,
    );
  }
}

class ConnectionInfo extends StatelessWidget {
  ConnectionInfo(
      {@required this.findDevices,
      @required this.isConnected,
      @required this.goToImages,
      @required this.goToVideos,
      @required this.selectedDevice});
  final Function findDevices;
  final bool isConnected;
  final Function goToVideos;
  final Function goToImages;
  final RemoteMediaPlayer selectedDevice;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    onTap: goToVideos,
                    child: MediaTypeSelector(
                      icon: Icons.video_library,
                      title: "Videos",
                      color: Colors.indigoAccent,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    onTap: goToImages,
                    child: MediaTypeSelector(
                      icon: Icons.collections,
                      title: "Images",
                      color: Colors.orange,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "You are,",
                          style: TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              fontFamily: "Roboto"),
                        ),
                        isConnected
                            ? Text(
                                "Connected",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.green,
                                    fontFamily: "Roboto"),
                              )
                            : Text(
                                "Disconnected",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.red,
                                    fontFamily: "Roboto"),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    onTap: findDevices,
                    child: Ink(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: isConnected ? Colors.white : null,
                          border: isConnected
                              ? Border.all(color: kBorderColor, width: 2)
                              : null,
                          gradient: !isConnected
                              ? LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.indigoAccent,
                                    Colors.lightBlue
                                  ],
                                )
                              : null),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(isConnected ? "Stop" : "Find",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto",
                                color: isConnected
                                    ? kPrimaryTextColor
                                    : Colors.white,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            isConnected ? Icons.cast_connected : Icons.search,
                            color:
                                isConnected ? kPrimaryTextColor : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: Text(
                  "You are connected to,",
                  style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
              (selectedDevice != null)
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.indigoAccent, Colors.lightBlue])),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.tv, size: 40.0, color: Colors.white),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(selectedDevice.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto")),
                          )
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "No Devices",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.error_outline,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class MediaTypeSelector extends StatelessWidget {
  MediaTypeSelector(
      {@required this.icon, @required this.title, this.color: Colors.blue});
  final IconData icon;
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        border: Border.all(color: kBorderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 50.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 25.0,
                color: kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto"),
          )
        ],
      ),
    );
  }
}
