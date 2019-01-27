class User {
  int _id;
  String _fullName;
  String _email;
  String _tokken;
  String _uuid;
  int _userLoggedIn;

  User(this._fullName, this._email, this._tokken, this._uuid, this._userLoggedIn);
  User.withId(this._id, this._fullName, this._email, this._tokken, this._uuid, this._userLoggedIn);

  int get id => _id;
  String get fullName => _fullName;
  String get email => _email;
  String get tokken => _tokken;
  String get uuid => _uuid;
  int get userLoggedIn => _userLoggedIn;

  set fullName(String full_name){
    if(full_name.length > 3 && full_name.length < 255 && full_name.contains(" "))
      _fullName = full_name;
  }
  set email(String email){
    if(_isEmailValid(email))
      _email = email;
  }

  set tokken(String tokken){
    if(tokken.length > 10 && tokken.length <255)
      _tokken = tokken;
  }
  set userLoggedIn(int userLoggedIn){
      _userLoggedIn = userLoggedIn;
  }

  bool _isEmailValid(String email){
    if(email.length > 5 && email.length < 255 && email.contains("@") && email.contains(".")){
      int indexOfMonkey = email.indexOf("@");
      int indexOfDot = email.indexOf(".");
      if(indexOfMonkey < indexOfDot)
        return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
      var map = Map<String, dynamic>();
      if(_id != null)
        map['user_id'] = _id;
      map['full_name'] = _fullName;
      map['email'] = _email;
      map['tokken'] = _tokken;
      map['uuid'] = _uuid;
      map['user_logged_in'] = _userLoggedIn;
      return map;
  }

  User.fromMapObject(Map<String, dynamic> map){
    this._id = map['user_id'];
    this._fullName = map['full_name'];
    this._email = map['email'];
    this._tokken = map['tokken'];
    this._uuid = map['uuid'];
    this._userLoggedIn = map['user_logged_in'];
  }

   User.fromObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._fullName = map['full_name'];
    this._email = map['email'];
    this._tokken = map['tokken'];
    this._uuid = map['uuid'];
    this._userLoggedIn = map['user_logged_in'];
  }

}