import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/model/order.dart';


class OrderDetailScreen extends StatefulWidget {
  Order? order;
  OrderDetailScreen({Key? key,this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.order!.product!.name}",style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.whiteBackground,
        iconTheme: IconThemeData(color: AppTheme.primaryColor,),
        elevation: 0,
        actions: [
          // InkWell(
          //   onTap: (){
          //     Navigator.of(context,rootNavigator: true).push(
          //       MaterialPageRoute(
          //         builder: (context) => NewSupplierScreen(
          //           supplier: widget.order,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Padding(
          //     padding:  EdgeInsets.only(right: 10.0),
          //     child: Icon(MdiIcons.squareEditOutline ),
          //
          //
          //   ),
          // )
        ],

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MySize.size20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(MySize.size15)),
                child:Image.network(
                  widget.order!.product!.image==null?"https://olegeek.fr/wp-content/uploads/2016/03/avartar-femme.png":
                  widget.order!.product!.image,
                  fit: BoxFit.cover,
                  height: MySize.size300,),
              ) ,

              ListTile(
          title: Text("Order Number"),
          subtitle: Text("${widget.order!.orderId}"),
        ),
              ListTile(
                title: Text("Product Name"),
                subtitle: Text("${widget.order!.product!.name}"),
              ),
              ListTile(
                title: Text("Total Cost"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" ${widget.order!.qty} x ${widget.order!.product!.salesPrice} "),
                    Text("${widget.order!.totalCost} "),
                  ],
                ),
              ),
              ListTile(
                title: Text("Option"),
                subtitle: Text(" ${widget.order!.product!.selectableOptions!.color}, ${widget.order!.product!.selectableOptions!.style} "),
              ),
              if(widget.order!.service!.length>0)
                Column(
               children: [
                 DetailHeader(title: "Services"),
                 Container(
                     child: ListView.builder(
                         shrinkWrap: true,
                         // scrollDirection: Axis.horizontal,
                         // controller: _scrollController,
                         // padding: EdgeInsets.symmetric(
                         //   horizontal: MySize.size10,
                         // ),
                         physics: NeverScrollableScrollPhysics(),
                         itemCount:widget.order!.service!.length,
                         itemBuilder: (BuildContext context, index) {
                           if (index == widget.order!.service!.length) {
                             return Container();
                           }
                           {
                             Service result = widget.order!.service![index];
                             return ListTile(
                               title:Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text("${result.name} "),
                                   Text("${result.amount}")
                                 ],
                               ),

                             );
                           }
                           //end of tile
                         })),
               ],
             ),

              if(widget.order!.customer!=null)
        Column(children: [
          DetailHeader(title: "Customer"),

          ListTile(
            title: Text("Name"),
            subtitle: Text("${widget.order!.customer!.firstName} ${widget.order!.customer!.lastName}"),
          ),
          ListTile(
            title: Text("Email"),
            subtitle: Text("${widget.order!.customer!.email}"),
          ),
          ListTile(
            title: Text("Phone"),
            subtitle: Text("${widget.order!.customer!.phone}"),
          ),
          ListTile(
            title: Text("Address"),
            subtitle: Text("${widget.order!.customer!.address!.home}"),
          ),
        ],),

              // if(widget.order!.staff!=null)
                Column(children: [
                  DetailHeader(title: "Staff"),
                  ListTile(
                    title: Text("Name"),
                    subtitle: Text("${widget.order!.staff!.firstName} ${widget.order!.staff!.lastName}"),
                  ),
                  ListTile(
                    title: Text("Email"),
                    subtitle: Text("${widget.order!.staff!.email}"),
                  ),
                  ListTile(
                    title: Text("Phone"),
                    subtitle: Text("${widget.order!.staff!.phone}"),
                  ),
                  ListTile(
                    title: Text("Designation"),
                    subtitle: Text("${widget.order!.staff!.designation}"),
                  ),
                ],),









            ],
          ),
        ),
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  String title;
   DetailHeader({
    Key? key,
    this.title=""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MySize.screenWidth,

        color: AppTheme.primaryColor,
        padding: EdgeInsets.all(MySize.size10),
        child: Text(title));
  }
}
