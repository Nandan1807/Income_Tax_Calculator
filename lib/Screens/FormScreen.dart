import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_track/DataModel.dart';

class FormScreen extends StatefulWidget {
  final Map<String, dynamic> map;
  final int index;

  const FormScreen({super.key, required this.map, required this.index});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late List<TextEditingController> _controller;
  late List<String> selected;

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
        _controller.add(ctr);
        selected.add("");
      } else {
        var detailList = formFields[key];
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
    List<String> keys = widget.map.keys.toList();
    return Scaffold(
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
                child: ElevatedButton(
                  onPressed: () {
                    final model = Provider.of<Model>(context, listen: false);
                    Map<String, dynamic> updated = {};
                    for (int i = 0; i < keys.length; i++) {
                      if (model.incomeTaxDetails[widget.index][keys[i]]
                          is String) {
                        updated[keys[i]] = _controller[i].text;
                      } else {
                        var detailList = List<Map<String, bool>>.from(
                            model.incomeTaxDetails[widget.index][keys[i]]);
                        for (int j = 0; j < detailList.length; j++) {
                          var key = detailList[j].keys.first;
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
                    Navigator.of(context).pop();
                  },
                  child: Text('Calculate'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldList(String data, int index, BuildContext context,
      TextEditingController controller, List<String> keys) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data,style: TextStyle(color: Colors.white),),
            Consumer<Model>(
              builder: (context, value, child) {
                var fieldVal = value.incomeTaxDetails[widget.index][keys[index]];
                if (fieldVal is String) {
                  return Row(
                    children: [
                      Expanded(flex:5,child: TextFormField(controller: controller,style: TextStyle(color: Colors.white),)),
                      Expanded(
                        child: Container(
                          child: Center(
                            child:
                                ElevatedButton(onPressed: () {}, child: Text('>')),
                          ),
                        ),
                      )
                    ],
                  );
                } else if (fieldVal is List<Map<String, dynamic>>) {
                  List<String> itemList = [];
                  var detailList = fieldVal;
                  for (var detail in detailList) {
                    itemList.addAll(detail.keys);
                  }
                  return DropdownButton<String>(
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
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
