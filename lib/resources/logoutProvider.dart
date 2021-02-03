import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/config/user_repo.dart';

import 'memberProvider.dart';

class LogoutProvider{
  Future logout()async{
    final userRepository=UserRepository();
    final dbHelper = DbHelper.instance;
    final id = await userRepository.getDataUser('id');
    Map<String, dynamic> row = {
      DbHelper.columnId   : id,
      DbHelper.columnStatus : '0',
      DbHelper.columnStatusOnBoarding  : "1",
      DbHelper.columnStatusExitApp  : "1"
    };
    await dbHelper.update(row);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }
}