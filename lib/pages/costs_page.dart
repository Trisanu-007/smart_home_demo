import 'dart:core';
import 'package:flutter/material.dart';
import 'package:smart_home_demo/constants/form_field_design.dart';

class CostsPage extends StatefulWidget {
  @override
  _CostsPageState createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  static const cost = 12.0;
  final _formKey = GlobalKey<FormState>();
  final List<String> days = ["1", "5", "10", "15", "30"];
  String curr_day = "1";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Current rate :",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Rs. $cost",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Find out your cost :",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField(
                decoration: textInputDecoration,
                value: curr_day,
                items: days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text("$day days before today"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => curr_day = val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: RaisedButton(
                child: Text("Check !"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
