import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';

class UserDP extends StatelessWidget {
  String title;
  String subtitle;
  String? image;
  bool shouldShowOnlyDP;


  UserDP(
      {this.title = "Hello!",
        this.subtitle = "",
        this.shouldShowOnlyDP = false,
        this.image=""});


  @override
  Widget build(BuildContext context) {
    Color borderColor = Color(0xFF55688B);

    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(
              left: MySize.size20,
              right: MySize.size10,
              top: MySize.size5),
          // padding: EdgeInsetsDirectional.fromSTEB(10, 10, 20, 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
            // clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all( width: 0),
                image: DecorationImage(image: NetworkImage(image.toString()))),
            // image: NetworkImage('https://picsum.photos/seed/126/600'))),
          ),
        ),


        if( currentUser!=null && !shouldShowOnlyDP) Container(
          margin: EdgeInsets.only(right: MySize.size10,top: MySize.size18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello," ,style: TextStyle(color: AppTheme.primaryColor,fontSize: MySize.size14),),
              Text("${currentUser!.firstName}" ,style: TextStyle(color: AppTheme.primaryColor,fontWeight: FontWeight.bold,fontSize: MySize.size14),),
            ],
          ),
        ),
      ],
    );
  }
}
