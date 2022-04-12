import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/widgets/dashCard.dart';

class DashBoardScreen extends StatefulWidget {
   DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
        Container(
          height: MySize.size180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              DashCard(
                title: "Total Orders",
                value: "50,000",
              ),
              DashCard(
                title: "Total Orders",
                value: "50,000",
              ),
              DashCard(
                title: "Total Orders",
                value: "50,000",
              ),
              DashCard(
                title: "Total Orders",
                value: "50,000",
              ),
            ],
          ),
        )
        ],
      ) ,
    );
  }
}

