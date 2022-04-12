import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/category.dart';
import 'package:user/model/countries.dart';
import 'package:user/model/country.dart';
import 'package:user/model/supplier.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';

class NewSupplierScreen extends StatefulWidget {
  Supplier? supplier;
   NewSupplierScreen({Key? key, this.supplier}) : super(key: key);

  @override
  _NewSupplierScreenState createState() => _NewSupplierScreenState();
}

class _NewSupplierScreenState extends State<NewSupplierScreen> {
  String category="";
  String country="";


  final _key = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address')
  ]);


  initMethod(){
    if(widget.supplier!=null){
       contactNameController.text=widget.supplier!.contactPerson;
       contactPhoneController.text=widget.supplier!.contactPhone ;
       emailController.text=widget.supplier!.email;
       phoneController.text=widget.supplier!.phone ;
       addressController.text=widget.supplier!.address;
       storeNameController.text=widget.supplier!.name;
       // productController.text=widget.supplier!.p;
       // stateController.text=widget.supplier!.state;
       category=widget.supplier!.category.toString();
    }
  }

  TextEditingController contactNameController=TextEditingController();
  TextEditingController contactPhoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController storeNameController=TextEditingController();
  TextEditingController productController=TextEditingController();
  TextEditingController stateController=TextEditingController();

  bool showPassword=false;

  String get storeName =>storeNameController.text;
  String get email =>emailController.text;
  String get phone =>phoneController.text;
  String get contactName =>contactNameController.text;
  String get contactPhone =>contactPhoneController.text;
  String get product =>productController.text;
  String get address =>addressController.text;
  String get state =>stateController.text;

bool isLoading=false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryMethod();
    getCountryMethod();
    initMethod();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: widget.supplier==null?"New Supplier":"Edit Supplier",),
      body: isLoading? Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Stack(

          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: MySize.size20),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [



                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
                      fieldLabel: "Store Name",
                      inputWidget: Txt(
                        // width: MySize.size300,
                          controller: storeNameController,
                          validator:  RequiredValidator(errorText: 'This field is required'),
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),
                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
                      fieldLabel: "Phone",
                      inputWidget: Txt(
                        // width: MySize.size300,
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          validator:  MinLengthValidator(10,errorText: 'At least 10 characters'),
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),
                    SizedBox(height: MySize.size10,),

                    InputWithTitle(
                      fieldLabel: "Email",
                      inputWidget: Txt(
                        // width: MySize.size300,
                          controller: emailController,
                          validator: emailValidator,
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),
                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
                      fieldLabel: "Contact Name",
                      inputWidget: Txt(
                        controller: contactNameController,
                          validator:  RequiredValidator(errorText: 'This field is required'),
                          // width: MySize.size300,
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),
                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
                      fieldLabel: "Contact Phone",
                      inputWidget: Txt(
                        // width: MySize.size300,
                          controller: contactPhoneController,
                          keyboardType: TextInputType.number,
                          validator:  MinLengthValidator(10,errorText: 'At least 10 characters'),
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),
                    SizedBox(height: MySize.size10,),

                    InputWithTitle(
                      fieldLabel: "Address",
                      inputWidget: Txt(
                          // width: MySize.size300,
                        controller: addressController,
                          validator:  RequiredValidator(errorText: 'This field is required'),
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),

                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
                      fieldLabel: "Country",
                      inputWidget:  MyDropDown(
                          hint: "Select Category",
                          drop_value: country,
                          itemFunction: countryList?.map((item) {
                            return DropdownMenuItem(
                              child: new Text("${item.name}"),
                              value: item.id,
                            );
                          })?.toList() ??
                              [],
                          onChanged: (newValue) async {
                            print(newValue);

                            country=newValue.toString();
                          }
                      ),
                    ),
                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
                      fieldLabel: "State",
                      inputWidget: Txt(
                          // width: MySize.size300,
                        controller: stateController,
                          validator:  RequiredValidator(errorText: 'This field is required'),
                          placeholderText: "",
                          onChanged: (txt){}),
                    ),

                    SizedBox(height: MySize.size10,),
                    InputWithTitle(
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
                    SizedBox(height: MySize.size20,),




                    FillButton(
                      // fontColor: Colors.white,
                        height: 45,
                        width: MySize.size650,
                        text:widget.supplier==null?"Add Supplier":"Update supplier",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: MySize.size14,
                        enabledColor: AppTheme.primaryColor,
                        enabled: true,
                        onPressed: (){
                        if(_key.currentState!.validate()){
                            addSupplier();
                        }
                        else
                          return;

                        }),
                    SizedBox(height: MySize.size20,),


                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void addSupplier() async {
    String url="";

if(widget.supplier==null){
  url= baseUrl + '/supplier/';

}   else{
  url= baseUrl + '/supplier/${widget.supplier!.id}/';
}

    if (mounted)
      setState(() {
        isLoading = true;
      });
    // firstname, lastname, username, email, phone, password, account_type)
    //
    // optional: (profilePics, business_name, business_address, business_email)
    var myData;
    var body = json.encode(
        {
          "name": storeName,
          "phone": phone,
          "email": email,
          "contact_person": contactName,
          "contact_phone": contactPhone,
          "country": country,
          "category": category,
          "state": state,
          "address": address,
        }

    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    // try{
      if(widget.supplier==null) {
          res=  await RequestHelper.postRequestAuth(url, body);

      }else{
          res=  await RequestHelper.patchRequestAuth(url, body);

      }
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
        myData = res[0]["data"]["data"];
        print("MyData");
        // print(myData["token"]);

        setState(() {
          phoneController.clear();
          emailController.clear();
          contactNameController.clear();
          contactPhoneController.clear();
          stateController.clear();
          addressController.clear();
          storeNameController.clear();
        });
        // MotionToast.success(
        //     title:  Text("Successful"),
        //     description:  Text("Account Created")
        // ).show(context);

        Navigator.pop(context,"success");

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          confirmBtnColor: AppTheme.primaryColor,
          backgroundColor: AppTheme.primaryColor,
          text:widget.supplier==null? "Supplier added!":"Detail updated!",
        );

        // Navigator.of(context, rootNavigator: true,).pop();

      }
    // }
    // catch( e){
    //   print("CATCH");
    //   print(e.toString());
    //   CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.error,
    //     confirmBtnColor: AppTheme.primaryColor,
    //     backgroundColor: AppTheme.primaryColor,
    //     text: "${replaceString(e.toString())}",
    //   );
    // }

    setState(() {
      isLoading = false;
    });
  }

  List<Category> categoryList=[];
  void getCategoryMethod() async {
    String url = baseUrl + '/category/';
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
          if(widget.supplier==null){
            category= categoryList[0].id;
          }
          isLoading=false;
        });
        log(categoryList[0].name);

      }
    // }
    // catch( e){
    //   print("CATCH-CAT");
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
        ).show(context);
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        setState(() {
          countryList= countryFromJson(json.encode(myData));
          country= countryList[0].id;
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
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }

}
