
import 'package:flutter/material.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/screens/dashboard/inventory/products/productsScreen.dart';
import 'package:user/screens/dashboard/inventory/stock/stockScreen.dart';
import 'package:user/screens/dashboard/inventory/supplier/supplierScreen.dart';


int mortgageSelectedIndex = 1;

class InventoryTab extends StatefulWidget {
  @override
  _InventoryTabState createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab>
    with SingleTickerProviderStateMixin {
  static final _myMortgageTabPageKey =  GlobalKey<_InventoryTabState>();
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
      mortgageSelectedIndex = index;
      tabController.index = mortgageSelectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    // onItemClicked(1) ;
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
        length: 3,
        // set initial index to 1
        initialIndex: 2,
        child: Scaffold(
          backgroundColor: AppTheme.whiteBackground,
          // appBar:(mortgageSelectedIndex!=3)? BrentAppBar(title: pageTitle,):null,
          body: TabBarView(
            key:_myMortgageTabPageKey ,
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[
              ProductScreen(),
              StockScreen(),
              SupplierScreen()

              //
            ],

          ),

          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                // activeIcon:Image.asset("assets/icons/dash_on.png",height: 30,),
                  icon:Icon(Icons.tab),
                  label: "Product"),
              BottomNavigationBarItem(
                  // // activeIcon:Image.asset("assets/icons/home_on.png",height: 30,),
                  icon:Icon(Icons.data_usage_rounded),
                  label:"Stock"),

              BottomNavigationBarItem(
                  icon:Icon(Icons.account_circle_outlined),
                  label: "Supplier"),

            ],
            currentIndex: mortgageSelectedIndex,
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