import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/checkerModel.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/resources/configProvider.dart';


class UserRepository {
  requestTimeOut(Function callback){
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.green, // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      callback();
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.refresh,color: Colors.white,), // icon
                        Text("coba lagi",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text("gagal memuat. harap periksa koneksi internet anda !!"),
          ],
        ),
      ),
    );
  }
  moreThenOne(BuildContext context, Function callback){
    return Container(
      padding:EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.green, // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      prefs.commit();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.power_settings_new,color: Colors.white,), // icon
                        Text("Keluar",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text("percobaan anda sudah melebihi 1x.",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            Text("silahkan keluar aplikasi terlebih dahulu, apabila masih ada kendala silahkan hubungi admin atau klik tombol di bawah ini",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            SizedBox(height: 20.0),
            Container(
              child: Center(
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)
                  ),
                  color: Colors.white,
                  textColor: Colors.green,
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    callback();

//                    AppSettings.openAppSettings();
//                    updateApk();
                  },
                  child: Text(
                    "cara clear data".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  modeUpdate(BuildContext context){
    return Container(
      padding:EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.green, // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      prefs.commit();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.power_settings_new,color: Colors.white,), // icon
                        Text("Keluar",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text("anda baru saja mengupgdate aplikasi thaibah.",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            Text("tekan tombol keluar untuk melanjutkan proses pemakaian aplikasi thaibah",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
          ],
        ),
      ),
    );
  }

  Future getDeviceId() async{
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init(ApiService().deviceId, iOSSettings: settings);
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String onesignalUserId = status.subscriptionStatus.userId;
    return onesignalUserId;
  }

  Future<bool> cekVersion() async {
    var res = await ConfigProvider().cekVersion();
    if(res is Checker){
      Checker results = res;
      var versionCode = results.result.versionCode;
      print("##################################### $versionCode ###########################");
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
