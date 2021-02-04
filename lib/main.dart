import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/Model/checkerModel.dart';
import 'package:thaibah/Model/onboardingModel.dart' as Prefix2;
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/Model/user_location.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/onboarding/introViews.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/updatePage.dart';
import 'package:thaibah/UI/component/auth/loginPhone.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'package:thaibah/config/api.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:thaibah/resources/location_service.dart';

void main() async {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  final dbHelper = DbHelper.instance;
  final serviceLocation = LocationService();
  double lat,lng;

  loadLocation()async{
    print("LATITUDE $lat");
  }
  @override
  void initState() {
    super.initState();
    loadLocation();
    serviceLocation.locationStream.listen((event) {
      if(mounted){
        setState(() {
          lat = event.latitude;
          lng = event.longitude;
        });
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Timer _timer;
  @override

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    initializeDateFormatting('id');
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: WillPopScope(
          child: MaterialApp(
            color: Colors.white,
            debugShowCheckedModeBanner: false,
            home:  Splash(),
          ),
          onWillPop: _onWillPop
        )
    );
  }
  Future<bool> _onWillPop() async {
    return (
        UserRepository().notifAlertQ(context, "info ", "Keluar", "Kamu yakin akan keluar dari aplikasi ?", "Ya", "Batal", ()=>SystemNavigator.pop(), ()=>Navigator.of(context).pop(false))
    ) ?? false;
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  bool isLoading = false;
  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!",style:TextStyle(fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
            content: new Text("Masukan pin yang sesuai.",style:TextStyle(fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close",style:TextStyle(fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  String label='versi';

  Future checkFirstSeen() async {
    final checkVersion = await ConfigProvider().cekVersion();
//    final checker = await ConfigProvider().cekVersion();
    final userRepository = UserRepository();
    final statusOnBoarding = await userRepository.getDataUser('statusOnBoarding');
    final statusLogin = await userRepository.getDataUser('status');
    final statusExitApp = await userRepository.getDataUser('statusExitApp');
    // final lat = await userRepository.getDataUser('latitude');
    // print("LATITUDE LOCAL DB $lat");
    if(checkVersion is Checker){
      Checker checker = checkVersion;
      setState(() {isLoading=false;});
      if(checker.status == 'success'){
        setState(() {
          label='Konfigurasi';
        });
        if(checker.result.versionCode != ApiService().versionCode){
          setState(() {
            label='version code';
          });
          print("####################### CHECKING VERSION CODE ${checker.result.versionCode} ################################");
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              new CupertinoPageRoute(builder: (BuildContext context)=>UpdatePage()), (Route<dynamic> route) => false
          );
        }
        else{
          if(statusOnBoarding == ''||statusOnBoarding=='0'){
            setState(() {
              label='on boarding';
            });
            setState(() {isLoading=false;});
            Navigator.of(context, rootNavigator: true).pushReplacement(
                new CupertinoPageRoute(builder: (context) => IntroScreen())
              // new CupertinoPageRoute(builder: (context) => WidgetIndex())
            );
          }else{
            setState(() {
              label='status User';
            });
            if(statusLogin=='1'){
              setState(() {isLoading=false;});
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  new CupertinoPageRoute(builder: (BuildContext context)=>PinScreen(callback: _callBackPin)), (Route<dynamic> route) => false
              );
            }else{
              setState(() {isLoading=false;});
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  new CupertinoPageRoute(builder: (context) => LoginPhone())
              );
            }
          }
        }
      }
      else{
        if(statusOnBoarding == ''||statusOnBoarding=='0'){
          setState(() {isLoading=false;});
          setState(() {
            label='on boarding';
          });
          Navigator.of(context, rootNavigator: true).pushReplacement(
              new CupertinoPageRoute(builder: (context) => IntroScreen())
          );
        }else{
          setState(() {
            label='status User';
          });
          if(statusLogin=='1'){
            setState(() {isLoading=false;});
            Navigator.of(context, rootNavigator: true).pushReplacement(
                new CupertinoPageRoute(builder: (context) => WidgetIndex())
              // new CupertinoPageRoute(builder: (context) => DashboardThreePage())
            );
          }else{
            setState(() {isLoading=false;});
            Navigator.of(context, rootNavigator: true).pushReplacement(
                new CupertinoPageRoute(builder: (context) => LoginPhone())
            );
          }
        }
      }
    }
    else{
      setState(() {isLoading=false;});
      print(checkVersion);
      if(statusOnBoarding == ''||statusOnBoarding=='0'){
        setState(() {isLoading=false;});
        Navigator.of(context, rootNavigator: true).pushReplacement(
            new CupertinoPageRoute(builder: (context) => IntroScreen())
        );
      }
      else{
        if(statusLogin=='1'){
          setState(() {isLoading=false;});
          Navigator.of(context, rootNavigator: true).pushReplacement(
              new CupertinoPageRoute(builder: (context) => WidgetIndex(param: '',))
          );
        }else{
          setState(() {isLoading=false;});
          Navigator.of(context, rootNavigator: true).pushReplacement(
              new CupertinoPageRoute(builder: (context) => LoginPhone())
          );
        }
      }
    }
  }
  final serviceLocation = LocationService();
  double lat,lng;
  @override
  void initState() {
    super.initState();
    isLoading=true;
    checkFirstSeen();
    serviceLocation.locationStream.listen((event) {
      if(mounted){
        setState(() {
          lat = event.latitude;
          lng = event.longitude;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      body: UserRepository().loadingWidget(),
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
        Prefix2.OnboardingModel onboardingModel = Prefix2.OnboardingModel.fromJson(jsonResponse);
        if(onboardingModel.result.length != 0){
          onboardingModel.result.map((Prefix2.Result items){
            setState(() {
              wrapOnboarding.add(PageViewModel(
                pageColor: Colors.white,
                bubbleBackgroundColor: Colors.indigo,
                title: Container(),
                body: Column(
                  children: <Widget>[
                    Text(items.title,style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color: Color(0xFF116240),fontWeight: FontWeight.bold)),
                    Text(items.description,style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                  ],
                ),
                mainImage: Image.network(
                  items.picture,
                  width: 285.0,
                  alignment: Alignment.center,
                ),
                textStyle: TextStyle(color: Colors.black,fontFamily:ThaibahFont().fontQ,),
              ));
            });

          }).toList();
          setState(() {
            isLoading = false;
          });
        }
        else{
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => LoginPhone(),
            ), //MaterialPageRoute
          );
        }

      }
      else{
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => LoginPhone(),
          ), //MaterialPageRoute
        );
      }
    }else {
      throw Exception('Failed to load info');
    }
  }

  SharedPreferences preferences;
  Future<Null> go() async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) => LoginPhone(),
      ), //MaterialPageRoute
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: isLoading?Container(child: Center(child: CircularProgressIndicator(),),):wrapOnboarding!=[]?Stack(
          children: <Widget>[
            IntroViewsFlutter(
              wrapOnboarding,
              onTapDoneButton: (){
                go();
              },
              showSkipButton: true,
              doneText: Text("MULAI",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
              pageButtonsColor: Colors.green,
              pageButtonTextStyles: new TextStyle(
                fontSize: ScreenUtilQ.getInstance().setSp(30),
                fontFamily:ThaibahFont().fontQ,
                fontWeight: FontWeight.bold
              ),
            ),
            Positioned(
                top: 20.0,
                left: MediaQuery.of(context).size.width/2 - 50,
                // child: Image.asset('assets/images/logoOnBoardTI.png', width: 100,)
                child: Image.asset('assets/images/logoOnBoardTI.png', width: 100,)
            )
          ],
        ):Text('Data Tidak Tersedia')
    );
  }
}






