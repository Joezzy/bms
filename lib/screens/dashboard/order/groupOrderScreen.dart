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
import 'package:user/controller/businessProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/groupOrder.dart';
import 'package:user/model/order.dart';
import 'package:user/model/product.dart';
import 'package:user/screens/dashboard/order/orderDetailScreen.dart';

class GroupOrderScreen extends StatefulWidget {
  const GroupOrderScreen({Key? key}) : super(key: key);

  @override
  _GroupOrderScreenState createState() => _GroupOrderScreenState();
}

class _GroupOrderScreenState extends State<GroupOrderScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child:   Text("Bulk Orders",style: TextStyle(fontSize: MySize.size16,fontWeight: FontWeight.bold),),
              ),

              Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      // controller: _scrollController,
                      padding: EdgeInsets.all(0),

                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orderList.length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == orderList.length) {
                          return Container();
                        }
                        {
                          GroupOrder result = orderList[index];
                          return Column(
                            children: [
                              ListTile(
                                  title:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${result.groupId}"),
                                      Text("${result.status}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                                    ],
                                  ),

                                  subtitle: Text("${AppTheme.money(double.parse(result.totalItemsCost.toString()))}"),
                                  onTap: (){
                                    // Navigator.of(context,rootNavigator: true).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => OrderDetailScreen(
                                    //       order: result,
                                    //     ),
                                    //   ),
                                    // );
                                  }
                                // _optionSheet(result,context),
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
  List<GroupOrder> orderList=[];
  void getOrders() async {
    final businessProvider=Provider.of<BusinessProvider>(context,listen: false);

    String url = baseUrl + '/group_orders/?business_id=${businessProvider.baseStore}';
    // String url = baseUrl + '/group_orders/';
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
        orderList= groupOrderFromJson(json.encode(myData));
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
    // try{
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


      getOrders();

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





}
