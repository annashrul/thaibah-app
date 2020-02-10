import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/History/historyPPOB.dart';
import 'package:thaibah/UI/component/History/historySuplemen.dart';
import 'package:thaibah/UI/component/History/historyTanah.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/style.dart';



class IndexHistory extends StatefulWidget {
  @override
  _IndexHistoryState createState() => _IndexHistoryState();
}

class _IndexHistoryState extends State<IndexHistory> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace,color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: false,
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
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text('Riwayat Pembelian', style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 2,
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color:Colors.white, fontFamily: 'Rubik',fontSize: 16),
                  tabs: <Widget>[
                    Tab(text: "Produk"),
//                    Tab(text: "Tanah",),
                    Tab(text: "PPOB"),
                  ]
              ),
            ),
            body: TabBarView(
                children: <Widget>[

                  HistorySuplemen(),
//                  HistoryTanah(),
                  HistoryPPOB(),
                ]
            ),

          )
      ),
    );
  }

}

