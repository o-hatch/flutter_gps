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

  newLocationDataSameTrace(LocationData newLocationData) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(recordNum)+1 as recordNum FROM LocationData");
    int recordNum = table.first["recordNum"];
    int lastRecordNum = recordNum - 1;
    var res = await db.query("LocationData", where: "recordNum = ?", whereArgs: [lastRecordNum]);
    //var lastLocation = getLocationData(lastRecordNum);
    int traceNum = res.first["traceNum"];
    var raw = await db.rawInsert(
        "INSERT Into LocationData (recordNum, traceNum, id,latitude,longitude,altitude, accuracy)"
            " VALUES (?,?,?,?,?,?,?)",
        [recordNum, traceNum, newLocationData.id, newLocationData.latitude, newLocationData.longitude, newLocationData.altitude, newLocationData.accuracy]);
    return raw;

  }

  Future<List<LocationData>> getTraceNums() async {
    final db = await database;
    var res = await db.rawQuery("SELECT DISTINCT tracenum FROM LocationData");
    List<LocationData> list =
    res.isNotEmpty ? res.map((c) => LocationData.fromMap(c)).toList() : [];
    return list;


  }


  Future<List<LocationData>> getTraceData(int traceNum) async {
    final db = await database;
    var res = await db.query("LocationData", where: "traceNum = ?", whereArgs: [traceNum]);
    List<LocationData> list =
    res.isNotEmpty ? res.map((c) => LocationData.fromMap(c)).toList() : [];
    return list;

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

  deleteTraceData(int traceNum) async {
    final db = await database;
    return db.delete(
        "LocationData", where: "traceNum = ?", whereArgs: [traceNum]);
  }

  deleteAll() async {
    final db = await database;
    return db.rawDelete("DELETE FROM LocationData");
  }
}

