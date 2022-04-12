import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/controller/userController.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/business.dart';
import 'package:user/model/serviceModel.dart';
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/screens/dashboard/pos/cartScreen.dart';
import 'package:user/screens/settings/business/businessDetails.dart';
import 'package:user/screens/settings/business/newBusiness.dart';
import 'package:user/screens/settings/category/categoryScreen.dart';
import 'package:user/screens/settings/services/newServiceScreen.dart';
import 'package:user/screens/settings/settingScreen.dart';
import 'package:user/widgets/dashCard.dart';
import 'package:user/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:user/widgets/userDp.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({Key? key}) : super(key: key);
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getServicesMethod();

  }
  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: MyAppBar(title: "Services",),
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
         var page = await  Navigator.of(context,rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => NewServiceScreen(),
              ),
            );

         if(page=="success"){
              cartProvider.getServicesMethod();
         }

          },
          child: Icon(Icons.add),
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        ),
        body: Builder(builder: (context) {
          if(cartProvider.isLoading==true){
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            // height: MySize.size200,
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartProvider.serviceList.length,
                        itemBuilder: (BuildContext context, index) {
                          if (index == cartProvider.serviceList.length) {
                            return Container();
                          }
                          {
                            ServiceModel result = cartProvider.serviceList[index];
                            print("LISTVIEW");
                            print(result.cost);
                            print(result.cost);
                            print(result.cost);
                            print(result.cost);
                            return Column(
                              children: [
                                InkWell(
                              onTap:()async{
                                var page=await  Navigator.of(context,rootNavigator: true).push(
                                      MaterialPageRoute(
                                        builder: (context) => NewServiceScreen(
                                          serviceModel: result,
                                        ),
                                      ),
                                    );

                                    if(page=="success"){
                                      cartProvider.getServicesMethod();
                                    }

                                  },
                                  child: ListTile(
                                    title:Text(result.name),
                                    subtitle: Text(AppTheme.money(double.parse(result.cost.toString()))),
                                    // subtitle1: result.description,
                                  ),
                                )   ,
                                // Divider()
                              ],
                            );
                          }
                          //end of tile
                        })),

              ],
            ),
          );
        })



    );
  }

  bool isLoading=false;

}


