import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/SizeConfig.dart';
import 'package:user/common/backgroundWavy.dart';
import 'package:user/common/app_theme.dart';
import 'package:user/common/constant.dart';
import 'package:user/helpers/apiClass.dart';
import 'package:user/screens/dashboard/dashBoardTab.dart';
import 'package:user/screens/dashboard/selectStoreScreen.dart';
import 'package:user/screens/forgotPassword.dart';
import 'package:user/screens/registrationScreen.dart';
import 'package:user/widgets/heventhButton.dart';
import 'package:user/widgets/heventhTextBox.dart';
import 'package:user/widgets/inputWithTitle.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final requiredValidator = RequiredValidator(errorText: 'this field is required');
  final _key = GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController(text:"hopannachy@gmail.com");
  TextEditingController passwordController=TextEditingController(text:"#Joe1234");
  bool showPassword=true;

  String get email =>emailController.text;
  String get password =>passwordController.text;


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

  @override
  Widget build(BuildContext context) {
    Screen screen=getScreen();
    return Scaffold(
      backgroundColor: Colors.white,
      body:isLoading?Center(child: CircularProgressIndicator()):
      Container(
        // width: MySize.screenWidth/2,
        padding: EdgeInsets.symmetric(horizontal: MySize.size20),

        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MySize.size100),
              Image.asset("assets/logo.png",
              width: MySize.size150,
              height: MySize.size150,
              ),
              SizedBox(height: MySize.size20),

              Text("Login into your account",
              style: TextStyle(color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,fontSize: MySize.size20),),
              SizedBox(height: MySize.size20),

// Text("Login now to access the latest improvement for your "
//     "inventory and warehousing performance"),
              SizedBox(height: MySize.size30),
              InputWithTitle(
                  fieldLabel: "Email",
                  inputWidget: Txt(
                    width: MySize.screenWidth,
                    placeholderText: "johnwick@gmail.com",
                    controller: emailController,
                      validator:emailValidator,
                      onChanged: (txt){}),
              ),
              SizedBox(height: MySize.size20,),
              InputWithTitle(
                fieldLabel: "Password",
                inputWidget:   Txt(
                controller: passwordController,
                  validator: passwordValidator,
                    width: MySize.screenWidth,
                    isPasswordField: showPassword,
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
              SizedBox(height: MySize.size20,),

              Container(
                width: (screen==Screen.tab)?MySize.screenWidth/1.4:MySize.screenWidth,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Keep me signed in",
                      style: TextStyle(fontSize: MySize.size16),
                    ),
                    InkWell(
                      onTap: ()=>  Navigator.of(context,rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      ),
                      child: Text("Forgot password",
                        style: TextStyle(fontSize: MySize.size16),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: MySize.size20,),

              FillButton(
                  // fontColor: Colors.white,
                  width: MySize.screenWidth,
                height: 45,
                  text:"Login",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: MySize.size20,
                  enabledColor: AppTheme.primaryColor,
                  enabled: true,
                  onPressed: (){
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (BuildContext context) => DashBoardTab()),
                    //         (Route<dynamic> route) => false);

                    if(_key.currentState!.validate()){
                        print("Yes");
                      loginMethod();

                    }else
                      return;


                  }),
              SizedBox(height: MySize.size20,),


Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    Text("Not registered yet?  ",style: TextStyle(color: AppTheme.primaryColor,fontSize:MySize.size16,)),

    InkWell(
      onTap: ()=>     Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationScreen(

          )),
      ),
      child: Text("Create a new account",style: TextStyle(color: AppTheme.primaryColor,
        fontWeight:FontWeight.bold, fontSize:MySize.size16, decoration: TextDecoration.underline,
      ),)),
  ],
)

            ],
          ),
        ),
      ),
    );
  }

bool isLoading = false;

  void loginMethod() async {
    String url = baseUrl + '/auth/login/';
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var myData;
    var body = json.encode(
        {

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
            width:(screen==Screen.tab)? MySize.screenWidth/1.5:MySize.screenWidth/1.1,
            title:  Text("Unsuccessful!\n",style: TextStyle(fontWeight: FontWeight.bold),),
            description:  Text("${replaceString(res[0]["message"].toString())}")
        ).show(context);

      } else {
        myData = res[0]["data"]["data"];
        print("MyData");
        // print(myData["token"]);
        crypt.setString("access", myData["token"]);


        if(myData["user_type"]=="client_admin"){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => SelectStoreScreen()),
                  (Route<dynamic> route) => false);
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => DashBoardTab()),
                  (Route<dynamic> route) => false);
        }



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
