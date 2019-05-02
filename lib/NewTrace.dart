import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_gps4/LocationDataModel.dart';
import 'package:flutter_gps4/Database.dart';


class NewTrace extends StatefulWidget {
  @override
  _NewTraceState createState() => new _NewTraceState();
}

class _NewTraceState extends State<NewTrace> {

  var location = new Location();
  Timer timer;
  Timer accelTimer;
  final locationFreq = const Duration(seconds: 5);
  final accelFreq = const Duration(milliseconds: 550);
  List<int> allTraces = new List<int>();
  Map<String, double> userLocation;


  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  var _isStartDisabled = false;
  var _isStopDisabled = true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: const Text('Start New Trace'),
        actions: <Widget>[
          _buildStartIcon(),
          _buildStopIcon(),
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
                      title: RichText (
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Latitude: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: item.latitude.toString() + "\n"),
                            TextSpan(text: 'Longitude: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: item.longitude.toString() + "\n"),
                            TextSpan(text: 'Altitude: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: item.altitude.toString() + "\n"),
                            TextSpan(text: 'Accuracy: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: item.accuracy.toString() + "\n"),
                            TextSpan(text: 'Accelerometer: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "[" + item.accelerometerX.toStringAsFixed(2) + ", "
                                + item.accelerometerY.toStringAsFixed(2) + ", " + item.accelerometerZ.toStringAsFixed(2) + "]\n"),
                            TextSpan(text: 'Gyroscope: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "[" + item.gyroscopeX.toStringAsFixed(2) + ", "
                                + item.gyroscopeY.toStringAsFixed(2) + ", " + item.gyroscopeZ.toStringAsFixed(2) + "]\n"),
                            TextSpan(text: 'UserAccelerometer: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "[" + item.userAccelerometerX.toStringAsFixed(2) + ", "
                                + item.userAccelerometerY.toStringAsFixed(2) + ", " + item.userAccelerometerZ.toStringAsFixed(2) + "]"),
                          ],
                        ),
                      ),
                      leading: Text(item.recordNum.toString()),
                      //trailing: Text(item.traceNum.toString())
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

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  void _switchButtons() {
    setState(() {
      _isStartDisabled = !_isStartDisabled;
      _isStopDisabled = !_isStopDisabled;
    });
  }

  void _updateData() {
    setState(() {
      // Update all data
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
              accuracy: userLocation["accuracy"],
              accelerometerX: _accelerometerValues != null ? _accelerometerValues[0]:null,
              accelerometerY: _accelerometerValues != null ? _accelerometerValues[1]:null,
              accelerometerZ: _accelerometerValues != null ? _accelerometerValues[2]:null,
              gyroscopeX: _gyroscopeValues != null ? _gyroscopeValues[0]:null,
              gyroscopeY: _gyroscopeValues != null ? _gyroscopeValues[1]:null,
              gyroscopeZ: _gyroscopeValues != null ? _gyroscopeValues[2]:null,
              userAccelerometerX: _userAccelerometerValues != null ? _userAccelerometerValues[0]:null,
              userAccelerometerY: _userAccelerometerValues != null ? _userAccelerometerValues[1]:null,
              userAccelerometerZ: _userAccelerometerValues != null ? _userAccelerometerValues[2]:null);
          DBProvider.db.newLocationData(userLocationData);

          setState(() {});
        });
      });

      // Update only accelerometer, gyroscope, and user accelerometer data
      accelTimer = Timer.periodic(accelFreq, (accelTimer) {
        LocationData userLocationData = LocationData(
            latitude: userLocation["latitude"],
            longitude: userLocation["longitude"],
            altitude: userLocation["altitude"],
            accuracy: userLocation["accuracy"],
            accelerometerX: _accelerometerValues != null ? _accelerometerValues[0]:null,
            accelerometerY: _accelerometerValues != null ? _accelerometerValues[1]:null,
            accelerometerZ: _accelerometerValues != null ? _accelerometerValues[2]:null,
            gyroscopeX: _gyroscopeValues != null ? _gyroscopeValues[0]:null,
            gyroscopeY: _gyroscopeValues != null ? _gyroscopeValues[1]:null,
            gyroscopeZ: _gyroscopeValues != null ? _gyroscopeValues[2]:null,
            userAccelerometerX: _userAccelerometerValues != null ? _userAccelerometerValues[0]:null,
            userAccelerometerY: _userAccelerometerValues != null ? _userAccelerometerValues[1]:null,
            userAccelerometerZ: _userAccelerometerValues != null ? _userAccelerometerValues[2]:null);
        DBProvider.db.newLocationDataSameTrace(userLocationData);
      });

      timer = Timer.periodic(locationFreq, (timer) {

        accelTimer.cancel();


        // Update all data
        _getLocation().then((value) {
          setState(() {
            userLocation = value;
            LocationData userLocationData = LocationData(
                latitude: userLocation["latitude"],
                longitude: userLocation["longitude"],
                altitude: userLocation["altitude"],
                accuracy: userLocation["accuracy"],
                accelerometerX: _accelerometerValues != null ? _accelerometerValues[0]:null,
                accelerometerY: _accelerometerValues != null ? _accelerometerValues[1]:null,
                accelerometerZ: _accelerometerValues != null ? _accelerometerValues[2]:null,
                gyroscopeX: _gyroscopeValues != null ? _gyroscopeValues[0]:null,
                gyroscopeY: _gyroscopeValues != null ? _gyroscopeValues[1]:null,
                gyroscopeZ: _gyroscopeValues != null ? _gyroscopeValues[2]:null,
                userAccelerometerX: _userAccelerometerValues != null ? _userAccelerometerValues[0]:null,
                userAccelerometerY: _userAccelerometerValues != null ? _userAccelerometerValues[1]:null,
                userAccelerometerZ: _userAccelerometerValues != null ? _userAccelerometerValues[2]:null);
            DBProvider.db.newLocationDataSameTrace(userLocationData);
            setState(() {});
          });
        });

        // Update only accelerometer, gyroscope, and user accelerometer data
        accelTimer = Timer.periodic(accelFreq, (accelTimer) {
          LocationData userLocationData = LocationData(
              latitude: userLocation["latitude"],
              longitude: userLocation["longitude"],
              altitude: userLocation["altitude"],
              accuracy: userLocation["accuracy"],
              accelerometerX: _accelerometerValues != null ? _accelerometerValues[0]:null,
              accelerometerY: _accelerometerValues != null ? _accelerometerValues[1]:null,
              accelerometerZ: _accelerometerValues != null ? _accelerometerValues[2]:null,
              gyroscopeX: _gyroscopeValues != null ? _gyroscopeValues[0]:null,
              gyroscopeY: _gyroscopeValues != null ? _gyroscopeValues[1]:null,
              gyroscopeZ: _gyroscopeValues != null ? _gyroscopeValues[2]:null,
              userAccelerometerX: _userAccelerometerValues != null ? _userAccelerometerValues[0]:null,
              userAccelerometerY: _userAccelerometerValues != null ? _userAccelerometerValues[1]:null,
              userAccelerometerZ: _userAccelerometerValues != null ? _userAccelerometerValues[2]:null);
          DBProvider.db.newLocationDataSameTrace(userLocationData);
        });

      });
    });
  }

  // Play button
  Widget _buildStartIcon() {
    return new ButtonTheme(
      minWidth: 50.0,
      height: 50.0,
      child: RaisedButton.icon(
        icon: Icon(Icons.play_arrow, size: 30 ),
        textColor: Colors.white,
        color: Colors.green[300],
        elevation: 4.0,
        onPressed: _startPress(),
        label: Text(""),
      ),
    );
  }

  // Stop button
  Widget _buildStopIcon() {
    return new ButtonTheme(
      minWidth: 50.0,
      height: 50.0,
      child: RaisedButton.icon(
        icon: Icon(Icons.stop, size: 30),
        textColor: Colors.white,
        color: Colors.red,
        elevation: 4.0,
        onPressed: _stopPress(),
        label: Text(""),
      ),
    );
  }

  Function _startPress() {
    if (_isStartDisabled) {
      return null;
    } else {
      return () {
        _switchButtons();
        _updateData();
      };
    }
  }

  Function _stopPress() {
    if (_isStopDisabled) {
      return null;
    } else {
      return () {
        _switchButtons();
        accelTimer.cancel();
        timer.cancel();
      };
    }
  }

}