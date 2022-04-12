import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/screens/settings/business/businessDetails.dart';
import 'package:user/screens/settings/business/newBusiness.dart';
import 'package:user/screens/settings/category/categoryScreen.dart';
import 'package:user/widgets/myAppBar.dart';

class BusinessScreen extends StatefulWidget {
  BusinessScreen({Key? key}) : super(key: key);
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusinessMethod();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Stores",),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context,rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => NewBusinessScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      ),
      body:isLoading?Center(child: CircularProgressIndicator()): Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: businessList.length,
                    itemBuilder: (BuildContext context, index) {
                      if (index == businessList.length) {
                        return Container();
                      }
                      {
                        Business result = businessList[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap:(){

                                _optionSheet(result,context);

                              },
                              child: ListTile(
                                leading:Icon(MdiIcons.officeBuilding),
                                title: Text(result.storeName),
                                // subtitle1: result.description,


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


  bool isLoading=false;
  List<Business> businessList=[];
  void getBusinessMethod() async {
    String url = baseUrl + '/business/';
    if (mounted)
      setState(() {
        businessList.clear();
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
          businessList= businessFromJson(json.encode(myData));
          // business= businessList[0].id.toString();
          isLoading=false;
        });
        log(businessList[0].storeName);


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

  void deleteBusiness(id) async {
    String url = baseUrl + '/business/delete/$id/';
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
        text: "Store deleted!",
      );
      print("MyData");
      log(json.encode(myData));
      setState(() {
        isLoading=false;
      });

      getBusinessMethod();

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

  void _optionSheet(Business business,context) async {
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
                            "${business.storeName}",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.pencilOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("View ${business.storeName}"),
                            ],
                          ),
                          onTap: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => BusinessDetail(
                                  business: business,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.trashCanOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("View Categories "),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                  businessId: business.id,
                                ),
                              ),
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


