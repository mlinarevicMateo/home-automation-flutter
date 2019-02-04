import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_automation/screens/login/login_screen.dart';
import 'package:home_automation/models/user.dart';
import 'package:home_automation/screens/register/register_screen_presenter.dart';

class RegisterScreen extends StatefulWidget {
  final String message;

  RegisterScreen({Key key, @required this.message}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen>
    implements RegisterScreenContract {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _full_name, _email, _password;

  RegisterScreenPresenter _presenter;

  RegisterScreenState() {
    _presenter = new RegisterScreenPresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      print("CREDENTIALS: "+ _full_name + " " + _email + " " + _password);
      _presenter.doRegister(_full_name, _email, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("REGISTER", style: TextStyle(color: Colors.white),),
      color: Color.fromARGB(255, 69, 166, 216),
    );
    var loginForm = new Center(child:SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:  new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage('assets/logo.png'),),
        SizedBox(height: 5.0,),
        new Text(
          "Home Automation",
          textScaleFactor: 1.5,
        ),
        SizedBox(
          height: 25.0,
        ),
        new Text(
          "Register",
          textScaleFactor: 2.0,
        ),
        SizedBox(
                height: 25.0,
              ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _full_name = val,
                  validator: (val) {
                    return (val.length < 5 && val.contains(" "))
                        ? "Please enter full name"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Full name"),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val,
                  validator: (val) {
                    return (!val.contains("@") || !val.contains(".") || val.length < 10)
                        ? "Invalid email"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Email"),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn,
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Already have account?"),
            FlatButton(
              onPressed: (){
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen(message: "",)),);
              },
              child:Text("Login", style:TextStyle(color: Colors.deepPurple)),
              ),
          ],
        )

      ],
      
    )));

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                decoration: new BoxDecoration(
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ) 
    );
  }

  @override
  void onRegisterError(String errorTxt) {
    // TODO: implement onRegisterError
     _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onRegisterSuccess(String res) {
    // TODO: implement onRegisterSuccess
    _showSnackBar(res);
    setState(() => _isLoading = false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen(message: "Successfully registered, please sign in.",)));
  }
}