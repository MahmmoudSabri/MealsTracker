import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imageIcon = Icons.light,
    this.index = 0,
    this.isSelected = false,
    this.animationController,

  });

  IconData imageIcon;
  bool isSelected;
  int index;


  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imageIcon: Icons.home_outlined,
      index: 0,
      isSelected: true,
    ),
    TabIconData(
      imageIcon: Icons.lunch_dining,
      index: 1,
      isSelected: false,
    ),
    TabIconData(
      imageIcon: Icons.local_drink,
      index: 2,
      isSelected: false,
    ),
    TabIconData(
      imageIcon: Icons.settings,
      index: 3,
      isSelected: false,
    ),
  ];
}
