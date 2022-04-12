import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/product.dart';
import 'package:user/screens/dashboard/inventory/products/newProduct.dart';


class ProductDetailsScreen extends StatelessWidget {
  Product? product;

  ProductDetailsScreen({Key? key,this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${product!.name}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewProductScreen(
                    product: product,
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
              title: Text("Item Name"),
              subtitle: Text("${product!.name}"),
            ),
            Divider(),
            ListTile(
              title: Text("Stock Unit"),
              subtitle: Text("${product!.stockUnit}"),
            ),
            Divider(),
            ListTile(
              title: Text("SKU"),
              subtitle: Text("${product!.sku}"),
            ),
            Divider(),
            ListTile(
              title: Text("Cost Price"),
              subtitle: Text("${product!.costPrice}"),
            ),
            Divider(),
            ListTile(
              title: Text("Sales price"),
              subtitle: Text("${product!.salesPrice}"),
            ),
            Divider(),
            ListTile(
              title: Text("Unit Measurement"),
              subtitle: Text("${product!.unitMeasurement}"),
            ),
            Divider(),
            ListTile(
              title: Text("Unit Increment"),
              subtitle: Text("${product!.unitIncrement}"),
            ),





          ],
        ),
      ),
    );
  }
}
