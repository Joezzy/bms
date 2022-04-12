import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/customer.dart';
import 'package:user/model/staff.dart';
import 'package:user/model/supplier.dart';
import 'package:user/screens/dashboard/users/customer/newCustomerScreen.dart';

import 'package:user/widgets/myAppBar.dart';

class CustomerDetail extends StatelessWidget {
  Customer? customer;
  CustomerDetail({Key? key,this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${customer!.firstName} ${customer!.lastName}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewCustomerScreen(
                    customer: customer,
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


              ListTile(
                title: Text("Name"),
                subtitle:  Text(" ${customer!.firstName} ${customer!.lastName}"),
              ),

              ListTile(
                title: Text("Email"),
                subtitle:  Text("${customer!.firstName} ${customer!.email}"),
              ),

              ListTile(
                title: Text("Phone"),
                subtitle:  Text("${customer!.phone}"),
              ),   ListTile(
                title: Text("Address"),
                subtitle:  Text("${customer!.address==null?"N/A":customer!.address["home"]}"),
              ),







            ],
          ),
        ),
      ),
    );
  }
}
