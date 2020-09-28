import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:provider/provider.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/Model/tertimoniModel.dart'  as Prefix1;
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/component/testimoni/testiKavling.dart';
import 'package:thaibah/UI/component/testimoni/testiSuplemen.dart';
import 'package:thaibah/bloc/categoryBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/config/api.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'dart:async';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../detailInspirasi.dart';

class Testimoni extends StatefulWidget {
  @override
  _TestimoniState createState() => _TestimoniState();
}

class _TestimoniState extends State<Testimoni> with SingleTickerProviderStateMixin  {
  int currentPos;
  String stateText;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  Color warna1;
  Color warna2;
  String statusLevel ='0';
  Future loadTheme() async{
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
      statusLevel = levelStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTheme();

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Map<String, dynamic> row = {
      'Produk':'Produk',
      'Bisnis':'Bisnis',
    };
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: UserRepository().appBarWithTab(context, 'Testimoni',row),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  TestiSuplemen(),
//                  IndexTesti(),
                  TestiKavling(),
                ]
            ),
          )
      ),
    );
  }

}
