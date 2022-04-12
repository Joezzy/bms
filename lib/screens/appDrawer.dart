import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/constant.dart';
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/screens/settings/settingScreen.dart';


class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    // TODO: implement initState
    super.initState();
  }

  Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     Text(
                      //       "Hi, ${userModel == null ? '' : userModel!.firstName}",
                      //       style: TextStyle(
                      //           fontSize: 20, fontFamily: "Brand-bold"),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     Text("${userModel!.email}")
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),

              // Divider(),
              // ListTile(
              //   leading: Icon(MdiIcons.chartArc),
              //   title: Text(
              //     "Dashboard",
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => DashBoardTab()));
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text(
                  "Settings",
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingScreen()));
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.logout),
                title: Text(
                  "Logout",
                ),
                onTap: () {

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                },
              ),
              // Divider(),






            ],
          ),
        ),
      ),
    );
  }
}
