import 'package:flutter/material.dart';
import 'package:home_automation/screens/home/home_screen.dart';
import 'package:home_automation/screens/login/login_screen.dart';
import 'package:home_automation/screens/register/register_screen.dart';
import 'package:home_automation/screens/users/users_screen.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(message: null,),
  '/register': (BuildContext context) => new RegisterScreen(),
  '/users': (BuildContext context) => new UsersScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
};