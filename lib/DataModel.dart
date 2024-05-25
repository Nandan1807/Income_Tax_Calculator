import 'package:flutter/foundation.dart';

class Model extends ChangeNotifier {
  List<Map<String, dynamic>> incomeTaxDetails = [
    {
      "Gross Income": "0",
      "User Type": [
        {"Individual Male": true},
        {"Individual Female": false},
        {"Individual Senior Citizen": false},
        {"Individual Supersenior Citizen ": false}
      ],
      "Financial Year": [
        {"2022-23": false},
        {"2023-24": false},
        {"2024-25": true}
      ],
      "Deduction": "0",
      "Income From House": "0",
      "Income From Other": "0"
    },
  ];

  void updateData(Map<String, dynamic> newData, int index) {
    incomeTaxDetails[index] = newData;
    notifyListeners();
  }
}
