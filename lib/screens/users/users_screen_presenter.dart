import 'package:home_automation/models/user.dart';
import 'package:home_automation/utils/rest_datasource.dart';

abstract class UsersScreenContract {
  void onFetchSuccess(List<User> users);
  void onFetchError(String errorTxt);
  void onInviteSuccess(String res);
  void onInviteError(String errorTxt);
  void onDeleteSuccess(String res);
  void onDeleteError(String errorTxt);
}

class UsersScreenPresenter {
  UsersScreenContract _view;
  RestDatasource api = new RestDatasource();
  UsersScreenPresenter(this._view);

  fetchUsers() async {
    try {
     var res = await api.fetchConnectedUsers();
     print("Response: " + res.toString());
      _view.onFetchSuccess(res);
    } on Exception catch(error) {
      _view.onFetchError(error.toString());
    }
  }

  invite(String uuid) async {
    try {
     var res = await api.inviteUser(uuid);
     print("Response: " + res.toString());
      _view.onInviteSuccess(res.toString());
    } on Exception catch(error) {
      _view.onInviteError(error.toString());
    }
  }
  deletePrivileges(int id) async {
    try {
     var res = await api.deletePrivileges(id);
     print("Response: " + res.toString());
      _view.onDeleteSuccess(res.toString());
    } on Exception catch(error) {
      _view.onDeleteError(error.toString());
    }
  }
}