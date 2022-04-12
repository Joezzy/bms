import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';

class StaffCard extends StatelessWidget {
  // const ({Key? key}) : super(key: key);
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  VoidCallback? onTap;

  StaffCard({
    this.title = '',
    this.subtitle1 = '',
    this.subtitle2 = '',
    this.subtitle3 = '',
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MySize.size100,
        margin: EdgeInsets.symmetric(
          horizontal: MySize.size10,
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySize.size30),),
        child: Card(
          // color: baxiColor,
          elevation: 1,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySize.size10),
          ),
          child: Container(
            height: MySize.size165,
            width: MySize.screenWidth,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              // color: baxiColor
            ),
            margin: EdgeInsets.symmetric(vertical: MySize.size16,),
            padding: EdgeInsets.symmetric(horizontal: MySize.size20,),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title),

                    Text(subtitle1),
                  ],),
                Divider(thickness: 1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subtitle3),
                    Text(subtitle2),
                  ],)

              ],
            ),

          ),
        ),
      ),
    );
  }
}
