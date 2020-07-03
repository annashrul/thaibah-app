import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/bloc/transferBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          subhead: TextStyle(color: Colors.white54),
          body1: TextStyle(color: Colors.white54),
          subtitle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          title: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
            appBar: UserRepository().appBarWithButton(context,'Konfirmasi Transfer', warna1, warna2,(){
              Navigator.of(context).pop();
            }, Container()),
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
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                                  ),
                                  Text(
                                    widget.referralpenerima,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: 5),

                        SizedBox(height: 11),
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
                                    ),
                                    Text(
                                      "Lanjutkan",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                onPressed: () {

                                  print('tap');
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
                                                    child: Text("SUMBER DANA YANG DIGUNAKAN DARI SALDO UTAMA ANDA",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize: 20.0,letterSpacing: 5.0),textAlign: TextAlign.center,),
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

        ),
      ),
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
              Text("$title",style: TextStyle(color: Colors.black87,fontFamily:ThaibahFont().fontQ)),
              Text("$desc",style: TextStyle(color: Colors.black45,fontFamily:ThaibahFont().fontQ)),
            ],
          ),
        ),
      ],
    );
  }


  Widget detail(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: new Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Konfirmasi Transfer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              ),
              Divider(),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.picture,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                      ),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(children: <Widget>[
                    Text(widget.penerima),
                    Text(widget.referralpenerima),
                  ],)
                ],),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Sumber"),
                  Text("SALDO UTAMA"),
                ],),
              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Pesan"),
                  Text("${widget.pesan!=''?widget.pesan:'-'}"),
                ],),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text("Nominal Transfer"),
                          Text("Biaya Transfer"),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Text(formatter.format(int.parse(widget.nominal))),
                          Text(formatter.format(int.parse(widget.fee_charge))),
                        ],
                      )
                  )
                ],),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButton(context){
    return Container(
      height: kBottomNavigationBarHeight,
      child: RaisedButton(
        color: Styles.primaryColor,
        onPressed: (){
          _pinBottomSheet(context);
        },
        child: Text("Bayar", style: TextStyle(color: Colors.white)))
    );
  }

  Future<void> _pinBottomSheet(context) async {
//    showDialog(
//        context: context,
//        builder: (BuildContext bc){
//          return PinScreen(callback: _callBackPin);
//        }
//    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: LinearProgressIndicator(),
            );
          },
        );

      });
      var res = await transferBloc.fetchTransfer(widget.nominal, widget.referralpenerima,"");

      if(res.status=="success"){
        setState(() {
          Navigator.pop(context);
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialogQ(
                alertTitle: richTitle("Transaksi Berhasil"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            }
        );
      }else{
        setState(() {
          Navigator.pop(context);
        });
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res.msg)));
      }
    }else{
      setState(() {
        Navigator.pop(context);
      });
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                    DetailTransfer(
                        nominal: widget.nominal,
                        fee_charge: widget.fee_charge,
                        total_bayar: widget.total_bayar,
                        penerima: widget.penerima,
                        picture: widget.picture,
                        referralpenerima: widget.referralpenerima,
                        pesan:widget.pesan
                    )
                  ), (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        },
      );
    }
  }


}
