import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_home_demo/constants/loading.dart';
import 'package:smart_home_demo/config.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  String str;
  bool loading = false;
  var isScheduled = false;
  var lastTime;

  final databaseRef = FirebaseDatabase.instance.reference();
  /*
  bool> readData() async {
    res bool;
    return await databaseRef.once().then((value) => value.value["isTimeSet"]);
  }

  @override
  void initState() {
    super.initState();
    bool res = readData();
  }
  */
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: EdgeInsets.all(32),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                "Enter the number of hours and minutess after which you want your device to function",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter hours",
                hintStyle: TextStyle( color: Colors.white70),
                //fillColor: Colors.white,
              ),
              style: TextStyle(color: Colors.white),
              controller: myController,
              validator: (value) {
                if (value.isEmpty) {
                  return "This can not be empty";
                } else if (int.parse(value) < 0) {
                  return "This should be more than 0";
                } else if (int.parse(value) > 23) {
                  return "This should be less than 24";
                } else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter minutes",
                hintStyle: TextStyle( color: Colors.white70),
                // border: OutlineInputBorder(
                //   borderSide: BorderSide(
                //     color: Colors.teal,
                //   ),
                // ),

              ),
              style: TextStyle(color: Colors.white),
              controller: myController1,
              validator: (value) {
                if (value.isEmpty) {
                  return "This can not be empty";
                } else if (int.parse(value) < 0) {
                  return "This should be more than 0";
                } else if (int.parse(value) > 59) {
                  return "This should be less than 60";
                } else
                  return null;
              },
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.deepOrangeAccent.withOpacity(0.5),
                      blurRadius: 25,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),

                  ),
                  splashColor: Colors.grey,
                  child: Text("Set schedule"),
                  color: Colors.deepOrange,
                  textColor: Colors.black,
                  onPressed: () async {
                    var hr =
                        int.parse(myController.text) + new DateTime.now().hour;
                    var min =
                        int.parse(myController1.text) + new DateTime.now().minute;
                    //print(now);
                    if (_key.currentState.validate()) {
                      print("Your data is submitted");
                      if(min>=60){
                        hr= hr+1;
                        min= min-60;
                      }
                      str = hr.toString() + ":" + min.toString();
                      setState(() {
                        loading = true;
                      });

                      await databaseRef.child("time").set(str);
                      await databaseRef.child("isTimeSet").set(true);
                      setState(() {
                        loading = false;
                      });
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Your device is scheduled at : " + str),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            loading == true ? LoadingScreen() : Container(),
          ],
        ),
      ),
    );
  }
}
