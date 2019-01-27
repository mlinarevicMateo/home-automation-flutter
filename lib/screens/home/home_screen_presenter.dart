import 'package:home_automation/models/action.dart';
import 'package:home_automation/utils/rest_datasource.dart';

abstract class HomeScreenContract {
  void onFetchSuccess(List<Action> actions);
  void onFetchError(String errorTxt);
}

class HomeScreenPresenter {
  HomeScreenContract _view;
  RestDatasource api = new RestDatasource();
  HomeScreenPresenter(this._view);

  fetchActions() async {
    try {
     var res = await api.fetchActions();
     print("Response: " + res.toString());
      _view.onFetchSuccess(res);
    } on Exception catch(error) {
      _view.onFetchError(error.toString());
    }
  }
}