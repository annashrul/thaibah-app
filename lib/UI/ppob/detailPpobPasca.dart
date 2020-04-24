import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCheckoutModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/alertq.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/PPOB/PPOBPascaProvider.dart';

class DetailPpobPasca extends StatefulWidget {
  DetailPpobPasca({
    this.param,
    this.tagihan_id,
    this.code,
    this.product_name,
    this.type,
    this.phone,
    this.no_pelanggan,
    this.nama,
    this.periode,
    this.jumlah_tagihan,
    this.admin,
    this.jumlah_bayar,
    this.status,
    this.nominal
  });
  final String param;
  final String tagihan_id;
  final String code;
  final String product_name;
  final String type;
  final String phone;
  final String no_pelanggan;
  final String nama;
  final String periode;
  final String jumlah_tagihan;
  final String admin;
  final String jumlah_bayar;
  final String status;
  final String nominal;

  @override
  _DetailPpobPascaState createState() => _DetailPpobPascaState();
}

class _DetailPpobPascaState extends State<DetailPpobPasca> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final userRepository = UserRepository();
  double _height;
  double _width;
  bool _isLoading = false;
  final formatter = new NumberFormat("#,###");



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("TAGIHAN ID = "+widget.tagihan_id);
    print("CODE = "+widget.code);
    print("PRODUCT NAME = "+widget.product_name);
    print("TYPE = "+widget.type);
    print("PHONE = "+widget.phone);
    print("NO PELANGGAN = "+widget.no_pelanggan);
    print("NAMA = "+widget.nama);
    print("PERIODE = "+widget.periode);
    print("JUMLAH TAGIHAN = "+widget.jumlah_tagihan);
    print("ADMIN = "+widget.admin);
    print("JUMLAH BAYAR = "+widget.jumlah_bayar);
    print("STATUS = "+widget.status);
    print("NOMINAL = "+widget.nominal);

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
            onPressed: (){Navigator.of(context).pop();},
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
          title: new Text("Detail Pembayaran ${widget.param}", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: homePageContent(nominal: formatter.format(int.parse(widget.jumlah_tagihan)),nama: widget.nama,periode: widget.periode),
                top: 0,
                right: 0,
                left: 0,
              ),
              Positioned(
                top: 160,
                bottom: 0,
                left: 0,
                right: 0,
                child: ListView(
                  children: <Widget>[
                    TokenCard(
                      param: widget.product_name,
                      iconUrl: IconImgs.noImage,
                      provider: widget.type,
                      no: widget.no_pelanggan,
                      price: widget.jumlah_bayar,
                      note: widget.status,
                    ),
                    Container(
//                      margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                      padding: EdgeInsets.all(21),
                      child: Row(
                        children: <Widget>[
                          Material(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                child: Container(
                                  width: ScreenUtilQ.getInstance().setWidth(670),
                                  height: ScreenUtilQ.getInstance().setHeight(100),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                                      borderRadius: BorderRadius.circular(6.0),
                                      boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
//                                        dialogCash(context);
//                                        print("${widget.no}, ${widget.code},${widget.raw_price},${widget.fee_charge}");
                                        _pinBottomSheet(context);
                                      },
                                      child: Center(
                                        child: Text("Bayar",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _pinBottomSheet(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    var price;
    if(widget.param == 'ZAKAT'){
      price = widget.nominal;
    }else{
      price = widget.jumlah_bayar;
    }
    print("CODE = ${widget.code}");
    print("ORDERID = ${widget.tagihan_id}");
    print("PRICE = ${price}");
//    Navigator.pop(context);
    var res = await PpobPascaProvider().fetchPpobPascaCheckout(widget.code, widget.tagihan_id,price );

//
    print(res);
    if(res == 'gagal'){
      Navigator.pop(context);
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('terjadi kesalahan, request timeout')));
    }
    else if(res == 'error'){
      Navigator.pop(context);
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('error respon')));
    }
    else{
      if(res is PpobPascaCheckoutModel){
        PpobPascaCheckoutModel results = res;
        if(results.status=="success"){
          setState(() {
            Navigator.pop(context);
          });
          print("#####################################################BERHASIL#######################################");
          return dialogCash(
              context,
              results.result.idtrx,
              results.result.total,
              results.result.nama,
              results.result.target,
              results.result.mtrpln,
              results.result.token
          );
//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return RichAlertDialogQ(
//                  alertTitle: richTitle("Transaksi Berhasil"),
//                  alertSubtitle: richSubtitle("kd trx : ${res.result.idtrx} \n total : ${res.result.total} \n nama : ${res.result.nama} \n target : ${res.result.target} \n no : ${res.result.mtrpln} \n token : ${res.result.token} \n "),
//                  alertType: RichAlertType.SUCCESS,
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text("Kembali"),
//                      onPressed: (){
//                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
//                      },
//                    ),
//                  ],
//                );
//              }
//          );
        }
        else{
          print("#####################################################GAGAK#######################################");
          Navigator.pop(context);
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
        }
      }
      else{
        General results = res;
        print("#####################################################BERHASIL#######################################");
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
      }
    }

  }

  void dialogCash(BuildContext context, var id,var total,var nama,var target,var no,var token) {
    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState){
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    height: 400.0,
                    width: 300.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 400.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                color: Color(0xff454dff),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "BERHASIL",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('ID Transkasi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                        SizedBox(width: 10.0,),
                                        Text(': $id', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                        SizedBox(width: 10.0,),
                                        Icon(Icons.content_copy, color: Colors.black, size: 15,),
                                      ]
                                    ),
                                    onTap: () {
                                      Clipboard.setData(new ClipboardData(text: '$id'));
                                      scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("kode transaksi Berhasil Disalin")));
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          SizedBox(width: 10.0,),
                                          Text(': $total', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                        ]
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Nama', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          SizedBox(width: 10.0,),
                                          Text(': Nama', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                        ]
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Target', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          SizedBox(width: 10.0,),
                                          Text(': $target', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                        ]
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('No', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          SizedBox(width: 10.0,),
                                          Flexible(
                                            child: Text(': $no', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          ),
                                        ]
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(height: 20.0),
                                  GestureDetector(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Token', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          SizedBox(width: 10.0,),
                                          Flexible(
                                            child: Text(': $token', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Rubik',)),
                                          ),
                                          SizedBox(width: 10.0,),
                                          Icon(Icons.content_copy, color: Colors.black, size: 15,),
                                        ]
                                    ),
                                    onTap: () {
                                      Clipboard.setData(new ClipboardData(text: '$token'));
                                      scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("token Berhasil Disalin")));
                                    },
                                  ),

                                ],
                              ),
                            )

                          ],
                        ),
                        Align(
                          // These values are based on trial & error method
                          alignment: Alignment(1.05, -1.05),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                new CupertinoPageRoute(builder: (context) => DashboardThreePage()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    new CupertinoPageRoute(builder: (context) => DashboardThreePage()),
                                  );
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}


class homePageContent extends StatelessWidget {
  homePageContent({this.nominal,this.nama,this.periode});
  final String nominal,nama,periode;
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
      height: 200,
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
                  RichText(
                    text: TextSpan(
                      text: 'Rp. ${nominal} ',
                      style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.0),
                      children: <TextSpan>[
                        TextSpan(text: '( Dari Saldo Utama )', style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:'Rubik')),
                      ],
                    ),
                  ),

                ],
              ),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Atas Nama", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("  :", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("$nama", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Periode", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("        :", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("${periode.substring(0,4)} / ${periode.substring(5,periode.length)}", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              ),
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
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 21.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      padding: EdgeInsets.all(21.0),
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