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
import 'package:user/model/product.dart';
import 'package:user/screens/settings/category/NewSubcategory.dart';

import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';

class NewStockScreen extends StatefulWidget {
  PageSetting pageSetting;
  bool is_in;
  NewStockScreen({Key? key, this.pageSetting=PageSetting.inApp,this.is_in=true}) : super(key: key);

  @override
  _NewStockScreenState createState() => _NewStockScreenState();
}

class _NewStockScreenState extends State<NewStockScreen> {
  String business="";
  TextEditingController quantityController=TextEditingController();
  TextEditingController remarkController=TextEditingController();


  String get qty =>quantityController.text;
  String get remark =>remarkController.text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusinessMethod();
    getProduct();
    initMethod();
  }
  // final requiredValidator = RequiredValidator(errorText: 'this field is required');
  final _key = GlobalKey<FormState>();
  initMethod(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title:widget.is_in? "New Stock":"Deplete Stock",),

      body: isLoading?Center(child: CircularProgressIndicator()):
      Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: MySize.size20),


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
                fieldLabel: "Product",
                inputWidget:  MyDropDown(
                    hint: "Select Store",
                    drop_value: product,
                    itemFunction: productList?.map((item) {
                      return DropdownMenuItem(
                        child: new Text("${item.name} ${item.sku}"),
                        value: item.id,
                      );
                    })?.toList() ??
                        [],
                    onChanged: (newValue) async {
                      print(newValue);
                      product=newValue.toString();
                    }
                ),
              ),
              SizedBox(height: MySize.size10,),

              InputWithTitle(
                fieldLabel: "Quantity",
                inputWidget: Txt(
                    placeholderText: "",
                    controller: quantityController,
                    validator: RequiredValidator(errorText: 'this field is required'),
                    onChanged: (txt){}),
              ),
              SizedBox(height: MySize.size10,),
              InputWithTitle(
                fieldLabel: "Remark",
                inputWidget:   Txt(
                    controller: remarkController,
                    placeholderText: "",
                    validator: RequiredValidator(errorText: 'this field is required'),
                    maxLine: 3,
                    onChanged: (txt){}),
              ),


              SizedBox(height: MySize.size30,),


              FillButton(
                // fontColor: Colors.white,
                  height: 45,
                  text:"Submit",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: MySize.size14,
                  enabledColor: AppTheme.primaryColor,
                  enabled: true,
                  onPressed: (){
                    getBusinessMethod();

                    if(_key.currentState!.validate()){
                      addInventory();

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


  String product="";
  List<Product> productList=[];
  void getProduct() async {
    String url = baseUrl + '/product/';
    if (mounted)
      setState(() {
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
    log(json.encode(res));
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
      log(json.encode(res));

      setState(() {
        productList= productFromJson(json.encode(myData));
        product=productList[0].id;
        isLoading=false;
      });
      // log(categoryList[0].name);

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


  void addInventory() async {
    String url;
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "quantity": qty,
          "is_in": widget.is_in,
          "remark": remark,
          "product": product,
          "business": business
        }
    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;
    try{


        url = baseUrl + '/inventory/';

        res=  await RequestHelper.postRequestAuth(url, body);

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
            quantityController.clear();
            remarkController.clear();
          });

          MotionToast.success(
              title:  Text("Successful"),
              description:  Text("Action successful")
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