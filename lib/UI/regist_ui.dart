import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/Model/typeOtpModel.dart';
import 'package:thaibah/UI/regist_pin_ui.dart' as prefix1;
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';

import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:http/http.dart' as http;

class Regist extends StatefulWidget {
  Regist() : super();
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  var nameController      = TextEditingController();
  var emailController     = TextEditingController();
  var passwordController  = TextEditingController();
  var pinController       = TextEditingController();
  var confirmPinController       = TextEditingController();
  var reffController      = TextEditingController();
  var noHpController      = TextEditingController();
  var addressController   = TextEditingController();
  var genderController    = TextEditingController();
  var ktpController       = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode nohpFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();
  final FocusNode confirmPinFocus = FocusNode();
  final FocusNode reffFocus = FocusNode();
  final userRepository = UserRepository();


  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  File _image;
  bool apiCall = false;
  bool disableReferral = true;
  bool isRef = false;
  String codeCountry = '';
  String _radioValue1 = 'available';
  String _radioValue2 = 'camera';


  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }


  Future create() async {

    final checkConnection = await userRepository.check();
    if(checkConnection == false){
      setState(() {_isLoading = false;});
      UserRepository().notifNoAction(_scaffoldKey, context,"Anda Tidak Terhubung Dengan Internet","failed");
    }
    else{
      if (nameController.text == "") {
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"Nama Harurs Diisi","failed");
      }
      else if(noHpController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"No WhatsApp Harus Diisi","failed");
      }
      else if(pinController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"PIN Harus Diisi","failed");
      }
      else if(pinController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"Konfirmasi PIN Harus Diisi","failed");
      }
      else if(reffController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"Kode Referral Harus Diisi","failed");
      }
      else if(pinController.text != confirmPinController.text){
        setState(() {Navigator.pop(context);});
        pinController.clear();
        confirmPinController.clear();
        UserRepository().notifNoAction(_scaffoldKey, context,"PIN Yang Anda Masuka Tidak Sesuai","failed");

      }
      else{
        if(pinController.text.length > 6 || pinController.text.length < 6){
          setState(() {Navigator.pop(context);});
          UserRepository().notifNoAction(_scaffoldKey, context,"PIN Tidak Boleh Lebih atau kurang Dari 6 Digit","failed");
        }
        else if(confirmPinController.text.length > 6 || confirmPinController.text.length < 6){
          setState(() {Navigator.pop(context);});
          UserRepository().notifNoAction(_scaffoldKey, context,"Konfirmasi PIN Tidak Boleh Lebih atau kurang Dari 6 Digit","failed");
        }
        else if(pinController.text[0]=='0' || confirmPinController.text[0]=='0'){
          setState(() {Navigator.pop(context);});
          UserRepository().notifNoAction(_scaffoldKey, context,"PIN dan Konfirmasi Tidak Boleh Diawali Angka 0","failed");
        }
        else{
          if(codeCountry == ''){
            setState(() {codeCountry = "62";});
          }
          String indexHiji = noHpController.text[1];
          String rplc = noHpController.text[0];
          String replaced = '';
          String cek62 = "${rplc}${indexHiji}";

          if(rplc == '0'){
            replaced = "${noHpController.text.substring(1,noHpController.text.length)}";
          }
          else if(cek62 == '62'){
            replaced = "${noHpController.text.substring(2,noHpController.text.length)}";
          }
          else{
            replaced = "${noHpController.text}";
          }
          String no = "${codeCountry}${replaced}";
          var res = await MemberProvider().resendOtp(no,reffController.text,"register",_valType);
          if(res is ResendOtp){
            ResendOtp result = res;
            if(result.status == 'success'){
              setState(() {Navigator.pop(context);});
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      prefix1.SecondScreen(
                        pin:pinController.text,
                        name:nameController.text,
                        isMobile:"ya",
                        noHp:no,
                        kdReferral:reffController.text,
                        otp: result.result.otp,
                        statusOtp: result.result.statusOtp,
                      ),
                ),
              );
            }else{
              setState(() {Navigator.pop(context);});
              UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
            }
          }
          else{
            General results = res;
            setState(() {Navigator.pop(context);});
            UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
          }
        }

      }

    }


  }

  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  cek(var value) async{
    setState(() {
      monVal = value;
    });
    if(monVal == false){
      disableReferral = true;
      reffController..text = '';
    }else{
      disableReferral = false;
      reffController..text = '-';
    }
  }

  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue1 = value;
      switch (_radioValue1) {
        case 'available':
          reffController.text = '';
          break;
        case 'notAvailable':
          reffController.text = '-';
          break;
      }
    });
  }
  void _handleRadioValueChange2(String value) {
    setState(() {
      _radioValue2 = value;
      switch (_radioValue2) {
        case 'gallery':
          setState(() {
            _image = null;
          });

          break;
        case 'camera':
          setState(() {
            _image = null;
          });
          break;
      }
    });
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  Color warna1;
  Color warna2;
  String statusLevel ='0';
  Future loadTheme() async{
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
      statusLevel = levelStatus;
    });
  }

  bool typeOtp = true;
  TypeOtpModel typeOtpModel;
  String _valType='whatsapp' ;  //Ini untuk menyimpan value data friend
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
          Navigator.pop(context);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTheme();
    loadTheme();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar:UserRepository().appBarWithButton(context, "Form Pendaftaran",warna1,warna2,(){Navigator.of(context).pop();},Container()),
      body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(left:10.0,right:10.0),
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
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Lengkapi Form Dibawah Ini ..",style: TextStyle(fontWeight:FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(40))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider()
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nama",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(30))),
                        TextFormField(
                          style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                          autofocus: false,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtilQ.getInstance().setSp(30))),
                          focusNode: nameFocus,
                          onFieldSubmitted: (term){
                            _fieldFocusChange(context, nameFocus, nohpFocus);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: ScreenUtilQ.getInstance().setHeight(50)),
                        RichText(
                          text: TextSpan(
                            text: 'No WhatsApp ',
                            style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontSize:12),
                            children: <TextSpan>[
                              TextSpan(text: '( Silahkan Masukan No WhatsApp Yang Akan Anda Daftarkan )', style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 10,color:Colors.green,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
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
                                textStyle: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily: 'Rubik'),
                              ),
                              width: MediaQuery.of(context).size.width/3.1-30.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/1.5-18.0,
                              child: TextFormField(
                                style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                                controller: noHpController,
                                keyboardType: TextInputType.number,
                                focusNode: nohpFocus,
                                onFieldSubmitted: (term){
                                  _fieldFocusChange(context, nohpFocus, pinFocus);
                                },
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30))),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: ScreenUtilQ.getInstance().setHeight(50)),
                        RichText(
                          text: TextSpan(
                            text: 'PIN ',
                            style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontSize:12),
                            children: <TextSpan>[
                              TextSpan(text: '( buat pin sebanyak 6 digit )', style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 10,color:Colors.green,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                          obscureText: _secureText,
                          maxLengthEnforced: true,
                          controller: pinController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30)),
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: pinFocus,
                          onFieldSubmitted: (term){
                            _fieldFocusChange(context, pinFocus, confirmPinFocus);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: ScreenUtilQ.getInstance().setHeight(50)),
                        RichText(
                          text: TextSpan(
                            text: 'Konfirmasi PIN',
                            style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontSize:12),
                            children: <TextSpan>[
//                              TextSpan(text: '( buat pin sebanyak 6 digit )', style: TextStyle(fontFamily: "Rubik",fontSize: 10,color:Colors.green,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                          obscureText: _secureText,
                          maxLengthEnforced: true,
                          controller: confirmPinController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30)),
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: confirmPinFocus,
                          onFieldSubmitted: (term){
                            _fieldFocusChange(context, pinFocus, reffFocus);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: ScreenUtilQ.getInstance().setHeight(50)),
                        Text("Kode Referral",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(30))),
                        TextFormField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                          maxLengthEnforced: true,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30)),
                          ),
                          onChanged: (value) {
                            if (reffController.text != value.toUpperCase())
                              reffController.value = reffController.value.copyWith(text: value.toUpperCase());
                          },
                          controller: reffController,
                          keyboardType: TextInputType.number,
                          focusNode: reffFocus,
                          onFieldSubmitted: (term){
                            reffFocus.unfocus();
                          },
                          textInputAction: TextInputAction.done,
                        )
                      ],
                    ),
                  ),




                  typeOtp==true? Padding(
                    padding: EdgeInsets.only(left:16.0,right:16.0,top:16.0,bottom:0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Kirim OTP Via ?", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),),
                        SizedBox(height:10.0),
                        DropdownButton(
                          isDense: true,
                          isExpanded: true,
                          hint: Text("Kirim OTP Via ?",style: TextStyle(fontFamily: 'Rubik'),),
                          value: _valType,
                          items: _type.map((value) {
                            return DropdownMenuItem(
                              child: Text(value,style: TextStyle(fontFamily: 'Rubik',fontSize: ScreenUtilQ.getInstance().setSp(30))),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _valType = value;
                            });
                          },
                        )
                      ],
                    ),
                  ):Container(),
                  SizedBox(height: 20.0),
                  UserRepository().buttonQ(context, warna1,warna2,()async{
                    setState(() {
                      UserRepository().loadingQ(context);
                    });
                    create();

                  }, false,'Simpan')

                ],
              ),
            ),
          ],
        ),
//      bottomNavigationBar: _bottomNavBarBeli(context),
    );
  }


}

