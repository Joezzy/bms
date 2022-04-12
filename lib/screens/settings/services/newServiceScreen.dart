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
import 'package:user/model/serviceModel.dart';
import 'package:user/screens/settings/category/NewSubcategory.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';

class NewServiceScreen extends StatefulWidget {
  ServiceModel? serviceModel;
  NewServiceScreen({Key? key, this.serviceModel}) : super(key: key);

  @override
  _NewServiceScreenState createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  String business="";

  TextEditingController nameController=TextEditingController();
  TextEditingController costController=TextEditingController();


  String get name =>nameController.text;
  String get cost =>costController.text;

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
    if(widget.serviceModel!=null){
      nameController.text=widget.serviceModel!.name;
      costController.text=widget.serviceModel!.cost.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "New Service",),

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

              // InkWell(
              //   onTap: ()=>getBusinessMethod()
              //   ,
              //   child: Text("Create a new department(stage)",
              //     style: TextStyle( fontWeight: FontWeight.w500,
              //         fontSize: MySize.size16),
              //
              //   ),
              // ),
              SizedBox(height: MySize.size30),
              InputWithTitle(
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
                fieldLabel: "Name",
                inputWidget: Txt(
                    placeholderText: "",
                    controller: nameController,
                    validator: RequiredValidator(errorText: 'this field is required'),
                    onChanged: (txt){}),
              ),
              SizedBox(height: MySize.size10,),
              InputWithTitle(
                fieldLabel: "Cost",
                inputWidget:   Txt(
                    controller: costController,
                    // validator: RequiredValidator(errorText: 'this field is required'),
                    placeholderText: "",
                    onChanged: (txt){}),
              ),


              SizedBox(height: MySize.size30,),


              FillButton(
                // fontColor: Colors.white,
                  height: 45,
                  text:widget.serviceModel==null? "Submit":"Update",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: MySize.size14,
                  enabledColor: AppTheme.primaryColor,
                  enabled: true,
                  onPressed: (){
                    if(_key.currentState!.validate()){
                      addServiceMethod();
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
          business= businessList[0].id.toString();
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


  void addServiceMethod() async {
    String url ="";
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;

    var body = json.encode(
        {
          "business": business,
          "name": name,
          "cost": cost,
        }
    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;

    try{

        if(widget.serviceModel==null){
          url = baseUrl + '/services/';
          res=  await RequestHelper.postRequestAuth(url, body);
        }else{
          url = baseUrl + '/services/${widget.serviceModel!.id}/';
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
          setState(() {
            nameController.clear();
            costController.clear();
          });


          // if(widget.serviceModel!=null){
          //   Navigator.pop(context,"success");
          //
          // }
        Navigator.pop(context,"success");

        MotionToast.success(
            title:  Text("Successful"),
            description:  Text( widget.serviceModel!=null?"Service Updated":"Services Created!")
        ).show(context);





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