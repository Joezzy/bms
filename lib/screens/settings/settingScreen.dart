import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/model/category.dart';
import 'package:user/model/currentUser.dart';
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/screens/dashboard/inventory/supplier/supplierScreen.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/screens/settings/business/businessScreen.dart';
import 'package:user/screens/settings/category/NewSubcategory.dart';
import 'package:user/screens/settings/category/categoryScreen.dart';
import 'package:user/screens/settings/department/deptScreen.dart';
import 'package:user/screens/settings/services/serviceScreen.dart';


class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // TODO: implement initState
    super.initState();
  }

  Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Settings",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                height: MySize.size100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Hi, ${currentUser == null ? '' : currentUser!.firstName}",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Brand-bold"),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("${currentUser?.email}")
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // Divider(),
              ListTile(
                leading: Icon(MdiIcons.officeBuilding),
                title: Text(
                  "Stores",
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessScreen()));
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.folderOutline),
                title: Text(
                  "Department",
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeptSCreen()));
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.roomServiceOutline),
                title: Text(
                  "List of Services",
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Logout",
                ),
                onTap: () {


                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                  currentUser=CurrentUser();
                },
              ),
              Divider(),






            ],
          ),
        ),
      ),
    );
  }
}
