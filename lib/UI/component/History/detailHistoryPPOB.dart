import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thaibah/Model/detailHistoryPPOBModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/resources/historyPembelianProvider.dart';

class DetailHistoryPPOB extends StatefulWidget {
  final String kdTrx;
  DetailHistoryPPOB({this.kdTrx});
  @override
  _DetailHistoryPPOBState createState() => _DetailHistoryPPOBState();
}

class _DetailHistoryPPOBState extends State<DetailHistoryPPOB> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future cek() async{
    var res = await HistoryPembelianProvider().fetchDetailHistoryPPOB(widget.kdTrx);

  }

  Timer _timer;
  _callBackPins(BuildContext context,bool isTrue) async{
    if(isTrue){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!"),
            content: new Text("Masukan pin yang sesuai."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  void _initializeTimer() {
    _timer = Timer.periodic(Duration(seconds:ApiService().timerActivity), (Timer t) => _logOutUser());
    print(_timer);
  }
  void _logOutUser()  {
    print('logout');
    _timer.cancel();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (BuildContext context) => PinScreen(callback: _callBackPins)
    ), (Route<dynamic> route) => false);
    print("############################ EWEH AKTIFITAS KUDU NGABUSKEUN PIN  ########################");
  }
  void _handleUserInteraction([_]) {
    if (!_timer.isActive) {
      print('_handleUserInteraction');
      return;
    }
    print(_timer.isActive);
    _timer.cancel();
    _initializeTimer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeTimer();
  }

  @override
  Widget build(BuildContext context) {
    detailHistoryPPPOBBloc.fetchDetailHistoryPPOBList(widget.kdTrx);
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
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
            centerTitle: true,
            title: Text("Detail History PPOB",style: TextStyle(fontSize:12.0,color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
          ),
          body: Column(
            children: <Widget>[
              StreamBuilder(
                  stream: detailHistoryPPPOBBloc.getResult,
                  builder: (context,AsyncSnapshot<DetailHistoryPpobModel> snapshot){
                    return snapshot.hasData ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          accountItems("Produk",20.0,snapshot.data.result.produk,oddColour:Color(0xFFF7F7F9)),
                          accountItems("Target",20.0,snapshot.data.result.target,oddColour:Colors.white),
                          accountItems("Mtrpln",20.0,snapshot.data.result.mtrpln,oddColour:Color(0xFFF7F7F9)),
                          accountItems("Token",20.0,snapshot.data.result.token,oddColour:Colors.white),
                          accountItems("Note",20.0,snapshot.data.result.note,oddColour:Color(0xFFF7F7F9)),
                        ],
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(color: Colors.white),
                            width: width/1,
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
                            child: Column(
                              children: <Widget>[
                                ListView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  itemBuilder: (context,i){
                                    return Row(
                                      children: <Widget>[
                                        SkeletonFrame(width: 100,height: 16),
                                        SizedBox(height:20.0),
                                        SizedBox(height:20.0),
                                        SizedBox(height:20.0),
                                        SkeletonFrame(width: 50,height: 16)
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
              )
            ],
          )
      ),
    );
  }


  Widget accountItems(String key, double ukuran, String val,{Color oddColour = Colors.white} ){
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(color: oddColour),
      width: width/1,
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(key, style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              SizedBox(height:ukuran),
              Text(
                val,
                style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ],
      ),
    );
  }
}
