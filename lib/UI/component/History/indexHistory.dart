
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/component/History/historyPPOB.dart';
import 'package:thaibah/UI/component/History/historySuplemen.dart';
import 'package:thaibah/config/user_repo.dart';



class IndexHistory extends StatefulWidget {
  @override
  _IndexHistoryState createState() => _IndexHistoryState();
}

class _IndexHistoryState extends State<IndexHistory> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
    Map<String,dynamic> row={
      "Produk":"Produk",
      "PPPOB":"PPOB"
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar:UserRepository().appBarWithTabButton(context,"Riwayat Pembelian",warna1,warna2, row,(){Navigator.of(context).pop();}),
            body: TabBarView(
                children: <Widget>[
                  HistorySuplemen(),
                  HistoryPPOB(),
                ]
            ),

          )
      ),
    );
  }

}

