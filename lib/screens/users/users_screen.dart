import 'package:flutter/material.dart';
import 'package:home_automation/models/user.dart';
import 'package:home_automation/screens/users/users_screen_presenter.dart';

class UsersScreen extends StatefulWidget {
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> implements UsersScreenContract {
  bool _isLoading = true;
  List<User> _users = new List<User>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
 UsersScreenPresenter _presenter;

  _UsersScreenState() {
    _presenter = new UsersScreenPresenter(this);
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _presenter.fetchUsers();
    }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
       appBar: AppBar(
         title: Text("Users List"),
         elevation: 5.0,
       ),
       body: RefreshIndicator(
              onRefresh: _refresh,
              child: _isLoading ? 
                new Center(
                  child: new CircularProgressIndicator(),
                ) 
                : Container(
                  child: Center(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Column(children: <Widget>[
                          ListTile(
                          leading: CircleAvatar(
                            child: Center(
                              child: Text(_users[index].fullName[0]),
                            ),
                          ),
                          title: Text(_users[index].fullName),
                          subtitle: Text(_users[index].email),
                          trailing: GestureDetector(
                            onTap: () async {
                              await showDialog<String>(
                              context: context,
                              child:  AlertDialog(
                                title: Text("Are you sure you want to delete privilages to " + _users[index].fullName + "?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("YES"),
                                    onPressed: (){
                                      _presenter.deletePrivileges(_users[index].id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                              );
                            },
                            
                            child: Icon(Icons.delete, color: Colors.redAccent,),
                          ) 
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Divider(
                          color: Colors.black87,
                        ),
                        )
                        ],);
                      }
                    ),
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add user",
        child: Center(
          child: Icon(Icons.add),
        ),
        onPressed: () async {
          _showDialog();
        },
      ),
    );

  }

Future<void> _refresh() async {
    setState(() {
        _isLoading = true;
        _presenter.fetchUsers();
      });
  }
 _showDialog() async {
   TextEditingController _textfieldController = new TextEditingController();
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: Text("Add user"),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              
              child: new TextField(
                controller: _textfieldController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Insert users unique id'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('ADD'),
              onPressed: () {
                String uuid = _textfieldController.text;
                _presenter.invite(uuid);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }


  @override
  void onFetchError(String errorTxt) {
    _showSnackBar(errorTxt);
  }

  @override
  void onFetchSuccess(List<User> users) {
      setState(() {
        _users = users;
        _isLoading = false;
    });
  }

  @override
  void onInviteError(String errorTxt) {
    _showSnackBar(errorTxt);
  }

  @override
  void onInviteSuccess(String res) {
    _isLoading = true;
    _presenter.fetchUsers();
  }

  @override
  void onDeleteError(String errorTxt) {
    _showSnackBar(errorTxt);
  }

  @override
  void onDeleteSuccess(String res) {
    _isLoading = true;
    _presenter.fetchUsers();
    _showSnackBar(res.split("message: ")[1].split("}")[0]);
  }
}