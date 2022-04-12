import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/supplier.dart';
import 'package:user/screens/dashboard/inventory/supplier/newSupplierScreen.dart';
import 'package:user/widgets/myAppBar.dart';

class SupplierDetail extends StatelessWidget {
    Supplier? supplier;
   SupplierDetail({Key? key,this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${supplier!.name}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewSupplierScreen(
                    supplier: supplier,
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
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),
        child: Column(
          children: [
                    ListTile(
                      subtitle: Text("${supplier!.name}"),
                      title: Text("Company"),),
                    ListTile(
                      subtitle: Text("${supplier!.email}"),
                      title: Text("Email"),),

                    ListTile(
                    subtitle: Text("${supplier!.phone}"),
                      title: Text("Phone"),),

             ListTile(
                      title: Text("Address"),
                      subtitle: Text("${supplier!.address}"),
                    ),
                    ListTile(
                      title: Text("Country"),
                      subtitle: Text("${supplier!.country}"),
                    ),
                    // ListTile(
                    //   title: Text("State"),
                    //   subtitle: Text("${supplier!.pr}"),
                    // ),
                    ListTile(
                      title: Text("Contact Person"),
                      subtitle: Text("${supplier!.contactPerson}"),
                    ),
                    ListTile(
                      title: Text("Contact Phone"),
                      subtitle: Text("${supplier!.contactPhone}"),
                    ),



          ],
        ),
      ),
    );
  }
}
