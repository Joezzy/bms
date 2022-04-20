import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
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
import 'package:user/screens/dashboard/order/NewWIP.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';


class OrderDetailScreen extends StatefulWidget {
  wipList? order;
  OrderDetailScreen({Key? key,this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
        title: Text("${widget.order!.product!.name}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          // InkWell(
          //   onTap: (){
          //     Navigator.of(context,rootNavigator: true).push(
          //       MaterialPageRoute(
          //         builder: (context) => NewSupplierScreen(
          //           supplier: widget.order,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Padding(
          //     padding:  EdgeInsets.only(right: 10.0),
          //     child: Icon(MdiIcons.squareEditOutline ),
          //
          //
          //   ),
          // )
        ],

      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MySize.size20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                    child:Image.network(
                      widget.order!.product!.image==null?"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png":
                      widget.order!.product!.image,
                      fit: BoxFit.cover,
                      height: MySize.size300,),
                  ) ,

                  ListTile(
              title: Text("Order Number"),
              subtitle: Text("${widget.order!.orderId}"),
            ),
                  ListTile(
                    title: Text("Product Name"),
                    subtitle: Text("${widget.order!.product!.name}"),
                  ),
                  ListTile(
                    title: Text("Payment Status "),
                    subtitle: Text("${widget.order!.status=="payment_confirmed"?"Paid":"Pending"}"),
                  ),
                  ListTile(
                    title: Text("Total Cost"),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" ${widget.order!.qty} x ${widget.order!.product!.salesPrice} "),
                        Text("${widget.order!.totalCost} "),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text("Option"),
                    subtitle: Text(" ${widget.order!.product!.selectableOptions!.color}, ${widget.order!.product!.selectableOptions!.style} "),
                  ),
                  if(widget.order!.service!.length>0)
                    Column(
                   children: [
                     DetailHeader(title: "Services"),
                     Container(
                         child: ListView.builder(
                             shrinkWrap: true,
                             // scrollDirection: Axis.horizontal,
                             // controller: _scrollController,
                             // padding: EdgeInsets.symmetric(
                             //   horizontal: MySize.size10,
                             // ),
                             physics: NeverScrollableScrollPhysics(),
                             itemCount:widget.order!.service!.length,
                             itemBuilder: (BuildContext context, index) {
                               if (index == widget.order!.service!.length) {
                                 return Container();
                               }
                               {
                                 Service result = widget.order!.service![index];
                                 return ListTile(
                                   title:Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Text("${result.name} "),
                                       Text("${result.amount}")
                                     ],
                                   ),

                                 );
                               }
                               //end of tile
                             })),
                   ],
                 ),

                  if(widget.order!.customer!=null)
            Column(children: [
              DetailHeader(title: "Customer"),

              ListTile(
                title: Text("Name"),
                subtitle: Text("${widget.order!.customer!.firstName} ${widget.order!.customer!.lastName}"),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text("${widget.order!.customer!.email}"),
              ),
              ListTile(
                title: Text("Phone"),
                subtitle: Text("${widget.order!.customer!.phone}"),
              ),
              ListTile(
                title: Text("Address"),
                subtitle: Text("${widget.order!.customer!.address!.home}"),
              ),
            ],),

                  // if(widget.order!.staff!=null)
                    Column(children: [
                      DetailHeader(title: "Staff"),
                      ListTile(
                        title: Text("Name"),
                        subtitle: Text("${widget.order!.staff!.firstName} ${widget.order!.staff!.lastName}"),
                      ),

                      // ListTile(
                      //   title: Text("Email"),
                      //   subtitle: Text("${widget.order!.staff!.email}"),
                      // ),
                      // ListTile(
                      //   title: Text("Phone"),
                      //   subtitle: Text("${widget.order!.staff!.phone}"),
                      // ),
                      // ListTile(
                      //   title: Text("Designation"),
                      //   subtitle: Text("${widget.order!.staff!.designation}"),
                      // ),

                      SizedBox(
                        height: 200,
                      )
                    ],),

                ],
              ),
            ),
          ),



     widget.order!.status=="payment_confirmed"?
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: FillButton(
              // fontColor: Colors.white,
                height: 45,
                width: MySize.size650,
                text:"CREATE WIP",
                fontColor: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: MySize.size14,
                enabledColor: AppTheme.primaryColor,
                enabled: true,
                onPressed: (){
                  print("jukjj");
                  Navigator.of(context,rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => NewWIPScreen(
                        order: widget.order,
                      ),
                    ),
                  );
                  // _addServicesSheet(context,cartProvider);
                }
          )):
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: FillButton(
              // fontColor: Colors.white,
                height: 45,
                width: MySize.size650,
                text:"Confirm Payment",
                fontColor: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: MySize.size14,
                enabledColor: AppTheme.primaryColor,
                enabled: true,
                onPressed: (){


                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      title: "Confirm Payment",
                      text: "Are you sure payment has been made?",
                      onConfirmBtnTap: (){
                        Navigator.of(context, rootNavigator: true).pop();
                        // Navigator.pop(context);
                        confirmPayment();


                      },
                      onCancelBtnTap : ()=>Navigator.of(context, rootNavigator: true).pop()

                  );



                           }
          ))
        ],
      ),
    );
  }

  bool isLoading = false;

  void confirmPayment() async {
    String url= baseUrl + '/group_orders/${widget.order!.groupOrder["id"]}/';
    // String url= baseUrl + '/group_orders/${widget.order!.id}/';
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    if (mounted)
      setState(() {
        isLoading = true;
      });



    var myData;
    var body = json.encode(
        {
          "status": "payment_confirmed"
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
        text:"Detail updated!",
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
