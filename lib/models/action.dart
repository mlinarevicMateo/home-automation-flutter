class Action {
  int _id;
  String _name;
  String _type;

  Action(this._id, this._name, this._type);

  int get id => this._id;
  String get name => this._name;
  String get type => this._type;

  Map<String, dynamic> toMap() {
      var map = Map<String, dynamic>();
      map['id'] = _id;
      map['name'] = _name;
      map['type'] = _type;
      return map;
  }

  Action.fromMap(Map<String, dynamic> action){
    this._id = action['id'];
    this._name = action['name'];
    this._type = action['type'].toString();
  }
}