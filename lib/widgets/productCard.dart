import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';


class ProductCard extends StatelessWidget {
  final String title;
  final String amount;
  final String category;
  final String imageString;
  final bool isOffPlan;
  final VoidCallback? function;

  ProductCard({this.title="",
    this.amount="",
    this.imageString="",
    this.category="",
    this.isOffPlan=false,
    this.function
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: EdgeInsets.only(left: 0),
        margin: EdgeInsets.symmetric(horizontal: 5,),
        height: 180,
        width: 160,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey,width: 0.09),
            color: Colors.white, //edited
            boxShadow: <BoxShadow>[
          BoxShadow(
          color: Colors.grey, //edited
            spreadRadius: 0.0,
            blurRadius: 0.5,
            offset: new Offset(0.2, 0.2),
          ),
          ],
          ),
          child:Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),

                    child:  CachedNetworkImage(
                      imageUrl:  imageString==null?"https://miro.medium.com/max/2000/1*DOt4V8-RdcsLJL6rFI6njA.jpeg":imageString,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.photo),
                      fit:BoxFit.cover ,
                      height:  MySize.size140,
                      width: MySize.screenWidth,

                    ),
                  ),

                ],
              ),



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(child: Text(title,style: TextStyle(fontSize: MySize.size14,fontWeight: FontWeight.w700),)),
                    Container(child: Text(category,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),
                    SizedBox(height:6,),
                    Container(
                      // width: MySize.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(AppTheme.money(double.parse(amount)),
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: MySize.size12,
                              fontWeight: FontWeight.w700,color: AppTheme.heventhBlue),),
                        ],
                      ),
                    ),

                  ],
                ),
              ),



            ],
          ),

        ),
      ),
    );
  }
}
