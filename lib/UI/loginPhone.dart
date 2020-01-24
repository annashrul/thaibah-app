import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
//import 'package:onesignal/onesignal.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/authModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/regist_ui.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/bloc/authBloc.dart';
import 'package:thaibah/UI/Widgets/responsive_ui.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class LoginPhone extends StatefulWidget {
  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  var _noHpController = TextEditingController();
  final FocusNode _noHpFocus = FocusNode();
  bool alreadyLogin = false;
  String pesanHp="";
  String deviceId='';
  String codeCountry = '';

  final userRepository = UserRepository();


  Future login() async{
    if(codeCountry == ''){
      setState(() {
        codeCountry = "62";
      });
    }
    String indexHiji = _noHpController.text[1];
    String rplc = _noHpController.text[0];
    String replaced = '';
    String cek62 = "${rplc}${indexHiji}";
    print(replaced);
    if(rplc == '0'){
      print("nu kahiji 0");
      print("####################${_noHpController.text.substring(1,_noHpController.text.length)}####################");
      replaced = "${_noHpController.text.substring(1,_noHpController.text.length)}";
    }
    else if(cek62 == '62'){
      replaced = "${_noHpController.text.substring(2,_noHpController.text.length)}";
    }
    else{
      replaced = "${_noHpController.text}";
      print("nu kahiji lain 0");
    }
    String no = "${codeCountry}${replaced}";
    print(no);

    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String onesignalUserId = status.subscriptionStatus.userId;
    final checkConection = await userRepository.check();
    if(checkConection == false){
      setState(() {_isLoading = false;});
      return showInSnackBar("Anda Tidak Terhubung Dengan Internet");
    }else{
      var res = await authNoHpBloc.fetchAuthNoHp(no, onesignalUserId);
      if(res is AuthModel){
        AuthModel result = res;
        print(result.status);
        if(result.status == 'success'){
          setState(() {
            _isLoading = false;
            alreadyLogin = false;
            _noHpController.clear();
          });

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SecondScreen(
            otp: result.result.otp.toString(),
            id:result.result.id.toString(),
            name: result.result.name.toString(),
            address: result.result.address.toString(),
            email: result.result.email.toString(),
            picture: result.result.picture.toString(),
            cover: result.result.cover.toString(),
            socketid: result.result.socketid.toString(),
            kdReferral: result.result.kdReferral.toString(),
            kdUnique: result.result.kdUnique.toString(),
            token: result.result.token.toString(),
            pin: result.result.pin.toString(),
            noHp: result.result.noHp.toString(),
            ktp: result.result.ktp.toString(),
          )), (Route<dynamic> route) => false);
        }else{
          setState(() {_isLoading = false;});
          return showInSnackBar("No Handphone Tidak Terdaftar");
        }
      }
      else{
        General results = res;
        setState(() {_isLoading = false;});
        return showInSnackBar("No Handphone Tidak Terdaftar");
      }
    }
  }


  double _height;
  GlobalKey<FormState> _key = GlobalKey();
  bool _large;
  bool _medium;
  double _pixelRatio;
  double _width;
  SharedPreferences preferences;



  @override
  void initState() {
    super.initState();
    _isLoading = false;
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init("6a4c55fd-d96d-427f-8634-d2c4b9d96d69", iOSSettings: settings);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return pages(context);
//    return FutureBuilder<bool>(
//      future: getLoginStatus(),
//      builder: (context, snapshot) {
//        if (snapshot.data == null) return CircularProgressIndicator();
//        return (snapshot.data) ?
//        DashboardThreePage():  pages(context);
//      },
//    );
  }

  Widget pages(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Center(child:Image.asset("assets/images/logoOnBoardTI.png",width: 120.0)),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/images/image_02.png")
            ],
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "",
                        width: ScreenUtil.getInstance().setWidth(150),
                        height: ScreenUtil.getInstance().setHeight(150),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(180)),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(320),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0.0),
                        boxShadow: [
                          BoxShadow(color: Colors.black12,offset: Offset(0.0, 0.0),blurRadius: 0.0),
                          BoxShadow(color: Colors.black12,offset: Offset(0.0, -5.0),blurRadius: 10.0),
                        ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Masuk",style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(45),fontFamily: "Rubik",letterSpacing: .6,fontWeight: FontWeight.bold)),
                          SizedBox(height: ScreenUtil.getInstance().setHeight(30)),
                          Text("No WhatsApp (Silahkan Masukan No WhatsApp Yang Telah Anda Daftarkan)",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),
                          Row(
                            children: <Widget>[
                              Container(
                                child: CountryCodePicker(
                                  onChanged: (CountryCode  countryCode){
                                    setState(() {
                                      codeCountry = "${countryCode.dialCode.replaceAll('+', '')}";
//                                      print("${countryCode.dialCode.replaceAll('+', '')}");
                                    });
                                  },
                                  initialSelection: 'ID',
                                  favorite: ['+62','ID'],
                                  showCountryOnly: true,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: true,
                                ),
                                width: MediaQuery.of(context).size.width/3.1-30.0,
                              ),

                              new SizedBox(
                                width: 0.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/1.7-30.0,
                                child: TextFormField(
                                  maxLength: 15,
                                  controller: _noHpController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  focusNode: _noHpFocus,
                                  onFieldSubmitted: (value){
                                    _noHpFocus.unfocus();
                                    if(_noHpController.text == ''){
                                      return showInSnackBar("No Handphone Tidak Terdaftar");
                                    }
                                    else{
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      login();
                                    }
                                  },
                                  decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height:10.0),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("*Pastikan Handphone Anda Terkoneksi Dengan Internet*",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26),fontWeight: FontWeight.bold,color:Colors.red)),
                  ),

                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width/1,
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final checkConnection = await userRepository.check();
                                if(checkConnection == false){
                                  setState(() {_isLoading = false;});
                                  return showInSnackBar("Anda Tidak Terhubung Dengan Internet");
                                }else{
                                  if(_noHpController.text == ''){
                                    return showInSnackBar("Anda Belum Memasukan No WhatsApp");
                                  }else{
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    login();
                                  }
                                }

                              },
                              child: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Center(
                                child: Text("Masuk",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Atau",style: TextStyle(fontSize: 16.0, fontFamily: "Rubik", fontWeight: FontWeight.bold)),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(30)),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Text("Buat Akun ? ",style: TextStyle(fontFamily: "Rubik"),),
//                      InkWell(
//                        onTap: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => Regist(),
//                            ),
//                          );
//                        },
//                        child: Text("Daftar disini",style: TextStyle(color: Color(0xFF5d74e3),fontFamily: "Poppins-Bold")),
//                      )
//                    ],
//                  )
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width/1,
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 3.0
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0) //
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Regist(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text("Daftar",style: TextStyle(color: Colors.green,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      ),

    );
  }

  void showInSnackBar(String value) {
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
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
}


class SecondScreen extends StatefulWidget {
  final String otp,id,name,address,email,picture,cover,socketid,kdReferral,kdUnique,token,pin,noHp,ktp;
  SecondScreen({
    Key key,
    @required this.otp,
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.email,
    @required this.picture,
    @required this.cover,
    @required this.socketid,
    @required this.kdReferral,
    @required this.kdUnique,
    @required this.token,
    @required this.pin,
    @required this.noHp,
    @required this.ktp,
  }) : super(key: key);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool alreadyLogin = false;
  bool isLoading = false;
  var currentText;
  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
//          onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false)
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
//      key: _scaffoldKey,
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
//                padding:
//                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
//                child: Builder(
//                  builder: (context) => Padding(
//                    padding: const EdgeInsets.all(5.0),
//                    child: Center(
//                      child: otpInput(),
//                    ),
//                  ),
//                )
//              ),
//            ],
//          ),
//        ),
//      ),
////      bottomNavigationBar: _bottomNavBarBeli(context),
//    );
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: LockScreen(
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
                  isLoading = true;
                });

                _check(currentText, context);
//                _check(currentText.toString(),context);
              }
          ),
        )
    );
  }

  Widget build_(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // SizedBox(height: 50,),
              Text("Masukan Kode OTP"),
              Text(widget.otp),
              otpInput(),

              // buttonOtp()
            ],
          )
        ),
      )
    );
  }

  Widget otpInput() {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: PinPut(
            clearButtonIcon: new Icon(Icons.backspace, size: 21, color: Color(0xFF535c68)),
            pasteButtonIcon: new Icon(Icons.content_paste, size: 20),
            isTextObscure: true,
            keyboardType: TextInputType.number,
            fieldsCount: 4,
            onSubmit: (String txtOtp){
              setState(() {
                isLoading = true;
              });
              _check(txtOtp, context);
            },
            actionButtonsEnabled: false,

//            clearButtonIcon: Icon(Icons.backspace, size: 30),
            clearInput: true,
            onClear: (value){
              print(value);
            },
          ),
        ),
      ),
    );
  }

  Future _check(String txtOtp, BuildContext context) async {
    isLoading ? showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: LinearProgressIndicator(),
        );
      },
    ):Container();
    if (widget.otp == txtOtp) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isLoading = false;
        alreadyLogin = true;
        prefs.setBool('isPin', true);
        prefs.setBool('login', alreadyLogin);
        prefs.setString('id', widget.id);
        prefs.setString('name', widget.name);
        prefs.setString('address', widget.address);
        prefs.setString('email', widget.email);
        prefs.setString('picture', widget.picture);
        prefs.setString('cover', widget.cover);
        prefs.setString('socketid', widget.socketid);
        prefs.setString('kd_referral', widget.kdReferral);
        prefs.setString('kd_unique', widget.kdUnique);
        prefs.setString('token', widget.token);
        prefs.setString('pin', widget.pin);
        prefs.setString('nohp', widget.noHp);
        prefs.setString('ktp', widget.ktp);
        prefs.setBool('isLogin', true);

      });
      CircularProgressIndicator();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
    } else {
      setState(() {
        Navigator.of(context).pop();
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Terjadi Kesalahan!"),
            content: new Text("Kode OTP Tidak Sesuai"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    }
  }
  Widget _bottomNavBarBeli(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: Colors.green,
                onPressed: (){
                  setState(() {
//                    isLoading = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountDownTimer(),
                    ),
                  );
                },
                child:Text("Kirim Ulang Kode OTP", style: TextStyle(color: Colors.white)),

              )
          )

        ],
      ),
    );
  }

}
class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 120).toString().padLeft(2, '0')}';
  }

  void controlTime(){
    controller.reverse(from: controller.value == 0.0? 1.0: controller.value);
  }

  Future resend() async{
    controlTime();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 120),
    );
    controlTime();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.green,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child:
                Container(
                  height:controller.value * MediaQuery.of(context).size.height,
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
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: Colors.black,
                                  )),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(timerString,style: TextStyle(fontSize: 112.0,color: Colors.white,fontFamily: 'Rubik'),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                              onPressed: () {
                                resend();
                              },
                              backgroundColor: Colors.white,
                              icon: Icon(Icons.play_arrow,color: Colors.black87,),
                              label: Text("Kirim Ulang",style: TextStyle(color:Colors.black87,fontFamily: 'Rubik',fontWeight: FontWeight.bold),)
                            );
                          }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }
        ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}