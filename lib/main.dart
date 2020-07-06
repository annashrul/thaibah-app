import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/onboardingModel.dart' as Prefix2;
import 'package:thaibah/Model/pageViewModel.dart';
import 'package:thaibah/Model/user_location.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/splash/introViews.dart';
import 'package:thaibah/config/api.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/configProvider.dart' as Prefix1;
import 'package:thaibah/resources/location_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:thaibah/config/user_repo.dart';

import 'Constants/constants.dart';
import 'Model/checkerModel.dart';
import 'UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'UI/Widgets/pin_screen.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>  {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));

    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:  Splash(),

        )
    );
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
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
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



  Future checkFirstSeen() async {
    final checker = await Prefix1.ConfigProvider().cekVersion();
    final userRepository = UserRepository();
    final statusOnBoarding = await userRepository.getDataUser('statusOnBoarding');
    final statusLogin = await userRepository.getDataUser('status');
    final statusExitApp = await userRepository.getDataUser('statusExitApp');
    print("STATUS LOGIN = $statusLogin");
    print("STATUS ON BOARDING = $statusOnBoarding");
    print("STATUS EXIT APP = $statusExitApp");
    if(checker is Checker){
      setState(() {isLoading=false;});
      print("####################### CHECKING STATUS CHECKER ${checker.status} ################################");
      if(checker.status == 'success'){
        print("####################### SERVER VERSI ${checker.result.versionCode} & LOCAL VERSI ${ApiService().versionCode} ################################");
        if(checker.result.versionCode != ApiService().versionCode){
          print("####################### CHECKING VERSION COIDE ################################");
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              new CupertinoPageRoute(builder: (BuildContext context)=>UpdatePage()), (Route<dynamic> route) => false
          );
        }else if(checker.result.statusMember == 0){
          print("####################### CHECKING STATUS MEMBER ${checker.result.statusMember} ################################");
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              new CupertinoPageRoute(builder: (BuildContext context)=>LoginPhone()), (Route<dynamic> route) => false
          );
        }else{
          if(statusExitApp == '0'){
            setState(() {isLoading=false;});
            print("####################### CHECKING EXIT APP ################################");
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                new CupertinoPageRoute(builder: (BuildContext context)=>PinScreen(callback: _callBackPin)), (Route<dynamic> route) => false
            );
          }else{
            if(statusExitApp == '0'){
              setState(() {isLoading=false;});
              print("####################### CHECKING EXIT APP ################################");
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  new CupertinoPageRoute(builder: (BuildContext context)=>PinScreen(callback: _callBackPin)), (Route<dynamic> route) => false
              );
            }
            else{
              if(statusOnBoarding == ''||statusOnBoarding=='0'){
                setState(() {isLoading=false;});
                print("####################### CHECKING STATUS ONBOARDING ################################");
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    new CupertinoPageRoute(builder: (context) => IntroScreen())
                );
              }else{
                if(statusLogin=='1'||statusLogin!='0'){
                  setState(() {isLoading=false;});
                  print("####################### CHECKING STATUS LOGIN ################################");
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      new CupertinoPageRoute(builder: (context) => DashboardThreePage())
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
        }
      }
      else{
        if(statusExitApp == '0'){
          setState(() {isLoading=false;});
          print("####################### CHECKING EXIT APP ################################");
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              new CupertinoPageRoute(builder: (BuildContext context)=>PinScreen(callback: _callBackPin)), (Route<dynamic> route) => false
          );
        }
        else{
          if(statusOnBoarding == ''||statusOnBoarding=='0'){
            setState(() {isLoading=false;});
            print("####################### CHECKING STATUS ONBOARDING ################################");
            Navigator.of(context, rootNavigator: true).pushReplacement(
                new CupertinoPageRoute(builder: (context) => IntroScreen())
            );
          }else{
            if(statusLogin=='1'||statusLogin!='0'){
              setState(() {isLoading=false;});
              print("####################### CHECKING STATUS LOGIN ################################");
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  new CupertinoPageRoute(builder: (context) => DashboardThreePage())
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
    }
    else{
      setState(() {isLoading=false;});
      print("####################### ELSE CHECKER ################################");
      print(checker);
      if(statusExitApp == '0'){
        setState(() {isLoading=false;});
        print("####################### CHECKING EXIT APP ################################");
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          new CupertinoPageRoute(builder: (BuildContext context)=>PinScreen(callback: _callBackPin)), (Route<dynamic> route) => false
        );
      }
      else{
        if(statusOnBoarding == ''||statusOnBoarding=='0'){
          setState(() {isLoading=false;});
          print("####################### CHECKING STATUS ONBOARDING ################################");
          Navigator.of(context, rootNavigator: true).pushReplacement(
              new CupertinoPageRoute(builder: (context) => IntroScreen())
          );
        }else{
          if(statusLogin=='1'||statusLogin!='0'){
            setState(() {isLoading=false;});
            print("####################### CHECKING STATUS LOGIN ################################");
            Navigator.of(context, rootNavigator: true).pushReplacement(
                new CupertinoPageRoute(builder: (context) => DashboardThreePage())
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
//
//    setState(() {isLoading=false;});
//    Navigator.of(context, rootNavigator: true).pushReplacement(
//      new CupertinoPageRoute(builder: (context) => DashboardThreePage())
//    );

  }

  @override
  void initState() {
    super.initState();
    isLoading=true;
    checkFirstSeen();
//    new Timer(new Duration(milliseconds: 100), () {
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
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
                        child: isLoading?CircularProgressIndicator(strokeWidth: 10):SvgPicture.asset(
                          'assets/images/svg/splash.svg',
                          height: ScreenUtilQ.getInstance().setHeight(150),
                          width: ScreenUtilQ.getInstance().setWidth(150),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text('Pengecekan Versi ...',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),)
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
        Prefix2.OnboardingModel onboardingModel = Prefix2.OnboardingModel.fromJson(jsonResponse);
        onboardingModel.result.map((Prefix2.Result items){
          setState(() {
            wrapOnboarding.add(PageViewModel(
              pageColor: Colors.white,
              bubbleBackgroundColor: Colors.indigo,
              title: Container(),
              body: Column(
                children: <Widget>[
                  Text(items.title,style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Color(0xFF116240),fontWeight: FontWeight.bold)),
                  Text(items.description,style: TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
    print(wrapOnboarding);
    return new Scaffold(
        body: isLoading?Container(child: Center(child: CircularProgressIndicator(),),):wrapOnboarding!=[]?Stack(
          children: <Widget>[
            IntroViewsFlutter(
              wrapOnboarding,
              onTapDoneButton: (){
                go();
              },
              showSkipButton: true,
              doneText: Text("MULAI",style: TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
              pageButtonsColor: Colors.green,
              pageButtonTextStyles: new TextStyle(
                fontSize: 16.0,
                fontFamily:ThaibahFont().fontQ,
                fontWeight: FontWeight.bold
              ),
            ),
            Positioned(
                top: 20.0,
                left: MediaQuery.of(context).size.width/2 - 50,
                child: Image.asset('assets/images/logoOnBoardTI.png', width: 100,)
            )
          ],
        ):Text('Data Tidak Tersedia')
    );
  }
}


