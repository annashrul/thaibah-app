import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/registPinUIModel.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';

Future<Response> post(String url,var body)async{
  return await http
      .post(Uri.encodeFull(url), body: body, headers: {"Accept":"application/json"})
      .then((http.Response response) {

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Response.fromJson(json.decode(response.body));
  });
}

class SecondScreen extends StatefulWidget {
  final String pin,name,isMobile,noHp,kdReferral,ktp,otp,statusOtp;
  SecondScreen({
    Key key,
    @required
    this.pin,
    this.name,
    this.isMobile,
    this.noHp,
    this.kdReferral,
    this.ktp,
    this.otp,
    this.statusOtp
  }) : super(key: key);

  @override
  _SecondScreenStatefulState createState() => _SecondScreenStatefulState();

}

class _SecondScreenStatefulState extends State<SecondScreen> {
  final _txtOtp = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool alreadyLogin = false;

  bool _apiCall = false;
  var currentText;
  String _response = '';
  bool _isLoading = false;
  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Sentuh Tombol Masuk Untuk Keluar Dari Halaman Ini'),
    duration: snackBarDuration,
  );

  DateTime backButtonPressTime;

  bool showNotif = false;

  Future<bool> onWillPop() async {
    setState(() {
      showNotif = true;
    });
    Navigator.of(context).pop(false);
    return false;
  }
  Future create()async{
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
    var res = await createMemberBloc.fetchCreateMember(
      widget.pin,
      widget.name,
      widget.isMobile,
      widget.noHp,
      widget.kdReferral,
//      widget.ktp
    );
    setState(() {
      Navigator.of(context).pop();
    });
    if(res is General){
      General result = res;
      print(result.status);

      if(result.status == 'success'){
        setState(() {
          _isLoading = false;
        });
        print("#####################################################BERHASIL#######################################");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  child: RichAlertDialogQ(
                    alertTitle: richTitle(showNotif==true?"Perhatian":"Pendaftaran Berhasil"),
                    alertSubtitle: richSubtitle(showNotif==true?"Klik Tombol Masuk Untuk Keluar Dari Halaman Ini":"Silahkan login dengan nomor yang telah anda daftarkan."),
                    alertType: showNotif==true?RichAlertType.WARNING:RichAlertType.SUCCESS,
                    actions: <Widget>[
                      FlatButton(
                        color: Color(0xFF00e676),
                        child: Text("Masuk"),
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),
                  onWillPop: onWillPop
              );
            }
        );

      }else{
        setState(() {_isLoading = false;});
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result.msg)));
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _getId();
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
              passCodeVerify: (passcode) async {
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
                print(currentText);
                setState(() {
                  _isLoading = true;
                });
                create();
              }
          ),
        )
    );
  }

}