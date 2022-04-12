import 'package:flutter/material.dart';
import 'package:user/model/currentUser.dart';
import 'package:user/model/user.dart';

const Color primaryColor = Color(0xffAD391C);
const Color disableColor = Colors.grey;
const String baseUrl = "https://testing.workhopper.org";
// const String baseUrl = "https://saas-v2.couriax.com";
// const String baseUrl = "http://couriax-saas-api.eba-huvccy4z.us-east-1.elasticbeanstalk.com/api/v1";

String businessId="";
enum PageState{loading,loaded,initial}
String replaceString(String str) {
  str = str.replaceAll('}', '');
  str = str.replaceAll('{', '');
  str = str.replaceAll('[', '');
  str = str.replaceAll(']', '');
  return str;
}

String  passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
enum PageSetting{setup,inApp}
CurrentUser? currentUser;
// CurrentUser? currentUser;



enum Screen{phone,tab,win}
Screen getScreen(){
  MediaQueryData win=MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  double size=win.size.width;
  Screen screen=Screen.phone;
  if(size<=760)
    screen= Screen.phone;
  else if(size>760 && size <1200)
    screen= Screen.tab;
  else if(size>=1201)
    screen= Screen.win;
  print("SKREEN");
  print(size);
  print(screen);

  return screen;
}

Screen screen=getScreen();



