import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmExitApp extends StatelessWidget {
  ConfirmExitApp({@required this.onCancelExit, @required this.onExitApp});
  final Function onExitApp;
  final Function onCancelExit;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: 20.0,
                color: Colors.grey,
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 40.0, right: 40.0),
          child: Material(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Are you sure you want to close the app?",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTextColor,
                      fontFamily: "Roboto"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "If already connected, closing the app will close the connection between the app and your fire TV.",
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                      fontFamily: "Roboto"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        onTap: onExitApp,
                        child: Ink(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.indigoAccent, Colors.lightBlue],
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Exit",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        onTap: onCancelExit,
                        child: Ink(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            color: Colors.white,
                            border: Border.all(color: kBorderColor, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Cancel",
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto",
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
