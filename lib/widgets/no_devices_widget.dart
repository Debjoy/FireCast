import 'package:firecast_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NoDevices extends StatelessWidget {
  NoDevices({@required this.onFindAgain});
  final Function onFindAgain;
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
        padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 40.0),
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
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.black45,
                      ),
                      SizedBox(height: 10.0),
                      Text("No Devices Found",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black45,
                            decoration: TextDecoration.none,
                            fontFamily: "Roboto",
                          )),
                      SizedBox(height: 10.0),
                      InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        onTap: onFindAgain,
                        child: Ink(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.indigoAccent,
                                    Colors.lightBlue
                                  ],
                                )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Find Again",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "Roboto"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
