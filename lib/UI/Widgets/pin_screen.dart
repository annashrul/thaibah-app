import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/UI/component/pin/resendAuth.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:thaibah/Constants/constants.dart';

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
    setState(() {
      isLoading = false;
    });
    pinQ = await userRepository.getDataUser('pin');
    setState(() {
      pin = pinQ.toString();
      cek = pin.split('');
    });
    print("############## PIN ABI = $pinQ $cek #######################");
  }

  Future biometrics() async {
    setState(() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100.0),
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(strokeWidth: 10.0, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                    SizedBox(height:5.0),
                    Text("Tunggu Sebentar .....",style:TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                  ],
                ),
              )
          );

        },
      );
    });
//    print("################## STATUS LOADING $isLoading ###########################");
    var res= await MemberProvider().forgotPin();
    if(res is ResendOtp){
      setState(() {Navigator.pop(context);});

      ResendOtp results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading = true;
        });
        Timer(Duration(seconds: 4), () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ResendAuth(otp:results.result.otp))).whenComplete(cekPin);
        });
        UserRepository().notifNoAction(_scaffoldKey, context,"Cek OTP Yang Kami Kirim Ke No WhatsApp Anda","success");
      }else{
        setState(() {
          isLoading = true;
        });
        UserRepository().notifNoAction(_scaffoldKey, context, results.msg,"success");
      }
    }else{
      setState(() {Navigator.pop(context);});

      General results = res;
      UserRepository().notifNoAction(_scaffoldKey, context, results.msg,"failed");
    }

  }



  @override
  void initState() {
    cekPin();
    setState(() {
      isLoading=false;
    });
    isLoading=false;
    super.initState();
  }
  final userRepository = UserRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LockScreenQ(
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
            if (passcode[i] != int.parse(cek[i])) {
              return false;
            }
          }
          return true;
        },
        onSuccess: () async{
          setState(() {
            isLoading = true;
          });
          _check(context);
        }
      ),
    );
  }

  Future _check(/*String txtPin,*/ BuildContext context) async {
    widget.callback(context, true);
  }



}
