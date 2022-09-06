import 'dart:async';
import 'dart:convert';

import 'AppTheme.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
// import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    MyHomePage(title: "",)
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,

              colors: [AppTheme.nearlyGreen,AppTheme.nearlyDarkGreen,]
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 300.0,
                  width: 300.0,
                ),
                Text("Track the meals you eat in a day\n and stay on track of your calorie intake,\n and keep track of your water intake",textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text("Meals Tracker",textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
              ],
            ),

            CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(AppTheme.nearlyWhite),
            ),
          ],
        ),
      ),
    );
  }
}
