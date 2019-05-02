import 'package:flutter/material.dart';
import 'package:flutter_gps4/NewTrace.dart';
import 'package:flutter_gps4/SavedTraces.dart';

void main() {
  runApp(MaterialApp(
    title: 'Location Data',
    home: GetLocationPage(),
  ));
}

class GetLocationPage extends StatefulWidget {
  @override
  //_GetLocationPageState createState() => _GetLocationPageState();
  State<StatefulWidget> createState() {
    return _GetLocationPageState();
  }
}

class _GetLocationPageState extends State<GetLocationPage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    NewTrace(),
    SavedTraces()
  ];

  @override
  Widget build(BuildContext context) {

      return Scaffold(

          body: _children[_currentIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            fixedColor: Colors.blue,
            onTap: onTabTapped,
            items: [
            new BottomNavigationBarItem(
                icon: Icon(Icons.add_location),
                title: Text('New Trace'),
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.dehaze),
                  title: Text('Saved Traces')
              )
            ],

          ),
      );
  }

  // For bottom app bar
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
// End of _GetLocationPageState class


