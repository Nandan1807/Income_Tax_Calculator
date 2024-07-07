import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataModel.dart';
import 'FormScreen.dart';

class DeductionOption extends StatelessWidget {
  DeductionOption({super.key});
  final List<String> menuList = [
    "Section 80C",
    "Section 80D",
    "Section 24b",
    "Section 80E",
    "Section 80G"
  ];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    final List<Widget> routes = [
      FormScreen(calcName: menuList[0],map: model.incomeTaxDetails[7], index: 7),
      FormScreen(calcName: menuList[1],map: model.incomeTaxDetails[8], index: 8),
      FormScreen(calcName: menuList[2],map: model.incomeTaxDetails[9], index: 9),
      FormScreen(calcName: menuList[3],map: model.incomeTaxDetails[10], index: 10),
      FormScreen(calcName: menuList[4],map: model.incomeTaxDetails[11], index: 11),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Deduction Options'),
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

  Widget listCard(String data, int index, BuildContext context, List<Widget> routes) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => routes[index],
          ),
        );
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
