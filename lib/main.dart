import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_track/DataModel.dart';
import 'package:tax_track/Screens/splashscreen.dart';
import 'package:tax_track/Theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Model(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: darkTheme,

      title: 'TaxTrack',
      theme: lightTheme,
      home: SplashScreen(),
    );
  }
}
