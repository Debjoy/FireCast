import 'package:firecast_app/utils/constants.dart';
import 'package:firecast_app/widgets/image_loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_manager/photo_manager.dart';

class PlayerScreen extends StatelessWidget {
  PlayerScreen({
    @required this.assetEntity,
    @required this.isMuted,
    @required this.isPlaying,
    @required this.currentPlayerPosition,
    @required this.onPositionChanged,
    @required this.onPositionChangeEnd,
    @required this.onSeekBackward,
    @required this.onSeekForward,
    @required this.onStopCast,
    @required this.onPause,
    @required this.onPlay,
    @required this.onCollapsed,
    @required this.onPlayNextMedia,
    @required this.onPlayPreviousMedia,
    this.doHardRefresh: false,
  });
  final AssetEntity assetEntity;
  final bool isMuted;
  final bool isPlaying;
  final double currentPlayerPosition;
  final Function onPositionChanged;
  final Function onPositionChangeEnd;
  final Function onSeekForward;
  final Function onSeekBackward;
  final Function onPlay;
  final Function onPause;
  final Function onStopCast;
  final bool doHardRefresh;
  final Function onCollapsed;
  final Function onPlayNextMedia;
  final Function onPlayPreviousMedia;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      onTap: onCollapsed,
                      child: Icon(Icons.expand_more, color: kPrimaryTextColor)),
                ],
              ),
              SizedBox(height: 20.0),
              doHardRefresh
                  ? PlayerImageLoader(
                      assetEntity: assetEntity,
                      isImageFiles: false,
                      key: UniqueKey(),
                    )
                  : PlayerImageLoader(
                      assetEntity: assetEntity,
                      isImageFiles: false,
                    ),
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      onTap: onPlayPreviousMedia,
                      child: Icon(Icons.skip_previous,
                          size: 50.0, color: kPrimaryTextColor),
                    )),
                    Expanded(
                        child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      onTap: onStopCast,
                      child: Icon(Icons.stop_screen_share,
                          size: 50.0, color: kPrimaryTextColor),
                    )),
                    Expanded(
                        child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      onTap: onPlayNextMedia,
                      child: Icon(Icons.skip_next,
                          size: 50.0, color: kPrimaryTextColor),
                    ))
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SliderTheme(
                    data: SliderThemeData(
                        thumbColor: Colors.indigoAccent,
                        activeTrackColor: Colors.indigoAccent,
                        trackHeight: 5.0,
                        inactiveTickMarkColor: kPrimaryTextColor,
                        inactiveTrackColor: kPrimaryTextColor),
                    child: Slider(
                      value: (currentPlayerPosition >=
                              (assetEntity.duration.toDouble() + 1))
                          ? (assetEntity.duration.toDouble())
                          : (currentPlayerPosition >= 0
                              ? currentPlayerPosition
                              : 0),
                      onChanged: (value) {
                        onPositionChanged(value);
                      },
                      onChangeEnd: (value) {
                        onPositionChangeEnd(value);
                      },
                      max: assetEntity.duration.toDouble() + 1,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        Utils.convertTimeVideos(currentPlayerPosition.toInt()),
                        style: TextStyle(
                            color: kPrimaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        Utils.convertTimeVideos(assetEntity.duration),
                        style: TextStyle(
                            color: kPrimaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      onTap: onSeekBackward,
                      child: Icon(Icons.replay_10,
                          size: 50.0, color: kPrimaryTextColor),
                    )),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        onTap: isPlaying ? onPause : onPlay,
                        child: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons
                                  .play_circle_filled, //Icons.pause_circle_filled
                          color: Colors.indigoAccent,
                          size: 90.0,
                        ),
                      ),
                    ),
                    Expanded(
                        child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      onTap: onSeekForward,
                      child: Icon(Icons.forward_10,
                          size: 50.0, color: kPrimaryTextColor),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}
