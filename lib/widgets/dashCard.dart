import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';

class DashCard extends StatelessWidget {
  final String title;
  final String value;
  final String imageIcon;
  DashCard({
    Key? key,
    this.title="",
    this.value="",
    this.imageIcon="assets/filetext.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:MySize.size20,horizontal :MySize.size24),
      margin: EdgeInsets.symmetric(vertical:MySize.size10,horizontal :MySize.size5),
      width: MySize.size350,
      // height: MySize.size100,
      decoration: BoxDecoration(
        color: AppTheme.whiteBackground,
        borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),

        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey, //edited
            spreadRadius: 0.02,
            blurRadius: 0.09,
            // offset: new Offset(2.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,style: TextStyle(fontSize: MySize.size20,fontWeight: FontWeight.bold,color: Colors.black54),),
                  Text(title,style: TextStyle(fontSize: MySize.size18,fontWeight: FontWeight.bold,color: Colors.grey),),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(MySize.size50)),
                child:Container(
                    height: MySize.size60,
                    width: MySize.size60,
                    color: AppTheme.primaryColor,
                    padding: EdgeInsets.all(MySize.size14),
                    child: Image.asset(imageIcon,
                      width: MySize.size10,
                      height: MySize.size10,

                    )),
              )
            ],),
          SizedBox(height: MySize.size20),
          Text("+38.5% last 30-days",style: TextStyle(fontSize: MySize.size14,fontWeight: FontWeight.bold,color: Colors.black54),),

        ],
      ),
    );
  }
}



class StoreCard extends StatelessWidget {
  final String title;
  final String imageIcon;
  StoreCard({
    Key? key,
    this.title="",
    this.imageIcon="assets/filetext.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:MySize.size24,horizontal :MySize.size24),
      margin: EdgeInsets.symmetric(vertical:MySize.size10,horizontal :MySize.size14),
      decoration: BoxDecoration(
        color: AppTheme.whiteBackground,
        borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),

        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey, //edited
            spreadRadius: 0.02,
            blurRadius: 0.09,
            // offset: new Offset(2.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(value,style: TextStyle(fontSize: MySize.size20,fontWeight: FontWeight.bold,color: Colors.black54),),
                  Text(title,style: TextStyle(fontSize: MySize.size18,fontWeight: FontWeight.bold,color: Colors.grey),),
                ],
              ),

              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(MySize.size50)),
                child:Container(
                    height: MySize.size60,
                    width: MySize.size60,
                    color: AppTheme.primaryColor,
                    padding: EdgeInsets.all(MySize.size14),
                    child: Image.asset(imageIcon,
                      width: MySize.size10,
                      height: MySize.size10,

                    )),
              )
            ],),

        ],
      ),
    );
  }
}
