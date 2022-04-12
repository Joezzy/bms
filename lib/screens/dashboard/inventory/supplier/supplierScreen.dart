import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/common/dialogs.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/supplier.dart';
import 'package:user/screens/dashboard/inventory/supplier/newSupplierScreen.dart';
import 'package:user/screens/dashboard/inventory/supplier/supplierDetail.dart';


class SupplierScreen extends StatefulWidget {
  const SupplierScreen({Key? key}) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSupplier();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
        var page=await  Navigator.of(context,rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => NewSupplierScreen(),
            ),
          );


        if(page=="success"){
          getSupplier();
        }
        },
        child: Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      ),
      body:isLoading?Center(child: CircularProgressIndicator()):
      Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

Padding(
  padding:  EdgeInsets.symmetric(horizontal: MySize.size10),
  child:   Text("Suppliers",style: TextStyle(fontSize: MySize.size16,fontWeight: FontWeight.bold),),
),
            Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    // controller: _scrollController,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: supplierList.length,
                    itemBuilder: (BuildContext context, index) {
                      if (index == supplierList.length) {
                        return Container();
                      }
                      {
                        Supplier result = supplierList[index];

                        return Column(
                          children: [
                            InkWell(
                              onTap:(){
                                _optionSheet(result,context);
                                },
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                                  child:Container(
                                    height: MySize.size50,
                                    width: MySize.size50,
                                      color:Colors.grey.withOpacity(0.7),
                                      child: Center(child: Text(result.name.substring(0,1),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:MySize.size24 ),))),
                                ) ,
                                title: Text(result.name),
                                subtitle: Text(result.phone),
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
  }

  bool isLoading = true;
List<Supplier> supplierList=[];
  void getSupplier() async {
    final businessProvider=Provider.of<BusinessProvider>(context,listen: false);
    String url = baseUrl + '/supplier/?business_id=${businessProvider.baseStore}';
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
      final  res=  await RequestHelper.getRequestAuth(url, body);
      print("OKP");
      print(res);
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
        log(json.encode(myData));
        setState(() {
          supplierList= supplierFromJson(json.encode(myData));
          // category= categoryList[0].id.toString();
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

  void deleteSupplier(id) async {
    String url = baseUrl + '/supplier/delete/$id/';
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
          text: "Supplier deleted!",
        );
        print("MyData");
        log(json.encode(myData));
        setState(() {
          isLoading=false;
        });


        getSupplier();

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



  void _optionSheet(Supplier supplier,context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size200,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20),
                          child: Text(
                            "${supplier.name}",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.clipboardListOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("View details "),
                            ],
                          ),
                          onTap: () async{

                          Navigator.pop(context);
                      var page=await Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => SupplierDetail(
                                  supplier: supplier,
                                ),
                              ),
                            );

                      if(page=="success"){
                        getSupplier();
                      }


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
                                text: "Are you sure you want to delete ${supplier.name}",
                                confirmBtnColor: AppTheme.primaryColor,
                                confirmBtnText: "Yes",
                                borderRadius: 15,
                                onConfirmBtnTap: (){
                                  Navigator.of(context, rootNavigator: true).pop();
                                  Navigator.pop(context);
                                  // Navigator.of(context, rootNavigator: true).pop();
                                  deleteSupplier(supplier.id);
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
