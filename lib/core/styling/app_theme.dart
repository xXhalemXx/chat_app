import 'package:chat_app/core/styling/colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryLightColor),
    useMaterial3: true,
    fontFamily: 'RobotoSlab',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((_) {
          return secLightColor;
        }),
        shape: MaterialStateProperty.resolveWith((_) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          );
        }),
      ),
    ),
    appBarTheme: AppBarTheme(backgroundColor: primaryLightColor)
  );
}
