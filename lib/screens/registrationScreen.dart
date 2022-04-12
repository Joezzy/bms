

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/model/currentUser.dart';
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/screens/loginScreen.dart';
import 'package:user/screens/settings/business/newBusiness.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _key = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address')    ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(passwordPattern, errorText: 'should contain at least one upper case '
        '\nshould contain at least one lower case '
        '\nshould contain at least one digit '
        '\nAt least one Special character( ! @ # \$ & * ~ )')
  ]);

  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController otpController=TextEditingController();
  TextEditingController businessNameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  bool showPassword=true;

  String get firstName =>firstNameController.text;
  String get lastName =>lastNameController.text;
  String get email =>emailController.text;
  String get phone =>phoneController.text;
  String get password =>passwordController.text;
  String get businessName =>businessNameController.text;
  String get otp =>otpController.text;


  bool isVerify=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading? Center(child: CircularProgressIndicator()):Container(
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: SingleChildScrollView(
          child:!isVerify?
          Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: MySize.size20),
                Image.asset("assets/logo.png",
                  width: MySize.size150,
                  height: MySize.size150,
                ),
                SizedBox(height: MySize.size20),

                Text("Create an account",
                  style: TextStyle(color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: MySize.size20),

                // Text("Start a 14-days free trial, no credit card required"),
                // SizedBox(height: MySize.size20),

                InputWithTitle(
                  fieldLabel: "First Name",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: firstNameController,
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Last Name",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: lastNameController,
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Email",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: emailController,
                      validator: emailValidator,
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Phone",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      placeholderText: "+2348 0000 000",
                      keyboardType: TextInputType.number,
                      validator:     MinLengthValidator(10, errorText: 'At least 10 character'),
                      controller: phoneController,
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Business Name",
                  inputWidget: Txt(
                      width: MySize.screenWidth,
                      controller: businessNameController,
                      validator:     MinLengthValidator(2, errorText: 'Field is require'),
                      onChanged: (txt){}),
                ),
                SizedBox(height: MySize.size10,),
                InputWithTitle(
                  fieldLabel: "Password",

                  inputWidget:   Txt(
                      width: MySize.screenWidth,
                      controller: passwordController,
                      isPasswordField: showPassword,
                      validator: passwordValidator,
                      placeholderText: "Enter password",
                      suffixIcon: showPassword? Icon(MdiIcons.eyeOutline): Icon(MdiIcons.eyeOffOutline),
                      onSuffixItemTapped: (){
                        setState(() {
                          if(!showPassword)
                            showPassword=true;
                          else
                            showPassword=false;
                        });
                      },

                      onChanged: (txt){}),
                ),

                // InputWithTitle(
                //   fieldLabel: "Password",
                //   inputWidget:   Txt(
                //       isPasswordField: true,
                //       controller: passwordController,
                //       onChanged: (txt){}),
                // ),
                SizedBox(height: MySize.size10,),


                SizedBox(height: MySize.size20,),

                SizedBox(height: MySize.size10,),

                FillButton(
                    width: MySize.screenWidth,
                    height: 45,
                    text:"Sign Up",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: MySize.size14,
                    enabledColor: AppTheme.primaryColor,
                    enabled: true,
                    onPressed: (){

                      if(_key.currentState!.validate()){
                        registerMethod();

                      }else
                        return;
                    }),
                SizedBox(height: MySize.size20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("Already have an account?",style: TextStyle(color: AppTheme.primaryColor)),
                    SizedBox(width: 10),

                    InkWell(
                        onTap: ()=>     Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(

                              )),
                        ),
                        child: Text("Login",style: TextStyle(color: AppTheme.primaryColor, fontWeight:FontWeight.bold, fontSize:MySize.size12, decoration: TextDecoration.underline,
                        ),)),
                  ],
                ),
                SizedBox(height: MySize.size100,),


              ],
            ),
          )
              :Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MySize.size50),
            Image.asset("assets/logo.png",
              width: MySize.size150,
              height: MySize.size150,
            ),
            SizedBox(height: MySize.size20),

            Text("Verify Email",
              style: TextStyle(color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,fontSize: MySize.size20),),
            SizedBox(height: MySize.size20),

            Text("OTP has been sent to your email"),
            SizedBox(height: MySize.size30),
            InputWithTitle(
              fieldLabel: "OTP",
              inputWidget: Txt(
                  width: MySize.screenWidth,
                  placeholderText: "000000",
                  controller: otpController,
                  onChanged: (txt){

                  }),
            ),



            SizedBox(height: MySize.size20,),

            FillButton(
                width: MySize.screenWidth,
                height: 45,
                text:"Verify",
                fontColor: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: MySize.size14,
                enabledColor: AppTheme.primaryColor,
                enabled: true,
                onPressed: (){

                  verifyMethod();

                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (BuildContext context) => NewBusinessScreen()),
                  //         (Route<dynamic> route) => false);
                }),
            SizedBox(height: MySize.size20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                InkWell(
                    onTap: (){
                      resendMethod();
                    },
                    child: Text("Resend OTP",style: TextStyle(color: AppTheme.primaryColor, fontWeight:FontWeight.bold, fontSize:MySize.size12, decoration: TextDecoration.underline,
                    ),)),
              ],
            ),
            SizedBox(height: MySize.size100,),


          ],
        ),
        ),
      ),
    );
  }


  bool isLoading=false;

  void registerMethod() async {
    String url = baseUrl + '/users/';
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
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
          "business_name": businessName,
          "package": "473c1827-f0ac-459c-9440-ffe82770da25",
          // "package": "d195d4c9-5781-4e4a-80ae-75ff179080fe",
          "email": email,
          "password": password
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
        MotionToast.success(
            title:  Text("Successful"),
            description:  Text("Account Created")
        ).show(context);
        // crypt.setString("access", myData["token"]);
        setState(() {
          isVerify=true;
        });
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
        //         (Route<dynamic> route) => false);
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

  void verifyMethod() async {
    String url = baseUrl + '/auth/verify/';
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "email": email,
          "otp": otp,

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
            width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);
      } else {
        myData = res[0]["data"]["data"];
        print("MyData");
        // print(myData["token"]);
        print( myData["data"]["token"]);
        print( myData["first_name"]);
        print( myData["last_name"]);
        MotionToast.success(
            title:  Text("Successful"),
            width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
            description:  Text("Account Created")
        ).show(context);

        crypt.setString("access", myData["data"]["token"]);

        setState(() {
          // currentUser=currentUserFromJson(json.encode(myData));
          isVerify=true;
        });


        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => NewBusinessScreen(
              pageSetting: PageSetting.setup,
            )),
                (Route<dynamic> route) => false);
      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }


  void resendMethod() async {
    String url = baseUrl + '/auth/re_verify/';
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {
          "email": email,
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
            width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);
      } else {
        myData = res[0]["data"]["msg"];
        // print("MyData");

        MotionToast.success(
            title:  Text("Successful"),
            width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
            description:  Text("OTP sent again!")
        ).show(context);


      }
    }
    catch( e){
      print("CATCH");
      print(e.toString());
      MotionToast.error(
        width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
        title:  Text("Unsuccessful"),
        description:  Text("${e.toString()}"),
      ).show(context);
    }

    setState(() {
      isLoading = false;
    });
  }


}
