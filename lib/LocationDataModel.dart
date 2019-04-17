library flutter_gps4.LocationDataModel;

import 'dart:convert';

LocationData locationDataFromJson(String str) {
  final jsonData = json.decode(str);
  return LocationData.fromMap(jsonData);
}

String locationDataToJson(LocationData data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class LocationData {
  int recordNum;
  int traceNum;
  int id;
  double latitude;
  double longitude;
  double altitude;
  double accuracy;
  double accelerometerX;
  double accelerometerY;
  double accelerometerZ;
  double gyroscopeX;
  double gyroscopeY;
  double gyroscopeZ;
  double userAccelerometerX;
  double userAccelerometerY;
  double userAccelerometerZ;

  LocationData({
    this.recordNum,
    this.traceNum,
    this.id,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracy,
    this.accelerometerX,
    this.accelerometerY,
    this.accelerometerZ,
    this.gyroscopeX,
    this.gyroscopeY,
    this.gyroscopeZ,
    this.userAccelerometerX,
    this.userAccelerometerY,
    this.userAccelerometerZ,
  });

  factory LocationData.fromMap(Map<String, dynamic> json) => new LocationData(
    recordNum: json["recordNum"],
    traceNum: json["traceNum"],
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    altitude: json["altitude"],
    accuracy: json["accuracy"],
    accelerometerX: json["accelerometerX"],
    accelerometerY: json["accelerometerY"],
    accelerometerZ: json["accelerometerZ"],
    gyroscopeX: json["gyroscopeX"],
    gyroscopeY: json["gyroscopeY"],
    gyroscopeZ: json["gyroscopeZ"],
    userAccelerometerX: json["userAccelerometerX"],
    userAccelerometerY: json["userAccelerometerY"],
    userAccelerometerZ: json["userAccelerometerZ"],
  );

  Map<String, dynamic> toMap() => {
    "recordNum": recordNum,
    "traceNum": traceNum,
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "altitude": altitude,
    "accuracy": accuracy,
    "accelerometerX": accelerometerX,
    "accelerometerY": accelerometerY,
    "accelerometerZ": accelerometerZ,
    "gryoscopeX": gyroscopeX,
    "gryoscopeY": gyroscopeY,
    "gryoscopeZ": gyroscopeZ,
    "userAccelerometerX": userAccelerometerX,
    "userAccelerometerY": userAccelerometerY,
    "userAccelerometerZ": userAccelerometerZ,
  };

}