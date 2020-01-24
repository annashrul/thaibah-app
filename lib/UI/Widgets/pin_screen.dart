import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/UI/component/pin/resendAuth.dart';
//import 'package:thaibah/config/helperPin.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';

class PinScreen extends StatefulWidget {
  final Function(BuildContext context, bool isTrue) callback;
  PinScreen({this.callback});

  @override
  PinScreenState createState() => new PinScreenState();
}

class PinScreenState extends State<PinScreen> {
  var pinQ;var pin;var cek;
  bool isLoading = false;
  Future cekPin() async{
    pinQ = await userRepository.getPin();
    setState(() {
      pin = pinQ.toString();
      cek = pin.split('');
    });
    print("############## PIN ABI = $pinQ $cek #######################");
  }

  Future<Null> biometrics() async {
    var res=await MemberProvider().forgotPin();
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

    if(res is ResendOtp){
      setState(() {
        Navigator.of(context).pop();
      });
      ResendOtp results = res;
      print(results.result);
      if(results.status == 'success'){
        print(results.result.otp);
        Timer(Duration(seconds: 4), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResendAuth(otp:results.result.otp),
            ),
          );
//          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Pin(saldo: '',param: 'beranda')), (Route<dynamic> route) => false);
        });
        return showInSnackBar("Cek OTP Yang Kami Kirim Ke No WhatsApp Anda",Colors.green);
      }
    }else{
      setState(() {
        Navigator.of(context).pop();
      });
      General results = res;
      return showInSnackBar(results.msg,Colors.red);
    }
  }

  void showInSnackBar(String value,background){
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
  void initState() {
//    print
    cekPin();

    super.initState();
  }
  final userRepository = UserRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LockScreen(
        showFingerPass: true,
        forgotPin: 'Lupa Pin ? Klik Disini',
        fingerFunction: biometrics,
        title: "Keamanan",
        passLength: 6,
        bgImage: "assets/images/bg.jpg",
        borderColor: Colors.black,
        showWrongPassDialog: true,
        wrongPassContent: "Pin Tidak Sesuai",
        wrongPassTitle: "Opps!",
        wrongPassCancelButtonText: "Batal",
        deskripsi: 'Masukan PIN Anda Untuk Melanjutkan Ke Halaman Berikutnya',
        passCodeVerify: (passcode) async {
          for (int i = 0; i < cek.length; i++) {
            print(passcode[i]);
            if (passcode[i] != int.parse(cek[i])) {
              return false;
            }
          }
          print(passcode);
          return true;
        },
        onSuccess: () async{

          setState(() {
            isLoading = true;
          });
          _check(context);
//          widget.callback(context, true);
        }
      ),
//      body: GestureDetector(
//        onTap: () {
//          FocusScope.of(context).requestFocus(new FocusNode());
//        },
//        child: Container(
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
//          child: ListView(
//            children: <Widget>[
//              SizedBox(height: 30),
//              Image.asset(
//                'assets/images/verify.png',
//                height: MediaQuery.of(context).size.height / 3,
//                fit: BoxFit.fitHeight,
//              ),
//              SizedBox(height: 8),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 8.0),
//                child: Text(
//                  'Masukan Pin',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Rubik'),textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Padding(
//                  padding:
//                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
//                  child: Builder(
//                    builder: (context) => Padding(
//                      padding: const EdgeInsets.all(5.0),
//                      child: Center(
//
//                        child: pinInput(),
//                      ),
//                    ),
//                  )
//              ),
//
//            ],
//          ),
//        ),
//      ),
    );
  }

//  Widget pinInput() {
//    return Builder(
//      builder: (context) => Padding(
//        padding: const EdgeInsets.all(5.0),
//        child: Center(
//          child: PinPut(
//            fieldsCount: 6,
//            isTextObscure: true,
//            onSubmit: (String txtPin) => _check(txtPin, context),
////            onClear: () => _scaffoldKey.currentState.r,
//            actionButtonsEnabled: false,
//            clearInput: true,
//            clearButtonIcon: Icon(Icons.backspace),
//          ),
//        ),
//      ),
//    );
//  }

  Future _check(/*String txtPin,*/ BuildContext context) async {
//    int herPin = await userRepository.getPin();
//    print("PIN: $herPin");
//    setState(() {
//      Navigator.of(context).pop();
//    });
    widget.callback(context, true);
//    if (int.parse(txtPin) == herPin) {
//      widget.callback(context, true);
//    } else {
//      widget.callback(context, false);
//    }

  }



}
