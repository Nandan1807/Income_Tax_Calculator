import 'package:flutter/material.dart';
import 'package:tax_track/Screens/FormScreen.dart';
import 'package:tax_track/Screens/IncometaxOptionScreen.dart';
import 'package:tax_track/Screens/splashscreen.dart';

class MenuScreen extends StatelessWidget {
  List<String> menuList = [
    "Income Tax",
    "Hra Exemption",
    "Tax Benefit",
    "Gratuity",
    "Cost Inflation Index",
    "provident Fund"
  ];

  List routes = [
    IncomeTaxOptions(),
    SplashScreen(),
    SplashScreen(),
    SplashScreen(),
    SplashScreen(),
    SplashScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          return customContainer(menuList[index], index, context);
        },
      ),
    );
  }

  Widget customContainer(String data, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => routes[index],
          ),
        );
      },
      child: Card(
        color: Colors.blue,
        child: Center(
          child: Text(
            data,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
