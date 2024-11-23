import 'package:flutter/material.dart';
import 'package:foodapp/core/resources/color_manager.dart';
import 'package:foodapp/core/resources/fonts_manager.dart';
import 'package:foodapp/core/resources/styles_manager.dart';

ThemeData getAppThemeData() {
  return ThemeData(
    primaryColor: ColorManager.primary,
    textTheme: TextTheme(
        bodyMedium:
            getMediumStyle(15, ColorManager.grey1, FontsConstants.cairo),
        bodySmall:
            getSemiBoldStyle(16, ColorManager.white, FontsConstants.cairo),
        displayLarge:
            getSemiBoldStyle(33, ColorManager.blackBlue, FontsConstants.cairo),
        displayMedium:
            getMediumStyle(26, ColorManager.blackBlue, FontsConstants.cairo),
        displaySmall:
            getMediumStyle(12, ColorManager.grey1, FontsConstants.cairo)),

    // appbar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle:
          getBoldStyle(14, ColorManager.white, FontsConstants.cairo),
      titleTextStyle:
          getBoldStyle(14, ColorManager.white, FontsConstants.cairo),
      color: ColorManager.primary,
    ),
  );
}
