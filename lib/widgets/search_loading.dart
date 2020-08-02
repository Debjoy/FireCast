import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
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
              "Searching",
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
    );
  }
}
