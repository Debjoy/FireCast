import 'package:firecast_app/utils/constants.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_manager/photo_manager.dart';

class LoadingPlayerScreen extends StatelessWidget {
  LoadingPlayerScreen({this.message, @required this.onCollapsePlayer, Key key})
      : super(key: key);
  final String message;
  final Function onCollapsePlayer;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 20.0,
          color: Colors.grey,
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 40.0, right: 40.0),
        child: Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.cast_connected,
                      size: 25.0, color: Colors.indigoAccent),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      "Currently Showing",
                      style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      onTap: onCollapsePlayer,
                      child: Icon(Icons.expand_more)),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitWave(
                      color: Colors.lightBlueAccent,
                      size: 50.0,
                      itemCount: 4,
                      duration: Duration(milliseconds: 1000),
                    ),
                    SizedBox(height: 20.0),
                    Material(
                      color: Colors.white,
                      child: Text(
                        message,
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
