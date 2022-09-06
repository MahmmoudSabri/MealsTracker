import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meals_tracker/WaterPage.dart';
// import 'package:http/http.dart' as http;
import 'APPLIC.dart';
import 'BottomBarView.dart';
import 'MealsPage.dart';
import 'TabIconData.dart';
import 'sql_helper.dart';

import 'AppTheme.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  

  List<Map<String, dynamic>> _myMeal = [];
  List<Map<String, dynamic>> _myWaterCups = [];

  bool _isLoading = true;
  int _pageIndex=0;
  int _calories=0;
  int _water=0;


  Widget tabBody = Container(
    color: AppTheme.background,
  );

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await SQLHelper.getMeals(APPLIC.now,DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day+ 1));
    final dataWater = await SQLHelper.getWaters(APPLIC.now,DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day+ 1));
    _calories=0;
    _water=0;
    setState(() {
      _myMeal = data;
      if(_myMeal!=null&&_myMeal.length>0)
        {
          _myMeal.forEach((Map<String, dynamic> meal) {
            int cal=meal['calories'];
            _calories=_calories+cal ;
          });
        }
      _myWaterCups = dataWater;
      if(_myWaterCups!=null&&_myWaterCups.length>0)
        _water=_myWaterCups.length;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    APPLIC.now=DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day);
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    tabBody = Container();
    super.initState();
    _refreshData(); // Loading the diary when the app starts
  }





  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(60), // Set this height
        child:getAppBarUI(context),
      ),backgroundColor: AppTheme.background,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Stack(
              children: <Widget>[
                tabBody is Container?
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 16, bottom: 18),
                  child: Container(height: 180,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(68.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child:Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.orange
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Meals',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(

                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: AppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: Icon(Icons.lunch_dining,color: Colors.orange,),

                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 4, bottom: 3),
                                                  child: Text(
                                                    '${_calories}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(

                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 16,
                                                      color: AppTheme
                                                          .darkerText,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 4, bottom: 3),
                                                  child: Text(
                                                    'calorie',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(

                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: AppTheme
                                                          .grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.blue
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Water',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: AppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: Icon(Icons.local_drink,color: Colors.blue,),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 4, bottom: 3),
                                                  child: Text(
                                                    '${_water}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(


                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 16,
                                                      color: AppTheme
                                                          .darkerText,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 8, bottom: 3),
                                                  child: Text(
                                                    'Cup',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(


                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: AppTheme
                                                          .grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                )
                    :tabBody,
                bottomBar(),
              ],
            );
          }
        },
      ),
    );
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
  Widget getAppBarUI(context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.nearlyDarkGreen,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.white,
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _pageIndex==0? 'Meals Tracker':_pageIndex==1?'My Meals':_pageIndex==2?'Water Cups':'',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppTheme.nearlyWhite,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 58,
                    width: 38,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(32.0)),
                      onTap: () {
                        setState(() {
                          APPLIC.now= DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day- 1);
                          if(_pageIndex==0)
                            _refreshData();
                          if(_pageIndex==1)
                            tabBody = new MealsPage();
                          else
                          if(_pageIndex==2)
                            tabBody = new WaterPage();
                        });
                      },
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color:AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.calendar_today,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        Text(
                          DateFormat.MMMd().format(APPLIC.now).toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            letterSpacing: -0.2,
                            color: AppTheme.nearlyWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    width: 38,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(32.0)),
                      onTap: () {
                        setState(() {
                          APPLIC.now= DateTime(APPLIC.now.year, APPLIC.now.month , APPLIC.now.day+ 1);
                          //_refreshMeals();
                          if(_pageIndex==0)
                            _refreshData();
                          if(_pageIndex==1)
                          tabBody = new MealsPage();
                          else
                          if(_pageIndex==2)
                            tabBody = new WaterPage();

                        });

                      },
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            _pageIndex=index;
            if (index == 0) {
              setState(() {
                tabBody = Container();
              });
            }
            if (index == 1) {
              setState(() {
                tabBody = MealsPage();
              });
            }
            if (index == 2) {
              setState(() {
                tabBody = WaterPage();
              });
            }
            // else if (index == 1 || index == 3) {
            //   animationController?.reverse().then<dynamic>((data) {
            //     if (!mounted) {
            //       return;
            //     }
            //     setState(() {
            //       tabBody =
            //           TrainingScreen(animationController: animationController);
            //     });
            //   });
            // }
          },
        ),
      ],
    );
  }
}

