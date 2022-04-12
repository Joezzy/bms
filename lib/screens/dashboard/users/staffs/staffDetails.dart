import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/staff.dart';
import 'package:user/model/supplier.dart';
import 'package:user/screens/dashboard/users/staffs/newStaffScreen.dart';
import 'package:user/widgets/myAppBar.dart';

class StaffDetail extends StatelessWidget {
  Staff? staff;
  StaffDetail({Key? key,this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${staff!.firstName} ${staff!.lastName}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewStaffScreen(
                    staff: staff,
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

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MySize.size20),
          child: Column(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                child:Image.network(
                    staff!.avatar==null?"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png":
                    staff!.avatar.toString(),
                fit: BoxFit.cover,
                height: MySize.size300,),
              ) ,
              ListTile(
                title: Text("Name"),
                subtitle:  Text(" ${staff!.firstName} ${staff!.lastName}"),
              ),
              ListTile(
                title: Text("Designation"),
                subtitle:  Text("${staff!.designation}"),
              ),
              ListTile(
                title: Text("Email"),
                subtitle:  Text("${staff!.email}"),
              ),

              ListTile(
                title: Text("Phone"),
                subtitle:  Text("${staff!.phone}"),
              ),      ListTile(
                title: Text("Address"),
                subtitle:  Text("${staff!.address}"),
              ),





            ],
          ),
        ),
      ),
    );
  }
}
