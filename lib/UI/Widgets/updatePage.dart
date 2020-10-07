import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SCREENUTIL/ScreenUtilQ.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Tekan Kembali Untuk Keluar',style:TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(14),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
    duration: snackBarDuration,
  );

  DateTime backButtonPressTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null || currentTime.difference(backButtonPressTime) > snackBarDuration;
    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      scaffoldKey.currentState.showSnackBar(snackBar);
      return false;
    }

    return true;
  }
  Future updateApk() async{
    final prefs = await SharedPreferences.getInstance();
    print("############# CLEAR SESSION ${prefs.getKeys().length}");
    prefs.clear();
    String url = 'https://play.google.com/store/apps/details?id=com.thaibah';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print(url);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
//    cekStatusLogin();
  }
//  WidgetsBinding.instance.addObserver(this);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive){
      print("########################### IN ACTIVE ######################");
    }
    if(state == AppLifecycleState.paused){
      print("########################### PAUSED INDEX ######################");
    }
    if(state == AppLifecycleState.resumed){
      print("########################### RESUME ######################");
      final userRepository = UserRepository();
      var token = await userRepository.getDataUser('token');
      print("##################### TOKEN MODE UPDATE = $token ##############################");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: scaffoldKey,
      body:  WillPopScope(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image.asset("assets/images/warning.png",width: 100.0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Center(
                      child: Text("Silahkan Perbaharui Aplikasi Anda Ke Versi ${ApiService().versionCode} !!".toUpperCase(), textAlign: TextAlign.center, style:TextStyle(color:Colors.red,fontSize:ScreenUtilQ.getInstance().setSp(34),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Center(
                      child: Text("Tekan Tombol Dibawah Ini Untuk Memperbaharui Aplikasi ...".toUpperCase(),  textAlign: TextAlign.center,style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color:Colors.red,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                    ),
                  ),
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
                          updateApk();
                        },
                        child: Text(
                          "Perbaharui Aplikasi Sekarang".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onWillPop: onWillPop
      ),
    );
  }
}