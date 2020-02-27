import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/registPinUIModel.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/api.dart';

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
          return AlertDialog(
            content: LinearProgressIndicator(),
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
                  child: RichAlertDialog(
                    alertTitle: richTitle(showNotif==true?"Perhatian":"Pendaftaran Berhasil"),
                    alertSubtitle: richSubtitle(showNotif==true?"Klik Tombol Masuk Untuk Keluar Dari Halaman Ini":"Silahkan login dengan nomor yang telah anda daftarkan."),
                    alertType: showNotif==true?RichAlertType.WARNING:RichAlertType.SUCCESS,
                    actions: <Widget>[
                      FlatButton(
                        color: Color(0xFF00e676),
                        child: Text("Masuk"),
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
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
//    return Scaffold(
//      key: scaffoldKey,
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        centerTitle: false,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//        elevation: 1.0,
//        automaticallyImplyLeading: true,
//        title: new Text("Keamanan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//      ),
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
//                height: MediaQuery.of(context).size.height / 4,
//                fit: BoxFit.fitHeight,
//              ),
//              SizedBox(height: 8),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 8.0),
//                child: Text(
//                  'Masukan Kode OTP',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Rubik'),textAlign: TextAlign.center,
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
//                child: Text(
//                  'Masukan kode OTP yang telah kami kirim melalui pesan ke no whatsApp anda',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,fontFamily: 'Rubik'),textAlign: TextAlign.center,
//                ),
//              ),
//              Padding(
//                  padding:
//                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
//                  child: Builder(
//                    builder: (context) => Padding(
//                      padding: const EdgeInsets.all(5.0),
//                      child: Center(
//                        child: otpInput(),
//                      ),
//                    ),
//                  )
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
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
//                _check(currentText.toString(),context);
              }
          ),
        )
    );
  }
  // receive data from the FirstScreen as a parameter


//  Widget otpInput() {
//    return Builder(
//      builder: (context) => Padding(
//        padding: const EdgeInsets.all(40.0),
//        child: Center(
//          child: PinPut(
//            fieldsCount: 4,
//            onSubmit: (String txtOtp) => _check(txtOtp, context),
//            actionButtonsEnabled: false,
//          ),
//        ),
//      ),
//    );
//  }

//  Future _check(String txtOtp,  BuildContext context) {
//    if (widget.otp == txtOtp) {
//      print(widget.otp);
//      create();
//    } else {
//      setState(() {_isLoading = false;});
//      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('kode otp tidak sesuai')));
//      print(widget.otp);
//    }
//  }
}