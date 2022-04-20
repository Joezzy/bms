import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/model/category.dart';
import 'package:user/model/subCategory.dart';
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';


class NewSubCategoryScreen extends StatefulWidget {
  PageSetting pageSetting;
  SubCategory? subCategory;
   NewSubCategoryScreen({Key? key, this.pageSetting=PageSetting.inApp,this.subCategory}) : super(key: key);

  @override
  _NewSubCategoryScreenState createState() => _NewSubCategoryScreenState();
}

class _NewSubCategoryScreenState extends State<NewSubCategoryScreen> {
  String category="";
  final _key = GlobalKey<FormState>();

  TextEditingController subCategoryController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  String business="";

  String get subCategory =>subCategoryController.text;
  String get description =>descriptionController.text;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCategoryMethod();
    getBusinessMethod();
    initMethod();
  }

  initMethod(){
   setState(() {
     if(widget.subCategory!=null){
       subCategoryController.text=widget.subCategory!.name;
       category=widget.subCategory!.category;
     }
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: widget.subCategory==null? "New Sub Category":"Edit Sub-category",),

      body: isLoading?Center(child: CircularProgressIndicator()):
      Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: MySize.size20),

              SizedBox(height: MySize.size20),

       if(widget.subCategory==null)
         Text("Create a sub-category for your product category",
                style: TextStyle( fontWeight: FontWeight.w500,
                    fontSize: MySize.size16),

              ),
              SizedBox(height: MySize.size30),
              SizedBox(height: MySize.size30),
              InputWithTitle(
                fieldLabel: "Store",
                inputWidget:  MyDropDown(
                    hint: "Select Store",
                    drop_value: business,
                    itemFunction: businessList.map((item) {
                      return DropdownMenuItem(
                        child: new Text("${item.storeName}"),
                        value: item.id.toString(),
                      );
                    }).toList() ??
                        [],
                    onChanged: (newValue) async {
                      print(newValue);
                      business=newValue.toString();
                    }
                ),
              ),
              SizedBox(height: MySize.size10,),

        if(widget.subCategory==null)      InputWithTitle(
                fieldLabel: "Category",
                inputWidget:  MyDropDown(
                    hint: "Select Category",
                    drop_value: category,
                    itemFunction: categoryList.map((item) {
                      return DropdownMenuItem(
                        child: new Text("${item.name}"),
                        value: item.id.toString(),
                      );
                    }).toList() ??
                        [],
                    onChanged: (newValue) async {
                      print(newValue);
                      category=newValue.toString();
                    }
                ),
              ),

              SizedBox(height: MySize.size10,),

              InputWithTitle(
                fieldLabel: "Sub-category Name",
                inputWidget: Txt(
                    placeholderText: "",
                    controller: subCategoryController,
                    validator: RequiredValidator(errorText: 'this field is required'),
                    onChanged: (txt){}),
              ),



              SizedBox(height: MySize.size30,),


              FillButton(
                // fontColor: Colors.white,
                  height: 45,
                  text: widget.subCategory==null? "Submit":"Update",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: MySize.size14,
                  enabledColor: AppTheme.primaryColor,
                  enabled: true,
                  onPressed: (){
                    // getBusinessMethod();
                    if(_key.currentState!.validate()){
                      addSubCategoryMethod();

                    }else
                      return;
                  }),
              SizedBox(height: MySize.size20,),


            ],
          ),
        ),
      ),
    );
  }

  bool isLoading=false;
  List<Category> categoryList=[];
  void getCategoryMethod(id) async {
    String url = baseUrl + '/category/?business_id=$id';
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
          category= categoryList[0].id;
          isLoading=false;
        });
        log(categoryList[0].name);



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
          business= businessList[0].id.toString();
          isLoading=false;
        });
        log(businessList[0].storeName);
        getCategoryMethod(business);

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

  void addSubCategoryMethod() async {
    String url = baseUrl + '/sub_category/';
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "business": business,
          "category": category,
          "name": subCategory,
        }
    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    try{
      if(widget.subCategory==null){
          res=  await RequestHelper.postRequestAuth(url, body);
      }else{
          res=  await RequestHelper.postRequestAuth(url, body);
      }
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
        myData = res[0]["data"];
        print("MyData");
        print(myData);
        if(widget.pageSetting==PageSetting.setup){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => DashBoardTab()),
                  (Route<dynamic> route) => false);
        }else{
          setState(() {
            subCategoryController.clear();
            descriptionController.clear();
          });

          MotionToast.success(
              title:  Text("Successful"),
              description:  Text(widget.subCategory==null?"SubCategory Created":"Sub-category updated")
          ).show(context);


        }


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



}


// {
// "store_name": "shirts",
// "business_address": "24 uselu",
// "country": "Nigeria",
// "state": "ogun"
// }