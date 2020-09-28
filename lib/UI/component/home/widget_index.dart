import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/History/detailHistoryPPOB.dart';
import 'package:thaibah/UI/component/about.dart';
import 'package:thaibah/UI/component/donasi/history_donasi.dart';
import 'package:thaibah/UI/component/donasi/widget_donasi.dart';
import 'package:thaibah/UI/component/home/screen_home.dart';
import 'package:thaibah/UI/component/home/widget_artikel.dart';
import 'package:thaibah/UI/component/myProfile.dart';
import 'package:thaibah/UI/component/profile_our_business.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/UI/component/testimoni/testi.dart';
import 'package:thaibah/UI/produk_mlm_ui.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../detail_berita_ui.dart';
import '../../history_ui.dart';
import '../../jaringan_ui.dart';
import '../../loginPhone.dart';

class WidgetIndex extends StatefulWidget {
  final String param;
  WidgetIndex({this.param});
  @override
  _WidgetIndexState createState() => _WidgetIndexState();
}

class _WidgetIndexState extends State<WidgetIndex>{

  Widget currentScreen;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();
  final userRepository = UserRepository();
  int currentTab = 0;
  bool modeUpdate=false;
  void cekPath(){
    if(widget.param == 'home' || widget.param == ''){
      setState(() {
        currentTab = 0;
        currentScreen = ScreenHome();
      });
    }
    if(widget.param == 'produk'){
      setState(() {
        currentTab = 1;
        currentScreen = ProdukMlmUI();
      });
    }
    if(widget.param == 'about'){
      setState(() {
        currentTab = 2;
        currentScreen = About();
      });
    }
  }
  Future checkModeUpdate() async{
    final pin = await userRepository.getDataUser('pin');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(pin == null || pin == '') {
      setState(() {
        modeUpdate = true;
      });
      GagalHitProvider().fetchRequest('index','kondisi = DATA SQLITE KOSONG, brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
    }
  }
  Future updateApk() async{
    String url = 'https://play.google.com/store/apps/details?id=com.thaibah';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print(url);
    }
  }
  Future<Null> blockedMember() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('cek', true);
    prefs.setString('id', null);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = ScreenHome();
    cekPath();
    checkModeUpdate();
    cekPath();
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init("6a4c55fd-d96d-427f-8634-d2c4b9d96d69", iOSSettings: settings);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      var notify = notification.notification.payload.additionalData;
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
      if (notify["type"] == "feed_komentar") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSosmed(id: notify['id']),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => JaringanUI(kdReferral: '')));
      }
      if (notify["type"] == "blocked_member") {
        blockedMember();
      }
    });

  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  showNotification(String title, desc, ) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$desc', platform,payload: 'Nitish Kumar Singh is part time Youtuber');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  final List<Widget> screens = [
    ScreenHome(),
    ProdukMlmUI(),
    About(),
    Testimoni(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      key: scaffoldKey,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: currentTab == 2 ? Colors.green : Colors.white,
        child: SvgPicture.asset(
          ApiService().assetsLocal+"t.svg",
          height: ScreenUtilQ.getInstance().setHeight(50),
          width: ScreenUtilQ.getInstance().setWidth(50),
          color: currentTab == 2 ? Colors.white : Colors.green,
        ),
        onPressed: () {
          setState(() {
            currentScreen = About();// if user taps on this dashboard tab will be active
            currentTab = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ScreenHome(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 0 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Home_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Home_Abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ProdukMlmUI(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 1 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Produk_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Produk_abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // Right Tab bar icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Testimoni(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 3 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Testimoni_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Testimoni_Abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = MyProfile(); // if user taps on this dashboard tab will be active
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 4 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Profile_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Profile_abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }



}