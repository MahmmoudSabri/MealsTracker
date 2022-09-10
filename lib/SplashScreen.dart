import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meals_tracker/APPLIC.dart';
import 'package:meals_tracker/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppTheme.dart';
import 'package:flutter/material.dart';

import 'GoogleSignIn.dart';
import 'HomePage.dart';
import 'SysUser.dart';
// import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    getUser ();
    Timer(Duration(seconds: 3),
            () async {
      if(APPLIC.user!=null)
        {
          final List<Map<String, dynamic>> data = await SQLHelper.getMealNotSynced();
          //print(data);
          if(data.length>0)
          for(int index=0;index<data.length;index++)
            {
              try {
                CollectionReference mealsFS = FirebaseFirestore.instance.collection('meals');

                final result = await InternetAddress.lookup('google.com');
                // print(result);
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
                  await mealsFS.add({
                    'name': data[index]['name'],
                    'calories': data[index]['calories'],
                    'id': '1' ,
                    'createdAt':data[index]['createdAt'],
                    'user_id':APPLIC.user?.email
                  })  .then((value)  => SQLHelper.updateMeal(data[index]['id'],data[index]['name'],data[index]['calories'],'Y'))//print("Meal Added"))
                      .catchError((error) => print("Failed to add Meal: $error"));
              } catch (_) {
                print("throwing new error");
                //throw Exception("Error on server");
              }
            }
          //
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                  MyHomePage(title: "",)
              )
          );
        }

      else
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    GoogleSignIn()
            )
        );
    }
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
  getUser () async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    String? email = prefs.getString("email");
    String? uid = prefs.getString("uid");
    if(username!=null&&username!='')
      {
        APPLIC.user=new SysUser();
        APPLIC.user?.userName=username;
        APPLIC.user?.email=email;
        APPLIC.user?.uid=uid;
      }

  }
}
