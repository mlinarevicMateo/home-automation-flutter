import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:home_automation/models/user.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = "user";
  String id = "user_id";
  String fullName = 'full_name';
  String email = 'email';
  String tokken = 'tokken';
  String uuid = 'uuid';
  String userLoggedIn = 'user_logged_in';

  DatabaseHelper._createInstance();
  
  factory DatabaseHelper() {
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if(_database == null) {
      _database = await initializaDatabase();
    }

    return _database;
  }

  Future<Database> initializaDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'home_automation.db';

    var database = await openDatabase(path, version: 1, onCreate: _createDatabase);
    
    return database;
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('create table $userTable ( $id integer primary key autoincrement, $fullName text not null, $email text not null, $tokken text not null, $uuid text not null, $userLoggedIn INTEGER DEFAULT 0)');
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    var result = await db.query(userTable);
    return result;
  }

  Future<List<User>> getUserList() async {
    var userMapList = await getUserMapList();
    List<User> userList = List<User>();

    for (var user in userMapList) {
      userList.add(User.fromMapObject(user));
    }

    return userList;
  } 

  Future<String> getTokenFromDatabase() async {
    var userList = await getUserList();

    
      if(userList[userList.length-1].userLoggedIn == 1){
        return userList[userList.length-1].tokken;
      }
   
    return null;
  }

  Future<User> getUserFromDatabase() async {
    var userList = await getUserList();

    
      if(userList[userList.length-1].userLoggedIn == 1){
        User user = userList[userList.length-1];
        return user;
      }
   
    return null;
  }

  Future<void> saveUser(User user) async {  
    Database db = await this.database;
    await db.insert(userTable, user.toMap());
  }

  Future<void> deleteUser(token) async {  
    Database db = await this.database;
    await db.delete(userTable, where: "$tokken = '$token'");
  }
}