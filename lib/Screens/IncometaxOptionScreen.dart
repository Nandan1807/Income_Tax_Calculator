import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_track/DataModel.dart';
import 'package:tax_track/Screens/FormScreen.dart';
import 'package:tax_track/Screens/splashscreen.dart';

class IncomeTaxOptions extends StatelessWidget {
  final List<String> menuList = [
    "Quick Tax Calculator",
    "Deduction",
    "Capital Gain",
    "Compare Return",
  ];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    List routes = [
      FormScreen(map: model.incomeTaxDetails[0], index: 0),
      SplashScreen(),
      SplashScreen(),
      SplashScreen(),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: menuList.length,
          itemBuilder: (context, index) {
            return listCard(menuList[index], index, context, routes);
          },
        ),
      ),
    );
  }

  Widget listCard(String data, int index, BuildContext context, List routes) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => routes[index],
          ),
        );
      },
      child: Container(
        height: 100,
        child: Card(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    data,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
