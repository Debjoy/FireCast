import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fling/remote_media_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DeviceList extends StatelessWidget {
  DeviceList({@required this.onDeviceClick, @required this.deviceList});
  final Function onDeviceClick;
  final List<RemoteMediaPlayer> deviceList;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 40.0),
        child: Material(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Devices",
                style: TextStyle(
                  fontSize: 18.0,
                  color: kPrimaryTextColor,
                  decoration: TextDecoration.none,
                  fontFamily: "Roboto",
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      itemCount: deviceList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onDeviceClick(index);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.tv,
                                size: 60.0,
                                color: Colors.lightBlueAccent,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(deviceList[index].name,
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Roboto",
                                        )),
                                    Text("click to connect",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Roboto",
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
