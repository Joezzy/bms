import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/order.dart';
import 'package:user/model/serviceModel.dart';
import 'package:user/model/wip.dart';
import 'package:user/screens/dashboard/order/NewWIP.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';


class WIPDetailScreen extends StatefulWidget {
  Wip? wip;
  WIPDetailScreen({Key? key,this.wip}) : super(key: key);

  @override
  State<WIPDetailScreen> createState() => _WIPDetailScreenState();
}

class _WIPDetailScreenState extends State<WIPDetailScreen> {
  String selectedStage="5b6b19a8-5cb4-4426-be36-14c017eacd13";
  TextEditingController remarkController=TextEditingController();

  String get remark=>remarkController.text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getServicesMethod();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.wip!.orderDetails!.orderNumber}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,


      ),
      body: isLoading?Center(child: CircularProgressIndicator()): Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MySize.size20),
              child: Column(
                children: [

                  ListTile(
                    title: Text("Order Number"),
                    subtitle: Text("${widget.wip!.orderDetails!.orderNumber}"),
                  ),
                  ListTile(
                    title: Text("Status"),
                    subtitle: Text("${widget.wip!.status}"),
                  ),
                  ListTile(
                    title: Text("Date Created"),
                    subtitle: Text(" ${ DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.wip!.dateCreated.toString()))}"),
                  ),
                  ListTile(
                    title: Text("Remark"),
                    subtitle: Text(" ${ widget..wip!.remark}"),
                  ),
                  ListTile(
                    title: Text("Stage"),
                  ),

                  Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          // scrollDirection: Axis.horizontal,
                          // controller: _scrollController,
                          padding: EdgeInsets.all(0),

                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.wip!.timeline!.length,
                          itemBuilder: (BuildContext context, index) {
                            if (index == widget.wip!.timeline!.length) {
                              return Container();
                            }
                            {
                              Timeline result = widget.wip!.timeline![index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: MySize.size20),
                                    child: Text("${result.stage!.name}"),
                                  ),
                                  // Divider()
                                ],
                              );
                            }
                            //end of tile
                          })),

                  SizedBox(height: 50,),
                  FillButton(
                    // fontColor: Colors.white,
                      height: 45,
                      width: MySize.size650,
                      text:"Complete Stage",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: MySize.size14,
                      enabledColor: AppTheme.primaryColor,
                      enabled: true,
                      onPressed: (){


                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            title: "Confirm Stage",
                            text: "Are you sure you want to complete stage ?",
                            onConfirmBtnTap: (){
                              Navigator.of(context, rootNavigator: true).pop();
                              // Navigator.pop(context);
                              updateWip();

                            },
                            onCancelBtnTap : ()=>Navigator.of(context, rootNavigator: true).pop()

                        );



                      }
                  ),






                ],
              ),
            ),
          ),



        ],
      ),
    );
  }

  bool isLoading = false;

  void updateWip() async {
    String url= baseUrl + '/wip/${widget.wip!.id}/';
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "status": "completed",
          "business_id": "${businessProvider.baseStore}"
        }
    );
    var res;
    // try{

    res=  await RequestHelper.patchRequestAuth(url, body);
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
        text:"WIP Stage Created!",
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



  void _addServicesSheet(context,cartProvider) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MySize.size400,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size20 ),
                          child: Text(
                            "Create WIP Stage",
                            style: TextStyle(
                                fontSize: MySize.size18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MySize.size10 ),
                          child: Text(
                            "Select one stage to create a WIP stage",
                            style: TextStyle(
                                fontSize: MySize.size12, fontWeight: FontWeight.bold),
                          ),
                        ),

                        InputWithTitle(
                          fieldLabel: "Stage",
                          inputWidget:  MyDropDown(
                              hint: "Select Stage",
                              drop_value: selectedStage,
                              itemFunction: cartProvider.serviceList.map((item) {
                                return DropdownMenuItem(
                                  child: new Text("${item.name}"),
                                  value: item.id.toString(),
                                );
                              }).toList() ??
                                  [],
                              onChanged: (newValue) async {
                                print(newValue);
                                selectedStage=newValue.toString();
                              }
                          ),
                        ),                        // Container(
                        //     child: ListView.builder(
                        //         shrinkWrap: true,
                        //         // scrollDirection: Axis.horizontal,
                        //         // controller: _scrollController,
                        //         // padding: EdgeInsets.symmetric(
                        //         //   horizontal: MySize.size10,
                        //         // ),
                        //         physics: NeverScrollableScrollPhysics(),
                        //         itemCount:cartProvider.serviceList.length,
                        //         itemBuilder: (BuildContext context, index) {
                        //           if (index == cartProvider.serviceList.length) {
                        //             return Container();
                        //           }
                        //           {
                        //             ServiceModel result = cartProvider.serviceList[index];
                        //             return RadioListTile(
                        //               value: result.id,
                        //               groupValue: selectedStage,
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   selectedStage = value.toString();
                        //                   print(selectedStage);
                        //                 });
                        //               },
                        //               title: Text(result.name),
                        //             );
                        //           }
                        //           //end of tile
                        //         })),

                        Padding(
                          padding:  EdgeInsets.symmetric( horizontal: MySize.size10),
                          child: InputWithTitle(
                            fieldLabel: "Remark(Optional)",
                            inputWidget:   Txt(
                                controller: remarkController,
                                // validator: RequiredValidator(errorText: 'this field is required'),
                                placeholderText: "",
                                contentPadding: EdgeInsets.all(10),
                                maxLine: 3,
                                onChanged: (txt){}),
                          ),
                        ),

                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                          child: Positioned(
                              bottom: 20,
                              right: 20,
                              left: 20,
                              child: FillButton(
                                // fontColor: Colors.white,
                                  height: 45,
                                  width: MySize.size650,
                                  text:"Create WIP  Stage",
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: MySize.size14,
                                  enabledColor: AppTheme.primaryColor,
                                  enabled: true,
                                  onPressed: (){


                                  }
                              )),
                        ),

                      ],
                    ),
                  ),
                );
              });
        });
  }


}

class DetailHeader extends StatelessWidget {
  String title;
  DetailHeader({
    Key? key,
    this.title=""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MySize.screenWidth,

        color: AppTheme.primaryColor,
        padding: EdgeInsets.all(MySize.size10),
        child: Text(title));
  }
}
