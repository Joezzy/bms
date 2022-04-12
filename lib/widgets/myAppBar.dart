








import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/widgets/userDp.dart';


class MyAppBar extends StatefulWidget implements PreferredSizeWidget{

  final String title;
   MyAppBar({Key? key,this.title=""}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MySize.size100),


      // here the desired height
      child: AppBar(
        title: Text(widget.title,style:TextStyle(color:Colors.black,fontSize: MySize.size16) ,),
        iconTheme: IconThemeData(color: AppTheme.primaryColor),
        centerTitle: false,
        elevation: 0.5,
        actions: [
          UserDP(
            shouldShowOnlyDP: true,
            image:"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png",
          ),
        ],          backgroundColor: AppTheme.whiteBackground,

      ),
    );
  }
}
