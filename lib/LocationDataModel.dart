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

  LocationData({
    this.recordNum,
    this.traceNum,
    this.id,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracy,
  });

  factory LocationData.fromMap(Map<String, dynamic> json) => new LocationData(
    recordNum: json["recordNum"],
    traceNum: json["traceNum"],
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    altitude: json["altitude"],
    accuracy: json["accuracy"],
  );

  Map<String, dynamic> toMap() => {
    "recordNum": recordNum,
    "traceNum": traceNum,
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "altitude": altitude,
    "accuracy": accuracy,
  };

  int getTraceNum() {
    return traceNum;
  }
}