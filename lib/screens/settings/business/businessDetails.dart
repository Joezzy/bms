import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/business.dart';
import 'package:user/screens/settings/business/newBusiness.dart';
import 'package:user/widgets/myAppBar.dart';

class BusinessDetail extends StatelessWidget {
  Business? business;

  BusinessDetail({Key? key,this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${business!.storeName}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewBusinessScreen(
                    business: business,
                  ),
                ),
              );
            },
            child: Padding(
              padding:  EdgeInsets.only(right: 10.0),
              child: Icon(MdiIcons.squareEditOutline ),


            ),
          )
        ],

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size15),
        child: Column(
          children: [
            ListTile(
              title: Text("Store"),
              subtitle: Text("${business!.storeName}"),
            ),
            Divider(),
            ListTile(
              title: Text("Address"),
              subtitle: Text("${business!.address}"),
            ),




          ],
        ),
      ),
    );
  }
}
