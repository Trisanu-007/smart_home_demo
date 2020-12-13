import 'package:flutter/material.dart';
import 'package:smart_home_demo/pages/costs_page.dart';
import 'package:smart_home_demo/pages/home_page.dart';
import 'package:smart_home_demo/pages/schedule.dart';
import 'package:smart_home_demo/pages/settings.dart';
import 'package:smart_home_demo/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  static List<Widget> _wOption = <Widget>[
    Home(),
    CostsPage(),
    Schedule(),
    Settings(),
  ];

  static List<String> _appBarTitles = <String>[
    "Home page",
    "Check your costs",
    "Schedule your device",
    "Settings"
  ];

  void handleOnTap(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarTitles.elementAt(selectedIndex),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: _wOption.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.white,
        onTap: handleOnTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: "Cost",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: "Settings",
          // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
           label: "Schedule",
            )
        ],
      ),
    );
  }
}


// bottomNavigationBar: BottomNavigationBar(
// currentIndex: selectedIndex,
// selectedItemColor: Colors.deepOrange,
// unselectedItemColor: Colors.white,
// backgroundColor: primaryColor,
// onTap: handleOnTap,
// items: <BottomNavigationBarItem>[
// BottomNavigationBarItem(
// icon: Icon(Icons.home),
// label: "Home",
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.monetization_on),
// label: "Cost",
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.schedule),
// label: "Schedule",
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.settings),
// label: "Settings",
// ),
// ],
// ),