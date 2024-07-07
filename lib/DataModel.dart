import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model extends ChangeNotifier {
  List<Map<String, dynamic>> incomeTaxDetails = [
    {
      "Gross Income": "",
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
      "Deduction": "",
      "Income From House": "",
      "Income From Other": ""
    },
    {
      "Basic Salary":"",
      "HRA Received":"",
      "Actual Rent Paid":"",
      "City Type":[
        {"Metro":true},
        {"Non-Metro":false}
      ]
    },
    {
      "Principal Paid":"",
      "Interest Paid":""
    },
    {
      "Principal Paid":"",
      "Interest Paid":"",
      "Rent Income":"",
      "Municipal Tax":""
    },
    {
      "Basic Salary":"",
      "Dearness Allowance":"",
      "Years Of Service":""
    },
    {
      "Purchase Amount":"",
      "Sale Amount":"",
      "Purchase Year":[
        {"2001": false},
        {"2002": false},
        {"2003": false},
        {"2004": false},
        {"2005": false},
        {"2006": false},
        {"2007": false},
        {"2008": false},
        {"2009": false},
        {"2010": false},
        {"2011": false},
        {"2012": false},
        {"2013": false},
        {"2014": false},
        {"2015": false},
        {"2016": false},
        {"2017": false},
        {"2018": false},
        {"2019": false},
        {"2020": false},
        {"2021": false},
        {"2022": false},
        {"2023": false},
        {"2024": true}
      ],
      "Sale Year":[
        {"2001": false},
        {"2002": false},
        {"2003": false},
        {"2004": false},
        {"2005": false},
        {"2006": false},
        {"2007": false},
        {"2008": false},
        {"2009": false},
        {"2010": false},
        {"2011": false},
        {"2012": false},
        {"2013": false},
        {"2014": false},
        {"2015": false},
        {"2016": false},
        {"2017": false},
        {"2018": false},
        {"2019": false},
        {"2020": false},
        {"2021": false},
        {"2022": false},
        {"2023": false},
        {"2024": true}
      ]
    },
    {
      "Current Age":"",
      "Retirement Age":"",
      "Basic Monthly Salary":"",
      "Employee PF Percent":"",
      "Employer PF Percent":"",
      "Yearly Increment Percent":"",
      "Current Interest Rate":"",
      "Current PF Balance":""
    },
    {
      "Investments":""
    },
    {
      "Health Insurance Premium":"",
      "User Type":[
        {"Senior Citizen":false},
        {"Non Senior Citizen":true}
      ]
    },
    {
      "Interest On Home Loan":""
    },
    {
      "Interest On Education Loan":""
    },
    {
      "Donations":"",
      "Gross Total Income":""
    },
    {
      "Purchase Price":"",
      "Selling Price":"",
      "Tax Rate":""
    }
  ];

  Model() {
    loadIncomeTaxDetails();
  }

  Future<void> saveIncomeTaxDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('incomeTaxDetails', jsonEncode(incomeTaxDetails));
  }

  Future<void> loadIncomeTaxDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('incomeTaxDetails');
    if (data != null) {
      try {
        dynamic decodedData = jsonDecode(data);
        if (decodedData is List) {
          incomeTaxDetails = List<Map<String, dynamic>>.from(decodedData);
          notifyListeners();
        } else {
          throw FormatException('Invalid data format');
        }
      } catch (e) {
        print('Error loading income tax details: $e');
        // Handle error as needed
      }
    }
  }


  void updateData(Map<String, dynamic> newData, int index) {
    incomeTaxDetails[index] = newData;
    notifyListeners();
  }
}
