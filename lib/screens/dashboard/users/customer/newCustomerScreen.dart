import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/backgroundWavy.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/model/country.dart';
import 'package:user/model/customer.dart';
import 'package:user/model/role.dart';
import 'package:user/model/staff.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:http/http.dart' as http;
import 'package:user/widgets/myAppBar.dart';
import 'package:path/path.dart';
class NewCustomerScreen extends StatefulWidget {
  Customer? customer;
  NewCustomerScreen({Key? key,this.customer}) : super(key: key);

  @override
  _NewCustomerScreenState createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  String country="";

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address')    ]);

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController addressController=TextEditingController();


  bool showPassword=true;


  String get firstName =>firstNameController.text;
  String get lastName =>lastNameController.text;
  String get email =>emailController.text;
  String get phone =>phoneController.text;
  String get address =>addressController.text;

  final _key = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getBusinessMethod(context);
    initMethod();
  }

  initMethod(){
    if(widget.customer!=null){
      firstNameController.text=widget.customer!.firstName;
      lastNameController.text=widget.customer!.lastName;
      emailController.text=widget.customer!.email;
      phoneController.text=widget.customer!.phone;
      addressController.text=widget.customer!.address==null?"":widget.customer!.address["home"];

    }

    getBusinessMethod(context);
  }

  bool isLoading=false;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.customer==null? "New Customer":"Edit Customer",),
      backgroundColor: Colors.white,
      body: isLoading? Center(child: CircularProgressIndicator()):
      Container(
        width: MySize.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: SingleChildScrollView(
            child:
            Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: MySize.size10,),

                  InputWithTitle(
                    fieldLabel: "First Name",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: firstNameController,
                        validator:     MinLengthValidator(2, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Last Name",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: lastNameController,
                        validator:     MinLengthValidator(2, errorText: 'Field is require'),
                        onChanged: (txt){}),
                  ),
                  if( widget.customer==null )       SizedBox(height: MySize.size10,),
                  if( widget.customer==null )   InputWithTitle(
                    fieldLabel: "Email",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: emailController,
                        validator: emailValidator,
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Phone",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        placeholderText: "+2348 0000 000",
                        keyboardType: TextInputType.number,
                        validator:     MinLengthValidator(10, errorText: 'At least 10 character'),
                        controller: phoneController,
                        onChanged: (txt){}),
                  ),



                  SizedBox(height: MySize.size10,),

                  InputWithTitle(
                    fieldLabel: "Address",
                    inputWidget: Txt(
                        width: MySize.screenWidth,
                        controller: addressController,
                        onChanged: (txt){}),
                  ),
                  SizedBox(height: MySize.size10,),
                  InputWithTitle(
                    fieldLabel: "Store",
                    inputWidget:  MyDropDown(
                        hint: "Select Store",
                        width: MySize.screenWidth,
                        drop_value: business,
                        itemFunction: businessList!.map((item) {
                          return DropdownMenuItem(
                            child: new Text("${item.storeName}"),
                            value: item.id,
                          );
                        }).toList() ??
                            [],
                        onChanged: (newValue) async {
                          print(newValue);
                          business=newValue.toString();
                        }
                    ),
                  ),


                  SizedBox(height: MySize.size20,),

                  FillButton(
                      width: MySize.screenWidth,
                      height: 45,
                      text:widget.customer==null?"Add Customerf":"Update Customer",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: MySize.size14,
                      enabledColor: AppTheme.primaryColor,
                      enabled: true,
                      onPressed: (){
                        // getCountryMethod();
                        if(_key.currentState!.validate()){
                          addCustomerMethod(context);
                        }else
                          return;
                      }),

                  SizedBox(height: MySize.size100,),


                ],
              ),
            )

        ),
      ),
    );
  }


  double imgH = MySize.size100 * 2;
  double imgW = MySize.size100 * 2;
  File? _selectedFile;
  bool _inProcess = false;
  Dio dio = Dio();
  var avatar;



  void addCustomerMethod(context) async {
    String url="";
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    String filePath="";
    String filename="";
    if(_selectedFile!=null){
      filePath=_selectedFile!.path;
      filename=basename(filePath);
    }

    print(filePath);
var addressJson=json.encode({"home":address});
    var body = FormData.fromMap(
        {
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
          "email": email,
          "address": addressJson,
          "business": business,

        }
    );
    print(body.fields);
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    try{
      if(widget.customer==null){
        url=  baseUrl + '/customers/';
        res=  await RequestHelper.postRequestAuth(url, body);
      }else{
        url=  baseUrl + '/customers/${widget.customer!.id}/';
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
        myData = res[0]["data"]["data"];
        print("MyData");
        setState(() {
          firstNameController.clear();
          lastNameController.clear();
          emailController.clear();
          phoneController.clear();
          addressController.clear();
          _selectedFile=null;
        });

        Navigator.pop(context,"success");
        MotionToast.success(
            title:  Text("Successful"),
            description:  Text(widget.customer==null? "Account Created":"Account updated")
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


  List<Country> countryList=[];
  void getCountryMethod() async {
    String url = baseUrl + '/countries/';
    if (mounted)
      setState(() {
        countryList.clear();
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
        );
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        setState(() {
          countryList= countryFromJson(json.encode(myData));
          country= countryList[0].id.toString();
          isLoading=false;
        });
        log(countryList[0].name);


      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  String business="";
  List<Business> businessList=[];
  void getBusinessMethod(context) async {
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





}
