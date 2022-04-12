import 'package:flutter/material.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/screens/registrationScreen.dart';
import 'package:user/widgets/heventhButton.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MySize.screenHeight,
            child: Image.asset("assets/welcome2.jpg",
              fit: BoxFit.cover,),
          ),

      Positioned(
        top:80,
          left: 0,
          right: 0,
          child: Container(child: Center(child: Image.asset("assets/royal.png")))),


        Positioned(
           bottom: MySize.size70,
           right: MySize.size30,
           left: MySize.size30,
           child: Column(children: [
             FillButton(
               // fontColor: Colors.white,
                 width: MySize.screenWidth,
                 height: 55,
                 text:"Login",
                 fontColor: Colors.white,
                 fontWeight: FontWeight.w100,
                 fontSize: MySize.size20,
                 enabledColor: AppTheme.primaryColor.withOpacity(0.8),
                 enabled: true,
                 onPressed: (){
                   Navigator.of(context).pushAndRemoveUntil(
                       MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                           (Route<dynamic> route) => false);




                 }),
             SizedBox(
               height: MySize.size20,
             ),
             // FillButton(
             //   // fontColor: Colors.white,
             //     width: MySize.screenWidth,
             //     height: 55,
             //     text:"Register",
             //     fontColor: AppTheme.whiteBackground,
             //     fontWeight: FontWeight.w100,
             //     fontSize: MySize.size20,
             //     enabledColor: AppTheme.heventhGrey.withOpacity(0.7),
             //     enabled: true,
             //     onPressed: (){
             //       Navigator.of(context).pushAndRemoveUntil(
             //           MaterialPageRoute(builder: (BuildContext context) => RegistrationScreen()),
             //               (Route<dynamic> route) => false);
             //
             //
             //
             //
             //     }),
           ],),
         )



        ],
      ),
      
    );
  }
}
