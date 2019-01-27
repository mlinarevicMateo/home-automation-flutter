
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:home_automation/models/action.dart';
import 'package:home_automation/models/log.dart';
import 'package:home_automation/utils/network_util.dart';
import 'package:home_automation/models/user.dart';
import 'package:home_automation/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://104.248.21.187:8080";
  static final LOGIN_URL = BASE_URL + "/signin";
  static final REGISTER_URL = BASE_URL + "/signup";
  static final ACTIONS_URL = BASE_URL + "/action";
  static final TRIGGER_URL = BASE_URL + "/trigger";
  static final LOGS_URL = BASE_URL + "/log/action";
  static final CURRENT_STATE_URL = BASE_URL + "/state";
  static final CONNECTED_USERS_URL = BASE_URL + "/user/connected";
  static final INVITE_URL = BASE_URL + "/invite";
  static final DELETE_PRIVILEGES_URL = BASE_URL + "/user/delete";

  Future<User> login(String email, String password) {
    print("CREDENTIALS datasource: " + email + " " + password);
    return _netUtil
      .post(LOGIN_URL, body: "{\n\t\"email\":\"$email\",\n\t\"password\":\"$password\"\n}")
      .then((dynamic res) {
        print(res['token']);//throw new Exception(res["error_msg"]);
        return new User(res['full_name'], res['email'], res['token'], res['uuid'], 1);
    });
  }

  Future<String> register(String full_name, String email, String password) {
    print("CREDENTIALS datasource: " + full_name + " " + email + " " + password);
    return _netUtil
      .post(REGISTER_URL, body: "{\n\t\"full_name\":\"$full_name\",\n\t\"email\":\"$email\",\n\t\"password\":\"$password\"\n}")
      .then((dynamic res) {
        return res;
    });
  }

  Future<List<Action>> fetchActions() async{

    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
    Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
    return _netUtil
      .get(ACTIONS_URL, headers: header)
      .then((dynamic res) {
        if(res.contains('message')){
          return null;
        }
        var list = List<Action>();
        for(var action in res){
          list.add(Action.fromMap(action));
        }
        return list;
      });
  } 

  Future<String> triggerAction(int id) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
    Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };

    return _netUtil
    .post(TRIGGER_URL + "/$id", headers: header)
    .then((dynamic res){
      return res;
    }); 
  }
  Future<String> inviteUser(String uuid) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
    Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };

    return _netUtil
      .post(INVITE_URL, body: "{\n\t\"uuid\":\"$uuid\"}", headers: header)
      .then((dynamic res) {
        return res;
    }); 
  }
  Future<String> deletePrivileges(int id) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
    Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };

    return _netUtil
      .post(DELETE_PRIVILEGES_URL, body: "{\n\t\"id\":\"$id\"}", headers: header)
      .then((dynamic res) {
        return res.toString();
    }); 
  }

  Future<List<Log>> loadLogs(int id) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
     Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
    return _netUtil
      .get(LOGS_URL + "/$id", headers: header)
      .then((dynamic res) {
        print(res);
        if(res.contains('message')){
          return null;
        }
        res = res.reversed;
        var list = List<Log>();
        for(var log in res){
          list.add(Log.fromMap(log));
        }
        print(res.length);
        return list;
    });
  }

   Future<dynamic> loadCurrentState(int id) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
     Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
    return _netUtil
      .get(CURRENT_STATE_URL + "/$id", headers: header)
      .then((dynamic res) {
        print(res);
        if(res.toString().contains('message')){
          return res['message'];
        }
        var status = res['status'];
        return status;
    });
  }
  Future<List<User>> fetchConnectedUsers() async{

    DatabaseHelper databaseHelper = new DatabaseHelper();
    var token = await databaseHelper.getTokenFromDatabase();
    Map<String, String> header = {
        HttpHeaders.contentTypeHeader:"application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
    return _netUtil
      .get(CONNECTED_USERS_URL, headers: header)
      .then((dynamic res) {
        if(res.contains('message')){
          return null;
        }
        var list = List<User>();
        for(var user in res){
          list.add(User.fromObject(user));
        }
        return list;
      });
  } 
}