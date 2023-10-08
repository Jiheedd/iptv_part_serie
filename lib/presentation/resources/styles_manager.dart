import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color, {bool isUnderline = false}) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: FontConstants.fontFamily,
      color: color,
      fontWeight: fontWeight,
      decoration: isUnderline? TextDecoration.underline:TextDecoration.none,
  );
}


// regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color, bool isUnderline = false}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color, isUnderline: isUnderline);
}

// medium style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s12, required Color color, bool isUnderline = false}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color, isUnderline: isUnderline);
}

// medium style

TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color, bool isUnderline = false}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color, isUnderline: isUnderline);
}

// bold style

TextStyle getBoldStyle(
    {double fontSize = FontSize.s12, required Color color, bool isUnderline = false}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color, isUnderline: isUnderline);
}

// semibold style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12, required Color color, bool isUnderline = false}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color, isUnderline: isUnderline);
}
