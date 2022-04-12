import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/cart.dart';
import 'package:user/model/product.dart';
import 'package:user/screens/dashboard/pos/addToCartScreen.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/productCard.dart';


class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body:isLoading?Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                height: MySize.screenHeight,
                child: GridView.builder(
                  padding:  EdgeInsets.only(bottom: 300),
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 /1.15,
                        crossAxisSpacing: MySize.size2,
                        mainAxisSpacing: 20
                    ),
                    itemCount: productList!.length,
                    itemBuilder: (BuildContext context, index) {
                      if (index == productList!.length) {
                        return Container();
                      }
                      {
                        Product product=productList![index];
                        return
                         GestureDetector(
                           onTap: (){
                             setState(() {
                               itemQuantity=1;
                             });

                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => AddToCartScreen(
                                       product: product,
                                     )));


                             // _optionSheet( context,product,cartProvider);
                           },
                           child: ProductCard(
                             title: product.name,
                             amount: product.salesPrice,
                             imageString: product.image,
                           ),
                         )
                        ;
                      }
                      //end of tile
                    }
                ),
              ),
              SizedBox(height: 100,)

            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = true;
  List<Product> productList=[];
  void getProduct() async {
    // String url = baseUrl + '/product/';
    final businessProvider=Provider.of<BusinessProvider>(context,listen: false);
    String url = baseUrl + '/product/?business_id=${businessProvider.baseStore}';
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {}
    );
    // List res;
    try{
    final  res=  await RequestHelper.getRequestAuth(url, body);
    print("OKP");
    log(json.encode(res));
    if (res[0]["status"] == "failed") {
      print(res[0]["data"]);
      MotionToast.error(
          height: MySize.size200,
          title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
          description:  Text("${replaceString(res[0]["message"].toString())}")
      ).show(context);
    } else {
      myData = res[0]["message"];
      print("MyData");
      log(json.encode(res));

      setState(() {
        productList= productFromJson(json.encode(myData));
        isLoading=false;
      });
      // log(categoryList[0].name);

    }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }

  void deleteProduct(id) async {
    String url = baseUrl + '/product/delete/$id/';
    if (mounted)
      setState(() {
        // categoryList.clear();
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {}
    );
    // List res;
    try{
    final  res=  await RequestHelper.deleteRequestAuth(url, body);
    print("OKP");
    print(res);
    if (res[0]["status"] == "failed") {
      print(res[0]["data"]);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        confirmBtnColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.primaryColor,
        text: "${replaceString(res[0]["message"].toString())}",
      );


    } else {
      // myData = res[0]["message"]["data"];
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        confirmBtnColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.primaryColor,
        text: "Item deleted!",
      );
      print("MyData");
      log(json.encode(myData));
      setState(() {
        isLoading=false;
      });


      getProduct();

    }
    }

    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }



  void _optionSheet(context,Product product,cartProvider) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
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
  height: MySize.size200,
  padding:  EdgeInsets.only(left: MySize.size15),

  child:Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(MySize.size15),
        child:  CachedNetworkImage(
          imageUrl:  product.image==null?"https://miro.medium.com/max/2000/1*DOt4V8-RdcsLJL6rFI6njA.jpeg":product.image,
          // placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.photo),
          fit:BoxFit.cover ,
          height:  MySize.size150,
          width: MySize.size150,

        ),
      ),
      Container(
        height: MySize.size150,
        padding:  EdgeInsets.all(MySize.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(product.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: MySize.size24),),
            Text("${AppTheme.money(double.parse(product.salesPrice))} x $itemQuantity"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${AppTheme.money(double.parse(totalCost.toString()))}",style: TextStyle(fontSize: MySize.size30),),
              ],
            ),
            // Spacer(),
          ],
        ),
      )
    ],
  ),

),
                        Container(
                          width: MySize.size200,
                          padding: EdgeInsets.symmetric(vertical: MySize.size14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FillButton(
                                  width: MySize.size50,
                                  height: MySize.size50,
                                  text:"-",
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: MySize.size30,
                                  enabledColor: AppTheme.primaryColor,
                                  enabled: true,
                                  onPressed: (){

                                    setState((){
                                      itemQuantity--;
                                      if(itemQuantity<1)
                                        itemQuantity=1;
                                      else
                                      totalCost=double.parse(product.salesPrice)*itemQuantity;

                                      print("Added to cart");
                                    });

                                  }),
                              Container(
                                width: MySize.size50,
                                child: Center(child: Text(itemQuantity.toString(), style: TextStyle(fontSize: 16),)),
                              ),
                              FillButton(
                                  width: MySize.size50,
                                  height: MySize.size50,
                                  text:"+",
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: MySize.size30,
                                  enabledColor: AppTheme.primaryColor,
                                  enabled: true,
                                  onPressed: (){

                                    setState((){
                                      itemQuantity++;
                                      totalCost=double.parse(product.salesPrice)*itemQuantity;
                                      print("Added to cart");
                                    });

                                  }),




                            ],
                          ),
                        ),

                        SizedBox(height: MySize.size140),
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
                              
                              Navigator.pop(context);
                           setState((){
                             cartProvider.addToCart(Cart(
                               product: product.name,
                               sku: product.sku,
                               image: product.image,
                               amount: totalCost,
                               quantity: itemQuantity,
                             ));


                             itemQuantity=1;
                             print("Added to cart");
                           });

                            }),


                      ],
                    ),
                  ),
                );
              });
        });
  }

int itemQuantity=1;
double totalCost=0;
}
