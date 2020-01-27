import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/UI/Homepage/beranda.dart';
import 'package:thaibah/UI/component/History/detailHistoryPPOB.dart';
import 'package:thaibah/UI/component/about.dart';
import 'package:thaibah/UI/component/testimoni/testi.dart';
import 'package:thaibah/UI/detail_berita_ui.dart';
import 'package:thaibah/UI/history_ui.dart';
import 'package:thaibah/UI/jaringan_ui.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/produk_mlm_ui.dart';
import 'package:thaibah/UI/profile_ui.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;



class DashboardThreePage extends StatefulWidget {
  @override
  _DashboardThreePageState createState() => _DashboardThreePageState();
}

class _DashboardThreePageState extends State<DashboardThreePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  final TextStyle whiteText = TextStyle(color: Colors.white);
  final userRepository = UserRepository();
  SharedPreferences preferences;
  String id="", kdReferral='';
  bool showAlignmentCards = false;
  bool isLoading = false;
  bool isLoading2 = false;

  String versionCode = '';
  Future cekVersion() async {
    var res = await ConfigProvider().cekVersion();
    if(res is Info){
      Info results = res;
      versionCode = results.result.versionCode;
    }
  }


//  String versionCode = '';
//
//  Future<void> cekVersion() async {
//    String id = await userRepository.getID();
//    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
//    if (jsonString.statusCode == 200) {
//      final jsonResponse = json.decode(jsonString.body);
//      Info response = new Info.fromJson(jsonResponse);
//      print("##################################### INFO ${response.result.versionCode} #################################################");
//      versionCode = (response.result.versionCode);
//      if(versionCode == ApiService().versionCode){
//        setState(() {
//          isLoading = true;
//        });
//      }
//
//
//    } else {
//      throw Exception('Failed to load info');
//    }
//  }

  Future<Null> checkLoginStatus() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      id    = preferences.getString("id");
      kdReferral = preferences.getString('kd_referral');
    });
    if(id == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
    }

  }


  Future<Null> blockedMember() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('cek', true);
    prefs.setString('id', null);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
  }

  Location location = Location();

//  Map<String, double> latitude;
//  Map<String, double> longitude;

  String latitude = '';
  String longitude = '';


  @override
  void initState(){
    cekVersion();
    location.onLocationChanged().listen((value) {
      if(mounted){
        setState(() {
          latitude = value.latitude.toString();
          longitude = value.longitude.toString();
        });
      }
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
//    cek();
    checkLoginStatus();
    isLoading = true;
    isLoading2 = true;

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init("6a4c55fd-d96d-427f-8634-d2c4b9d96d69", iOSSettings: settings);
//    OneSignal.shared.init("1077af68-aaa7-45e8-8f03-ec720d1a97e2", iOSSettings: settings);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      var notify = notification.notification.payload.additionalData;
      print("################################################################################");
      print(notify);
      print("################################################################################");
      if (notify["type"] == "berita") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBeritaUI(id: notify['id'],category: notify['category'])));
      }
      if (notify["type"] == "transaksi_bonus") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "transaksi_suplemen") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "transaksi_tanah") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "transaksi_ppob") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailHistoryPPOB(kdTrx: notify['id']),
          ),
        );
      }
      if (notify["type"] == "UPDATE_APK") {
        updateApk();
      }
      if (notify["type"] == "transaksi_saldo") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "member") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral)));
      }
      if (notify["type"] == "blocked_member") {
        blockedMember();
      }
      if(notify['type'] == 'adzan'){
        play();
      }

    });


  }


  Future updateApk() async{
    String url = 'https://play.google.com/store/apps/details?id=com.thaibah';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print(url);
    }
  }

  Future play() async{
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play('https://thaibah.com/assets/adzan_.mp3');

  }

  @override
  void dispose() {
    indexcontroller.close();
    super.dispose();

  }
  PageController pageController = PageController(initialPage: 0);
  StreamController<int> indexcontroller = StreamController<int>.broadcast();
  int index = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Tekan Kembali Untuk Keluar',style:TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPin', true);
//    var cek = prefs.setBool('isPin', true);
    print("################################# KALUAR APLIKASI ${prefs.getBool('isPin')} ##############################");
    return true;
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return latitude == null || longitude == null ? CircularProgressIndicator() :Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
//      body: UpdatePage(),
      body: Container(
        color: const Color(0xffF4F7FA),
        child: WillPopScope(
          onWillPop: onWillPop,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              indexcontroller.add(index);
            },
            controller: pageController,
            children: <Widget>[
              Beranda(lat:latitude,lng:longitude),
              ProdukMlmUI(),
              About(),
              Testimoni(),
              ProfileUI(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: StreamBuilder<Object>(
          initialData: 0,
          stream: indexcontroller.stream,
          builder: (context, snapshot) {
            int cIndex = snapshot.data;
            return FancyBottomNavigation(
              currentIndex: cIndex,
              items: <FancyBottomNavigationItem>[
                FancyBottomNavigationItem(icon: Icon(Icons.home), title: Text('Home',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),),
                FancyBottomNavigationItem(icon: Icon(Icons.shopping_basket), title: Text('Produk',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
                FancyBottomNavigationItem(icon: Icon(Icons.account_balance), title: Text('Tentang',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
                FancyBottomNavigationItem(icon: Icon(Icons.videocam), title: Text('Testimoni',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),),
                FancyBottomNavigationItem(icon: Icon(Icons.account_circle), title: Text('Profile',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
              ],
              onItemSelected: (int value) {
                indexcontroller.add(value);
                Future.delayed(Duration(milliseconds: 100), () {
                  pageController.jumpToPage(value);
                });
//              pageController.jumpToPage(value);
              },
            );
          }
      ),
    );
  }
}


class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Tekan Kembali Untuk Keluar',style:TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
    String url = 'https://play.google.com/store/apps/details?id=com.thaibah';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print(url);
    }
  }
  Future cekStatusLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('id') == null || prefs.getString('id') == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekStatusLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: WillPopScope(
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
                    child: Text("Silahkan Perbaharui Aplikasi Anda Ke Versi ${ApiService().versionCode} !!".toUpperCase(), style:TextStyle(color:Colors.red,fontSize:14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  child: Center(
                    child: Text("Tekan Tombol Dibawah Ini Untuk Memperbaharui Aplikasi ...".toUpperCase(), style:TextStyle(color:Colors.red,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
                        style: TextStyle(
                          fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold
                        ),
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


class FancyBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final List<FancyBottomNavigationItem> items;
  final ValueChanged<int> onItemSelected;

  FancyBottomNavigation(
      {Key key,
        this.currentIndex = 0,
        this.iconSize = 24,
        this.activeColor,
        this.inactiveColor,
        this.backgroundColor,
        @required this.items,
        @required this.onItemSelected}) {
    assert(items != null);
    assert(onItemSelected != null);
  }

  @override
  _FancyBottomNavigationState createState() {
    return _FancyBottomNavigationState(
        items: items,
        backgroundColor: backgroundColor,
        currentIndex: currentIndex,
        iconSize: iconSize,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onItemSelected: onItemSelected);
  }
}

class _FancyBottomNavigationState extends State<FancyBottomNavigation> {
  final int currentIndex;
  final double iconSize;
  Color activeColor;
  Color inactiveColor;
  Color backgroundColor;
  List<FancyBottomNavigationItem> items;
  int _selectedIndex;
  ValueChanged<int> onItemSelected;

  _FancyBottomNavigationState(
      {@required this.items,
        this.currentIndex,
        this.activeColor,
        this.inactiveColor = Colors.black,
        this.backgroundColor,
        this.iconSize,
        @required this.onItemSelected}) {
    _selectedIndex = currentIndex;
  }

  Widget _buildItem(FancyBottomNavigationItem item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected ? 100 : 50,
      height: double.maxFinite,
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        color: activeColor,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: IconThemeData(
                      size: iconSize,
                      color: isSelected ? backgroundColor : inactiveColor),
                  child: item.icon,
                ),
              ),
              isSelected
                  ? DefaultTextStyle.merge(
                style: TextStyle(color: backgroundColor),
                child: item.title,
              )
                  : SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeColor = (activeColor == null) ? Theme.of(context).accentColor : activeColor;
    backgroundColor = (backgroundColor == null) ? Theme.of(context).bottomAppBarColor : backgroundColor;
    return Container(
      width: MediaQuery.of(context).size.width/2,
      height: 56,
      padding: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [BoxShadow(color: Colors.green, blurRadius: 2)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          var index = items.indexOf(item);
          return GestureDetector(
            onTap: () {
              onItemSelected(index);
              setState(() {
                _selectedIndex = index;
              });
            },
            child: _buildItem(item, _selectedIndex == index),
          );
        }).toList(),
      ),
    );
  }
}

class FancyBottomNavigationItem {
  final Widget icon;
  final Text title;

  FancyBottomNavigationItem({
    @required this.icon,
    @required this.title,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}

