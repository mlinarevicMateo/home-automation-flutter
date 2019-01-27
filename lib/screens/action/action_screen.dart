import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_automation/models/action.dart';
import 'package:home_automation/models/log.dart';
import 'package:home_automation/screens/action/action_screen_presenter.dart';
import 'package:home_automation/screens/login/login_screen.dart';
import 'package:home_automation/utils/database_helper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ActionScreen extends StatefulWidget {
  final Action action;

  ActionScreen({Key key, @required this.action}) : super(key: key);

  @override
  _ActionScreenState createState() => _ActionScreenState();
  
}

class _ActionScreenState extends State<ActionScreen> implements ActionScreenContract {
  BuildContext _ctx;
  bool _isTriggering = false;
  bool _isLoadingLogs = true;
  bool _isLoadingCurrentState = true;
  var dayBefore = null;
  var currentDay = null;
  ActionScreenPresenter _presenter;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Log> _logs = new List<Log>();
  String _currentState = null;
  var colors = [
      Color.fromARGB(255, 42, 57, 72),
      Color.fromARGB(255, 240, 176, 52),
      Color.fromARGB(255, 59, 114, 177),
      Color.fromARGB(255, 69, 166, 216)
    ];

  _ActionScreenState() {
    _presenter = new ActionScreenPresenter(this);
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _isLoadingLogs = true;
      _isLoadingCurrentState = true;
      _presenter.loadLogs(widget.action.id);
      _presenter.getCurrentState(widget.action.id, int.parse(widget.action.type));
    }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.action.name),
      ),
      body:RefreshIndicator(
              onRefresh: _refresh,
              child: ModalProgressHUD(
          inAsyncCall: _isTriggering,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child:  Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Center(
                    child: Text("Trigger Action", style: TextStyle(color: Colors.white),),
                  ),
                  color: colors[2],
                  elevation: 5.0,
                  
                  onPressed: () {
                    setState(() {
                      _isTriggering = true;
                    });
                    _presenter.triggerAction(widget.action.id);
                  },
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 10.0, bottom: 3.0, top: 3.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Current state: ", textAlign: TextAlign.right, style: TextStyle(fontSize: 15.0),),
                      Text(_isLoadingCurrentState ? "?" : _currentState.toString().toUpperCase(), textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black87),),
                    ],
                  )                
                ),
                SizedBox(height: 30.0,),
                new Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 10.0, bottom: 3.0, top: 3.0),
                  child: Text("History: ", textAlign: TextAlign.left, style: TextStyle(fontSize: 20.0),),
                ),
                
                new Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.0, top: 3.0),
                  child: new Container(
                    alignment: Alignment(0.0, 1.0),
                    height: MediaQuery.of(context).size.height * 0.70,
                    padding: EdgeInsets.all(5.0),
                    child: _isLoadingLogs ? 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator()
                          ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Center(
                          child: Text("Loading logs...", style: TextStyle(color: Colors.white),),
                        )
                        ]
                    )
                    : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                      bool isNewDay = false;
                      if(index == 0) {
                        print("INDEX JE NULA");
                          dayBefore = _logs[index].createdAt.toString().split(" ")[0];
                          currentDay = _logs[index].createdAt.toString().split(" ")[0];
                          isNewDay = true;
                        }
                        else{
                          dayBefore = currentDay;
                          currentDay = _logs[index].createdAt.toString().split(" ")[0];
                        }
                        
                        if(dayBefore != currentDay){
                          isNewDay = true;
                        }

                        Widget tile = Column(
                          children: <Widget>[
                            isNewDay ? Container(
                              color: colors[0],
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              
                              children: <Widget>[Text(currentDay, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),)],)) : Text(""),
                            new ListTile(
                              leading: CircleAvatar(
                                backgroundColor: colors[1],
                                child: Center(
                                  child: Text((index+1).toString(), style: TextStyle(color: Colors.white,))
                                ),
                              ),
                              title: Text(_logs[index].logText),
                              subtitle: Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, size: 15.0, color: colors[0],),
                                  SizedBox(width: 2.0,),
                                  Text(_logs[index].createdAt.toString(), style: TextStyle(color: colors[0],)),
                                ],
                              )
                            ), 
                            Divider(height: 1.0, color: Colors.black,)
                          ],
                        );

                        return tile; 
                      }
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: new BorderRadius.all(const  Radius.circular(10.0))
                    ),
                    
                  ),
                )
                
              ],
            )
          ),
        )
      )
      )
    );
  }

  Future<void> _refresh() async {
    setState(() {
        _isLoadingLogs = true;
        _isLoadingCurrentState = true;
        _presenter.loadLogs(widget.action.id);
        _presenter.getCurrentState(widget.action.id, int.parse(widget.action.type));
      });
  }

  @override
  void onTriggerError(String errorTxt) async {
    setState(() => _isTriggering = false);
    print("A" + errorTxt + "A");
    if(errorTxt == "Unauthorised: You need to be signed in..."){
      
      var db = new DatabaseHelper();
      var token = await db.getTokenFromDatabase();
      await db.deleteUser(token);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(message: errorTxt,)),);
    }
     _showSnackBar("Error: " + errorTxt);
  }

  @override
  void onTriggerSuccess(String message) {
    setState(() {
      _isTriggering = false;
      _isLoadingLogs = true;
      _isLoadingCurrentState = true;
      _presenter.loadLogs(widget.action.id);
      _presenter.getCurrentState(widget.action.id, int.parse(widget.action.type));
    });
    _showSnackBar("Successfully trigger action: " + widget.action.name);
  }

  @override
  void onLoadingLogsError(String errorTxt) async {
    if(errorTxt == "Exception: Unauthorised: You need to be signed in..."){
      
      var db = new DatabaseHelper();
      var token = await db.getTokenFromDatabase();
      await db.deleteUser(token);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(message: errorTxt,)),);
    }
     _showSnackBar("Error: " + errorTxt);
  }

  @override
  void onLoadingLogsSuccess(List<Log> logs) {
    setState(() {
      _isLoadingLogs = false;
      _logs = logs;
    });
  }

  @override
  void onLoadingCurrentStateError(String errorTxt) async {
    // TODO: implement onLoadingCurrentStateError
   if(errorTxt == "Exception: Unauthorised: You need to be signed in..."){
      
      var db = new DatabaseHelper();
      var token = await db.getTokenFromDatabase();
      await db.deleteUser(token);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(message: errorTxt,)),);
    }
     _showSnackBar("Error: " + errorTxt);
  }

  @override
  void onLoadingCurrentStateSuccess(String res) {
    // TODO: implement onLoadingCurrentStateSuccess
    setState(() {
      _isLoadingCurrentState = false;
      _currentState = res;
      print("RES:" + res);
    });
  }
}   