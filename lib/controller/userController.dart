

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/model/currentUser.dart';

class UserProvider extends ChangeNotifier{
  PageState isLoading =PageState.initial;

  UserProvider(){
    getUser();
    // getBusinessMethod();
}


  void getUser() async {
    String url = baseUrl + '/users/';
    isLoading =PageState.loading;
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
        isLoading =PageState.loaded;
        // MotionToast.error(
        //     height: MySize.size200,
        //     title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
        //     description:  Text("${replaceString(res[0]["message"].toString())}")
        // ).show(context);
      } else {
        myData = res[0]["message"][0];
        print("MyData");
        log(json.encode(myData).toString());
          currentUser=currentUserFromJson(json.encode(myData));
          print(currentUser!.firstName);
          print(currentUser!.lastName);
        isLoading =PageState.loaded;
      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      isLoading =PageState.loaded;
      // MotionToast.error(
      //   title:  Text("Unsuccessful"),
      //   description:  Text("${e.toString()}"),
      // ).show(context);

    }

    isLoading =PageState.loaded;

    notifyListeners();
  }






}