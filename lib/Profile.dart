import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meals_tracker/AppTheme.dart';
import 'package:meals_tracker/SplashScreen.dart';
import 'package:meals_tracker/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'APPLIC.dart';
import 'HomePage.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String? _username;
  String? _email;

  @override
  void initState() {
    // TODO: implement initState
    if(APPLIC.user!=null)
      {
        _username=APPLIC.user?.userName;
        _email=APPLIC.user?.email;
      }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:AppBar(title:Text('Profile'),backgroundColor: AppTheme.nearlyDarkGreen,centerTitle: true,
        leading:
      GestureDetector(
        onTap: ()
        {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage(title: '',)));
        },
        child: new Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 22.0,
        ),
      ),),
        body:  new Container(
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Parsonal Information',
                              style: TextStyle(
                                  fontSize: 18.0,color: AppTheme.nearlyGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 16.0,color: AppTheme.nearlyGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                            child:Text(_username??"")
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 16.0,color: AppTheme.nearlyGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new Text(_email??""),
                        ),
                      ],
                    )),

              ],
            ),
          ),
        )
      ,bottomNavigationBar:  _getActionButtons(),);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new MaterialButton(
                    child: new Text("Logout"),
                    textColor: Colors.white,
                    color:AppTheme.nearlyDarkGreen,
                    onPressed: () async {

                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('Please Confirm'),
                              content: const Text('Are you sure to remove all data and logout?'),
                              actions: [
                                // The "Yes" button
                                TextButton(
                                    onPressed: () async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      APPLIC.user=null;
                                      await prefs.clear();
                                      await SQLHelper.deleteAllMeals();
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => SplashScreen()));
                                    },
                                    child: const Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'))
                              ],
                            );
                          });


                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

}