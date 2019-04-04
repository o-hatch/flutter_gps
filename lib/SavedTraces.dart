import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
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

/*      body: ListView(
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
      ),
*/
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
                      title: Text(
                          "Latitude: " + item.latitude.toString() + "\n" +
                              "Longitude: " + item.longitude.toString() + "\n" +
                              "Alitutude: " + item.altitude.toString() + "\n" +
                              "Accuracy: " + item.accuracy.toString()
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