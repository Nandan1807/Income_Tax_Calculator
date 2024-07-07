import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Color.fromRGBO(0, 153, 255, 1),
    secondary: Color.fromRGBO(163, 216, 252, 0.3),
    background: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Color.fromRGBO(0, 47, 86, 1),
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color.fromRGBO(0, 47, 86, 1)),
    bodyMedium: TextStyle(color: Color.fromRGBO(0, 47, 86, 0.5)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(0, 153, 255, 1),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: Color.fromRGBO(163, 216, 252, 1),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Color.fromRGBO(94, 148, 255, 1),
    secondary: Color.fromRGBO(163, 216, 252, 0.3),
    background: Color.fromRGBO(18, 18, 18, 1),
    onPrimary: Colors.grey.shade100,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    surface: Color.fromRGBO(28, 28, 28, 1),
    onSurface: Color.fromRGBO(0, 47, 86, 1),
  ),
  scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color.fromRGBO(163, 216, 252, 1)),
    bodyMedium: TextStyle(color: Color.fromRGBO(163, 216, 252, 0.7)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(0, 153, 255, 1),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.black,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: Color.fromRGBO(28, 28, 28, 1),
  ),
);
