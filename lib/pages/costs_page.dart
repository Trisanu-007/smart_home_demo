import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:smart_home_demo/constants/form_field_design.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_demo/constants/constants.dart';
import 'package:smart_home_demo/classes/cost.dart';
import 'package:smart_home_demo/config.dart';

import '../config.dart';
import '../config.dart';
import '../config.dart';
import '../config.dart';

class CostsPage extends StatefulWidget {
  @override
  _CostsPageState createState() => _CostsPageState();
}

class _CostsPageState extends State<CostsPage> {
  final String rApiKey = readApiKey;
  final String wApiKey = writeApiKey;
  static const cost = 12.0;
  final _formKey = GlobalKey<FormState>();
  final List<String> days = ["1", "5", "10", "15", "30"];
  String curr_day = "1";
  static List<CostData> costData;

  void getCostList() async {
    http.Response response = await http.get(
      Uri.encodeFull(
          "https://api.thingspeak.com/channels/1214545/fields/3.json?api_key=$rApiKey&sum=daily&days=$curr_day"),
    );
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      print(parsedJson);
      var feeds = parsedJson["feeds"];
      List<CostData> _costs = new List<CostData>();
      for (int i = 0; i < feeds.length - 1; i++) {
        var costData = CostData.fromJson(feeds[i]);
        _costs.add(costData);
      }
      /*
      for (int i = 0; i < _costs.length; i++) {
        print(_costs[i].value);
      }
      */
      setState(() {
        costData = _costs.reversed.toList();
      });
    } else {
      print("Error!");
    }
  }

  @override
  void initState() {
    super.initState();
    costData = new List<CostData>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Current rate :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "Rs. $cost",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Find out your cost per day (incl. today):",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10)),

              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: primaryColor,
                    ),
                    value: curr_day,
                    items: days.map((day) {
                      return DropdownMenuItem(
                        
                        value: day,
                        child: Text("$day days before today", style: TextStyle(color: Colors.white),),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => curr_day = val),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.deepOrangeAccent.withOpacity(0.5),
                      blurRadius: 30,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  child: Text("Check !"),
                  color: Colors.deepOrange,
                  onPressed: () {
                    getCostList();
                  },
                ),
              ),
            ),
            costData.length > 0
                ? Container(
                    //padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Expanded(
                      child: ListView.builder(
                        //reverse: true,
                        itemCount: costData.length,
                        itemBuilder: (BuildContext context, int index) {
                          CostData costdata = costData[index];
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Card(
                              color: primaryColor,
                              shadowColor: Colors.blueAccent,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepOrange,
                                  child: Text("${index + 1}",style: TextStyle(color: Colors.black)),
                                ),
                                title: costdata.value == "NA"
                                    ? Text("Cost : Not found",style: TextStyle(color: Colors.white))
                                    : Text("Cost : Rs.${costdata.value}",style: TextStyle(color: Colors.white)),
                                isThreeLine: true,
                                subtitle: Text(
                                  "Date:${costdata.date}  Message:${costdata.message}",style: TextStyle(color: Colors.white)
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
