import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    splashColor: ColorManager.lightPrimary,
    // ripple effect color
    // cardview theme
    cardTheme: CardTheme(
        color: ColorManager.white,
        shadowColor: ColorManager.grey,
        elevation: AppSize.s4),
    // app bar theme
    appBarTheme: AppBarTheme(
        centerTitle: true,
        color: ColorManager.primary,
        elevation: AppSize.s4,
        shadowColor: ColorManager.lightPrimary,
        titleTextStyle:
            getRegularStyle(fontSize: FontSize.s16, color: ColorManager.white)),
    // button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorManager.grey1,
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.lightPrimary),

    // elevated button them
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppSize.s4,
        textStyle: getRegularStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s20,
        ),
        // primary: ColorManager.primary,
        foregroundColor: ColorManager.primary,
        backgroundColor: ColorManager.white,
        maximumSize: const Size.fromHeight(45),
        // minimumSize: const Size.fromHeight(5),
        fixedSize: const Size.fromWidth(200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: 20,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: ColorManager.yellow,
        side:
            BorderSide(color: ColorManager.yellow, width: 1.5, strokeAlign: 0),
        // backgroundColor: Colors.black,
      ),
    ),

    // useMaterial3: true,

    textTheme: TextTheme(
        displayLarge:
            getLightStyle(color: ColorManager.white, fontSize: FontSize.s22),
        // Label
        labelSmall: getRegularStyle(
          color: ColorManager.white,
          fontSize: FontSize.s12,
        ),
        labelMedium: getSemiBoldStyle(
          color: ColorManager.white,
          fontSize: FontSize.s18,
        ),
        labelLarge: getSemiBoldStyle(
          color: ColorManager.white,
          fontSize: FontSize.s30,
          isUnderline: true,
        ),
        // HeadLine
        headlineSmall: getSemiBoldStyle(
            color: ColorManager.yellow, fontSize: FontSize.s12),
        headlineMedium: getRegularStyle(
            color: ColorManager.black, fontSize: FontSize.s20),
        headlineLarge: getRegularStyle(
            color: ColorManager.white, fontSize: FontSize.s30),
        // Title
        titleSmall:
            getMediumStyle(color: ColorManager.white, fontSize: FontSize.s16),
        titleMedium:
            getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s16),
        titleLarge:
            getBoldStyle(color: ColorManager.white, fontSize: FontSize.s40),
        // Body
        bodyLarge:
            getRegularStyle(color: ColorManager.white, fontSize: FontSize.s100),
        bodyMedium:
            getBoldStyle(color: ColorManager.white, fontSize: FontSize.s20,),
        bodySmall: getRegularStyle(color: ColorManager.grey)),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
        // content padding
        contentPadding: const EdgeInsets.all(AppPadding.p20),
        // hint style
        hintStyle:
            getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
        // label style
        labelStyle:
            getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
        fillColor: ColorManager.white,
        // error style
        errorStyle: getRegularStyle(color: ColorManager.error),

        // enabled border style
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.white, width: AppSize.s0),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s20))),

        // focused border style
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.white,
              width: AppSize.s0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s20))),

        // error border style
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s20))),
        // focused error border style
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius:
                const BorderRadius.all(Radius.circular(AppSize.s20)))),
    // label style
  );
}
