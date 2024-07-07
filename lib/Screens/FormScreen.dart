import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tax_track/CalculatorModel.dart';
import 'package:tax_track/DataModel.dart';
import 'package:tax_track/Screens/ResultScreen.dart';

class FormScreen extends StatefulWidget {
  final String calcName;
  final Map<String, dynamic> map;
  final int index;

  const FormScreen(
      {super.key,
      required this.map,
      required this.index,
      required this.calcName});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late List<TextEditingController> _controller;
  late List<String> selected;
  final NumberFormat _formatter = NumberFormat('#,##,###');

  @override
  void initState() {
    super.initState();
    _controller = [];
    selected = [];
    List<String> keys = widget.map.keys.toList();
    Map<String, dynamic> formFields = widget.map;
    for (var key in keys) {
      var ctr = TextEditingController();
      if (formFields[key] is String) {
        ctr.text = formFields[key];
        _formatNumber(ctr);
        _controller.add(ctr);
        selected.add("");
      } else {
        List<dynamic> detailList = List<dynamic>.from(formFields[key]);
        bool found = false;
        for (var detail in detailList) {
          var val = detail.values.toList();
          var detailKey = detail.keys.toList();
          if (val[0] == true) {
            ctr.text = detailKey[0];
            _controller.add(ctr);
            selected.add(detailKey[0]);
            found = true;
            break;
          }
        }
        if (!found) {
          _controller.add(ctr);
          selected.add("");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context, listen: false);
    var keys = widget.map.keys.toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.calcName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    return textFieldList(
                        keys[index], index, context, _controller[index], keys);
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Map<String, dynamic> updated = {};
                      for (int i = 0; i < keys.length; i++) {
                        if (model.incomeTaxDetails[widget.index][keys[i]]
                            is String) {
                          updated[keys[i]] = _removeCommas(_controller[i].text);
                        } else {
                          var detailList =
                              model.incomeTaxDetails[widget.index][keys[i]];
                          for (int j = 0; j < detailList.length; j++) {
                            String key = detailList[j].keys.first;
                            if (key == _controller[i].text) {
                              detailList[j] = {key: true};
                            } else {
                              detailList[j] = {key: false};
                            }
                          }
                          updated[keys[i]] = detailList;
                        }
                      }
                      model.updateData(updated, widget.index);

                      var map =
                          TaxCalculator.calculator(widget.calcName, updated);

                      if ([
                        "Section 80C",
                        "Section 80D",
                        "Section 24b",
                        "Section 80E",
                        "Section 80G"
                      ].contains(widget.calcName)) {
                        Map<String, dynamic> map1 = model.incomeTaxDetails[7];
                        Map<String, dynamic> map2 = model.incomeTaxDetails[8];
                        Map<String, dynamic> map3 = model.incomeTaxDetails[9];
                        Map<String, dynamic> map4 = model.incomeTaxDetails[10];
                        Map<String, dynamic> map5 = model.incomeTaxDetails[11];
                        Map<String, dynamic> map6 = model.incomeTaxDetails[0];

                        double res = TaxCalculator.totalDeductions(
                            map1, map2, map3, map4, map5);
                        map6['Deduction'] = res.toString();
                        model.updateData(map6, 0);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          data: map,
                          title: widget.calcName,
                        ),
                      ));
                    },
                    child: Container(
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Center(
                          child: Text(
                        'Calculate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldList(String data, int index, BuildContext context,
      TextEditingController controller, List<String> keys) {
    return Padding(
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Consumer<Model>(
                builder: (context, value, child) {
                  var fieldVal =
                      value.incomeTaxDetails[widget.index][keys[index]];

                  if (fieldVal is String) {
                    return TextFormField(
                      onChanged: (value) {
                        _formatNumber(controller);
                      },
                      keyboardType: TextInputType.number,
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter $data',
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    );
                  } else if (fieldVal is List<dynamic>) {
                    List<String> itemList = [];
                    List<Map<String, dynamic>> detailList =
                        List<Map<String, dynamic>>.from(fieldVal);
                    for (var detail in detailList) {
                      itemList.addAll(detail.keys);
                    }
                    return DropdownButton<String>(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      underline: SizedBox(),
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(20),
                      value: selected[index],
                      items: itemList.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selected[index] = value!;
                          _controller[index].text = value;
                        });
                      },
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _formatNumber(TextEditingController controller) {
    String text = controller.text.replaceAll(',', '');
    if (text.isEmpty) {
      return;
    }

    double value = double.parse(text);
    String formattedText = _formatter.format(value);

    // Update the text field with the formatted number.
    controller.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _removeCommas(String input) {
    return input.replaceAll(',', '');
  }
}
