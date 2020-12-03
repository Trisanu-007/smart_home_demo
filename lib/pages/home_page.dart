import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:smart_home_demo/classes/data.dart';
import 'package:smart_home_demo/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_demo/constants/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: non_constant_identifier_names
  int num_of_devices =
      1; // basically number of LED's or motors connected without the temperature sensor
  final String rApiKey = readApiKey;
  final String wApiKey = writeApiKey;
  DataLed _dataLed;
  final int device1 = 1;
  double brightness;
  bool hasChanged = false;
  String message;

  Future<DataLed> getDataFromApi() async {
    http.Response response = await http.get(
      Uri.encodeFull(
          "https://api.thingspeak.com/channels/1214545/fields/$device1.json?api_key=$rApiKey&results=1"),
    );
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      print(parsedJson["channel"]["last_entry_id"]);

      int lastEntryId = parsedJson["channel"]["last_entry_id"];
      List<Feeds> feeds = new List<Feeds>();
      var feedApi = parsedJson["feeds"];
      var lastEntry;
      print(feedApi[0]["entry_id"].runtimeType);

      for (int i = 0; i < feedApi.length; i++) {
        Feeds newFeed = new Feeds(
          createdAt: feedApi[i]["created_at"],
          entryId: feedApi[i]["entry_id"],
          field: int.parse(feedApi[i]["field$device1"]),
        );
        feeds.add(newFeed);

        if (newFeed.entryId == lastEntryId) {
          lastEntry = newFeed.field;
        }
      }

      return DataLed(
        id: parsedJson["channel"]["id"],
        lastEntryId: parsedJson["channel"]["last_entry_id"],
        message: "success",
        updatedAt: parsedJson["channel"]["updated_at"],
        lastentry: lastEntry,
        feeds: feeds,
      );
    }
    return null;
  }

  void fillInitialData() async {
    DataLed dt = (await getDataFromApi());
    setState(() {
      _dataLed = dt;
      brightness = _dataLed.lastentry.toDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    fillInitialData();
  }

  Future<String> updateData() async {
    http.Response response = await http.get(Uri.encodeFull(
        "https://api.thingspeak.com/update?api_key=$wApiKey&field$device1=$brightness"));
    if (response.statusCode == 200)
      return "Success";
    else
      return "Failure";
  }

  @override
  Widget build(BuildContext context) {
    return _dataLed == null
        ? LoadingScreen()
        : Container(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Living room",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Registered Devices :",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "$num_of_devices",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Divider(color: Colors.black, thickness: 2.0),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Name :",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Light bulb",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Last Updated status :",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Value :",
                        style: TextStyle(
                          fontSize: 15.0,
                          //fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "${_dataLed.lastentry}",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Last updated when :",
                        style: TextStyle(
                          fontSize: 15.0,
                          //fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "${_dataLed.updatedAt.replaceAll('T', ", ")}",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Change the value :",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "$brightness",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                Center(
                  child: Row(
                    children: [
                      Container(
                        child: Switch(
                          value: brightness > 0 ? true : false,
                          activeTrackColor: Colors.blue,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            setState(() {
                              brightness = val == true ? 1 : 0;
                              hasChanged = true;
                            });
                          },
                        ),
                        /*
                        child: Slider(
                          value: brightness,
                          min: 0.0,
                          max: 255.0,
                          divisions: 17,
                          activeColor: Colors.yellow[100 + brightness.round()],
                          onChanged: (double val) {
                            setState(() {
                              brightness = val;
                              hasChanged = true;
                            });
                          },
                        ),
                        */
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: RaisedButton(
                            color: Colors.blue,
                            child: Text("Update"),
                            onPressed: hasChanged == false
                                ? null
                                : () async {
                                    var res = await updateData();
                                    print(res);
                                    setState(() {
                                      message = res;
                                      _dataLed.lastentry = brightness.round();
                                    });
                                  }),
                      ),
                    ],
                  ),
                ),
                message != null
                    ? Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "$message",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(),
                // );
              ],
            ),
          );
  }
}
