import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/cart.dart';
import 'package:user/model/product.dart';
import 'package:user/screens/dashboard/inventory/products/newProduct.dart';
import 'package:user/screens/dashboard/inventory/products/productDetails.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/myAppBar.dart';

class CartScreen extends StatefulWidget {
   CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: MyAppBar(title: "Billing",),
      body:isLoading?Center(child: CircularProgressIndicator()):
      Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MySize.screenHeight,
                      child: ListView.builder(
                          shrinkWrap: true,
                          // scrollDirection: Axis.horizontal,
                          // controller: _scrollController,
                          padding: EdgeInsets.all(0),

                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartProvider.cartList!.length,
                          itemBuilder: (BuildContext context, index) {
                            if (index == cartProvider.cartList!.length) {
                              return Container();
                            }
                            {
                              Cart result = cartProvider.cartList![index];
                              return Column(
                                children: [
                                  ListTile(
                                      leading:ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                                        child:Image.network(
                                            result.image==null?"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png":
                                            result.image),
                                      ),
                                      title:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${result.product}"),
                                          Text("${result.sku}",style: TextStyle(fontWeight: FontWeight.w600),),
                                        ],
                                      ),
                                      subtitle: Text("${AppTheme.money(double.parse(result.amount.toString()))}"),
                                      trailing: InkWell(
                                        onTap: (){
                                          cartProvider.removeFromCart(index);
                                          // cartProvider.removeFromCart(cartProvider.cartList![index]);

                                          // setState(() {
                                          //   cartProvider.cartList!.remove(cartProvider.cartList![index]);
                                          //   print("REMOVED");
                                          // });
                                        },
                                        /////
                                        child: Container(
                                          padding: EdgeInsets.all(MySize.size4),
                                          margin: EdgeInsets.only(bottom: MySize.size10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              border: Border.all(width: 1,color: Colors.grey)
                                            ),
                                            child: Icon(Icons.close,size: MySize.size20,))),

                                  ),
                                  // Divider()
                                ],
                              );
                            }
                            //end of tile
                          })),
                ],
              ),
            ),
          ),


     if(cartProvider.cartList!.length>0)     Positioned(
              bottom: 20,

              right: 20,
              left: 20,
              child: Container(
              child:    FillButton(
    width: MySize.size300,
    height: MySize.size50,
    text:"Check Out",
    fontColor: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: MySize.size20,
    enabledColor: AppTheme.primaryColor,
    enabled: true,
    onPressed: (){

cartProvider.addOrderMethod(context);

    }),
              ))
        ],
      ),
    );
  }







}
