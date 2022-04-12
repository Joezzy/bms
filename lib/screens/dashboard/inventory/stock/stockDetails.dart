import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/inventory.dart';
import 'package:user/model/product.dart';
import 'package:user/screens/dashboard/inventory/products/newProduct.dart';


class StockDetail extends StatelessWidget {
  Inventory? inventory;

  StockDetail({Key? key,this.inventory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${inventory!.productName}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          // InkWell(
          //   onTap: (){
          //     Navigator.of(context,rootNavigator: true).push(
          //       MaterialPageRoute(
          //         builder: (context) => NewProductScreen(
          //           product: inventory,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Padding(
          //     padding:  EdgeInsets.only(right: 10.0),
          //     child: Icon(MdiIcons.squareEditOutline ),
          //
          //
          //   ),
          // )
        ],

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size15),
        child: Column(
          children: [
            ListTile(
              title: Text("Item Name"),
              subtitle: Text("${inventory!.productName}"),
            ),

            ListTile(
              title: Text("Quantity"),
              subtitle: Text("${inventory!.isIn?"+":"-"} ${inventory!.quantity.toString()}"),
            ),
            ListTile(
              title: Text("Previous Quantity"),
              subtitle: Text("${inventory!.previousQty.toString()} "),
            ),

            ListTile(
              title: Text("Performed By"),
              subtitle: Text("${inventory!.performedByName.toString()}"),
            ),
            ListTile(
              title: Text("Date Performed"),
              subtitle: Text("${ DateFormat('dd-MM-yyyy').format(DateTime.parse(inventory!.date.toString()))    }"),
            ),
            ListTile(
              title: Text("Remark"),
              subtitle: Text("${inventory!.remark}"),
            ),







          ],
        ),
      ),
    );
  }
}
