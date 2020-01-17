import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/component/bank/getAvailableBank.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/config/user_repo.dart';

String pin = "";


class SaldoUI extends StatefulWidget {

  String saldo; String name;

  SaldoUI({this.saldo,this.name});
  @override
  _SaldoUIState createState() => _SaldoUIState();
}

class _SaldoUIState extends State<SaldoUI> {

  final userRepository = UserRepository();
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  TextEditingController saldoController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();
  String _saldo;
  bool isLoading = false;

  getBank() async {
    setState(() {
      isLoading = false;
    });
    final pin  = await userRepository.getPin();
    print(pin);
    if(saldoController.text == ''){
      return showInSnackBar("Masukan Nominal Minimal 100001");
    }else{
      if(int.parse(saldoController.text) <= 100000){
        return showInSnackBar("Masukan Nominal Minimal 100001");
      }else{
        if(pin == 0){
          scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                content: Text('Silahkan Buat PIN untuk Melanjutkan Transaksi',style: TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                action: SnackBarAction(
                  textColor: Colors.green,
                  label: 'Buat PIN',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => Pin(saldo: widget.saldo)),
                    );

                  },
                ),
              )
          );
        }else{
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => GetAvailableBank(amount:int.parse(saldoController.text),name: widget.name,saldo:widget.saldo)),
          );
        }
      }
    }
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }


  Widget cepat(String val, String nominal){
    return RaisedButton(
      elevation: 0.5,
      padding: EdgeInsets.all(1),
      color: Colors.white,
      onPressed: () {
        saldoController.text = "$val";
      },
      child: Text("$nominal",style: TextStyle(color:Color(0xFF116240),fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
//              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
            },
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
          title: new Text("Topup", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black26,
                    offset: new Offset(0.0, 2.0),
                    blurRadius: 25.0,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32)
                )
              ),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CardHeader(saldo: widget.saldo),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nominal",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: saldoController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                            prefixText: 'Rp.',
                          ),
                          textInputAction: TextInputAction.done,
                          focusNode: saldoFocus,
                          onFieldSubmitted: (value){
                            saldoFocus.unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            getBank();
                          },
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Pilih Nominal Cepat",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        GridView.count(
                          padding: EdgeInsets.only(top:10, bottom: 10, right: 2),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 2,
                          shrinkWrap: true,
                          children: <Widget>[
                            cepat("100001", "Rp. 100.001,-"),
                            cepat("200000", "Rp. 200.000,-"),
                            cepat("300000", "Rp. 300.000,-"),
                            cepat("400000", "Rp. 400.000,-"),
                            cepat("500000", "Rp. 500.000,-"),
                            cepat("1000000", "Rp. 1.000.000,-"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          setState(() {isLoading = true;});
                          getBank();
                        },
                        icon: isLoading?CircularProgressIndicator():Icon(Icons.arrow_forward),
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

}
