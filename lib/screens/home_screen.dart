import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(
      {@required this.findDevices,
      @required this.isConnected,
      @required this.goToImages,
      @required this.goToVideos});
  final Function findDevices;
  final bool isConnected;
  final Function goToVideos;
  final Function goToImages;
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Hi,",
                        style: TextStyle(
                            fontSize: 50.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.menu,
                    size: 40.0,
                    color: kPrimaryTextColor,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("what do you want to watch on your FireTv today?",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              ConnectionInfo(
                findDevices: findDevices,
                goToImages: goToImages,
                goToVideos: goToVideos,
                isConnected: isConnected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectionInfo extends StatelessWidget {
  ConnectionInfo(
      {@required this.findDevices,
      @required this.isConnected,
      @required this.goToImages,
      @required this.goToVideos});
  final Function findDevices;
  final bool isConnected;
  final Function goToVideos;
  final Function goToImages;

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
                  child: GestureDetector(
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
                  child: GestureDetector(
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
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        isConnected
                            ? Text(
                                "Connected",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.green),
                              )
                            : Text(
                                "Disconnected",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.red),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: findDevices,
                    child: Container(
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
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              isConnected
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
                            child: Text("Debranjan's 2nd FireTV Stick",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
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
                                color: Colors.black54, fontSize: 18.0),
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
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
