import 'package:home_automation/utils/rest_datasource.dart';
import 'package:home_automation/models/user.dart';

abstract class RegisterScreenContract {
  void onRegisterSuccess(String string);
  void onRegisterError(String errorTxt);
}

class RegisterScreenPresenter {
  RegisterScreenContract _view;
  RestDatasource api = new RestDatasource();
  RegisterScreenPresenter(this._view);

  doRegister(String full_name, String email, String password) async {
    print("CREDENTIALS presenter: " + email + " " + password);
    /*api.Register(email, password).then((User user) {
      _view.onRegisterSuccess(user);
    }).catchError((Exception error) => _view.onRegisterError(error.toString()));
    */
    try {
     var res = await api.register(full_name, email, password);
      _view.onRegisterSuccess(res.toString());
    } on Exception catch(error) {
      _view.onRegisterError(error.toString());
    }
  }
}