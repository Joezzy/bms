
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/screens/dashboard/inventory/products/productsScreen.dart';
import 'package:user/screens/dashboard/inventory/stock/stockScreen.dart';
import 'package:user/screens/dashboard/inventory/supplier/supplierScreen.dart';
import 'package:user/screens/dashboard/order/groupOrderScreen.dart';
import 'package:user/screens/dashboard/order/orderScreen.dart';
import 'package:user/screens/dashboard/users/customer/customerScreen.dart';
import 'package:user/screens/dashboard/users/staffs/staffScreen.dart';


int selectedUserIndex = 1;

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab>
    with SingleTickerProviderStateMixin {
  static final _myMortgageTabPageKey =  GlobalKey<_OrderTabState>();
  late  TabController tabController;
  String pageTitle="";
  void onItemClicked(int index) {
    setState(() {
      if (index==0){
      }
      if(index==1){
        pageTitle="Mortgage";
      } else if(index==2){
        pageTitle="Affordabilty Calculator";
      }
      else if(index==3){
        pageTitle="Browse";
      }
      else if(index==4){
        pageTitle="More";
      }
      selectedUserIndex = index;
      tabController.index = selectedUserIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    // onItemClicked(0) ;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        // set initial index to 1
        // initialIndex: 0,
        child: Scaffold(
          backgroundColor: AppTheme.whiteBackground,
          // appBar:(mortgageSelectedIndex!=3)? BrentAppBar(title: pageTitle,):null,
          body: TabBarView(
            key:_myMortgageTabPageKey ,
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[

              OrderScreen(),
              GroupOrderScreen()

              //
            ],

          ),

          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                // // activeIcon:Image.asset("assets/icons/home_on.png",height: 30,),
                  icon:Icon(MdiIcons.giftOutline),
                  label:"Order"),

              BottomNavigationBarItem(
                  icon:Icon(MdiIcons.cubeOutline),
                  label: "Bulk Orders"),

            ],
            currentIndex: selectedUserIndex,
            unselectedItemColor: Colors.green,
            selectedItemColor: Colors.orange,
            //showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontSize:12),
            onTap: onItemClicked,
          ),
        ),
      ),
    );
  }
}