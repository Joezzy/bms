import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/constant.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/screens/welcomeScreen.dart';


class SplashScreen extends StatefulWidget {
  static const String id = "splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => moveOn());
  }

  int initScreen = 1;

  moveOn() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    // themeData = Theme.of(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {
                print("Splash tap");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                        (Route<dynamic> route) => false);
              },
              child: Stack(children: <Widget>[
                Center(
                  child: Container(
                    width: MySize.size300,
                    height: MySize.size300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/logo.png',
                          ),
                          fit: BoxFit.contain),
                    ),
                  ),
                )
              ]),
            )));
  }
}
