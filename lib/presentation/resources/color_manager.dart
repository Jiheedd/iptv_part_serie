import 'package:flutter/material.dart';

class ColorManager {
  static Color transparent = Colors.transparent;
  static Color primary = const Color(0xff1848e7);
  static Color darkGrey = const Color(0xff525252);
  static Color grey = const Color(0xff737477);
  static Color lightGrey = const Color(0xff9E9E9E);

  // new colors
  static Color darkPrimary = const Color(0xff0b346c);
  static Color mediumDarkPrimary = const Color(0xff194983);
  static Color lightPrimary = const Color(0xff024a84);
  static Color selectedNavBarItem = const Color(0xff389be8);
  static Color lightBlue = const Color(0xff4c5f7b); //
  // color with 80% opacity
  static Color grey1 = const Color(0xff616165);
  static Color grey2 = const Color(0xff797979);
  static Color white = const Color(0xffFFFFFF);
  static Color black = const Color(0xff000000);
  static Color yellow = const Color(0xfffff200);


  static Color error = const Color(0xffe61f34); // red color
  static Color red = const Color(0xfffd1010); // red color



  // Gradients Colors

  static const List<Color> backgroundColorDark = [
    Color.fromRGBO(54, 54, 54, 1.0),
    Color.fromRGBO(45, 45, 45, 1.0),
    Color.fromRGBO(31, 31, 31, 1.0),
    Color.fromRGBO(17, 17, 17, 1.0),
  ];

  static const List<Color> backgroundColorLight = [
    Color.fromRGBO(255, 255, 255, 1.0),
    Color.fromRGBO(241, 241, 241, 1),
    Color.fromRGBO(233, 233, 233, 1),
    Color.fromRGBO(222, 222, 222, 1),
  ];

  static const List<Color> actionContainerColorDarkBlue = [
    // Color.fromRGBO(47, 75, 110, 1),
    // Color.fromRGBO(22, 57, 100, 1.0),
    // Color.fromRGBO(81, 121, 22, 1.0),
    Color.fromRGBO(4, 27, 70, 1.0),
    Color.fromRGBO(3, 17, 42, 1.0),
  ];

  // static const List<Color> blackMask = [
  //   // Color.fromRGBO(47, 75, 110, 1),
  //   // Color.fromRGBO(22, 57, 100, 1.0),
  //   // Color.fromRGBO(81, 121, 22, 1.0),
  //   Color.fromRGBO(4, 27, 70, 1.0),
  //   Color.fromRGBO(3, 17, 42, 1.0),
  // ];

  static const List<Color> backgroundSeries = [
    Color.fromRGBO(34, 58, 90, 1.0),
    Color.fromRGBO(0, 18, 42, 1.0),
  ];

  static const List<Color> searchBarColor = [
    Color(0xff4e6581),
    Color(0xff6086ab),
  ];

  static const List<Color> borderSearchBarColor = [
    Color(0xff4c5f7b),
    Color(0xff50a5e4),
  ];

  static const List<Color> actionContainerColorBlue = [
    Color.fromRGBO(63, 124, 190, 1.0),
    Color.fromRGBO(8, 80, 147, 1.0),
    Color.fromRGBO(63, 135, 208, 1.0),
    Color.fromRGBO(4, 42, 88, 1.0),

  ];
}
