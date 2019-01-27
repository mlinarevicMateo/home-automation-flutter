import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_automation/utils/database_helper.dart';
import 'package:home_automation/models/user.dart';
import 'package:home_automation/screens/login/login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  final String message;

  LoginScreen({Key key, @required this.message}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      print("CREDENTIALS: " + _email + " " + _password);
      _presenter.doLogin(_email, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    bool showLoginScreen;
    print("MESSAGE: " + widget.message.toString());
    if(widget.message != null){
      showLoginScreen = false;
    }
    else{
      showLoginScreen = true;
    }
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN", style: TextStyle(color: Colors.white),),
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
          "Login",
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
                height: 25.0,
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
            Text("Don't have account?"),
            FlatButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('/register');
              },
              child:Text("Register", style:TextStyle(color: Colors.deepPurple)),
              ),
          ],
        )

      ],
      
    )));

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: showLoginScreen ? new Container(
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
      ) : AlertDialog(
        title: Text('Your session expired.'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please login'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              setState(() {
                              showLoginScreen = true;
                            });
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen(message: null,)),);
            },
          ),
        ],
      ) 
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    Navigator.of(_ctx).pushReplacementNamed('/home');
  }
}