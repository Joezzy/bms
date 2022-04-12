
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';
import 'package:user/widgets/myAppBar.dart';


enum PasswordPage{reset,change}


class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final PasswordPage page;
  const ResetPasswordScreen({Key? key,this.email="", this.page=PasswordPage.reset}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {


  TextEditingController passwordController=TextEditingController();
  TextEditingController passwordController2=TextEditingController();
  TextEditingController otpController=TextEditingController();

  String get password =>passwordController.text;
  String get password2 =>passwordController2.text;
  String get otp =>otpController.text;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:(widget.page==PasswordPage.change)? MyAppBar():null,
      backgroundColor: Colors.white,
      body: isLoading? Center(child: CircularProgressIndicator()):Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: SingleChildScrollView(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MySize.size100),

                if(widget.email!="")
                  Text("Reset Password",
                  style: TextStyle(color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,fontSize: 20),),
                if(widget.email!="")
                  Text("A One-Time-Password(OTP) has been sent to ${widget.email}"),
                SizedBox(height: MySize.size20),

              if(widget.email!="")
                InputWithTitle(
                  fieldLabel: "OTP",
                  inputWidget: Txt(
                      controller: otpController,
                      placeholderText: "000000",
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10),

                InputWithTitle(
                  fieldLabel: "New Password",
                  inputWidget: Txt(
                    isPasswordField: true,
                      controller: passwordController,
                      placeholderText: "* * * * * * * *",
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10),

                InputWithTitle(
                  fieldLabel: "Confirm New Password",
                  inputWidget: Txt(
                      controller: passwordController2,
                      isPasswordField: true,
                      placeholderText: "* * * * * * * *",
                      onChanged: (txt){}
                      ),
                ),


                SizedBox(height: MySize.size30,),

                FillButton(
                  // fontColor: Colors.white,
                    height: 45,
                    text:"Change password",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: MySize.size14,
                    enabledColor: AppTheme.primaryColor,
                    enabled: true,
                    onPressed: (){

                      resetPassword();
                    }),
                SizedBox(height: MySize.size20,),



              ],
            )
        ),
      ),
    );
  }


  bool isLoading=false;

  void resetPassword() async {
    String url = baseUrl + '/auth/reset-password/';
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
          "email": widget.email,
          "otp_code": otp,
          "password": password,
          "confirm_password": password
        }
    );
    SharedPreferences crypt = await SharedPreferences.getInstance();
    // List res;
    try{
      final  res=  await RequestHelper.putRequest(url, body);
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
        MotionToast.success(
            title:  Text("Successful"),
            description:  Text("Account Created")
        ).show(context);



        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                (Route<dynamic> route) => false);



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
