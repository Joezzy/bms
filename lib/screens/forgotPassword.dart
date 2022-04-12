
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/screens/resetPassword.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {


  TextEditingController emailController=TextEditingController();

  String get email =>emailController.text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading? Center(child: CircularProgressIndicator()):Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MySize.size50),
              Center(
                child: Image.asset("assets/logo.png",
                  width: MySize.size150,
                  height: MySize.size150,
                ),
              ),
              SizedBox(height: MySize.size20),

              Text("Forgot Password",
                style: TextStyle(color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: MySize.size10),


              InputWithTitle(
                fieldLabel: "Enter registration email",
                inputWidget: Txt(
                    controller: emailController,
                    placeholderText: "ucheademusa@gmail.com",
                    onChanged: (txt){}),
              ),


              SizedBox(height: MySize.size30,),

              FillButton(
                // fontColor: Colors.white,
                  height: 45,
                  text:"Submit",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: MySize.size14,
                  enabledColor: AppTheme.primaryColor,
                  enabled: true,
                  onPressed: (){
                    // Navigator.of(context,rootNavigator: false).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ResetPasswordScreen(email: "",),
                    //   ),
                    // );
                    forgotPassword();
                  }),
              SizedBox(height: MySize.size20,),



            ],
          )
        ),
      ),
    );
  }


  bool isLoading=false;

  void forgotPassword() async {
    String url = baseUrl + '/auth/forgot-password/';
    if (mounted)
      setState(() {
        isLoading = true;
      });
    // firstname, lastname, username, email, phone, password, account_type)
    //
    // optional: (profilePics, business_name, business_address, business_email)
    var myData;
    var body = json.encode(
        {
          "email": email
        }
    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    // List res;
    try{
      final  res=  await RequestHelper.postRequest(url, body);
      print("OKP");
      print(res);
      if (res[0]["status"] == "failed") {
        print(res[0]["data"]);
        MotionToast.error(
            height: MySize.size200,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);
      } else {
        myData = res[0]["data"]["data"];
        print("MyData");
        // print(myData["token"]);
        // MotionToast.success(
        //     title:  Text("Successful"),
        //     description:  Text("Account Created")
        // ).show(context);
        Navigator.of(context,rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email,
            page: PasswordPage.reset,),
          ),
        );

      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }




}
