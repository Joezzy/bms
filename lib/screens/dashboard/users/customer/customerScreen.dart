import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/customer.dart';
import 'package:user/screens/dashboard/users/customer/CustomerDetail.dart';
import 'package:user/screens/dashboard/users/customer/newCustomerScreen.dart';



class CustomerScreen extends StatefulWidget {
   CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          var page= Navigator.of(context,rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => NewCustomerScreen(),
            ),
          );

          if(page=="success"){
            getCustomers();
          }
        },

        child: Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      ),
      body:isLoading?Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Padding(
                padding:  EdgeInsets.symmetric(horizontal: MySize.size10),
                child:   Text("Customers",style: TextStyle(fontSize: MySize.size16,fontWeight: FontWeight.bold),),
              ),

              Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      // controller: _scrollController,
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: MySize.size10,
                      // ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: customerList.length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == customerList.length) {
                          return Container();
                        }
                        {
                          Customer result = customerList[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                                  child:Container(
                                      height: MySize.size50,
                                      width: MySize.size50,
                                      color:Colors.grey.withOpacity(0.7),
                                      child: Center(child: Text(result.firstName.substring(0,1),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:MySize.size24 ),))),
                                ) ,

                                title:Text("${result.firstName} ${result.lastName}"),
                                subtitle: Text("${result.phone}"),
                                onTap: ()=> _optionSheet(result,context),
                              )   ,
                              // Divider()
                            ],
                          );
                        }
                        //end of tile
                      })),



            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  List<Customer> customerList=[];
  void getCustomers() async {
    String url = baseUrl + '/customers/';
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

      setState(() {
        customerList= customerFromJson(json.encode(myData));
        isLoading=false;
      });
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

    setState(() {
      isLoading = false;
    });
  }




  void _optionSheet(Customer customer,context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size230,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20 ),
                          child: Text(
                            "${customer.firstName}",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.clipboardListOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("View details "),
                            ],
                          ),
                          onTap: () {

                            Navigator.pop(context);
                            Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => CustomerDetail(
                                  customer: customer,
                                ),
                              ),
                            );


                          },
                        ),
                        ListTile(
                          leading: Icon(MdiIcons.trashCanOutline),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delete "),
                            ],
                          ),
                          onTap: () {


                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                title: "Confirm Deletion",
                                text: "Your transaction was successful!",
                                onConfirmBtnTap: (){
                                  Navigator.of(context, rootNavigator: true).pop();
                                  Navigator.pop(context);
                                  // Navigator.of(context, rootNavigator: true).pop();
                                  // deleteSupplier(staff.id);
                                },
                                onCancelBtnTap : ()=>Navigator.of(context, rootNavigator: true).pop()

                            );


                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }


}
