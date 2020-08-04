import 'dart:ui';
import 'package:firecast_app/screens/parent_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firecast_app/keepalive/app_retain_widget.dart';
import 'package:firecast_app/keepalive/background_main.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark
      // status bar color
      ));
  runApp(MyApp());

//  var channel = const MethodChannel('com.example/background_service');
//  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
//  channel.invokeMethod('startService', callbackHandle.toRawHandle());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget mainApp;
  void loadMainApp() {
    setState(() {
      mainApp = AppRetainWidget(
        child: ParentNavigator(),
      );
      var channel = const MethodChannel('com.example/background_service');
      var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
      channel.invokeMethod('startService', callbackHandle.toRawHandle());
    });
  }

  void initial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onBoard = (prefs.getBool('onboard') ?? false);

    if (onBoard) {
      loadMainApp();
    } else {
      setState(() {
        mainApp = MaterialApp(
          home: OnBoardingPage(onFinish: () async {
            await prefs.setBool("onboard", true);
            loadMainApp();
          }),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mainApp = Container(
      color: Colors.white,
    );
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return mainApp;
  }
}

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({@required this.onFinish});
  final Function onFinish;
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  Function onFinish;
  @override
  void initState() {
    super.initState();
    onFinish = widget.onFinish;
  }

  void _onIntroEnd(context) {
    onFinish();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w400, color: Color(0xff9397a3));
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          color: Color(0xff171e33)),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Watch media",
          body:
              "Live stream video or image from your phone to your FireTv and control its playback.",
          image: Container(
            padding: EdgeInsets.all(30.0),
            child: SvgPicture.asset(
              "assets/media_player.svg",
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Via Wifi",
          body:
              "Make sure your phone and your FireTv is connected to the same wifi and you are good to go.",
          image: Container(
            padding:
                EdgeInsets.only(top: 100.0, left: 30, right: 30, bottom: 70),
            child: SvgPicture.asset(
              "assets/broadcast.svg",
              width: 10,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Inbuilt explorer",
          body:
              "Use the inbuilt video or image file explorer for casting the selected file to your FireTV.",
          image: Container(
            padding: EdgeInsets.all(60.0),
            child: SvgPicture.asset("assets/my_files.svg", width: 50),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip', style: TextStyle(color: Color(0xff171e33))),
      next: const Icon(Icons.arrow_forward, color: Color(0xff171e33)),
      done: const Text('Done',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff171e33))),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFaaaebd),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.indigoAccent,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
