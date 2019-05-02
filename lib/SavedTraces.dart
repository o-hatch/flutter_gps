import 'package:flutter/material.dart';
import 'package:flutter_gps4/LocationDataModel.dart';
import 'package:flutter_gps4/Database.dart';

class SavedTraces extends StatefulWidget {
  @override
  _SavedTracesState createState() => new _SavedTracesState();
}

class _SavedTracesState extends State<SavedTraces> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: const Text('Saved Traces'),
      ),
      body: FutureBuilder<List<LocationData>>(
        future: DBProvider.db.getTraceNums(),
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
                    DBProvider.db.deleteTraceData(item.traceNum);
                  },
                  child: ListTile(
                      title: Text("Trace #" + item.traceNum.toString()),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        _navigateToSecondScreen(context, item.traceNum);
                      }
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


  void _navigateToSecondScreen(BuildContext context, int traceNum) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(traceNum),
        ));
  }

}

// ignore: must_be_immutable
class SecondScreen extends StatelessWidget {
  final int traceNum;
  SecondScreen(this.traceNum);

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text('Trace #' + traceNum.toString())
      ),

      body: FutureBuilder<List<LocationData>>(
        future: DBProvider.db.getTraceData(traceNum),
        builder: (BuildContext context, AsyncSnapshot<List<LocationData>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                LocationData item = snapshot.data[index];
                counter++;
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
                      leading: Text(counter.toString()),
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

}