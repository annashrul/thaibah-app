import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thaibah/UI/component/History/historyBonus.dart';
import 'package:thaibah/UI/component/History/historyMain.dart';
import 'package:thaibah/config/style.dart';


class HistoryUI extends StatefulWidget {
  final String page;
  HistoryUI({this.page});

  @override
  _HistoryUIState createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: false,
              elevation: 0.0,
              title: Text('Riwayat Transkasi',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xFF116240),
                      Color(0xFF30cc23)
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 2,
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Styles.primaryColor, fontFamily: 'Rubik',fontSize: 16),
                  tabs: <Widget>[
                    Tab(text: "Transaksi",),
                    Tab(text: "Bonus"),
                  ]
              ),
            ),
            body: TabBarView(
                children: <Widget>[
                  HistoryMain(),
                  HistoryBonus(),
                ]
            ),

          )
      ),
    );
  }

}


