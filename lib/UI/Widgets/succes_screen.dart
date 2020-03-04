import 'dart:core';

import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';


class SuccessScreen extends StatefulWidget {
  SuccessScreen({this.title,this.price,this.qty});
  final String title;
  final int price;
  final int qty;
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with SingleTickerProviderStateMixin{
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _controller;
  double _height;
  double _width;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

    Future<bool> _onWillPop() {
    return Navigator.of(context).pushReplacementNamed(BOTTOM_TABS_CONTROL) ??
        false;
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Image.network('https://www.1designshop.com/wp-content/uploads/2015/12/1dsp-20151221-pattern005.png',
          fit: BoxFit.cover,
        ),
//          new Parallax.inside(
//            child: new Align(
//              alignment: Alignment.center,
//              child: Image.network('https://www.1designshop.com/wp-content/uploads/2015/12/1dsp-20151221-pattern005.png',
//            fit: BoxFit.cover,
//            ),
//            ),
//            mainAxisExtent: 500.0,
//          ),
          _detailSuccess()
      ],
    );
  }

  Widget _detailSuccess(){
    return SafeArea(
        left: false,
        top: true,
        right: false,
        bottom: true,
        child: Column(
        children: <Widget>[
          new Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pushReplacementNamed(BOTTOM_TABS_CONTROL)
            )
          ),
          Image.asset('assets/images/checkmark.gif', width: _width/2.5,),
          Container(
            width: _width,
            padding: EdgeInsets.all(10),
              // transform: Matrix4.translationValues(0.0, -120.0, 0.0),
              // margin: EdgeInsets.only(top: _height/4.5,),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text("Pembayaran Berhasil!", style: TextStyle(color: Colors.green[900], fontSize: 24),),
                Text("Pembelian ${widget.title}", style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text("Saldo Utama", style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ),
          Container(
            width: _width,
            padding: EdgeInsets.all(10),
              // transform: Matrix4.translationValues(0.0, -120.0, 0.0),
              // margin: EdgeInsets.only(top: _height/3,),
              child: Material(
                color: Colors.white,
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Rp. ${widget.price}", style: TextStyle(color: Colors.green[900], fontSize: 24,)),
                      SizedBox(height: 10,),
                      Text("Info Pesanan", style: TextStyle(color: Colors.black38, fontSize: 14,)),
                      Text("${widget.title} sebanyak ${widget.qty}.", style: TextStyle(color: Colors.black87, fontSize: 16,)),
                      SizedBox(height: 5,),
                      Divider(),
                      Align(
                        alignment: Alignment.center,
                        child: Text("Kamu bisa mengakses ini pada halaman History", style: TextStyle(color: Colors.black45, fontStyle: FontStyle.italic),),
                      )
                    ]
                  ),
                )
              )
          ),
        ],
      )
  );
  }

  @override
  Widget build(BuildContext context) {
    // getPin();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        // appBar: AppBar(title: Text("Isi Pulsa"),),
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Container(
          height: _height,
          width: _width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
              ],
            ),
          ),
        ),
      )
    );
  }
}
