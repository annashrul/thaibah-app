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
  bool _secureText1 = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  showHide1() {
    setState(() {
      _secureText1 = !_secureText1;
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
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        nameFocus.requestFocus();
      }
      else if(noHpController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"No WhatsApp Harus Diisi","failed");
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        nohpFocus.requestFocus();
      }
      else if(pinController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"PIN Harus Diisi","failed");
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        pinFocus.requestFocus();
      }
      else if(confirmPinController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"Konfirmasi PIN Harus Diisi","failed");
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        confirmPinFocus.requestFocus();
      }
      else if(reffController.text == ""){
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(_scaffoldKey, context,"Kode Referral Harus Diisi","failed");
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        reffFocus.requestFocus();
      }
      else if(pinController.text != confirmPinController.text){
        setState(() {Navigator.pop(context);});
        pinController.clear();
        confirmPinController.clear();
        UserRepository().notifNoAction(_scaffoldKey, context,"PIN Yang Anda Masuka Tidak Sesuai","failed");
        await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
        confirmPinFocus.requestFocus();

      }
      else{
        if(pinController.text.length > 6 || pinController.text.length < 6){
          setState(() {Navigator.pop(context);});
          pinController.clear();
          UserRepository().notifNoAction(_scaffoldKey, context,"PIN Tidak Boleh Lebih atau kurang Dari 6 Digit","failed");
          await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
          pinFocus.requestFocus();
        }
        else if(confirmPinController.text.length > 6 || confirmPinController.text.length < 6){
          setState(() {Navigator.pop(context);});
          confirmPinController.clear();
          UserRepository().notifNoAction(_scaffoldKey, context,"Konfirmasi PIN Tidak Boleh Lebih atau kurang Dari 6 Digit","failed");
          await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
          confirmPinFocus.requestFocus();
        }
        else if(pinController.text[0]=='0' || confirmPinController.text[0]=='0'){
          setState(() {Navigator.pop(context);});
          pinController.clear();
          confirmPinController.clear();
          UserRepository().notifNoAction(_scaffoldKey, context,"PIN dan Konfirmasi PIN Tidak Boleh Diawali Angka 0","failed");
          await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
          pinFocus.requestFocus();
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
      appBar: UserRepository().appBarWithButton(context, "Form Pendaftaran",(){Navigator.pop(context);},<Widget>[]),
      body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(left:15.0,right:15.0,bottom: 10.0),
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
                  UserRepository().textQ("Nama",10,Colors.black,FontWeight.bold,TextAlign.left),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: nameController,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      focusNode: nameFocus,
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, nameFocus, nohpFocus);
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  UserRepository().textQ("Masukan No WhatsApp Yang Akan Anda Daftarkan",10,Colors.black,FontWeight.bold,TextAlign.left),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:  Row(
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
                            style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                            controller: noHpController,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[200]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: nohpFocus,
                            onFieldSubmitted: (term){
                              _fieldFocusChange(context, nohpFocus, pinFocus);
                            },
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  UserRepository().textQ("PIN Harus 6 Digit",10,Colors.black,FontWeight.bold,TextAlign.left),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      maxLength: 6,
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: pinController,
                      obscureText: _secureText,
                      maxLengthEnforced: true,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility, color: Colors.black,)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: pinFocus,
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, pinFocus, confirmPinFocus);
                      },

                    ),
                  ),
                  SizedBox(height: 10.0),
                  UserRepository().textQ("Konfirmasi PIN",10,Colors.black,FontWeight.bold,TextAlign.left),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      maxLength: 6,
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: confirmPinController,
                      obscureText: _secureText1,
                      maxLengthEnforced: true,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: IconButton(onPressed: showHide1,icon: Icon(_secureText1? Icons.visibility_off: Icons.visibility, color: Colors.black,)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: confirmPinFocus,
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, confirmPinFocus, reffFocus);
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  UserRepository().textQ("Kode Referral",10,Colors.black,FontWeight.bold,TextAlign.left),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: reffController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLengthEnforced: true,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: reffFocus,
                      onFieldSubmitted: (term){
                        reffFocus.unfocus();
                      },
                      onChanged: (value) {
                        if (reffController.text != value.toUpperCase())
                          reffController.value = reffController.value.copyWith(text: value.toUpperCase());
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  typeOtp==false?Container():UserRepository().textQ("Kirim OTP Via ??",12,Colors.black,FontWeight.bold,TextAlign.left),
                  typeOtp==false?Container():SizedBox(height: 10.0),
                  typeOtp==false?Container():Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: DropdownButton<String>(
                        isDense: true,
                        isExpanded: true,
                        value: _valType,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        underline: SizedBox(),
                        onChanged: (value) {
                          setState(() {
                            _valType = value;
                          });
                        },
                        items: <String>['whatsapp', 'sms'].map<DropdownMenuItem<String>>((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                UserRepository().textQ(value,10,Colors.black,FontWeight.bold,TextAlign.left)
                              ],
                            ),
                          );
                        }).toList(),

                      )
                  ),
                  SizedBox(height: typeOtp==false?0.0:10.0),
                  UserRepository().buttonQ(context,()async{
                    setState(() {
                      UserRepository().loadingQ(context);
                    });
                    create();
                  },'Simpan')
                ],
              ),
            ),
          ],
        ),
//      bottomNavigationBar: _bottomNavBarBeli(context),
    );
  }


}

