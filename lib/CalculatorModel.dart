class TaxCalculator {
  static const Map<String, Map<String, List<double>>> oldRegimeSlabs = {
    'Individual Male': {
      '2023-24': [0, 2.5, 5, 10],
      '2024-25': [0, 2.5, 5, 10]
    },
    'Individual Female': {
      '2023-24': [0, 2.5, 5, 10],
      '2024-25': [0, 2.5, 5, 10]
    },
    'Individual Senior Citizen': {
      '2023-24': [0, 3, 5, 10],
      '2024-25': [0, 3, 5, 10]
    },
    'Individual Supersenior Citizen': {
      '2023-24': [0, 5, 10],
      '2024-25': [0, 5, 10]
    }
  };

  static const Map<String, Map<String, List<double>>> newRegimeSlabs = {
    'Individual Male': {
      '2023-24': [0, 3, 6, 9, 12, 15],
      '2024-25': [0, 3, 6, 9, 12, 15]
    },
    'Individual Female': {
      '2023-24': [0, 3, 6, 9, 12, 15],
      '2024-25': [0, 3, 6, 9, 12, 15]
    },
    'Individual Senior Citizen': {
      '2023-24': [0, 3, 6, 9, 12, 15],
      '2024-25': [0, 3, 6, 9, 12, 15]
    },
    'Individual Supersenior Citizen': {
      '2023-24': [0, 3, 6, 9, 12, 15],
      '2024-25': [0, 3, 6, 9, 12, 15]
    }
  };

  static double calculateTax(
      double taxableIncome, String year, String type, bool isNewRegime) {
    if (taxableIncome <= 0) return 0.0;

    List<double> slabs;
    List<double> rates;

    if (isNewRegime == true) {
      taxableIncome -= 300000;
    } else {
      taxableIncome -= 250000;
    }

    if (isNewRegime) {
      slabs = newRegimeSlabs[type]![year]!;
      rates = [0, 5, 10, 15, 20, 30];
    } else {
      slabs = oldRegimeSlabs[type]![year]!;
      if (type == 'Individual Supersenior Citizen') {
        rates = [0, 20, 30];
      } else {
        rates = [0, 5, 20, 30];
      }
    }
    double tax = 0.0;

    for (int i = slabs.length - 1; i > 0; i--) {
      if (taxableIncome > slabs[i] * 100000 && taxableIncome <= 1500000) {
        tax += (taxableIncome - slabs[i] * 100000) * (rates[i] / 100);
      } else {
        if (isNewRegime) {
          tax += (taxableIncome - 1200000) * (rates[i] / 100);
        } else {
          if (type == 'Individual Male' || type == 'Individual Female') {
            tax += (taxableIncome - 750000) * (rates[i] / 100);
          } else if (type == 'Individual Senior Citizen') {
            tax += (taxableIncome - 700000) * (rates[i] / 100);
          } else if (type == 'Individual Supersenior Citizen') {
            tax += (taxableIncome - 500000) * (rates[i] / 100);
          }
        }
      }
      taxableIncome = slabs[i] * 100000;
    }

    tax += tax * 0.04;

    return tax;
  }

  static Map<String, dynamic> taxMap(
    Map<String, dynamic> map,
  ) {
    List<dynamic> userType = map["User Type"];
    List<dynamic> financialYear = map["Financial Year"];
    double grossIncome =
        map["Gross Income"] == "" ? 0 : double.parse(map["Gross Income"]);
    double incomeFromHouse = map["Income From House"] == ""
        ? 0
        : double.parse(map["Income From House"]);
    double incomeFromOther = map["Income From Other"] == ""
        ? 0
        : double.parse(map["Income From Other"]);
    double deductions =
        map["Deduction"] == "" ? 0 : double.parse(map["Deduction"]);

    double taxableIncome =
        grossIncome - deductions + incomeFromHouse + incomeFromOther;

    String year = "";
    String type = "";
    for (int i = 0; i < userType.length; i++) {
      var obj = userType[i];
      var val = obj.values.toList();
      if (val[0]) {
        type = obj.keys.first;
      }
    }
    for (int i = 0; i < financialYear.length; i++) {
      var obj = financialYear[i];
      var val = obj.values.toList();
      if (val[0]) {
        year = obj.keys.first;
      }
    }

    var oldTax = calculateTax(taxableIncome, year, type, false);
    var newTax = calculateTax(taxableIncome, year, type, true);

    if(oldTax<0 || newTax<0){
      oldTax=0;
      newTax=0;
      taxableIncome = 0;
    }

    return {
      'Old Regime': oldTax,
      'New Regime': newTax,
      'Difference': oldTax - newTax,
      'Taxable Income': taxableIncome
    };
  }

  // HRAExemptionCalculator
  static Map<String, dynamic> calculateHRAExemption(Map<String, dynamic> map) {
    double hraExemption;
    double basicSalary = map["Basic Salary"] == ""
        ? 0
        : double.parse(map["Basic Salary"].toString());
    double hraReceived = map["HRA Received"] == ""
        ? 0
        : double.parse(map["HRA Received"].toString());
    double actualRentPaid = map["Actual Rent Paid"] == ""
        ? 0
        : double.parse(map["Actual Rent Paid"].toString());

    List<dynamic> city =
        List<dynamic>.from(map['City Type']);
    String cityType = "";

    for (int i = 0; i < city.length; i++) {
      var obj = city[i];
      var val = obj.values.toList();
      if (val[0]) {
        cityType = obj.keys.first;
      }
    }

    // Calculate 50% or 40% of basic salary
    double cityPercentage = cityType.toLowerCase() == 'metro' ? 0.50 : 0.40;
    double percentageOfBasic = basicSalary * cityPercentage;

    // Calculate actual rent paid minus 10% of basic salary
    double rentMinusTenPercent = actualRentPaid - (basicSalary * 0.10);

    // Least of the following three values will be the HRA exemption
    hraExemption = _min(hraReceived, percentageOfBasic, rentMinusTenPercent);

    // HRA exemption cannot be negative
    return {'HRA Exemption': hraExemption > 0 ? hraExemption : 0};
  }

  static double _min(double a, double b, double c) {
    return a < b ? (a < c ? a : c) : (b < c ? b : c);
  }

  static Map<String, dynamic> calculateTaxBenefitForSelfOccupied(
      Map<String, dynamic> map) {
    double principalPaid = map["Principal Paid"] == ""
        ? 0
        : double.parse(map["Principal Paid"].toString());
    double interestPaid = map["Interest Paid"] == ""
        ? 0
        : double.parse(map["Interest Paid"].toString());
    // Section 80C: Deduction on principal paid
    double section80C = (principalPaid <= 150000) ? principalPaid : 150000;

    // Section 24: Deduction on interest paid on home loan
    double section24 = (interestPaid <= 200000) ? interestPaid : 200000;

    // Calculate net taxable income
    double netTaxableIncome = section80C - section24;

    return {'Income From House Property': netTaxableIncome};
  }

  static Map<String, dynamic> calculateTaxBenefitForRentedOut(
      Map<String, dynamic> map) {
    double principalPaid = map["Principal Paid"] == ""
        ? 0
        : double.parse(map["Principal Paid"].toString());
    double interestPaid = map["Interest Paid"] == ""
        ? 0
        : double.parse(map["Interest Paid"].toString());
    double rentIncome = map["Rent Income"] == ""
        ? 0
        : double.parse(map["Rent Income"].toString());
    ;
    double municipalTax = map["Municipal Tax"] == ""
        ? 0
        : double.parse(map["Municipal Tax"].toString());
    ;
    double standardDeduction = 50000;
    double section80C = (principalPaid <= 150000) ? principalPaid : 150000;

    double section24 = (interestPaid <= 200000) ? interestPaid : 200000;

    double incomeFromHouseProperty =
        rentIncome - municipalTax - standardDeduction;

    double netTaxableIncome = incomeFromHouseProperty - section80C - section24;

    return {'Income From House Property': netTaxableIncome};
  }

  static Map<String, dynamic> calculateGratuity(Map<String, dynamic> map) {
    double basicSalary = map["Basic Salary"] == ""
        ? 0
        : double.parse(map["Basic Salary"].toString());
    double dearnessAllowance = map["Dearness Allowance"] == ""
        ? 0
        : double.parse(map["Dearness Allowance"].toString());
    double yearsOfService = map["Years Of Service"] == ""
        ? 0
        : double.parse(map["Years Of Service"].toString());
    ;
    double gratuity =
        ((basicSalary + dearnessAllowance) * yearsOfService * 15) / 26;

    return {'Gratuity': gratuity};
  }

  static Map<String, dynamic> calculateCII(Map<String, dynamic> map) {
    // Fetch the indices for the purchase and sale years
    //int purchaseYear, double purchaseAmount, int saleYear, double saleAmount, Map<int, int> ciiIndices
    double purchaseYear = 0;
    double saleYear = 0;
    double purchaseAmount = map["Purchase Amount"] == ""
        ? 0
        : double.parse(map["Purchase Amount"].toString());
    double saleAmount = map["Sale Amount"] == ""
        ? 0
        : double.parse(map["Sale Amount"].toString());

    List<dynamic> pyear =
        List<dynamic>.from(map['Purchase Year']);

    for (int i = 0; i < pyear.length; i++) {
      var obj = pyear[i];
      var val = obj.values.toList();
      if (val[0]) {
        purchaseYear = double.parse(obj.keys.first);
      }
    }
    List<dynamic> syear =
        List<dynamic>.from(map['Sale Year']);

    for (int i = 0; i < syear.length; i++) {
      var obj = syear[i];
      var val = obj.values.toList();
      if (val[0]) {
        saleYear = double.parse(obj.keys.first);
      }
    }
    Map<int, int> ciiIndices = {
      2001: 100,
      2002: 105,
      2003: 109,
      2004: 113,
      2005: 117,
      2006: 122,
      2007: 129,
      2008: 137,
      2009: 148,
      2010: 167,
      2011: 184,
      2012: 200,
      2013: 220,
      2014: 240,
      2015: 254,
      2016: 264,
      2017: 272,
      2018: 280,
      2019: 289,
      2020: 301,
      2021: 317,
      2022: 331,
      2023: 348,
      2024: 365 // Latest available index
    };

    int indexForPurchaseYear = ciiIndices[purchaseYear] ?? 0;
    int indexForSaleYear = ciiIndices[saleYear] ?? 0;

    if (indexForPurchaseYear == 0 || indexForSaleYear == 0) {
      return {
        "Indexed Cost Of Property": 0,
        "Capital Gain": 0,
        "Capital Gain Tax": 0
      };
    }

    // Calculate the indexed cost of the property
    double indexedCostOfProperty =
        (purchaseAmount * indexForSaleYear) / indexForPurchaseYear;

    // Calculate the capital gain
    double capitalGain = saleAmount - indexedCostOfProperty;

    // Calculate the capital gain tax
    // Assuming a tax rate for the calculation
    double taxRate = 0.2; // 20%
    double capitalGainTax = capitalGain * taxRate;

    return {
      "Indexed Cost Of Property": indexedCostOfProperty,
      "Capital Gain": capitalGain,
      "Capital Gain Tax": capitalGainTax
    };
  }

  static Map<String, dynamic> calculateProvidentFund(Map<String, dynamic> map) {
    double currentAge = map["Current Age"] == ""
        ? 0
        : double.parse(map["Current Age"].toString());
    double retirementAge = map["Retirement Age"] == ""
        ? 0
        : double.parse(map["Retirement Age"].toString());
    double basicMonthlySalary = map["Basic Monthly Salary"] == ""
        ? 0
        : double.parse(map["Basic Monthly Salary"].toString());
    double employeePFPercent = map["Employee PF Percent"] == ""
        ? 0
        : double.parse(map["Employee PF Percent"].toString());
    double employerPFPercent = map["Employer PF Percent"] == ""
        ? 0
        : double.parse(map["Employer PF Percent"].toString());
    double yearlyIncrementPercent = map["Yearly Increment Percent"] == ""
        ? 0
        : double.parse(map["Yearly Increment Percent"].toString());
    double currentInterestRate = map["Current Interest Rate"] == ""
        ? 0
        : double.parse(map["Current Interest Rate"].toString());
    double currentPFBalance = map["Current PF Balance"] == ""
        ? 0
        : double.parse(map["Current PF Balance"].toString());
    double workingYears = retirementAge - currentAge;
    double totalProvidentFund = currentPFBalance;
    double monthlySalary = basicMonthlySalary;

    for (int year = 0; year < workingYears; year++) {
      for (int month = 0; month < 12; month++) {
        double employeeContribution = monthlySalary * (employeePFPercent / 100);
        double employerContribution = monthlySalary * (employerPFPercent / 100);
        double monthlyContribution =
            employeeContribution + employerContribution;

        // Add monthly contributions to the total PF
        totalProvidentFund += monthlyContribution;

        // Add monthly interest to the total PF
        totalProvidentFund +=
            totalProvidentFund * (currentInterestRate / 100) / 12;
      }

      // Increment the salary for the next year
      monthlySalary += monthlySalary * (yearlyIncrementPercent / 100);
    }

    return {"Provident Fund": totalProvidentFund};
  }

  static Map<String, dynamic> section80C(Map<String, dynamic> map) {
    double investments = map["Investments"] == ""
        ? 0
        : double.parse(map["Investments"].toString());
    // Max deduction limit under section 80C is ₹1,50,000
    return {'Deduction': investments > 150000 ? 150000 : investments};
  }

  static Map<String, dynamic> section80D(Map<String, dynamic> map) {
    //double healthInsurancePremium, {bool isSeniorCitizen = false}
    // Max deduction for non-senior citizen is ₹25,000, for senior citizens it's ₹50,000
    double healthInsurancePremium = map["Health Insurance Premium"] == ""
        ? 0
        : double.parse(map["Health Insurance Premium"].toString());
    bool isSeniorCitizen = false;
    var type = "";
    List<dynamic> syear =
        List<dynamic>.from(map['User Type']);

    for (int i = 0; i < syear.length; i++) {
      var obj = syear[i];
      var val = obj.values.toList();
      if (val[0]) {
        type = obj.keys.first;
      }
    }
    if (type == "Senior Citizen") {
      isSeniorCitizen = true;
    }
    double maxLimit = isSeniorCitizen ? 50000 : 25000;
    return {
      'Deduction':
          healthInsurancePremium > maxLimit ? maxLimit : healthInsurancePremium
    };
  }

  static Map<String, dynamic> section24b(Map<String, dynamic> map) {
    double interestOnHomeLoan = map["Interest On Home Loan"] == ""
        ? 0
        : double.parse(map["Interest On Home Loan"].toString());
    // Max deduction for interest on home loan is ₹2,00,000
    return {
      'Deduction': interestOnHomeLoan > 200000 ? 200000 : interestOnHomeLoan
    };
  }

  static Map<String, dynamic> section80E(Map<String, dynamic> map) {
    double interestOnEducationLoan = map["Interest On Education Loan"] == ""
        ? 0
        : double.parse(map["Interest On Education Loan"].toString());
    // No upper limit on deduction under section 80E
    return {'Deduction': interestOnEducationLoan};
  }

  static Map<String, dynamic> section80G(Map<String, dynamic> map) {
    double donations =
        map["Donations"] == "" ? 0 : double.parse(map["Donations"].toString());
    double grossTotalIncome = map["Gross Total Income"] == ""
        ? 0
        : double.parse(map["Gross Total Income"].toString());
    // Deduction on donations depends on the type of donation and can be 50% or 100% of the donated amount
    // Here we are assuming a simplified scenario where 50% of donation is eligible for deduction
    double eligibleDonation = donations * 0.5;
    // However, the total deduction under section 80G cannot exceed 10% of Gross Total Income double donations, double grossTotalIncome
    double maxLimit = grossTotalIncome * 0.1;
    return {
      'Deduction': eligibleDonation > maxLimit ? maxLimit : eligibleDonation
    };
  }

  static Map<String, dynamic> calculateCapitalGain(Map<String, dynamic> map) {
    double purchasePrice = map["Purchase Price"] == ""
        ? 0
        : double.parse(map["Purchase Price"].toString());
    double sellingPrice = map["Selling Price"] == ""
        ? 0
        : double.parse(map["Selling Price"].toString());
    double taxRate =
        map["Tax Rate"] == "" ? 0 : double.parse(map["Tax Rate"].toString());
    double capitalGain = sellingPrice - purchasePrice;
    double tax = capitalGain * taxRate / 100;
    double netGain = capitalGain - tax;
    return {
      'Capital Gain': capitalGain,
      'Capital Gain Tax': tax,
      'Net gain': netGain
    };
  }

  static double totalDeductions(
      Map<String, dynamic> map1,
      Map<String, dynamic> map2,
      Map<String, dynamic> map3,
      Map<String, dynamic> map4,
      Map<String, dynamic> map5) {
    double total = 0;
    Map<String, dynamic> m1 = section80C(map1);
    Map<String, dynamic> m2 = section80D(map2);
    Map<String, dynamic> m3 = section24b(map3);
    Map<String, dynamic> m4 = section80E(map4);
    Map<String, dynamic> m5 = section80G(map5);
    total +=
        m1['Deduction'] == "" ? 0 : double.parse(m1["Deduction"].toString());
    total +=
        m2['Deduction'] == "" ? 0 : double.parse(m2["Deduction"].toString());
    total +=
        m3['Deduction'] == "" ? 0 : double.parse(m3["Deduction"].toString());
    total +=
        m4['Deduction'] == "" ? 0 : double.parse(m4["Deduction"].toString());
    total +=
        m5['Deduction'] == "" ? 0 : double.parse(m5["Deduction"].toString());
    return total;
  }

  static Map<String, dynamic> calculator(
      String name, Map<String, dynamic> map) {
    Map<String, dynamic> res = {};

    if (name == "Quick Tax Calculator") {
      res = taxMap(map);
    } else if (name == "HRA Exemption") {
      res = calculateHRAExemption(map);
    } else if (name == "Self-Occupied Property") {
      res = calculateTaxBenefitForSelfOccupied(map);
    } else if (name == "Rented-Out Property") {
      res = calculateTaxBenefitForRentedOut(map);
    } else if (name == "Gratuity") {
      res = calculateGratuity(map);
    } else if (name == "Cost Inflation Index") {
      res = calculateCII(map);
    } else if (name == "Provident Fund") {
      res = calculateProvidentFund(map);
    } else if (name == "Section 80C") {
      res = section80C(map);
    } else if (name == "Section 80D") {
      res = section80D(map);
    } else if (name == "Section 24b") {
      res = section24b(map);
    } else if (name == "Section 80E") {
      res = section80E(map);
    } else if (name == "Section 80G") {
      res = section80G(map);
    } else if (name == "Capital Gain") {
      res = calculateCapitalGain(map);
    }
    return res;
  }
}
