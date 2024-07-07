import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final NumberFormat _formatter = NumberFormat('#,##,###');
  ResultScreen({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Set your preferred app bar color
        elevation: 0, // Remove shadow
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              String key = data.keys.elementAt(index);
              dynamic value = data[key];
              return resultCard(key, value, context);
            },
          ),
        ),
      ),
    );
  }

  Widget resultCard(String key, value, BuildContext context) {
    double val = double.parse(value.toString());
    String formattedText = _formatter.format(val);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
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
        height: 150,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                child: Center(
                  child: Text(
                    key.toString(),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 5),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Center(
                  child: Text(
                    formattedText,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 5),
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
