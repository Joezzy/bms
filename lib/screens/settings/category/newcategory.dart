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
import 'package:user/screens/settings/category/NewSubcategory.dart';

import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';

class NewCategoryScreen extends StatefulWidget {
  PageSetting pageSetting;
  Category? category;
   NewCategoryScreen({Key? key, this.pageSetting=PageSetting.inApp,this.category}) : super(key: key);

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  String business="";

  TextEditingController categoryController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();


  String get category =>categoryController.text;
  String get description =>descriptionController.text;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusinessMethod();
    initMethod();
  }
  // final requiredValidator = RequiredValidator(errorText: 'this field is required');
  final _key = GlobalKey<FormState>();
initMethod(){
  if(widget.category!=null){
    categoryController.text=widget.category!.name;
    descriptionController.text=widget.category!.description;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: widget.category==null?"New Category":"Edit ${widget.category!.name}",),

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

              InkWell(
                onTap: ()=>getBusinessMethod()
                ,
                child: Text("Create a category for your product",
                  style: TextStyle( fontWeight: FontWeight.w500,
                      fontSize: MySize.size16),

                ),
              ),
              SizedBox(height: MySize.size30),
              if(widget.category==null)        InputWithTitle(
                fieldLabel: "Store",
                inputWidget:  MyDropDown(
                    hint: "Select Store",
                    drop_value: business,
                    itemFunction: businessList?.map((item) {
                      return DropdownMenuItem(
                        child: new Text("${item.storeName}"),
                        value: item.id.toString(),
                      );
                    })?.toList() ??
                        [],
                    onChanged: (newValue) async {
                      print(newValue);
                      business=newValue.toString();
                    }
                ),
              ),
              SizedBox(height: MySize.size10,),

              InputWithTitle(
                fieldLabel: "Category Name",
                inputWidget: Txt(
                    placeholderText: "",
                    controller: categoryController,
                    validator: RequiredValidator(errorText: 'this field is required'),
                    onChanged: (txt){}),
              ),
              SizedBox(height: MySize.size10,),
              InputWithTitle(
                fieldLabel: "Description(Optional)",
                inputWidget:   Txt(
                    controller: descriptionController,
                    // validator: RequiredValidator(errorText: 'this field is required'),
                    placeholderText: "",
                    maxLine: 3,
                    onChanged: (txt){}),
              ),


              SizedBox(height: MySize.size30,),


              FillButton(
                // fontColor: Colors.white,
                  height: 45,
                  text:widget.category==null?"Submit":"Update",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: MySize.size14,
                  enabledColor: AppTheme.primaryColor,
                  enabled: true,
                  onPressed: (){
getBusinessMethod();

                    if(_key.currentState!.validate()){
                      addCategoryMethod();

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
          business= businessList[0].id;
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


  void addCategoryMethod() async {
    String url;
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "business": business,
          "name": category,
          "description": description,
        }
    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    try{

      if(widget.category==null){
         url = baseUrl + '/category/';

        res=  await RequestHelper.postRequestAuth(url, body);

      }else{
         url = baseUrl + '/category/${widget.category!.id}/';

        res=  await RequestHelper.patchRequestAuth(url, body);

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
              MaterialPageRoute(builder: (BuildContext context) => NewSubCategoryScreen(
                pageSetting: PageSetting.setup,
              )),
                  (Route<dynamic> route) => false);
        }else{

          setState(() {
            categoryController.clear();
            descriptionController.clear();
          });

          MotionToast.success(
              title:  Text("Successful"),
              description:  Text(widget.category==null? "Category Created":"Category updated!")
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