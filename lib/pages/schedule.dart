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
  var status;
  var scheduledTime;
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

  Future<String> getDataFromFirebase() async {
    return await databaseRef.once().then((DataSnapshot snapshot) {
      return snapshot.value["status"];
    });
  }

  Future<String> getTime() async {
    return await databaseRef.once().then((DataSnapshot snapshot) {
      return snapshot.value["time"];
    });
  }

  void readinitData() async {
    var res = await getDataFromFirebase();
    var time = await getTime();
    if (res == "ongoing") {
      setState(() => status = "ONGOING");
      setState(() => scheduledTime = time);
    } else if (res == "done") {
      setState(() => status = "FINISHED");
      setState(() => scheduledTime = time);
    } else {
      setState(() => status = "");
    }
  }

  @override
  void initState() {
    readinitData();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return status == null
        ? LoadingScreen()
        : Container(
            color: primaryColor,
            padding: EdgeInsets.all(32),
            child: Form(
              key: _key,
              child: ListView(
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
                      hintStyle: TextStyle(color: Colors.white70),
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
                      hintStyle: TextStyle(color: Colors.white70),
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
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              var hr = int.parse(myController.text) +
                                  new DateTime.now().hour;
                              var min = int.parse(myController1.text) +
                                  new DateTime.now().minute;
                              //print(now);
                              if (_key.currentState.validate()) {
                                print("Your data is submitted");
                                str = hr.toString() + ":" + min.toString();
                                setState(() {
                                  loading = true;
                                });

                                await databaseRef.child("time").set(str);
                                await databaseRef.child("isTimeSet").set(true);
                                await databaseRef
                                    .child("status")
                                    .set("ongoing");
                                setState(() {
                                  loading = false;
                                  status = "ONGOING";
                                  scheduledTime = str;
                                });
                                myController.clear();
                                myController1.clear();
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Your device is scheduled at : " +
                                              str),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        status == "" || status == "FINISHED"
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      splashColor: Colors.grey,
                                      child: Text("Cancel Schedule"),
                                      onPressed: () async {
                                        await databaseRef.child("time").set("");
                                        await databaseRef
                                            .child("isTimeSet")
                                            .set(false);
                                        await databaseRef
                                            .child("status")
                                            .set("");
                                        setState(() => status = "");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  //),
                  loading == true ? LoadingScreen() : Container(),
                  status == ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Nothing scheduled yet",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          child: Card(
                            color: primaryColor,
                            shadowColor: Colors.deepOrange,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepOrange,
                                child: Icon(Icons.east),
                              ),
                              title: Text(
                                "Schedule status",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                "$status",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Text(
                                "$scheduledTime",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
  }
}
