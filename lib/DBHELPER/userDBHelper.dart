//import 'dart:io';
//
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:thaibah/Model/userLocalModel.dart';
//
//
//class DbHelper{
//  static DbHelper _dbHelper;
//  static Database _database;
//  DbHelper._createObject();
//
//  factory DbHelper(){
//    if(_dbHelper == null){
//      _dbHelper = DbHelper._createObject();
//    }
//    return _dbHelper;
//  }
//
//
//
//  Future<Database> initDb() async{
//    final Future<Database> database = openDatabase(
//      join(await getDatabasesPath(), 'doggie_database.db'),
//    );
//    //untuk menentukan nama database dan lokasi yang dibuat
//    Directory directory = await getApplicationDocumentsDirectory();
//    String path = directory.path + 'user.db';
//    //create, read database
//    var todoDatabase = openDatabase(path,version: 2,onCreate: _createDb);
//    //mengembalikan nilai object sebagai hasil dari fungsinya
//    print("TODO DATABASE $todoDatabase");
//    return todoDatabase;
//  }
////  int _id;
////  String _token;
////  String _name;
////  String _phone;
////  String _pin;
////  String _refferal;
//  //buat tabel baru dengan nama contact
//  void _createDb(Database db, int version) async {
//    await db.execute('''
//      CREATE TABLE contact (
//        id INTEGER PRIMARY KEY AUTOINCREMENT,
//        name TEXT,
//        phone TEXT,
//        token TEXT,
//        referral TEXT,
//        pin TEXT
//      )
//    ''');
//
//
////        await db.execute("CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, token TEXT, name TEXT, phone TEXT, pin TEXT, refferal TEXT)");
//  }
//  Future<Database> get database async {
//    if (_database == null) {
//      _database = await initDb();
//    }
//    return _database;
//  }
//  Future<List<Map<String, dynamic>>> select() async {
//    Database db = await this.database;
//    var mapList = await db.query('user', orderBy: 'phone');
//    return mapList;
//  }
//  //create databases
//  Future<int> insert(UserLocalModel object) async {
//    print("##################################### INSERT DB SQLITE ###############################");
//    print(object.toMap());
//    Database db = await this.database;
//    int count = await db.insert('user', object.toMap());
//    print("##################################### INSERT DB SQLITE COUNT $count ###############################");
//
//    return count;
//  }
////update databases
//  Future<int> update(UserLocalModel object) async {
//    Database db = await this.database;
//    int count = await db.update('user', object.toMap(),
//        where: 'phone=?',
//        whereArgs: [object.phone]);
//    return count;
//  }
//
////delete databases
//  Future<int> delete(String phone) async {
//    Database db = await this.database;
//    int count = await db.delete('user',
//        where: 'phone=?',
//        whereArgs: [phone]);
//    return count;
//  }
//
//  Future<List<UserLocalModel>> getContactList() async {
//    var contactMapList = await select();
//    int count = contactMapList.length;
//    List<UserLocalModel> contactList = List<UserLocalModel>();
//    for (int i=0; i<count; i++) {
//      contactList.add(UserLocalModel.fromMap(contactMapList[i]));
//    }
//    return contactList;
//  }
//  Future<List<Map<String, dynamic>>> queryRows(phone) async {
//    Database db = await this.database;
//    return await db.query("user", where: "phone='$phone'");
//  }
//
//}
//

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {

  static final _databaseName = "thaibah.db";
  static final _databaseVersion = 1;

  static final table = 'user';

  static final columnId = 'id';
  static final columnIdServer = 'id_server';
  static final columnName = 'name';
  static final columnAddress = 'address';
  static final columnEmail = 'email';
  static final columnPicture = 'picture';
  static final columnCover = 'cover';
  static final columnSocketId = 'socket_id';
  static final columnKdUnique = 'kd_unique';
  static final columnToken = 'token';
  static final columnPhone = 'phone';
  static final columnPin = 'pin';
  static final columnReferral = 'referral';
  static final columnKtp = 'ktp';
  static final columnStatus = 'status';
  static final columnStatusOnBoarding = 'status_on_boarding';
  static final columnStatusExitApp = 'status_exit_app';
  static final columnStatusLevel = 'status_level';
  static final columnWarna1 = 'warna1';
  static final columnWarna2 = 'warna2';

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    print("#################### CREATING DATABASE $_databaseName ########################");
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnIdServer TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnAddress TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnPicture TEXT NOT NULL,
            $columnCover TEXT NOT NULL,
            $columnSocketId TEXT NOT NULL,
            $columnKdUnique TEXT NOT NULL,
            $columnToken TEXT NOT NULL,
            $columnPhone TEXT NOT NULL,
            $columnPin TEXT NOT NULL,
            $columnReferral TEXT NOT NULL,
            $columnKtp TEXT NOT NULL,
            $columnStatus TEXT NOT NULL,
            $columnStatusOnBoarding TEXT NOT NULL,
            $columnStatusExitApp TEXT NOT NULL,
            $columnStatusLevel TEXT NOT NULL,
            $columnWarna1 TEXT NOT NULL,
            $columnWarna2 TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> updateByPhone(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String phone = row[columnPhone];
    return await db.update(table, row, where: '$columnPhone = ?', whereArgs: [phone]);
  }
  Future<int> delete(String id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdServer = ?', whereArgs: [id]);
  }
  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdServer');
  }

}