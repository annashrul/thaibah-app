
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
  final userRepository = UserRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> row={
      "Produk":"Produk",
      "PPPOB":"PPOB"
    };
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          appBar:UserRepository().appBarWithTabButton(context,"Riwayat Pembelian", row,(){Navigator.of(context).pop();}),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                HistorySuplemen(),
                HistoryPPOB(),
              ]
          ),

        )
    );
  }

}

