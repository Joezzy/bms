import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/cart.dart';
import 'package:user/model/customer.dart';
import 'package:user/model/product.dart';
import 'package:user/model/serviceModel.dart';
import 'package:user/screens/dashboard/inventory/products/newProduct.dart';
import 'package:user/screens/dashboard/inventory/products/productDetails.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';

class AddToCartScreen extends StatefulWidget {
  final Product? product;


  AddToCartScreen({Key? key,this.product}) : super(key: key);

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}


class _AddToCartScreenState extends State<AddToCartScreen> {
  int itemQuantity=1;
  double totalCost=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getCustomers(context);
    Provider.of<CartProvider>(context, listen: false).getServicesMethod();

    totalCost=double.parse(widget.product!.salesPrice);

  }
  bool isLoading=false;
  TextEditingController remarkController=TextEditingController();

  String get remark=>remarkController.text;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final businessProvider=Provider.of<BusinessProvider>(context);

    return Scaffold(
        appBar: MyAppBar(title: "Add to Cart",),
        body:cartProvider.isLoading?Center(child: CircularProgressIndicator()):
        Container(
          height: MySize.screenHeight,
          // width: MySize.scr,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(10),
              // topRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Container(
                  height: MySize.size190,
                  padding:  EdgeInsets.only(left: MySize.size15),

                  child:Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(MySize.size15),
                        child:  CachedNetworkImage(
                          imageUrl:  widget.product!.image==null?"https://miro.medium.com/max/2000/1*DOt4V8-RdcsLJL6rFI6njA.jpeg":widget.product!.image,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.photo),
                          fit:BoxFit.cover ,
                          height:  MySize.size150,
                          width: MySize.size150,

                        ),
                      ),
                      Container(
                        height: MySize.size180,
                        padding:  EdgeInsets.all(MySize.size10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.product!.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: MySize.size24),),
                            Text("${AppTheme.money(double.parse(widget.product!.salesPrice))} x $itemQuantity"),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("${AppTheme.money(double.parse(totalCost.toString()))}",style: TextStyle(fontSize: MySize.size30),),
                              ],
                            ),
                            Container(
                              width: MySize.size200,
                              padding: EdgeInsets.symmetric(vertical: MySize.size14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FillButton(
                                      width: MySize.size40,
                                      height: MySize.size40,
                                      text:"-",
                                      fontColor: Colors.white,
                                      fontWeight: FontWeight.w100,
                                      borderRadius: 50,
                                      fontSize: MySize.size20,
                                      enabledColor: AppTheme.primaryColor,
                                      enabled: true,
                                      onPressed: (){

                                        setState((){
                                          itemQuantity--;
                                          if(itemQuantity<1)
                                            itemQuantity=1;
                                          else
                                            totalCost=double.parse(widget.product!.salesPrice)*itemQuantity;

                                          print("Added to cart");
                                        });

                                      }),
                                  Container(
                                    width: MySize.size50,
                                    child: Center(child: Text(itemQuantity.toString(), style: TextStyle(fontSize: 16),)),
                                  ),
                                  FillButton(
                                      width: MySize.size40,
                                      height: MySize.size40,
                                      text:"+",
                                      fontColor: Colors.white,
                                      fontWeight: FontWeight.w100,
                                      fontSize: MySize.size20,
                                      borderRadius: 50,
                                      enabledColor: AppTheme.primaryColor,
                                      enabled: true,
                                      onPressed: (){

                                        setState((){
                                          itemQuantity++;
                                          totalCost=double.parse(widget.product!.salesPrice)*itemQuantity;
                                          print("Added to cart");
                                        });

                                      }),




                                ],
                              ),
                            ),

                            // Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),

                ),
                ListTile(title: Text("Add Customer"),
                  trailing: InkWell(
                    onTap: (){
                      _addCustomerSheet(context,cartProvider);
                    },
                    child: Container(
                        padding: EdgeInsets.all(MySize.size4),
                        margin: EdgeInsets.only(bottom: MySize.size10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 1,color: Colors.grey)
                        ),
                        child: Icon(Icons.add,size: MySize.size20,)),
                  ),),

                if(cartProvider.selectedCustomer!=null && cartProvider.selectedCustomer!.id!=0 ) Padding(
                  padding:  EdgeInsets.symmetric(horizontal: MySize.size20),
                  child: InputChip(
                    elevation: 0,
                    backgroundColor: AppTheme.primaryColor,
                    shadowColor: Colors.black,
                    onDeleted: ()=>cartProvider.onCustomerRemoved(cartProvider.selectedCustomer),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${cartProvider.selectedCustomer!.firstName} ${cartProvider.selectedCustomer!.lastName}",
                          style: TextStyle(fontSize: MySize.size14),
                        ),
                      ],
                    ), //Text
                  ),
                ),
                ListTile(title: Text("Add Services"),
                  trailing: InkWell(
                    onTap: (){
                      _addServicesSheet(context,cartProvider);
                    },
                    child: Container(
                        padding: EdgeInsets.all(MySize.size4),
                        margin: EdgeInsets.only(bottom: MySize.size10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 1,color: Colors.grey)
                        ),
                        child: Icon(Icons.add,size: MySize.size20,)),
                  ),),
                if(cartProvider.selectedServiceList!.length>0)
                  Container(
                      height: MySize.size50,
                      child: ListView.builder(
                        // shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          // controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: MySize.size10,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:cartProvider.selectedServiceList!.length,
                          itemBuilder: (BuildContext context, index) {
                            if (index == cartProvider.selectedServiceList!.length) {
                              return Container();
                            }
                            {
                              ServiceModel result = cartProvider!.selectedServiceList![index];
                              return  Padding(
                                padding:  EdgeInsets.symmetric(horizontal: MySize.size2),
                                child: InputChip(
                                  elevation: 0,
                                  backgroundColor: AppTheme.primaryColor,
                                  shadowColor: Colors.black,
                                  onDeleted: ()=>cartProvider.onServiceSelected(false, result),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        result.name,
                                        style: TextStyle(fontSize: MySize.size14),
                                      ),


                                    ],
                                  ), //Text
                                ),
                              );
                            }
                            //end of tile
                          })),
                SizedBox(height: MySize.size20,),
                Padding(
                  padding:  EdgeInsets.symmetric( horizontal: MySize.size10),
                  child: InputWithTitle(
                    fieldLabel: "Remark(Optional)",
                    inputWidget:   Txt(
                        controller: remarkController,
                        // validator: RequiredValidator(errorText: 'this field is required'),
                        placeholderText: "",
                        contentPadding: EdgeInsets.all(10),
                        maxLine: 5,
                        onChanged: (txt){}),
                  ),
                ),
                SizedBox(height: MySize.size60),
                FillButton(
                    width: MySize.size300,
                    height: MySize.size50,
                    text:"Add to Bill",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: MySize.size14,
                    enabledColor: AppTheme.primaryColor,
                    enabled: true,
                    onPressed: (){

                      setState((){
                        cartProvider.addToCart(Cart(
                          product: widget.product!.name,
                          sku: widget.product!.sku,
                          image: widget.product!.image,
                          amount: totalCost,
                          quantity: itemQuantity,
                        ));

                        cartProvider.allItem.add(
                            {
                              "business": businessProvider.baseStore,
                              "product": widget.product!.id,
                              "qty": itemQuantity,
                              "customer":cartProvider.selectedCustomer==null?"":cartProvider.selectedCustomer!.id,
                              "remark":remark,
                              "service":cartProvider.serviceIDList,
                            }

                        );


                        itemQuantity=1;
                        cartProvider.clearService();
                        if(cartProvider.selectedCustomer!=null)
                          cartProvider.onCustomerRemoved(cartProvider.selectedCustomer);

                        print("Added to cart");
                        Navigator.pop(context);

                      });

                    }),
              ],
            ),
          ),
        )
    );
  }



  void _addServicesSheet(context,cartProvider) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size300,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20 ),
                          child: Text(
                            "Add Services",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),

                        Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                // scrollDirection: Axis.horizontal,
                                // controller: _scrollController,
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: MySize.size10,
                                // ),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:cartProvider.serviceList.length,
                                itemBuilder: (BuildContext context, index) {
                                  if (index == cartProvider.serviceList.length) {
                                    return Container();
                                  }
                                  {
                                    ServiceModel result = cartProvider.serviceList[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          title:Row(
                                            children: [
                                              Text("${result.name} "),
                                              Text("${result.cost.toString()}")
                                            ],
                                          ),
                                          trailing: Checkbox(
                                            value: cartProvider.selectedServiceList.contains(result),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                print("tap");
                                                cartProvider.onServiceSelected(value,result);
                                              });
                                            },
                                          ),

                                        )   ,
                                        // Divider()
                                      ],
                                    );
                                  }
                                  //end of tile
                                })),
                      ],
                    ),
                  ),
                );
              });
        });
  }
  void _addCustomerSheet(context,cartProvider) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  // height: MySize.size300,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20 ),
                          child: Text(
                            "Customers",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),

                        Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                // scrollDirection: Axis.horizontal,
                                // controller: _scrollController,
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: MySize.size10,
                                // ),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:cartProvider.customerList.length,
                                itemBuilder: (BuildContext context, index) {
                                  if (index == cartProvider.customerList.length) {
                                    return Container();
                                  }
                                  {
                                    Customer result = cartProvider.customerList[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          title:Text("${result.firstName} ${result.lastName} "),
                                          subtitle:Text("${result.phone}"),
                                          onTap: (){
                                            Navigator.pop(context);
                                            cartProvider.onCustomerSelected(result);
                                          },
                                        )   ,
                                        // Divider()
                                      ],
                                    );
                                  }
                                  //end of tile
                                })),
                      ],
                    ),
                  ),
                );
              });
        });
  }

}
