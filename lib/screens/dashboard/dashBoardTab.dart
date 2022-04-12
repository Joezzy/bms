import 'dart:convert';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/model/currentUser.dart';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';

import 'package:user/screens/dashboard/dashboardScreen.dart';
import 'package:user/screens/dashboard/inventory/inventoryTab.dart';
import 'package:user/screens/dashboard/operation/orderScreen.dart';
import 'package:user/screens/dashboard/pos/cartScreen.dart';
import 'package:user/screens/dashboard/pos/posScreen.dart';
import 'package:user/screens/dashboard/users/userTab.dart';
import 'package:user/screens/settings/settingScreen.dart';


import 'package:user/widgets/userDp.dart';

class DashBoardTab extends StatefulWidget {
  int pageIndex;
  DashBoardTab({Key? key,this.pageIndex=0}) : super(key: key);

  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> with SingleTickerProviderStateMixin {

  late  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index=widget.pageIndex;
    onItemClicked(widget.pageIndex);
  }


  var pageTitle="Mobile Banking";
//////
  onItemClicked(int index) {
    setState(() {
      if (index==0){
        pageTitle="Stock";
      }

      print(index);
      // selectedIndex = index;
      // widget.pageIndex=index;
      _tabController.index = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    TextStyle tabStyle=TextStyle(fontSize: MySize.size12,fontWeight: FontWeight.w600);

    return DefaultTabController(
      length: 5,
      initialIndex: widget.pageIndex,
      child: Scaffold(
        // drawer:,

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
                        image:currentUser!.avatar!=""? currentUser!.avatar: "https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png",
                        title: "",
                        subtitle:
                        "Logout",
                      ),
                  ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                        horizontal:MySize.size20,
                        vertical:MySize.size4,
                      ),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: ()=>   Navigator.of(context,rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => CartScreen(),
                              ),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.all(10.0),
                              child: Icon(Icons.shopping_cart_outlined,color: AppTheme.primaryColor,),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              // left: 0,
                              child: Container(
                                  height: MySize.size20,
                                  width: MySize.size20,
                                  // padding: EdgeInsets.all(MySize.size2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppTheme.heventhBlue
                                  ),
                                  child: Center(child: Text("${cartProvider.cartList!.length.toString()}",style: TextStyle(color: AppTheme.whiteBackground,fontSize: MySize.size12),)))),

                        ],
                      ),
                    )
                  ],
                ),
              )
        ],
            elevation: 0,
            backgroundColor: AppTheme.whiteBackground,
            bottom:  TabBar(
              padding: EdgeInsets.all(4),
              indicatorColor: AppTheme.primaryColor,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              onTap: onItemClicked,
              tabs:   [
                Tab(
                  child:  InkWell(
                    // onTap: ()=>onItemClicked(0),
                    child: Text("Dashboard",style: tabStyle,),
                  ),

                ),
                Tab(
                  child:  Text("Inventory",
                    overflow: TextOverflow.ellipsis,
                    style: tabStyle,),
                ),
                Tab(
                  child:  Text("Users",style: tabStyle,),
                ),
                Tab(
                  child:  Text("POS",style: tabStyle,),
                ),
                Tab(
                  child:  Text("Orders",style: tabStyle,),
                ),


              ],
            ),
          ),
        ),

        body: isLoading?Center(child: CircularProgressIndicator()): Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [

              Expanded(
                  child: TabBarView(
                    children:  [
                      DashBoardScreen(),
                      InventoryTab(),
                      UserTab(),
                      PosScreen(),
                      OrderScreen(),



                    ],
                  )
              ),

            ],
          ),
        ),


      ),
    );

  }

 bool isLoading = true;
  void getUser() async {
    String url = baseUrl + '/users/';
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
      print(res);
      if (res[0]["status"] == "failed") {
        print(res[0]["data"]);
        MotionToast.error(
            height: MySize.size200,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);
      } else {
        myData = res[0]["message"][0];
        print("MyData");
        log(json.encode(myData).toString());


        setState(() {
          currentUser=currentUserFromJson(json.encode(myData));
          print(currentUser!.firstName);
          print(currentUser!.lastName);
          isLoading=false;
        });
        Provider.of<BusinessProvider>(context,listen: false).setBaseStore(currentUser!.business);

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


}

