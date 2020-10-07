import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/UI/component/dataDiri/indexMember.dart';
import 'package:thaibah/UI/component/deposit/formDeposit.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';


class Pin extends StatefulWidget {
  final String saldo,param;
  Pin({this.saldo,this.param});
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
  Future _check(var txtPin, BuildContext context) async {
    final dbHelper = DbHelper.instance;
    final name = await userRepository.getDataUser('name');
    if(widget.param == 'profile'){
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

      var res = await MemberProvider().forgotPin();
      if(res is ResendOtp){
        setState(() {Navigator.pop(context);});
        ResendOtp result = res;
        if(result.status=='success'){
          Timer(Duration(seconds: 3), () {
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => OtpUpdate(pin:txtPin,otp:result.result.otp)),
            );
          });
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,'success');
        }else{
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,'failed');
        }
      }else{
        setState(() {Navigator.pop(context);});
        General result = res;
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,'failed');
      }

      print('####################### PARAMETER PROFILE #####################');
    }else{
      var res = await updatePinMemberBloc.fetchUpdatePinMember(txtPin);
      if(res is General){
        General result = res;
        if(result.status == 'success'){
          final userRepository = UserRepository();
          final id = await userRepository.getDataUser('id');
          Map<String, dynamic> row = {
            DbHelper.columnId   : id,
            DbHelper.columnPin :txtPin
          };
          await dbHelper.update(row);
          setState(() {_isLoading  = false;});
          if(widget.param == 'beranda'){
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(
                  builder: (BuildContext context) => WidgetIndex(param: '',)
              ), (Route<dynamic> route) => false);
            });
          }else{
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(
                  builder: (BuildContext context) => widget.param=='topup' ? FormDeposit(saldo: widget.saldo,name: name) : WidgetIndex(param: '',)
              ), (Route<dynamic> route) => false);
            });
          }
          String note = widget.param == 'topup' ? 'Pembuatan PIN Berhasil Dilakukan, Anda Akan Diarahkan Kehalaman Topup Saldo' : 'Pembuatan PIN Berhasil Dilakukan, Anda Akan Diarahkan Kehalaman Beranda';
          UserRepository().notifNoAction(_scaffoldKey, context,note,'success');
        }else{
          setState(() {_isLoading = false;});
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,'failed');
        }
      }
      else{
        General results = res;
        setState(() {_isLoading = false;});
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,'failed');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(

        child: LockScreenQ(
            title: "Keamanan",
            passLength: 6,
            bgImage: "assets/images/bg.jpg",
            borderColor: Colors.black,
            showWrongPassDialog: true,
            wrongPassContent: "Pin Tidak Boleh Diawali Angka 0",
            wrongPassTitle: "Opps!",
            wrongPassCancelButtonText: "Oke",
            deskripsi: 'Buat PIN Untuk Keamanan Akun Anda',
            passCodeVerify: (passcode) async{
              var concatenate = StringBuffer();
              passcode.forEach((item){
                concatenate.write(item);
              });
              setState(() {
                currentText = concatenate.toString();
              });
              if(currentText[0] == 0 || currentText[0] == '0'){
                return false;
              }
              return true;
            },
            onSuccess: () {
              _check(currentText.toString(),context);
            }
        ),
      )
    );
  }
}


class OtpUpdate extends StatefulWidget {
  final String pin,otp;
  OtpUpdate({this.pin,this.otp});
  @override
  _OtpUpdateState createState() => _OtpUpdateState();
}

class _OtpUpdateState extends State<OtpUpdate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  final userRepository = UserRepository();

  Future _check(var otp, BuildContext context) async{
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
    final dbHelper = DbHelper.instance;
    var res = await updatePinMemberBloc.fetchUpdatePinMember(widget.pin);
    if(res is General){
      General result = res;
      if(result.status == 'success'){
        final userRepository = UserRepository();
        final id = await userRepository.getDataUser('id');
        final idServer = await userRepository.getDataUser('idServer');
        Map<String, dynamic> row = {
          DbHelper.columnId   : id,
          DbHelper.columnPin :widget.pin
        };
        await dbHelper.update(row);
        setState(() {Navigator.pop(context);});
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(
              builder: (BuildContext context) => IndexMember(id:idServer)
          ), (Route<dynamic> route) => false);
        });
        UserRepository().notifNoAction(_scaffoldKey, context,'Anda Akan Dialihkan Kehalaman Pengaturan','success');
      }else{
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,'failed');
      }
    }
    else{
      General results = res;
      setState(() {Navigator.pop(context);});
      UserRepository().notifNoAction(_scaffoldKey, context,results.msg,'failed');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("#################### INI PIN YANG MAU DIUPDATE ${widget.pin} ##########################");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(

          child: LockScreenQ(
              title: "Keamanan",
              passLength: 4,
              bgImage: "assets/images/bg.jpg",
              borderColor: Colors.black,
              showWrongPassDialog: true,
              wrongPassContent: "Kode OTP Tidak Sesuai",
              wrongPassTitle: "Opps!",
              wrongPassCancelButtonText: "Batal",
              deskripsi: 'Masukan Kode OTP Yang Telah Kami Kirim Melalui Pesan WhatsApp ${ApiService().showCode == true ? widget.otp : ""}',
              passCodeVerify: (passcode) async{
                var concatenate = StringBuffer();
                passcode.forEach((item){
                  concatenate.write(item);
                });
                setState(() {
                  currentText = concatenate.toString();
                });
                if(currentText != widget.otp){
                  return false;
                }
                return true;
              },
              onSuccess: () {
                _check(currentText.toString(),context);
              }
          ),
        )
    );
  }

}



