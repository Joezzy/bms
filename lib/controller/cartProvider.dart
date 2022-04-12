
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/cart.dart';
import 'package:user/model/category.dart';
import 'package:user/model/customer.dart';
import 'package:user/model/serviceModel.dart';

class CartProvider extends ChangeNotifier{
  CartProvider(){

  }
  List<dynamic> allItem=[];
  List<Cart>? cartList=[];
  List<ServiceModel>? selectedServiceList=[];
  List serviceIDList=[];
  List<ServiceModel> serviceList=[];
  Customer? selectedCustomer;


  addToCart(Cart cartItem){
    cartList!.add(cartItem);
    notifyListeners();
  }

  removeFromCart(index){
    cartList!.removeAt(index);
    allItem!.removeAt(index);
    print(index);
    print(cartList!.length);
    print(allItem.length);
    notifyListeners();
  }
  clearService(){
    selectedServiceList!.clear();
    serviceIDList.clear();
  }


  void onServiceSelected(selected,ServiceModel service) {
    if (selected == true) {
      selectedServiceList!.add(service);
      serviceIDList.add({"id": service.id, "amount": service.cost});
    } else {
      selectedServiceList!.remove(service);
      serviceIDList.removeWhere((item) => item["id"] == service.id);

    }
    selectedServiceList!.forEach((element) {
      print(element.name);
    });
    notifyListeners();
  }

  void onCustomerSelected(Customer customer) {
    selectedCustomer=customer;

    print(selectedCustomer!.id);
    print(selectedCustomer!.firstName);
    print(selectedCustomer!.lastName);
    notifyListeners();
  }
  void onCustomerRemoved(Customer? customer) {
    selectedCustomer=new Customer();
    notifyListeners();
  }



  bool  isLoading=false;
  void getServicesMethod() async {
    String url = baseUrl + '/services/';
    isLoading=false;
    var myData;
    var body = json.encode(
        {}
    );
    try{
      final  res=  await RequestHelper.getRequestAuth(url, body);
      print("OKP");
      print(res);
      if (res[0]["status"] == "failed") {
        print(res[0]["data"]);
        isLoading=false;
      } else {
        myData = res[0]["message"];
        print("MyData");
        log(json.encode(myData));
        serviceList= serviceModelFromJson(json.encode(myData));
      }
    }

    catch( e){
      print("CATCH");
      print(e.toString());
      isLoading = false;
    }

    isLoading = false;
    notifyListeners();
  }


  void addOrderMethod(context) async {
    String url="";
    isLoading = true;
    var myData;
    // var body=FormData.fromMap({atem});
    // print(allItem);
    SharedPreferences crypt = await SharedPreferences.getInstance();
    var res;

    try{
      url=  baseUrl + '/orders/';
      res=  await RequestHelper.postRequestAuth(url, allItem);

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
        log(json.encode(res[0]["data"]));
        // firstNameController.clear();
        // lastNameController.clear();
        // emailController.clear();
        // phoneController.clear();
        // addressController.clear();
        // _selectedFile=null;

        Navigator.pop(context,"success");
        MotionToast.success(
            title:  Text("Successful"),
            description:  Text("Order placed successfully")
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

    isLoading = false;
  }

  List<Customer> customerList=[];

  void getCustomers(context) async {
    String url = baseUrl + '/customers/';
    isLoading = true;
    var myData;
    var body = json.encode(
        {}
    );
    // List res;
    try{
      final  res=  await RequestHelper.getRequestAuth(url, body);
      print("OKP");
      // log(json.encode(res));
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

        customerList= customerFromJson(json.encode(myData));
        isLoading=false;
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
    isLoading = false;
    notifyListeners();
  }




}