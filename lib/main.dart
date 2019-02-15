import 'package:flutter/material.dart';
import 'package:location/location.dart';


void main() => runApp(GetLocationPage());

class GetLocationPage extends StatefulWidget {
  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {

  var location = new Location();
  final List<Map<String, double>> _allLocations = <Map<String, double>>[];

  Map<String, double> userLocation;

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = _allLocations.map(
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
        .toList();

    return MaterialApp(
        home: Scaffold(
        appBar: new AppBar(
        title: const Text('Location Info'),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.location_on), onPressed: () {
              _getLocation().then((value) {
                setState(() {
                  userLocation = value;
                  _allLocations.add(userLocation);
                });
              });
            }),
          ],
        ),
        body: new ListView(children: divided),
      )
    );
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


}