import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';

class BusinessProvider extends ChangeNotifier{
 String baseStore="";
  bool isLoading =false;
  BusinessProvider(){
  getBusinessMethod();
  }

  List<Business> businessList=[];
  void getBusinessMethod() async {
    String url = baseUrl + '/business/';
    // if (mounted)
    businessList.clear();
    isLoading = true;

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
        // MotionToast.error(
        //     height: MySize.size200,
        //     title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
        //     description:  Text("${replaceString(res[0]["message"].toString())}")
        // ).show(context);
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        // setState(() {
        businessList= businessFromJson(json.encode(myData));
        // business= businessList[0].id.toString();
        isLoading = false;
        // });
        log(businessList[0].storeName);


      }
    }
    catch(e){
      print("CATCH");
      print(e.toString());
      isLoading =false;
      // MotionToast.error(
      //   title:  Text("Unsuccessful"),
      //   description:  Text("${e.toString()}"),
      // ).show(context);
    }

    // setState(() {
    isLoading = false;
    // });
    notifyListeners();

  }

  setBaseStore(businessId){
    baseStore=businessId;
    print(baseStore);
    notifyListeners();
  }
}