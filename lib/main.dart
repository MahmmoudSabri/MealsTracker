
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'SplashScreen.dart';


void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent
  // ));
  WidgetsFlutterBinding.ensureInitialized();

  // initializing the firebase app
 await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals Tracker',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
