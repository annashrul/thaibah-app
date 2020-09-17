import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';
import 'component/History/widgetHistorySaldo.dart';


class HistoryUI extends StatefulWidget {
  final String page;
  HistoryUI({this.page});

  @override
  _HistoryUIState createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> with AutomaticKeepAliveClientMixin {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
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
    // TODO: implement initState
    super.initState();
    loadTheme();

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    Map<String, dynamic> row = {
      'Utama':'Utama',
      'Bonus':'Bonus',
      'Voucher':'Voucher',
      'Platinum':'Platinum'
    };
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 4,
          child: Scaffold(
            key: scaffoldKey,
            appBar: UserRepository().appBarWithTabButton(context, 'Riwayat Transaksi', warna1, warna2,row,(){
              Navigator.of(context).pop();
            }),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  WidgetHistorySaldo(label: 'master'),
                  WidgetHistorySaldo(label: 'bonus'),
                  WidgetHistorySaldo(label: 'voucher'),
                  WidgetHistorySaldo(label: 'platinum'),
                  // HistoryMain(),
                  // HistoryBonus(),
                  // HistoryVoucher(),
                  // HistoryPlatinum(),
                ]
            ),

          )
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}


