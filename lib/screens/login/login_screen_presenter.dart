import 'package:home_automation/utils/rest_datasource.dart';
import 'package:home_automation/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String email, String password) async {
    print("CREDENTIALS presenter: " + email + " " + password);
    try {
     var user = await api.login(email, password);
      _view.onLoginSuccess(user);
    } on Exception catch(error) {
      _view.onLoginError(error.toString());
    }
  }
}