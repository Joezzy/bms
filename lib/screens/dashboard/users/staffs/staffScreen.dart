import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/staff.dart';
import 'package:user/screens/dashboard/users/staffs/newStaffScreen.dart';
import 'package:user/screens/dashboard/users/staffs/staffDetails.dart';



class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  _StaffScreenState createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStaff();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         var page= Navigator.of(context,rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => NewStaffScreen(),
            ),
          );

         if(page=="success"){
           getStaff();
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
                child:   Text("Staff",style: TextStyle(fontSize: MySize.size16,fontWeight: FontWeight.bold),),
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
                      itemCount: staffList.length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == staffList.length) {
                          return Container();
                        }
                        {
                          Staff result = staffList[index];
                          return Column(
                            children: [
                              ListTile(
                                leading:ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                              child:Image.network(
                                  result.avatar==null?"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png":
                                  result.avatar.toString()),
                              ) ,
                                  title:Text("${result.firstName} ${result.lastName}"),
                                subtitle: Text("${result.designation}"),
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
  List<Staff> staffList=[];
  void getStaff() async {
    final businessProvider=Provider.of<BusinessProvider>(context,listen: false);

    String url = baseUrl + '/staff/?business_id=${businessProvider.baseStore}';
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
          staffList= staffFromJson(json.encode(myData));
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

  void deleteSupplier(id) async {
    String url = baseUrl + '/supplier/delete/$id/';
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
    final  res=  await RequestHelper.deleteRequestAuth(url, body);
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
      // myData = res[0]["message"]["data"];
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        confirmBtnColor: AppTheme.primaryColor,
        backgroundColor: AppTheme.primaryColor,
        text: "Staff deleted!",
      );
      print("MyData");
      log(json.encode(myData));
      setState(() {
        isLoading=false;
      });


      getStaff();

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



  void _optionSheet(Staff staff,context) async {
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
                            "${staff.firstName}",
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
                                builder: (context) => StaffDetail(
                                  staff: staff,
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
