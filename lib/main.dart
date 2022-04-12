import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/controller/businessProvider.dart';
import 'package:user/controller/cartProvider.dart';
import 'package:user/controller/userController.dart';
import 'package:user/screens/splashScreen.dart';
import 'package:provider/provider.dart';

// void main()async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>CartProvider()),
      ChangeNotifierProvider(create: (_)=>UserProvider()),
      ChangeNotifierProvider(create: (_)=>BusinessProvider()),
      // ChangeNotifierProvider<IndexLogic>(create: (_)=>IndexLogic()),
    ],
        child: MyApp()),
    // MyApp()
  );
}



////

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.01),
      statusBarColor: Colors.transparent, // status bar color
    ));
    return MaterialApp(
      title: 'Royal Hair',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: SplashScreen(),
    );
  }
}
