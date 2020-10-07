import 'package:flutter/material.dart';
import 'file:///E:/THAIBAH/mobile/thaibah-app/lib/UI/component/History/widgetHistoryTransaksi.dart';
import 'package:thaibah/config/user_repo.dart';

class MainHistoryTransaksi extends StatefulWidget {
  final String page;
  MainHistoryTransaksi({this.page});
  @override
  _MainHistoryTransaksiState createState() => _MainHistoryTransaksiState();
}

class _MainHistoryTransaksiState extends State<MainHistoryTransaksi> with AutomaticKeepAliveClientMixin{
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
    super.build(context);
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
            appBar: UserRepository().appBarWithTabButton(context, 'Riwayat Transaksi',row,(){
              Navigator.of(context).pop();
            }),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  WidgetHistoryTransaksi(label: 'master'),
                  WidgetHistoryTransaksi(label: 'bonus'),
                  WidgetHistoryTransaksi(label: 'voucher'),
                  WidgetHistoryTransaksi(label: 'platinum'),
                ]
            ),

          )
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
