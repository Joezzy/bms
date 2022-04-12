


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
import 'package:user/screens/settings/category/categoryDetails.dart';
import 'package:user/screens/settings/category/newcategory.dart';
import 'package:user/widgets/myAppBar.dart';

class CategoryScreen extends StatefulWidget {
  String? businessId;
   CategoryScreen({Key? key,this.businessId}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryMethod();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Categories",),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context,rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => NewCategoryScreen(),
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
                      itemCount: categoryList.length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == categoryList.length) {
                          return Container();
                        }
                        {
                          Category result = categoryList[index];

                          return Column(
                            children: [
                              InkWell(
                                onTap:(){
                                 _optionSheet(result,context);


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
  List<Category> categoryList=[];
  void getCategoryMethod() async {
    String url = baseUrl + '/category/?business_id=${widget.businessId}';
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
          categoryList= categoryFromJson(json.encode(myData));
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

  void deleteCategory(id) async {
    String url = baseUrl + '/category/delete/$id/';
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
        text: "Category deleted!",
      );
      print("MyData");
      log(json.encode(myData));
      setState(() {
        isLoading=false;
      });


      getCategoryMethod();

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



  void _optionSheet(Category category,context) async {
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
                          padding: EdgeInsets.only(top: MySize.size20),
                          child: Text(
                            "${category.name}",
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
                              Text("View sub-category "),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => CategoryDetails(
                                  category: category,
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
                              Text("Edit Category"),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => NewCategoryScreen(
                                  category:category
                                ),
                              ),
                            );
                            // CoolAlert.show(
                            //     context: context,
                            //     type: CoolAlertType.confirm,
                            //     title: "Confirm Deletion",
                            //     text: "Your transaction was successful!",
                            //     onConfirmBtnTap: (){
                            //       Navigator.of(context, rootNavigator: true).pop();
                            //       Navigator.pop(context);
                            //       // Navigator.of(context, rootNavigator: true).pop();
                            //       deleteCategory(category.id);
                            //     },
                            //     onCancelBtnTap : ()=>Navigator.of(context, rootNavigator: true).pop()
                            //
                            // );


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


