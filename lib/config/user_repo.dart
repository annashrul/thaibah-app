import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/checkerModel.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/resources/configProvider.dart';

class UserRepository {
  Future<bool> cekVersion() async {
    var res = await ConfigProvider().cekVersion();
    if(res is Checker){
      Checker results = res;
      var versionCode = results.result.versionCode;
      if(versionCode != ApiService().versionCode){
        return true;
      }
    }
    return false;
  }

  Future<bool> cekStatusMember() async {
    var res = await ConfigProvider().cekVersion();
    if(res is Checker){
      Checker results = res;
      var statusMember = results.result.statusMember;
      if(statusMember == 0){
        return true;
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
      }
    }
    return false;
  }
  Future<bool> cekStatusLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('id') == null || prefs.getString('id') == ''){
      return true;
    }
    return false;
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    return;
  }

  Future<void> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ctoken = prefs.getString('token');
    // await Future.delayed(Duration(seconds: 1));
    if(token == ctoken){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token!=null){
      return true;
    }else{
      return false;
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return token;
  }

  Future<int> getPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pin = prefs.getString('pin');
    return int.parse(pin);
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id');
    return id;
  }

  Future<String> getReff() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String reff = prefs.getString('kd_referral');
    return reff;
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    return name;
  }

  Future<String> getNoHp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nohp = prefs.getString('nohp');
    return nohp;
  }

  Future<String> getKtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nohp = prefs.getString('ktp');
    return nohp;
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }



}
