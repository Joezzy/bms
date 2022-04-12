


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
import 'package:user/model/category.dart';
import 'package:user/model/subCategory.dart';
import 'package:user/screens/settings/category/NewSubcategory.dart';
import 'package:user/screens/settings/category/newcategory.dart';
import 'package:user/widgets/myAppBar.dart';

class CategoryDetails extends StatefulWidget {
  Category? category;
  CategoryDetails({Key? key,this.category}) : super(key: key);

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubCategoryMethod(widget.category!.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category!.name}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context,rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => NewSubCategoryScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      ),
      body:isLoading?Center(child: CircularProgressIndicator()):

      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      // controller: _scrollController,
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: MySize.size10,
                      // ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subCategoryList.length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == subCategoryList.length) {
                          return Container();
                        }
                        {
                          SubCategory result = subCategoryList[index];

                          return Column(
                            children: [
                              InkWell(
                                onTap:(){
                                  // _optionSheet(result,context);



                                  // showDialog(
                                  //   context: context,
                                  //   builder: (_) => MyDialog(okFunction: (){
                                  //
                                  //     },),
                                  // );
                                },
                                child: ListTile(
                                  leading:Icon(Icons.list_alt_outlined),
                                  title: Text(result.name),
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
      ),
    );
  }


  bool isLoading=false;
  List<SubCategory> subCategoryList=[];
  void getSubCategoryMethod(categoryId) async {
    String url = baseUrl + '/sub_category/?category_id=$categoryId';
    // String url = baseUrl + '/subcategory/get/$categoryId';
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
        setState(() {
          isLoading=false;
        });
      } else {
        myData = res[0]["message"];
        print("MyData2");
        log(json.encode(myData));
        setState(() {

          subCategoryList= subCategoryFromJson(json.encode(myData));
          // subCategory= subCategoryList[0].id.toString();
          isLoading=false;
        });
        // log(subCategoryList[0].name);



      }
    }
    catch( e){
      print("CATCHr");
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void deleteCategory(id) async {
    String url = baseUrl + '/sub_category/delete/$id/';
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
        text: "Subcategory deleted!",
      );
      print("MyData");
      log(json.encode(myData));
      setState(() {
        isLoading=false;
      });


      getSubCategoryMethod(widget.category!.id);

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



  void _optionSheet(SubCategory subcategory,context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size160,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20),
                          child: Text(
                            "${subcategory.name}",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        // ListTile(
                        //   leading: Icon(MdiIcons.viewListOutline),
                        //   title: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text("View details "),
                        //     ],
                        //   ),
                        //   onTap: () {
                        //
                        //
                        //     // Navigator.of(context,rootNavigator: true).push(
                        //     //   MaterialPageRoute(
                        //     //     builder: (context) => SupplierDetail(
                        //     //       supplier: category,
                        //     //     ),
                        //     //   ),
                        //     // );
                        //
                        //
                        //   },
                        // ),
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
                                  deleteCategory(subcategory.id);
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


