import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/models/action.dart';
import 'package:home_automation/models/user.dart';
import 'package:home_automation/screens/action/action_screen.dart';
import 'package:home_automation/screens/home/home_screen_presenter.dart';
import 'package:home_automation/screens/login/login_screen.dart';
import 'package:home_automation/utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeScreenContract{
   BuildContext _ctx;

  bool _isLoading = true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Action> _actions = new List<Action>();
   User _user = null;
  var colors = [
    Color.fromARGB(255, 42, 57, 72),
    Color.fromARGB(255, 240, 176, 52),
    Color.fromARGB(255, 59, 114, 177),
    Color.fromARGB(255, 69, 166, 216),
    Color.fromARGB(255, 100, 221, 23),
    Color.fromARGB(255, 224, 224, 224)
  ];
  HomeScreenPresenter _presenter;

  _HomeScreenState() {
    _presenter = new HomeScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.fetchActions();
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
  @override
  Widget build(BuildContext context) {
   
    var db = new DatabaseHelper();
    db.getUserFromDatabase().then((u){
      _user = u; 
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Home Automation"),
        elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
      ),
      drawer: _user != null ? Drawer(
        child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(1.0, 1.9), 
          colors: [colors[0], colors[2]],
          tileMode: TileMode.repeated,
        ),
      ),
        accountEmail: Text(_user.email),
        accountName: Text(_user.fullName),
        currentAccountPicture: CircleAvatar(backgroundColor: colors[1],child: Icon(Icons.person, color: Colors.white,),) 
      ),
      ListTile(
        trailing: Icon(Icons.home, color: Colors.grey[800]),
        title: Text("Home page", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
        onTap: () => Navigator.of(context).pop()
      ),
       Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(
            color: Colors.black87,
          ),
        ),
      ListTile(
        trailing: Icon(Icons.supervised_user_circle, color: Colors.grey[800]),
        title: Text("Users", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
        onTap: () {
          if(_actions.length != 0){
            Navigator.of(context).pushNamed('/users');
          }
          else{
            _showSnackBar("You have no connected controllers");
            Navigator.of(context).pop();
          }
        },
      ),
      Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(
            color: Colors.black87,
          ),
        ),
      Padding(
        padding: EdgeInsets.all(5.0),
        child: Text("Account", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),),
      ),
      ListTile(
        trailing: Icon(Icons.arrow_back, color: Colors.grey[800],),
        title: Text("Logout", style: TextStyle(fontSize: 17.0, color: Colors.grey[800], fontWeight: FontWeight.bold),),
        onTap: () async {
            var db = new DatabaseHelper();
            var token = await db.getTokenFromDatabase();
            await db.deleteUser(token);
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen(message: null,)),);
        },
      ),
    ],
  ),
      ) : null,
      body: _isLoading ? 
              new Center(
                child: new CircularProgressIndicator(),
              ) 
              :  _actions.length == 0 ? _uuidWidget() : _actionsWidget(),
              
    );
  }

  Future<void> _refresh() async {
    setState(() {
          _isLoading = true;
          _presenter.fetchActions();
        });
  }

  Widget _uuidWidget(){
    return Center(
      child: Container(
      child: RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Your unique id is: ", style: TextStyle(fontSize: 20.0),),
              Text(_user.uuid.toString(), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),)
            ],
          )
        ),
      ) ,
      )
     
    ),
      )
    );
  }

  Widget _actionsWidget() {
    return new RefreshIndicator(
      onRefresh: _refresh,
      child:Container(
        color: colors[5],
        child: new GridView.builder(
          itemCount: _actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: EdgeInsets.all(2.0),
          itemBuilder: (BuildContext context, int index){
            final Action action = _actions[index];
            return _getGridItemUi(action, index);
          },
        ),
      )
    );
  }

  GestureDetector _getGridItemUi(Action action, int index) {
    return new GestureDetector(
      onTap: () {
        _onGridTileTap(index);
      },
      child: new Card(
        child: new GridTile(
          child: new Container(
            decoration: new BoxDecoration(
            color: colors[0], 
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white30, 
                borderRadius: new BorderRadius.all(new Radius.circular(3.0)),
              ),
              child: new Center(
            child: new Text(
              action.name.toUpperCase(), 
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: colors[5],
              ),),
          ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  void _onGridTileTap(int index){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActionScreen(action: _actions[index],)),
   );
  }

  @override
  Future onFetchError(String errorTxt) async {
     _showSnackBar(errorTxt);
      setState(() => _isLoading = false);
      var db = new DatabaseHelper();
      var token = await db.getTokenFromDatabase();
      await db.deleteUser(token);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(message: errorTxt,)),
   );
  }

  @override
  void onFetchSuccess(List<Action> actions) {
    setState(() {
      if(actions == null){
        Navigator.of(context).pushReplacementNamed('/login');
        _isLoading = true;
      }else{
        _actions = actions;
        _isLoading = false;
      } 
    });
  }
}