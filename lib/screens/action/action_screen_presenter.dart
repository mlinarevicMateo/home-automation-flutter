import 'package:home_automation/models/action.dart';
import 'package:home_automation/models/log.dart';
import 'package:home_automation/utils/rest_datasource.dart';

abstract class ActionScreenContract {
  void onTriggerSuccess(String message);
  void onTriggerError(String errorTxt);
  void onLoadingLogsSuccess(List<Log> logs);
  void onLoadingLogsError(String errorTxt);
  void onLoadingCurrentStateSuccess(String res);
  void onLoadingCurrentStateError(String errorTxt);
}
  class ActionScreenPresenter {
    ActionScreenContract _view;
    RestDatasource api = new RestDatasource();
    ActionScreenPresenter(this._view);
  
    triggerAction(int id) async {
      try {
       var res = await api.triggerAction(id);
       print("Response: " + res.toString());
        _view.onTriggerSuccess(res.toString());
      } on Exception catch(error) {
        _view.onTriggerError(error.toString());
      }
    }
  
    loadLogs(int id) async {
      try {
       var res = await api.loadLogs(id);
       print("Response: " + res.toString());
        _view.onLoadingLogsSuccess(res);
      } on Exception catch(error) {
        _view.onLoadingLogsError(error.toString());
      }
    }
  
    getCurrentState(int id, int type) async {
       try {
       var res = await api.loadCurrentState(id);
       String status = null;

       if(res == "LOW"){
        if(type == 0){ //click
          status = "OPENED";
         }
         else if(type == 1){ //hold
           status = "ON";
         }
         else{
           status = "?";
         }
       }
       else if(res == "HIGH"){
        if(type == 0){ //click
          status = "CLOSED";
         }
         else if(type == 1){ //hold
           status = "OFF";
         }
         else{
           status = "?";
         }
       }
       else {
        status = null;
       }
       print("Response: " + res.toString());
       
        _view.onLoadingCurrentStateSuccess(status);
    } on Exception catch(error) {
      _view.onLoadingCurrentStateError(error.toString());
    }
  }
}