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
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'file:///E:/THAIBAH/mobile/thaibah-app/lib/UI/component/auth/loginPhone.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';

import '../../Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:http/http.dart' as http;

import '../../Widgets/pin_screen.dart';
import '../profile/myProfile.dart';

class Regist extends StatefulWidget {
  final String kdReferral;
  Regist({this.kdReferral});
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  var nameController      = TextEditingController();
  var noHpController      = TextEditingController();
  var passwordController  = TextEditingController();
  var pinController       = TextEditingController();
  var confirmPinController= TextEditingController();
  var reffController      = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode nohpFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();
  final FocusNode confirmPinFocus = FocusNode();
  final FocusNode reffFocus = FocusNode();
  final userRepository = UserRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String codeCountry = '',no='',_valType='whatsapp';
  bool _secureText = true,_secureText1 = true,typeOtp = true;
  TypeOtpModel typeOtpModel;
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
  _callBackPin(BuildContext context, bool isTrue) async{
    UserRepository().loadingQ(context);
    var res = await createMemberBloc.fetchCreateMember(pinController.text,nameController.text,'ya',no,reffController.text);
    if(res is General){
      General result = res;
      if(result.status == 'success'){
        Navigator.of(context).pop();
        if(widget.kdReferral!=''){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialogQ(
                  alertTitle: richTitle("Berhasil"),
                  alertSubtitle: richSubtitle("Anda Berhasil Menambahkan Member"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Kembali",style: TextStyle(fontFamily: ThaibahFont().fontQ),),
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyProfile()), (Route<dynamic> route) => false);
//                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => JaringanUI(name:widget.namaOld,kdReferral: widget.kdReferral)), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              }
          );
        }
        else{
          UserRepository().notifAlertQ(context, 'success', 'Berhasil', 'Pendaftaran berhasil dilakukan', 'Kembali','Masuk',(){
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(new CupertinoPageRoute(builder: (BuildContext context)=>LoginPhone()), (Route<dynamic> route) => false);
          },(){
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(new CupertinoPageRoute(builder: (BuildContext context)=>LoginPhone()), (Route<dynamic> route) => false);
          });
        }
      }else{
        Navigator.of(context).pop();
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
      }
    }else{
      General result = res;
      Navigator.of(context).pop();
      UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
    }
  }
  Future create() async {
    final checkConnection = await userRepository.check();
    if(checkConnection == false){
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
          setState(() {
            no = "${codeCountry}${replaced}";
          });
          var res = await MemberProvider().resendOtp(no,reffController.text,"register",_valType);
          if(res is ResendOtp){
            ResendOtp result = res;
            if(result.status == 'success'){
              setState(() {Navigator.pop(context);});
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  new CupertinoPageRoute(builder: (BuildContext context)=>PinScreen(param: result.result.otp.toString(),
                      callback: _callBackPin
                  )), (Route<dynamic> route) => false
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
    if(widget.kdReferral!=''){
      reffController.text=widget.kdReferral;
    }
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
                UserRepository().textQ("Nama",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                      UserRepository().fieldFocusChange(context, nameFocus, nohpFocus);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          textStyle: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily: 'Rubik',fontWeight: FontWeight.bold,color:Colors.grey),
                        ),
                        width: MediaQuery.of(context).size.width/5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
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
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (term){
                            UserRepository().fieldFocusChange(context, nohpFocus, pinFocus);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                UserRepository().textQ("PIN Harus 6 Digit",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                      UserRepository().fieldFocusChange(context, pinFocus, confirmPinFocus);
                    },

                  ),
                ),
                SizedBox(height: 10.0),
                UserRepository().textQ("Konfirmasi PIN",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                      UserRepository().fieldFocusChange(context, confirmPinFocus, reffFocus);
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                UserRepository().textQ("Kode Referral",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                    readOnly: widget.kdReferral!=''?true:false,
                    // enabled: widget.kdReferral!=''?true:false,
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
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
                              UserRepository().textQ(value,12,Colors.grey,FontWeight.bold,TextAlign.left)
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
    );
  }
}


