import 'package:IoT_Agric_App/models/readings..dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper{


  static DatabaseHelper _databaseHelper;
  static Database _database;

  String readingstable = 'SensorRecords';
  String colId= 'id';
  String coltime = 'time';
  String coltemperature = 'temperature';
  String colwater_used = 'water_used';
  String colph = 'ph';
  String colmoisture = 'moisture';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if (_database == null){
      _database = await initializedatabase();
    }
    return _database;
  }

  Future<Database> initializedatabase() async {
    Directory directory= await getApplicationDocumentsDirectory();
    String path = directory.path + 'iotirrigation.db';
    var sensordata= await openDatabase(path,version: 1,onCreate: _createDb );
    return sensordata;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $readingstable($colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
            '$coltime TIMESdTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,'
            '$coltemperature  REAL,'
            '$colwater_used REAL,'
            '$colph REAL,'
            '$colmoisture REAL)');
  }

  Future<dynamic> getReadingTemList() async {
    Database db = await this.database;
    List<Map<dynamic, dynamic>> tempgraph = await db.rawQuery('select $coltime, $coltemperature FROM $readingstable ORDER BY $colId DESC limit 5');
    return tempgraph;
  }



  Future<dynamic> getReadingwaterusedList() async {
    Database db = await this.database;
    List<Map<dynamic, dynamic>> watergraph = await db.rawQuery('select $coltime, $colwater_used FROM $readingstable ORDER BY $colId DESC limit 5' );
    return watergraph;
  }

  StreamController<dynamic> streamController = StreamController();
  newMessage(dynamic message) {
    streamController.add(getReadingwaterusedList());
  }


  Future<dynamic> getReadingPhList() async {
    Database db = await this.database;
    List<Map<dynamic, dynamic>> phgraph = await db.rawQuery('select  $coltime, $colph FROM $readingstable ORDER BY $colId DESC limit 5' );
    return phgraph;
  }



  Future<dynamic> getReadingMoistureList() async {
    Database db = await this.database;
    List<Map<dynamic, dynamic>> moistgraph = await db.rawQuery('select $coltime, $colmoisture FROM $readingstable ORDER BY $colId DESC limit 5' );
    return moistgraph;

  }



  InsertDatareading(Datareading datareading) async{
    Database db = await this.database;
    var dataread = await db.insert(readingstable, datareading.toJson());
    print('Data inserted');
    return dataread;

  }
  deleteAll() async {
    Database db = await this.database;
    db.delete(readingstable).then((i)=>print('Database deleted'));
  }


}