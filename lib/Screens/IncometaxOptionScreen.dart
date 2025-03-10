import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_track/DataModel.dart';
import 'package:tax_track/Screens/DeductionOptionScreen.dart';
import 'package:tax_track/Screens/FormScreen.dart';

class IncomeTaxOptions extends StatelessWidget {
  final List<String> menuList = [
    "Quick Tax Calculator",
    "Deduction",
    "Capital Gain",
  ];

  List popupList = [false, true, false];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    final List<Widget> routes = [
      FormScreen(
          calcName: menuList[0], map: model.incomeTaxDetails[0], index: 0),
      DeductionOption(),
      FormScreen(
          calcName: menuList[2], map: model.incomeTaxDetails[12], index: 12),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Income Tax Options'),
        toolbarHeight: 80,
      ),
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

  Widget listCard(
      String data, int index, BuildContext context, List<Widget> routes) {
    return InkWell(
      onTap: () {
        if (popupList[index]) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // Ensure the shape is respected
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height *
                  0.75, // Adjust the height as needed
              child: routes[index],
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => routes[index],
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data,
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
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
