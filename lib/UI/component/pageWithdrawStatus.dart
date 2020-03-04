import 'package:flutter/material.dart';

class PageWithdrawStatus extends StatefulWidget {
  final String amount,accHolderName,accNumber,bankCode;
  PageWithdrawStatus({this.amount,this.accHolderName,this.accNumber,this.bankCode});
  @override
  _PageWithdrawStatusState createState() => _PageWithdrawStatusState();
}

class _PageWithdrawStatusState extends State<PageWithdrawStatus> with SingleTickerProviderStateMixin {
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

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Image.network('https://www.1designshop.com/wp-content/uploads/2015/12/1dsp-20151221-pattern005.png',
          fit: BoxFit.cover,
        ),
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
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Image.asset('assets/images/bouncy_balls.gif', width: _width/2.5,),
            Container(
              width: _width,
              padding: EdgeInsets.all(10),
              // transform: Matrix4.translationValues(0.0, -120.0, 0.0),
              // margin: EdgeInsets.only(top: _height/4.5,),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          Text("Transaksi berhasil", style: TextStyle(color: Colors.green, fontSize: 20, fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                          Text("Tunggu konfirmasi dari admin.", style: TextStyle(color: Colors.green, fontSize: 20, fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                          Divider(),
                          Text("Menunggu Status", style: TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),

                    // Text("Saldo Utama", style: TextStyle(color: Colors.black87)),
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
                    elevation: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Nominal Sebesar", style: TextStyle(color: Colors.black38, fontSize: 14,fontFamily: 'Rubik')),
                            Text(widget.amount, style: TextStyle(color: Colors.black, fontSize: 16,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            Divider(),
                            Text("Nama Bank", style: TextStyle(color: Colors.black38, fontSize: 14,fontFamily: 'Rubik')),
                            Text(widget.bankCode, style: TextStyle(color: Colors.black87, fontSize: 16,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            Divider(),
                            Text("Atas Nama", style: TextStyle(color: Colors.black38, fontSize: 14,fontFamily: 'Rubik')),
                            Text(widget.accHolderName, style: TextStyle(color: Colors.black87, fontSize: 16,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            Divider(),
                            Text("No Rekening", style: TextStyle(color: Colors.black38, fontSize: 14,fontFamily: 'Rubik')),
                            Text(widget.accNumber, style: TextStyle(color: Colors.black87, fontSize: 16,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            Divider(),
                            Align(
                              alignment: Alignment.center,
                              child: Text("Kamu bisa mengakses ini pada halaman History", style: TextStyle(color: Colors.green,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
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
    return Scaffold(
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
    );
  }
}
