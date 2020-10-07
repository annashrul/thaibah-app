import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/bloc/transferBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';

import '../home/widget_index.dart';

class DetailTransfer extends StatefulWidget {
  final String nominal;
  final String fee_charge;
  final String total_bayar;
  final String penerima;
  final String picture;
  final String referralpenerima;
  final String pesan;
  final bool statusFee;
  DetailTransfer({this.nominal,this.fee_charge,this.total_bayar,this.penerima,this.picture,this.referralpenerima,this.pesan,this.statusFee});
  @override
  _DetailTransferState createState() => _DetailTransferState();
}

class _DetailTransferState extends State<DetailTransfer> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  final userRepository = UserRepository();
  final formatter = new NumberFormat("#,###");

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
    // TODO: implement initState
    super.initState();
    loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
        appBar: UserRepository().appBarWithButton(context, "Konfirmasi Transfer",(){Navigator.pop(context);},<Widget>[]),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                statusLevel!='0'?warna1:ThaibahColour.primary1,
                statusLevel!='0'?warna2:ThaibahColour.primary2
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 3.0,
                                  offset: Offset(0, 3),
                                ),
                              ],

                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  widget.picture
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.penerima,
                                style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color: Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                              ),
                              Text(
                                widget.referralpenerima,
                                style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color: Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.sync_problem,
                                  color: Colors.white,
                                  size: ScreenUtilQ.getInstance().setHeight(60),
                                ),
                                Text(
                                  "Lanjutkan",
                                  style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),fontWeight:FontWeight.bold,color: Colors.white,fontFamily: ThaibahFont().fontQ),
                                )
                              ],
                            ),
                            onPressed: () {
                              _pinBottomSheet(context);
                            },
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 11),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(11.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(31),
                              topRight: Radius.circular(31),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[

                              Expanded(
                                child: ListView(
                                  children: <Widget>[
                                    bottomCard(Icon(Icons.input,color: Colors.white),'Nominal Transfer','Rp. '+formatter.format(int.parse(widget.nominal))),
                                    widget.statusFee == true ? bottomCard(Icon(Icons.error,color: Colors.white),'Biaya Transfer','Rp. '+formatter.format(int.parse(widget.fee_charge))):Container(),
                                    bottomCard(Icon(Icons.note,color: Colors.white),'Catatan',widget.pesan!=''?widget.pesan:'-'),
                                    Divider(),
                                    SizedBox(height: 25.0),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: 5.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Center(
                                                child: Text("SUMBER DANA YANG DIGUNAKAN DARI SALDO UTAMA ANDA",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize:ScreenUtilQ.getInstance().setSp(40),letterSpacing: 5.0),textAlign: TextAlign.center,),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )

    );
  }

  Widget bottomCard(Widget iconQ, String title, String desc){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(11),
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(15),
            color:  statusLevel!='0'?warna2:ThaibahColour.primary2,
          ),
          child: iconQ,
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Text("$title",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color: Colors.black87,fontFamily:ThaibahFont().fontQ)),
              Text("$desc",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color: Colors.black45,fontFamily:ThaibahFont().fontQ)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pinBottomSheet(context) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      UserRepository().loadingQ(context);
      var res = await transferBloc.fetchTransfer(widget.nominal, widget.referralpenerima,"");
      if(res.status=="success"){
        Navigator.pop(context);
        UserRepository().notifAlertQ(context,"success","Transaksi berhasil", "Terimakasih Telah Melakukan Transaksi", "Profile","Beranda",(){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: 'profile',)), (Route<dynamic> route) => false);
        },(){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);

        });
      }
      else{
        Navigator.pop(context);
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res.msg)));
      }
    }

  }


}
