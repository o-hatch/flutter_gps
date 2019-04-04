import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_gps4/LocationDataModel.dart';
import 'package:flutter_gps4/Database.dart';

class NewTrace extends StatefulWidget {
  @override
  _NewTraceState createState() => new _NewTraceState();
}

class _NewTraceState extends State<NewTrace> {

  var location = new Location();
  Timer timer;
  final freq = const Duration(seconds: 5);
  List<int> allTraces = new List<int>();
  Map<String, double> userLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: const Text('Start New Trace'),
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
                  LocationData userLocationData = LocationData(
                      latitude: userLocation["latitude"],
                      longitude: userLocation["longitude"],
                      altitude: userLocation["altitude"],
                      accuracy: userLocation["accuracy"]);
                  DBProvider.db.newLocationDataSameTrace(userLocationData);
                  setState(() {});
                });
              });
            });
          }),
          new IconButton(icon: const Icon(Icons.stop), onPressed: () {
            timer.cancel();
          }),
          new IconButton(icon: const Icon(Icons.delete), onPressed: () {
            DBProvider.db.deleteAll();
            setState(() {});
          })
        ],
      ),
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
                              "Altitude: " + item.altitude.toString() +
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
    );
  }

  // For Location getting
  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

}