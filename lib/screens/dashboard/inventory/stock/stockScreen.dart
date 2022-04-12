import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/inventory.dart';
import 'package:user/model/product.dart';
import 'package:user/screens/dashboard/inventory/stock/newStock.dart';
import 'package:user/screens/dashboard/inventory/stock/stockDetails.dart';


class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInventory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewStockScreen(
                    is_in: true,
                  ),
                ),
              );
            },

            child: Icon(Icons.add),
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
          ),
          SizedBox(height: MySize.size10,),
          FloatingActionButton(
            onPressed: (){
              Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NewStockScreen(
                    is_in: false,
                  ),
                ),
              );
            },

            child: Icon(MdiIcons.minus),
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
          ),
        ],
      ),
      body:isLoading?Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: MySize.size10),
                child:   Text("Inventory",style: TextStyle(fontSize: MySize.size16,fontWeight: FontWeight.bold),),
              ),

              Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      // controller: _scrollController,
                      padding: EdgeInsets.all(0),

                      physics: NeverScrollableScrollPhysics(),
                      itemCount: inventoryList.length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == inventoryList.length) {
                          return Container();
                        }
                        {
                          Inventory result = inventoryList[index];
                          return Column(
                            children: [
                              ListTile(
                              onTap:(){
                                Navigator.of(context,rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => StockDetail(
                                      inventory: result,
                                    ),
                                  ),
                                );
                              },
                                title:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${result.productName}"),
                                    Text("${result.isIn?"+":"-"} ${result.quantity.toString()}",
                                      style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("performed by ${result.performedByName}"),
                                    Text(" ${ DateFormat('dd-MM-yyyy').format(DateTime.parse(result.date.toString()))}"),
                                  ],
                                ),

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
    );
  }

  bool isLoading = true;
  List<Inventory> inventoryList=[];
  void getInventory() async {
    final businessProvider=Provider.of<BusinessProvider>(context,listen: false);

    String url = baseUrl + '/inventory/?business_id=${businessProvider.baseStore}';
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {}
    );
    // List res;
    // try{
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
        inventoryList= inventoryFromJson(json.encode(myData));
        isLoading=false;
      });
      // log(categoryList[0].name);

    }
    // }
    // catch( e){
    //   print("CATCH");
    //   print(e.toString());
    //   MotionToast.error(
    //     title:  Text("Unsuccessful"),
    //     description:  Text("${e.toString()}"),
    //   ).show(context);
    // }

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


      getInventory();

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



  void _optionSheet(Product product,context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size230,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20 ),
                          child: Text(
                            "${product.name}",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.viewListOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("View details "),
                            ],
                          ),
                          onTap: () {

                            Navigator.pop(context);
                            // Navigator.of(context,rootNavigator: true).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => StaffDetail(
                            //       staff: staff,
                            //     ),
                            //   ),
                            // );


                          },
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.trashCanOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delete "),
                            ],
                          ),
                          onTap: () {


                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                title: "Confirm Deletion",
                                text: "Your transaction was successful!",
                                onConfirmBtnTap: (){
                                  Navigator.of(context, rootNavigator: true).pop();
                                  Navigator.pop(context);
                                  // Navigator.of(context, rootNavigator: true).pop();
                                  deleteProduct(product.id);
                                },
                                onCancelBtnTap : ()=>Navigator.of(context, rootNavigator: true).pop()

                            );


                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }


}
