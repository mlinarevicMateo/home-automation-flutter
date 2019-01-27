import 'package:flutter/material.dart';
import 'package:home_automation/models/user.dart';
import 'package:home_automation/screens/home/home_screen.dart';
import 'package:home_automation/screens/login/login_screen.dart';
import 'package:home_automation/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'routes.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  
  bool _isLoading = true;
  bool _isUserLoggedIn = false;

  @override
    void initState() {
      super.initState();
      _isLoggedIn().then((isLogged) {
        print("Is logged " + isLogged.toString());
        if(isLogged == true){
          setState(() {
            _isLoading = false;
            _isUserLoggedIn = isLogged;
          });
        }
        setState(() {
            _isLoading = false;
          });
        
      });
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 42, 57, 72),
        accentColor: Color.fromARGB(255, 69, 166, 216)
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
      home: _isLoading ? Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ) : SafeArea(
        top: true,
        left: true,
        bottom: true,
        right: true,
        child: _isUserLoggedIn ? HomeScreen() : LoginScreen(message: null,),
      )
    );
  }
}
  
Future<bool> _isLoggedIn() async{
  DatabaseHelper helper = new DatabaseHelper();
  await helper.initializaDatabase();
  var users = await helper.getUserList();
  if(users.length != null){
    for(var user in users){
      if(user.userLoggedIn == 1)
        return true;
    }
  }
  return false;
}



