library flutter_gps4.Database;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gps4/LocationDataModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE LocationData ("
              "recordNum INTEGER PRIMARY KEY,"
              "traceNum INTEGER,"
              "id INTEGER,"
              // FLOAT or DOUBLE??
              "latitude FLOAT,"
              "longitude FLOAT,"
              "altitude FLOAT,"
              "accuracy FLOAT"
              ")");
        });
  }

  newLocationData(LocationData newLocationData) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(recordNum)+1 as recordNum FROM LocationData");
    int recordNum = table.first["recordNum"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into LocationData (recordNum, traceNum, id,latitude,longitude,altitude, accuracy)"
            " VALUES (?,?,?,?,?,?,?)",
        [recordNum, newLocationData.traceNum, newLocationData.id, newLocationData.latitude, newLocationData.longitude, newLocationData.altitude, newLocationData.accuracy]);
    return raw;
  }

  updateLocationData(LocationData newLocationData) async {
    final db = await database;
    var res = await db.update("LocationData", newLocationData.toMap(),
        where: "recordNum = ?", whereArgs: [newLocationData.recordNum]);
    return res;
  }

  getLocationData(int recordNum) async {
    final db = await database;
    var res = await db.query("LocationData", where: "recordNum = ?", whereArgs: [recordNum]);
    return res.isNotEmpty ? LocationData.fromMap(res.first) : null;
  }

  /*Future<List<LocationData>> getBlockedClients() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);

    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }*/

  // Method do increment trace number
  changeTraceNum(LocationData changeTraceNum) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(traceNum)+1 as traceNum FROM LocationData");
    int traceNum = table.first["traceNum"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into LocationData (recordNum, traceNum, id,latitude,longitude,altitude, accuracy)"
            " VALUES (?,?,?,?,?,?,?)",
        [changeTraceNum.recordNum, traceNum, changeTraceNum.id, changeTraceNum.latitude, changeTraceNum.longitude, changeTraceNum.altitude, changeTraceNum.accuracy]);
    return raw;
  }

  // Alternative method to increment trace number
  incrementTraceNum(LocationData location) async {
      final db = await database;
      LocationData newtrace = LocationData(
          recordNum: location.recordNum,
          traceNum: location.traceNum + 1,
          id: location.id,
          latitude: location.latitude,
          longitude: location.longitude,
          altitude: location.altitude,
          accuracy: location.accuracy);
      var res = await db.update("LocationData", newtrace.toMap(),
          where: "recordNum = ?", whereArgs: [location.recordNum]);
      return res;
  }



  Future<List<LocationData>> getAllLocationData() async {
    final db = await database;
    var res = await db.query("LocationData");
    List<LocationData> list =
    res.isNotEmpty ? res.map((c) => LocationData.fromMap(c)).toList() : [];
    return list;
  }

  deleteLocationData(int recordNum) async {
    final db = await database;
    return db.delete("LocationData", where: "recordNum = ?", whereArgs: [recordNum]);
  }

  deleteAll() async {
    final db = await database;
    return db.rawDelete("DELETE FROM LocationData");
  }
}

