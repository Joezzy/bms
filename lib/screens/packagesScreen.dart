import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';


class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
Container(
  width: MySize.screenWidth,
  height: MySize.screenWidth/2,
  padding: EdgeInsets.all( MySize.size20),
  margin: EdgeInsets.symmetric(horizontal: MySize.size20,vertical: MySize.size10),
  decoration: BoxDecoration(
    color: AppTheme.whiteBackground,
    borderRadius: BorderRadius.circular(25),
    boxShadow: <BoxShadow>[ 

        new BoxShadow(
          color: Colors.grey, //edited
          spreadRadius: 0.5,
          blurRadius: 5,
          // offset: new Offset(2.0, 0.0),
        ),
    ],
  ),
  child: Column(
    children: [
      Text("Brown",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.brown, fontSize: MySize.size26),),

      Text("Benefits"),

    ],
  ),
)

          ],
        ),
      ),
    );
  }
}
