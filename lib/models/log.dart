class Log{
  int _id;
  String _logText;
  String _createdAt;

  Log(this._id, this._logText, this._createdAt);

  int get id => _id;
  String get logText => _logText;
  String get createdAt => _createdAt;

  Log.fromMap(Map<String, dynamic> log){
    this._id = log['id'];
    var parsedLog = log['log'].toString().split("User ")[1].split(" with id ")[0] + " triggered action " +
                    log['log'].toString().split("User ")[1].split(" with id ")[1].split("triggered action named '")[1].split("' on microcontroller")[0];
    this._logText = parsedLog;
    this._createdAt = DateTime.parse(log['created_at']).toString().split(".000Z")[0];
  }
}