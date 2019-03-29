import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_gps4/LocationDataModel.dart';
import 'package:flutter_gps4/Database.dart';
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
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {

  int _selectedIndex = 0;
  final _widgetOptions = [
    Text('Index 0: New Trace'),
    Text('Index 1: Saved Traces'),
  ];


  var location = new Location();

  //final List<Map<String, double>> _allLocations = <Map<String, double>>[];
  Timer timer;
  final freq = const Duration(seconds: 5);
  List<int> allTraces = new List<int>();

  Map<String, double> userLocation;

  @override
  Widget build(BuildContext context) {

    /*final Iterable<ListTile> tiles = _allLocations.map(
            (Map<String, double> userLocation) {
          return new ListTile(
            title: new Text(
                  "Latitude: " + userLocation["latitude"].toString() +
                  "\n" +
                      "Longitude: " + userLocation["longitude"].toString() +
                  "\n" +
                  "Altitude: " + userLocation["altitude"].toString() +
                  "\n" +
                  "Accuracy: " + userLocation["accuracy"].toString(),
            ),
          );
        },
    );

    final List<Widget> divided = ListTile
        .divideTiles(
      context: context,
      tiles: tiles,
    )
        .toList();*/


    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: new AppBar(
            title: const Text('Location Info'),
            actions: <Widget>[
              new IconButton(icon: const Icon(Icons.play_arrow), onPressed: () {
                _getLocation().then((value) {
                  setState(() {
                    userLocation = value;
                    int traceHashCode = userLocation.hashCode;
                    allTraces.add(traceHashCode);
                    LocationData userLocationData = LocationData(
                        traceNum: traceHashCode,
                        latitude: userLocation["latitude"],
                        longitude: userLocation["longitude"],
                        altitude: userLocation["altitude"],
                        accuracy: userLocation["accuracy"]);
                    //DBProvider.db.incrementTraceNum(userLocationData);
                    DBProvider.db.newLocationData(userLocationData);

                    setState(() {});
                  });
                });

                timer = Timer.periodic(freq, (timer) {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                      //_allLocations.add(userLocation);
                      LocationData userLocationData = LocationData(
                          latitude: userLocation["latitude"],
                          longitude: userLocation["longitude"],
                          altitude: userLocation["altitude"],
                          accuracy: userLocation["accuracy"]);
                      DBProvider.db.newLocationData_SameTrace(userLocationData);
                      setState(() {});
                    });
                  });
                });
              }),
              new IconButton(icon: const Icon(Icons.stop), onPressed: () {
                timer.cancel();
                // Currently trace1 not used
                //trace1 = _allLocations;
                //_allLocations.removeRange(0, _allLocations.length-1);


              }),
              new IconButton(icon: const Icon(Icons.delete), onPressed: () {
                DBProvider.db.deleteAll();
                setState(() {});
              })
            ],
          ),
          //body: new ListView(children: divided),


          body: FutureBuilder<List<LocationData>>(
            future: DBProvider.db.getAllLocationData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<LocationData>> snapshot) {
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
                                  "Longitude: " + item.longitude.toString() +
                                  "\n" +
                                  "Alitutude: " + item.altitude.toString() +
                                  "\n" +
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
            onTap: _onItemTapped,
          )
      ),
    );
  }

    // New Trace / Location Data Display
  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: new AppBar(
              title: const Text('Location Info'),
              actions: <Widget>[
                new IconButton(
                    icon: const Icon(Icons.play_arrow), onPressed: () {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                      int traceHashCode = userLocation.hashCode;
                      allTraces.add(traceHashCode);
                      LocationData userLocationData = LocationData(
                          traceNum: traceHashCode,
                          latitude: userLocation["latitude"],
                          longitude: userLocation["longitude"],
                          altitude: userLocation["altitude"],
                          accuracy: userLocation["accuracy"]);
                      //DBProvider.db.incrementTraceNum(userLocationData);
                      DBProvider.db.newLocationData(userLocationData);

                      setState(() {});
                    });
                  });

                  timer = Timer.periodic(freq, (timer) {
                    _getLocation().then((value) {
                      setState(() {
                        userLocation = value;
                        //_allLocations.add(userLocation);
                        LocationData userLocationData = LocationData(
                            latitude: userLocation["latitude"],
                            longitude: userLocation["longitude"],
                            altitude: userLocation["altitude"],
                            accuracy: userLocation["accuracy"]);
                        DBProvider.db.newLocationData_SameTrace(
                            userLocationData);
                        setState(() {});
                      });
                    });
                  });
                }),
                new IconButton(icon: const Icon(Icons.stop), onPressed: () {
                  timer.cancel();
                  // Currently trace1 not used
                  //trace1 = _allLocations;
                  //_allLocations.removeRange(0, _allLocations.length-1);


                }),
                new IconButton(icon: const Icon(Icons.delete), onPressed: () {
                  DBProvider.db.deleteAll();
                  setState(() {});
                })
              ],
            ),
            //body: new ListView(children: divided),


            body: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text('Sun'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    print('Sun');
                  },
                ),
                ListTile(
                    leading: Icon(Icons.brightness_3),
                    title: Text('Moon'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      _navigateToSecondScreen(context);
                    }
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Star'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            )
        )
    );
  }*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }


  void _navigateToSecondScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(),
        ));
  }
}

class SecondScreen extends StatelessWidget {
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
          //currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          //onTap: _onItemTapped,
      ),
    );
  }

  void _goBackToFirstScreen(BuildContext context) {
    Navigator.pop(context);
  }
}

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
