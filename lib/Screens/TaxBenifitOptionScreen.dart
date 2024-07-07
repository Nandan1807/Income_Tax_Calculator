import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_track/DataModel.dart';
import 'package:tax_track/Screens/FormScreen.dart';

class TaxBenefitOptions extends StatelessWidget {
  TaxBenefitOptions ({super.key});
  final List<String> menuList = [
    "Self-Occupied Property",
    "Rented-Out Property"
  ];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    final List<Widget> routes = [
      FormScreen(calcName: menuList[0],map: model.incomeTaxDetails[2], index: 2),
      FormScreen(calcName: menuList[1],map: model.incomeTaxDetails[3], index: 3),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tax Benefit Options'),
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
