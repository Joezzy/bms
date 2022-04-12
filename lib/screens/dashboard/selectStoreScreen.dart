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
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/screens/dashboard/pos/cartScreen.dart';
import 'package:user/screens/settings/business/businessDetails.dart';
import 'package:user/screens/settings/business/newBusiness.dart';
import 'package:user/screens/settings/category/categoryScreen.dart';
import 'package:user/screens/settings/settingScreen.dart';
import 'package:user/widgets/dashCard.dart';
import 'package:user/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:user/widgets/userDp.dart';

class SelectStoreScreen extends StatefulWidget {
  SelectStoreScreen({Key? key}) : super(key: key);
  @override
  _SelectStoreScreenState createState() => _SelectStoreScreenState();
}

class _SelectStoreScreenState extends State<SelectStoreScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 Provider.of<BusinessProvider>(context, listen: false).getBusinessMethod();
 Provider.of<UserProvider>(context,listen: false).getUser();

  }
  @override
  Widget build(BuildContext context) {
    final userProvider=Provider.of<UserProvider>(context);
    final businessProvider=Provider.of<BusinessProvider>(context);
    // userProvider.getUser(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MySize.size120), // here the desired height
        child: AppBar(
          actions: <Widget>[
            Container(
              width: MySize.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                    },
                    child: UserDP(
                      image:"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png",
                      title: "",
                      subtitle:
                      "Logout",
                    ),
                  ),
                  ////
                ],
              ),
            )
          ],
          elevation: 0,
          backgroundColor: AppTheme.whiteBackground,
        ),
      ),
      body: Builder(builder: (context) {
      if(businessProvider.isLoading==true){
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
                    itemCount: businessProvider.businessList.length,
                    itemBuilder: (BuildContext context, index) {
                      if (index == businessProvider.businessList.length) {
                        return Container();
                      }
                      {
                        Business result = businessProvider.businessList[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap:(){

                                businessProvider.setBaseStore(result.id);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoardTab(

                                      )),
                                );

                              },
                              child: StoreCard(
                                title:result.storeName,

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


