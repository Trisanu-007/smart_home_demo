import 'package:flutter/material.dart';
import 'package:smart_home_demo/pages/costs_page.dart';
import 'package:smart_home_demo/pages/home_page.dart';
import 'package:smart_home_demo/pages/settings.dart';

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
    Settings(),
  ];

  static List<String> _appBarTitles = <String>[
    "Home page",
    "Check your costs",
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
      ),
      body: Container(
        child: _wOption.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
