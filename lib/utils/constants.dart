import 'package:flutter/material.dart';

enum PageState {
  HOME_SCREEN,
  FOLDER_VIDEO_SCREEN,
  FOLDER_IMAGE_SCREEN,
  VIDEO_LIST_SCREEN,
  IMAGE_LIST_SCREEN,
}
enum FolderMode {
  VIDEO,
  IMAGE,
}
const kPrimaryTextColor = Color(0xFF1A242E);
const kSubTextColor = Color(0x881A242E);
const kBorderColor = Color(0xFFF3F3F3);

class Utils {
  static String convertTimeVideos(int secs) {
    int minutes = ((secs / 60) % 60).toInt();
    int hours = (secs ~/ (60 * 60));
    int seconds = (secs % 60);
    if (hours > 0)
      return "${_convertNumberToString(hours)}:${_convertNumberToString(minutes)}:${_convertNumberToString(seconds)}";
    else
      return "${_convertNumberToString(minutes)}:${_convertNumberToString(seconds)}";
  }

  static String _convertNumberToString(int number) {
    if (number == 0) {
      return "00";
    } else if (number <= 9) {
      return "0$number";
    } else
      return "$number";
  }

  static String shortenTitle(String title) {
    String result = title;
    if (title.length > 49) {
      result = title.substring(0, 40) +
          "~" +
          title.substring(title.lastIndexOf("."));
    }
    return result;
  }
}
