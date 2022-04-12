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
import 'package:user/model/country.dart';
import 'package:user/screens/settings/category/newcategory.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';

class NewBusinessScreen extends StatefulWidget {
  Business? business;
  PageSetting pageSetting;
   NewBusinessScreen({Key? key,this.pageSetting=PageSetting.inApp,this.business}) : super(key: key);

  @override
  _NewBusinessScreenState createState() => _NewBusinessScreenState();
}

class _NewBusinessScreenState extends State<NewBusinessScreen> {
  String country="";
  String province="";


  TextEditingController storeNameController=TextEditingController();
  TextEditingController businessAddressController=TextEditingController();


  String get storeName =>storeNameController.text;
  String get businessAddress =>businessAddressController.text;


  final requiredValidator = RequiredValidator(errorText: 'this field is required');
  final _key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountryMethod();
    initMethod();

  }

  initMethod(){
if(widget.business!=null){
  setState(() {
    businessAddressController.text=widget.business!.address;
  });
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: widget.business==null?"New Store":"Edit ${widget.business!.storeName}",),

      body: isLoading?Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Container(
width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: MySize.size20),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MySize.size30),

           if(widget.business==null)     Text("Create New Store",
                  style: TextStyle(color: AppTheme.primaryColor,
                      fontSize: MySize.size18),
                ),

                SizedBox(height: MySize.size30),
                if(widget.business==null)         InputWithTitle(
                  fieldLabel: "Store Name",
                  inputWidget: Txt(
                    controller: storeNameController,
                      width: MySize.screenWidth,
                      validator: requiredValidator,
                      placeholderText: "",
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Store Address",
                  inputWidget:   Txt(
                      width: MySize.screenWidth,
                      validator: requiredValidator,
                      controller: businessAddressController,
                      placeholderText: "",
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                if(widget.business==null)            InputWithTitle(
                  fieldLabel: "Country",
                  inputWidget:  MyDropDown(
                      hint: "Select Country",
                      width: MySize.screenWidth,
                      drop_value: country,
                      itemFunction: countryList!.map((item) {
                        return DropdownMenuItem(
                          child: new Text("${item.name}"),
                          value: item.id,
                        );
                      })!.toList() ??
                          [],
                      onChanged: (newValue) async {
                        print(newValue);
                        country=newValue.toString();
                        getProvinceMethod(country);
                      }
                  ),
                ),
                SizedBox(height: MySize.size10,),

                if(widget.business==null)      InputWithTitle(
                  fieldLabel: "State/Province",
                  inputWidget:  MyDropDown(
                      hint: "Select State",
                      width: MySize.screenWidth,
                      drop_value: province,
                      itemFunction: provinceList!.map((item) {
                        return DropdownMenuItem(
                          child: new Text("${item.name}"),
                          value: item.id,
                        );
                      })!.toList() ??
                          [],
                      onChanged: (newValue) async {
                        print(newValue);
                        province=newValue.toString();
                      }
                  ),
                ),
                SizedBox(height: MySize.size30,),

                // InputWithTitle(
                //   fieldLabel: "State/Province",
                //   inputWidget:   Txt(
                //       width: MySize.screenWidth,
                //       validator: requiredValidator,
                //       placeholderText: "",
                //       controller: stateController,
                //       onChanged: (txt){}),
                // ),
                // SizedBox(height: MySize.size30,),

                FillButton(
                    width: MySize.screenWidth,
                    height: 45,
                    text:widget.business==null?"Submit":"Update",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: MySize.size14,
                    enabledColor: AppTheme.primaryColor,
                    enabled: true,
                    onPressed: (){

                    addBusinessMethod();
                    // getCountryMethod();
                    }),
                SizedBox(height: MySize.size20,),

              ],
            ),
          ),

        ),
      ),
    );
  }

 bool isLoading = false;

  void addBusinessMethod() async {
    String url;

    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "store_name": storeName,
          "address": businessAddress,
          "country": country,
          "state": province
     // "country": country,
     //      "state": state
        }
    );

    var bodyUpdate=json.encode({
      "address": businessAddress,
    });

    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    try{
      if(widget.business==null){
        url= baseUrl + '/business/';
        res=  await RequestHelper.postRequestAuth(url, body);

      }else{
        url= baseUrl + '/business/${widget.business!.id}/';
        res=  await RequestHelper.patchRequestAuth(url, bodyUpdate);

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
        print(myData);



if(widget.pageSetting==PageSetting.setup){
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => NewCategoryScreen(
        pageSetting: PageSetting.setup,
      )),
          (Route<dynamic> route) => false);
}else{

  setState(() {
    storeNameController.clear();
    businessAddressController.clear();
  });

  MotionToast.success(
      title:  Text("Successful"),
      description:  Text("Store Created")
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
        getProvinceMethod(country);


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

  List<Province> provinceList=[];
  void getProvinceMethod(id) async {
    String url = baseUrl + '/state/?country_id=$id';
    if (mounted)
      setState(() {
        provinceList.clear();
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
          provinceList= provinceFromJson(json.encode(myData));
          province= provinceList[0].id;
          isLoading=false;
        });
        log(provinceList[0].name);


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