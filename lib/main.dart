import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/onboardingModel.dart';
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/Model/user_location.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/splash/introViews.dart';
import 'package:thaibah/config/api.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/location_service.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

main(){

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>  {
  bool isLoading = false;
  SharedPreferences preferences;
  String id="";
   Future checkLoginStatus() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
      id = preferences.getString("id");
    });
  }
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final userRepository = UserRepository();



  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    isLoading = true;
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }


  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
            await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
              await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
            await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
              await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));

    return isLoading?CircularProgressIndicator(): StreamProvider<UserLocation>(
        builder: (context) => LocationService().locationStream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splash()
        )
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new DashboardThreePage()));
      prefs.setBool('isPin', false);
    } else {
      prefs.setBool('seen', true);
      prefs.setBool('cek', true);

      if(prefs.getBool('cek') == true){
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new IntroScreen()));
        prefs.setBool('isPin', false);
      }else{
        prefs.setBool('isPin', false);
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new DashboardThreePage()));
      }
    }
  }
  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 500), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50.0,
                        child: SvgPicture.asset(
                          'assets/images/svg/splash.svg',
                          height: ScreenUtil.getInstance().setHeight(150),
                          width: ScreenUtil.getInstance().setWidth(150),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text('Versi '+ApiService().versionCode,style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),)
                    ],
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}



class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  List<PageViewModel> wrapOnboarding = [];
  var cek = [];
  bool isLoading = false;
  var res;
  Future load() async{
    Client client = Client();
    final response = await client.get(ApiService().baseUrl+'info/onboarding');


    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      if(response.body.isNotEmpty){
        OnboardingModel onboardingModel = OnboardingModel.fromJson(jsonResponse);
        onboardingModel.result.map((Result items){
          setState(() {
            wrapOnboarding.add(PageViewModel(
              pageColor: Colors.white,
              bubbleBackgroundColor: Colors.indigo,
              title: Container(),
              body: Column(
                children: <Widget>[
                  Text(items.title,style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
                  Text(items.description,style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
              mainImage: Image.network(
                items.picture,
                width: 285.0,
                alignment: Alignment.center,
              ),
              textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
            ));
          });

        }).toList();
        setState(() {
          isLoading = false;
        });
      }
    }else {
      throw Exception('Failed to load info');
    }
  }
  @override
  void initState(){
    load();
    isLoading = true;
  }
  SharedPreferences preferences;
  Future<Null> go() async {
//    preferences = await SharedPreferences.getInstance();
//    preferences.setBool('isLogin', false);
//    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPhone(),
      ), //MaterialPageRoute
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: isLoading?Container(child: Center(child: CircularProgressIndicator(),),):Stack(
          children: <Widget>[
            IntroViewsFlutter(
              wrapOnboarding,
              onTapDoneButton: (){
                go();
              },
              showSkipButton: true,
              doneText: Text("Mulai",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              pageButtonsColor: Colors.green,
              pageButtonTextStyles: new TextStyle(
                fontSize: 16.0,
                fontFamily: "Rubik",
                fontWeight: FontWeight.bold
              ),
            ),
            Positioned(
                top: 20.0,
                left: MediaQuery.of(context).size.width/2 - 50,
                child: Image.asset('assets/images/logoOnBoardTI.png', width: 100,)
            )
          ],
        )
    );
  }
}


