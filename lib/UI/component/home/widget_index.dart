import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/user_location.dart';
import 'package:thaibah/UI/Homepage/beranda.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/home/screen_home.dart';
import 'package:thaibah/UI/component/home/widget_top_slider.dart';
import 'package:thaibah/UI/component/sosmed/listSosmed.dart';
import 'package:thaibah/UI/component/testimoni/testi.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../produk_mlm_ui.dart';
import '../about.dart';
import '../myProfile.dart';

class WidgetIndex extends StatefulWidget {
  @override
  _WidgetIndexState createState() => _WidgetIndexState();
}

class _WidgetIndexState extends State<WidgetIndex> {
  int currentTab = 0;
  Widget currentScreen;

  final PageStorageBucket bucket = PageStorageBucket();
  // Widget currentScreen =  ScreenHome();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = ScreenHome();

  }
  final List<Widget> screens = [
    ScreenHome(),
    ProdukMlmUI(),
    About(),
    Testimoni(),
    MyProfile(),

  ]; // to store nested tabs
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white, // status bar color
              brightness: Brightness.light,
              title:ListTile(
                contentPadding: EdgeInsets.only(top:10,bottom:10),
                title: InkWell(
                  onTap:(){},
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey[400]
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: UserRepository().textQ("Cari Amal Terbaikmu disini ...",12,Colors.grey,FontWeight.bold,TextAlign.left)
                  ),
                ),
                leading: CircleAvatar(
                    radius:20.0,
                    backgroundImage: AssetImage('assets/images/logoOnBoardTI.png')
                ),

              ),// status bar brightness
            ),
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

          ),


        )
    );


  }



}
