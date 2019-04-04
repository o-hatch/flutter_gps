import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_gps4/LocationDataModel.dart';
import 'package:flutter_gps4/Database.dart';
import 'package:flutter_gps4/NewTrace.dart';
import 'package:flutter_gps4/SavedTraces.dart';
//import 'dart:math' as math;


//void main() => runApp(GetLocationPage());
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

    //return MaterialApp(
      // home:
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





/*class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text('Saved Traces')
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          //onTap: _onItemTapped,
      ),
    );
  }

  void _goBackToFirstScreen(BuildContext context) {
    Navigator.pop(context);
  }
}*/

/*class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Traces'),
      ),
      body:  final Iterable<ListTile> tiles = allTraces.map(
        (int trace) {
          return new ListTile(
        title: new Text(
          "Trace # " + trace.toString() +
        ),
      );
    },
    )
    );
  }

}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trace #" + ),
      ),
      body: FutureBuilder<List<LocationData>>(
        future: DBProvider.db.getTraceData(traceNum),
        builder: (BuildContext context, AsyncSnapshot<List<LocationData>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                LocationData item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteLocationData(item.recordNum);
                  },
                  child: ListTile(
                      title: Text(
                          "Latitude: " + item.latitude.toString() + "\n" +
                              "Longitude: " + item.longitude.toString() + "\n" +
                              "Alitutude: " + item.altitude.toString() + "\n" +
                              "Accuracy: " + item.accuracy.toString()
                      ),
                      leading: Text(item.recordNum.toString()),
                      trailing: Text(item.traceNum.toString())
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}*/
