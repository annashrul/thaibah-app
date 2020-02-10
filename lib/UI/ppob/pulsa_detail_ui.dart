

import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/checkoutPPOBModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/bloc/PPOB/PPOBPraBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';


class DetailPulsaUI extends StatefulWidget {
  DetailPulsaUI({this.param,this.cmd,this.no,this.code,this.provider,this.nominal,this.price,this.note,this.imgUrl, this.fee_charge,this.raw_price});
  final String param;
  final String cmd;
  final String no;
  final String code;
  final String provider;
  final String nominal;
  final String price;
  final String note;
  final String imgUrl;
  final String fee_charge;
  final String raw_price;
  @override
  _DetailPulsaUIState createState() => _DetailPulsaUIState();
}

class _DetailPulsaUIState extends State<DetailPulsaUI> with SingleTickerProviderStateMixin{
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final userRepository = UserRepository();
  TabController _controller;
  double _height;
  double _width;

  bool _apiCall = false;
  
  bool isStarted = false;
  var sub;
  String countDownText = "00:00:10";
  String pin = "";
  String idpelanggan = "";
  cekPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pin = prefs.getString("pin").toString();
      if(widget.cmd == 'TOKEN'){
        idpelanggan = prefs.getString("idpelanggan");
      }else{
        idpelanggan = '';
      }

    });
    print("ID PELANGGAN ADALAH "+idpelanggan);
  }
  bool _isLoading = false;



  @override
  initState(){
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    cekPin();
  }



  @override
  Widget build(BuildContext context) {
    // getPin();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: ()=>Navigator.of(context).pop(),
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
          elevation: 1.0,
          automaticallyImplyLeading: true,
          title: new Text("Detail Pembelian ${widget.cmd.replaceAll('_', '-')}", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: homePageContent(nominal: widget.price),
                top: 0,
                right: 0,
                left: 0,
              ),
              Positioned(
                top: 215,
                bottom: 0,
                left: 0,
                right: 0,
                child: ListView(
                  children: <Widget>[
                    TokenCard(
                      param: widget.param,
                      iconUrl: widget.imgUrl,
                      provider: widget.provider,
                      no: widget.no,
                      price: widget.nominal,
                      note: widget.note,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(595),
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                print("${widget.no}, ${widget.code},${widget.raw_price},${widget.fee_charge}");
                                _pinBottomSheet(context);
                              },
                              child: Center(
                                child: Text("Bayar",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }






  Future<void> _pinBottomSheet(context) async {
    showDialog(
        context: context,
        builder: (BuildContext bc){
          return PinScreen(callback: _callBackPin,);
        }
    );
  }

  Future _callBackPin(BuildContext context,bool isTrue) async{
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
      var res = await checkoutPpobPraBloc.fetchCheckoutPpobPra(widget.no, widget.code, widget.raw_price, widget.fee_charge,idpelanggan);
      print(res);
      if(res is CheckoutPpobModel){
        CheckoutPpobModel results = res;
        if(results.status == 'success'){
          setState(() {
            Navigator.pop(context);
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialog(
                  alertTitle: richTitle("Transaksi Berhasil"),
                  alertSubtitle: richSubtitle(results.msg),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Kembali"),
                      onPressed: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => DashboardThreePage()),
                        );
                      },
                    ),
                  ],
                );
              });


        }
        else{
          setState(() {
            Navigator.pop(context);
          });
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
        }
      }else{
        setState(() {
          Navigator.pop(context);
        });
        General results = res;
        Navigator.pop(context);
        print(results.msg);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }



}


class homePageContent extends StatelessWidget {
  homePageContent({this.nominal});
  final String nominal;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: 269,
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Nominal Yang Harus Dibayar", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
              SizedBox(height: 11),
              Divider(color: Colors.white),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${nominal}",
                    style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.0),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Dari Saldo Utama", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TokenCard extends StatelessWidget {
  final String param,iconUrl,provider, no, nominal, price, note;
  TokenCard(
      {Key key,
        this.param,
        this.iconUrl,
        this.provider,
        this.no,
        this.nominal,
        this.price,
        this.note,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cek = "";
    if(param == 'PULSA'){
      cek = provider + " ( " + price + " )";
    }else{
      cek = provider;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      padding: EdgeInsets.all(21),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Image.network(iconUrl),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cek,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 14),
                  ),
                  SizedBox(height: 10.0,),

                  Text("Nomor : " +
                    no ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12)
                  ),
                  Divider(),
                  Text(
                    note.toLowerCase(),
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 14)
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}