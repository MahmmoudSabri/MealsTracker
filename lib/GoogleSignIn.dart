import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'SignInScreen.dart';

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);
  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    // we return the MaterialApp here ,
    // MaterialApp contain some basic ui for android ,
    return MaterialApp(

      //materialApp title
      title: 'SignIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      // home property contain SignInScreen widget
      home: SignInScreen(),
    );
  }
}