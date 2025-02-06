import 'package:flutter/material.dart';

import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottomsheet_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/text_theme.dart';
import 'custom_theme/textfield_theme.dart';

class AppTheme {
  AppTheme._();
  // -- Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: MyTextTheme.lightTextTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButton,
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    checkboxTheme: MyCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: MyBottomSheetTheme.lightBottomSheetTheme,

    // elevatedButtonTheme:,
    // outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MyTextFieldTheme.lightInputDecorationTheme,
  );

  // -- Dark Theme
  static ThemeData darkTheme = ThemeData();
}
