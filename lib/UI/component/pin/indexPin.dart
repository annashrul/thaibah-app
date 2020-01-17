import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/saldo_ui.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/user_repo.dart';


class Pin extends StatefulWidget {
  final String saldo;
  Pin({this.saldo});
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  final userRepository = UserRepository();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  bool _isLoading = false;
  Future _check(String txtPin, BuildContext context) async {
    final name = await userRepository.getName();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await updatePinMemberBloc.fetchUpdatePinMember(txtPin);
    if(res is General){
      General result = res;
      if(result.status == 'success'){
        setState(() {_isLoading  = false;});
        Timer(Duration(seconds: 3), () {
          prefs.setString('pin', txtPin);
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => SaldoUI(saldo: widget.saldo,name: name)),
          );
        });
        return showInSnackBar('Pembuatan PIN Berhasil Dilakukan, Anda Akan Diarahkan Kehalaman Topup Saldo',Colors.green);
      }else{
        setState(() {_isLoading = false;});
        return showInSnackBar(result.msg,Colors.redAccent);
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      return showInSnackBar(results.msg,Colors.redAccent);
    }

  }
  void showInSnackBar(String value,background) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: background,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
        title: new Text("Ubah PIN", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                'assets/images/verify.png',
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Masukan Pin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: PinPut(
                          fieldsCount: 6,
                          isTextObscure: true,
                          onSubmit: (String txtPin){
                            setState(() {
                              _isLoading=true;
                            });
                            _check(txtPin, context);
                          },
                          actionButtonsEnabled: false,
                          clearInput: true,
                        ),
                      ),
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}


