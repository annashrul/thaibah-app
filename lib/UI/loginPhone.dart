
import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/authModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/typeOtpModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/UI/regist_ui.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/bloc/authBloc.dart';
import 'package:thaibah/UI/Widgets/responsive_ui.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/Model/userLocalModel.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
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

  int count = 0;
  List<UserLocalModel> contactList;
  bool typeOtp = true;
  TypeOtpModel typeOtpModel;
  String _valType ='whatsapp';  //Ini untuk menyimpan value data friend
  List _type = ["whatsapp", "sms"];  //Array My Friend
  Future<void> loadData() async {
    try{
      var jsonString = await http.get(
          ApiService().baseUrl+'info/typeotp'
      ).timeout(Duration(seconds: ApiService().timerActivity));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        typeOtpModel = new TypeOtpModel.fromJson(jsonResponse);
        setState(() {
          typeOtp=typeOtpModel.result.typeOtp;
        });
      } else {
        throw Exception('Failed to load info');
      }
    } on TimeoutException catch(e){
      print('timeout: $e');
    } on Error catch (e) {
      print('Error: $e');
    }
  }
  UserLocalModel userLocalModel;

  Future login() async{
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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("ID = ${androidInfo.id}");
    print("TYPE = ${androidInfo.type}");
    print("MODEL = ${androidInfo.model}");
    print("PRODUCT = ${androidInfo.product}");
    print("DEVICE = ${androidInfo.device}");
    print("BRAND = ${androidInfo.brand}");
    if(codeCountry == ''){
      setState(() {
        codeCountry = "62";
      });
    }
    String indexHiji = _noHpController.text[1];
    String rplc = _noHpController.text[0];
    String replaced = '';
    String cek62 = "${rplc}${indexHiji}";

    if(rplc == '0'){replaced = "${_noHpController.text.substring(1,_noHpController.text.length)}";}
    else if(cek62 == '62'){replaced = "${_noHpController.text.substring(2,_noHpController.text.length)}";}
    else{replaced = "${_noHpController.text}";}
    String no = "${codeCountry}${replaced}";



    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String onesignalUserId = status.subscriptionStatus.userId;
    final checkConection = await userRepository.check();
    if(checkConection == false){
      setState(() {Navigator.pop(context);});
      UserRepository().notifNoAction(_scaffoldKey, context,"Anda Tidak Terhubung Dengan Internet","failed");
    }else{
      if(typeOtp==false){_valType = null;}
      else{_valType = _valType;}
      var res = await authNoHpBloc.fetchAuthNoHp(no, onesignalUserId,_valType,"${androidInfo.brand} ${androidInfo.device}");
      print("RESPONSE $res");
      print("################### TYPE OTP $_valType ########################");
      if(res is AuthModel){
        AuthModel result = res;
        if(result.status == 'success'){
          setState(() {
            Navigator.pop(context);
            alreadyLogin = false;
            _noHpController.clear();
          });
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              new CupertinoPageRoute(builder: (BuildContext context)=>SecondScreen(
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
                levelStatus:result.result.levelStatus.toString(),
                warna1:result.result.tema.warna1,
                warna2:result.result.tema.warna2,
              )), (Route<dynamic> route) => false
          );
        }
        else{
          print("######### STATUS ${result.status}");
          setState(() {Navigator.pop(context);});
          UserRepository().notifNoAction(_scaffoldKey, context,"No WhatsApp Tidak Terdaftar","failed");
        }

      }
      else{
        General results = res;
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"No WhatsApp Tidak Terdaftar","failed");
      }
    }
    print(_radioValue2);
  }


  double _height;
  GlobalKey<FormState> _key = GlobalKey();
  bool _large;
  bool _medium;
  double _pixelRatio;
  double _width;
  SharedPreferences preferences;



  @override
  void initState(){
    super.initState();
    loadData();
    setState(() {
      _isLoading = false;

    });
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init(ApiService().deviceId, iOSSettings: settings);
  }
  bool isSwitched = true;
  String _radioValue2 = 'whatsapp';
  void _handleRadioValueChange2(String value) {
    _radioValue2 = value;
    switch (_radioValue2) {
      case 'whatsapp':
        setState(() {});
        break;
      case 'sms':
        setState(() {});
        break;
    }

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

  }

  Widget pages(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
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
                padding: EdgeInsets.only(top: 30.0),
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
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "",
                        width: ScreenUtilQ.getInstance().setWidth(150),
                        height: ScreenUtilQ.getInstance().setHeight(150),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(180)),
                  Container(
                    width: double.infinity,
                    height: ScreenUtilQ.getInstance().setHeight(typeOtp==true?420:320),
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
                          Text("Masuk",style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(45),fontFamily:ThaibahFont().fontQ,letterSpacing: .6,fontWeight: FontWeight.bold)),
                          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                          Text("No WhatsApp (Silahkan Masukan No WhatsApp Yang Telah Anda Daftarkan)",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(26))),
                          Row(
                            children: <Widget>[
                              Container(
                                child: CountryCodePicker(
                                  onChanged: (CountryCode  countryCode){
                                    setState(() {
                                      codeCountry = "${countryCode.dialCode.replaceAll('+', '')}";
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
                                  style: TextStyle(fontFamily: ThaibahFont().fontQ),
                                  maxLength: 15,
                                  controller: _noHpController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  focusNode: _noHpFocus,
                                  onFieldSubmitted: (value){
                                    _noHpFocus.unfocus();
                                    if(_noHpController.text == ''){
                                      UserRepository().notifNoAction(_scaffoldKey, context,"No WhatsApp Tidak Terdaftar","failed");
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
                          SizedBox(height:typeOtp==true?5.0:0.0),
                          typeOtp==true?Text("Kirim OTP via ?",style: TextStyle(fontFamily: ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(26))):Text(''),
                          SizedBox(height:typeOtp==true?5.0:0.0),
                          typeOtp==true?DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            hint: Text("Pilih",style: TextStyle(fontFamily: 'Rubik'),),
                            value: _valType,
                            items: _type.map((value) {
                              return DropdownMenuItem(
                                child: Text(value,style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _valType = value;
                              });
                            },
                          ):Container(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("*Pastikan Handphone Anda Terkoneksi Dengan Internet*",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(26),fontWeight: FontWeight.bold,color:Colors.red)),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width/1,
                          height: ScreenUtilQ.getInstance().setHeight(100),
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
                                  UserRepository().notifNoAction(_scaffoldKey, context, "Anda Tidak Terhubung Dengan Internet","failed");
                                }else{
                                  if(_noHpController.text == ''){
                                    UserRepository().notifNoAction(_scaffoldKey, context, "Anda Belum Memasukan No WhatsApp","failed");
                                  }else{
                                    setState(() {
                                      _isLoading = true;
                                    });
                                   login();
                                  }
                                }

                              },
                              child:Center(
                                child: Text("Masuk",style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Atau",style: TextStyle(fontSize: 16.0, fontFamily:ThaibahFont().fontQ, fontWeight: FontWeight.bold)),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(30)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width/1,
                          height: ScreenUtilQ.getInstance().setHeight(100),
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
                                child: Text("Daftar",style: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
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



  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtilQ.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
}


class SecondScreen extends StatefulWidget {
  final String otp,id,name,address,email,picture,cover,socketid,kdReferral,kdUnique,token,pin,noHp,ktp,levelStatus,warna1,warna2;
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
    @required this.levelStatus,
    @required this.warna1,
    @required this.warna2,
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
    return Scaffold(
        key: _scaffoldKey,
        body: isLoading?Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(strokeWidth: 10)
            ],
          )
        ):
        LockScreenQ(
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
              setState(() {
                isLoading = true;
              });

              _check(currentText, context);
            }
        ),
    );
  }



  Future _check(String txtOtp, BuildContext context) async {
    final dbHelper = DbHelper.instance;
    if (widget.otp == txtOtp) {
      Map<String, dynamic> row = {
        DbHelper.columnIdServer  : widget.id.toString(),
        DbHelper.columnName  : widget.name.toString(),
        DbHelper.columnAddress  : widget.address.toString(),
        DbHelper.columnEmail : widget.email.toString(),
        DbHelper.columnPicture :widget.picture.toString(),
        DbHelper.columnCover  : widget.cover.toString(),
        DbHelper.columnSocketId  : widget.socketid.toString(),
        DbHelper.columnKdUnique  : widget.kdUnique.toString(),
        DbHelper.columnToken  :  widget.token.toString(),
        DbHelper.columnPhone  : widget.noHp.toString(),
        DbHelper.columnPin  :  widget.pin.toString(),
        DbHelper.columnReferral  : widget.kdReferral.toString(),
        DbHelper.columnKtp  : widget.ktp.toString(),
        DbHelper.columnStatus  : "1",
        DbHelper.columnStatusOnBoarding  : "1",
        DbHelper.columnStatusExitApp  : "1",
        DbHelper.columnStatusLevel  : widget.levelStatus,
        DbHelper.columnWarna1  : widget.warna1.toString(),
        DbHelper.columnWarna2  : widget.warna2.toString(),
      };
      final countRow = await dbHelper.queryRowCount();
      print("COUNT ROW DATABASE $countRow");
      if(countRow >= 1){
        setState(() {isLoading=false;});
        await dbHelper.deleteAll();
        await dbHelper.insert(row);
        setState(() {isLoading=false;});
      }else{
        print("CREATE");
        await dbHelper.insert(row);
        setState(() {isLoading=false;});
      }
      print("COUNT ROW DATABASE $countRow");


      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
    } else {
      setState(() {
        Navigator.of(context).pop();
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Terjadi Kesalahan!",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),),
            content: new Text("Kode OTP Tidak Sesuai",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),),
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