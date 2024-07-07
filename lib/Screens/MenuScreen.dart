import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataModel.dart';
import '../Screens/FormScreen.dart';
import '../Screens/IncomeTaxOptionScreen.dart';
import '../Screens/TaxBenifitOptionScreen.dart';

class MenuScreen extends StatelessWidget {
  final Map<String, dynamic> menuListMap = {
    "Income Tax": "assets/incomeTaxImage.png",
    "HRA Exemption": "assets/hraImage.png",
    "Tax Benefit": "assets/taxBenifitImage.png",
    "Gratuity": "assets/gratuityImage.png",
    "Cost Inflation Index": "assets/costInflationImage.png",
    "Provident Fund": "assets/providentfund.png",
  };

  List<bool> popupList = [true, false, true, false, false, false];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);

    List<String> menuList = menuListMap.keys.toList();
    final List<Widget> routes = [
      IncomeTaxOptions(),
      FormScreen(calcName: menuList[1], map: model.incomeTaxDetails[1], index: 1),
      TaxBenefitOptions(),
      FormScreen(calcName: menuList[3], map: model.incomeTaxDetails[4], index: 4),
      FormScreen(calcName: menuList[4], map: model.incomeTaxDetails[5], index: 5),
      FormScreen(calcName: menuList[5], map: model.incomeTaxDetails[6], index: 6),
    ];

    return WillPopScope(
      onWillPop: () async {
        bool? exitConfirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  await model.saveIncomeTaxDetails();
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
        return exitConfirmed ?? false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/mainPage1.png',
                  ),
                  Expanded(flex: 6, child: Container()),
                ],
              ),
              Column(
                children: [
                  Expanded(flex: 4, child: Container()),
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Tax Track',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Expanded(flex: 3, child: Container()),
                  Expanded(
                    flex: 6,
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                        top: 40,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.787,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        return customContainer(
                          menuList[index],
                          index,
                          context,
                          routes,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customContainer(
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
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Container()),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(40),
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
                          padding: const EdgeInsets.all(13.0),
                          child: Image.asset(
                            menuListMap[data],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 2, child: Container()),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: Text(
                  data,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
