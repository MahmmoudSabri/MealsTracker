//SignInScreen

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meals_tracker/HomePage.dart';
import 'package:meals_tracker/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SysUser.dart';

import 'APPLIC.dart';
import 'AppTheme.dart';


class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  CollectionReference mealsFS = FirebaseFirestore.instance.collection('meals');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
        AppTheme.nearlyGreen,
          AppTheme.nearlyDarkGreen,
        ],
    ),
    ),
    child: Card(
    margin: EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
    elevation: 20,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Text(
    "sign-in using Google to synced your data to the cloud  and if you login from a different device,the app should load your data from your accoun",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
    ),
    Padding(
    padding: const EdgeInsets.only(left: 40, right: 40),
    child: MaterialButton(
    color: Colors.black,
    elevation: 10,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    height: 30.0,
    width: 30.0,
    decoration: BoxDecoration(
    image: DecorationImage(
    image:
    AssetImage('assets/googleimage.png'),
    fit: BoxFit.cover),
    shape: BoxShape.circle,
    ),
    ),
    SizedBox(
    width: 10,
    ),
    Text("Sign In with Google",style: TextStyle(color: Colors.white),)
    ],
    ),

    // by onpressed we call the function signup function
    onPressed: () =>  signup(context),

  ),
  )

      ,Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: MaterialButton(
          color: Colors.white,
          elevation: 10,
          child:Text("Login as a guest",style: TextStyle(color: Colors.black),),

          // by onpressed we call the function signup function
          onPressed: () =>  Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage(title: '',))),

        ),
      ),

  ],
  ),
  ),
  ),
  );
}
// function to implement the google signin

// creating firebase instance
final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> signup(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Getting users credential
    UserCredential result = await auth.signInWithCredential(authCredential);
    User? user = result.user;
    print(result);
    print(user?.providerData[0].email);

    if (result != null) {
     // print('go home');
      print(user?.displayName);
      print(user?.email);
      print(user?.uid);
      String? userName=user?.displayName;
      String? email=user?.email;
      String? uid=user?.uid;
      if(email==null)
        email=user?.providerData[0].email;
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      if(userName!=null)
      prefs.setString("username", userName);

      if(email!=null)
        prefs.setString("email", email);

      if(uid!=null)
        prefs.setString("uid", uid);

      APPLIC.user=new SysUser();
      APPLIC.user?.userName=userName;
      APPLIC.user?.email=email;
      APPLIC.user?.uid=uid;
      final result = await InternetAddress.lookup('google.com');
      // print(result);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
   await mealsFS.where("user_id",isEqualTo:APPLIC.user?.email).snapshots() .listen((event) async {
        for (var doc in event.docs) {
          await SQLHelper.createMealWithDate(
              doc.get('name'),int.parse(doc.get('calories')) ,doc.get('createdAt'),'Y');
        }

      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(title: '',)));
    } // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }
}

}
