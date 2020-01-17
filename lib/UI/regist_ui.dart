import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/regist_pin_ui.dart' as prefix1;
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';

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
  var reffController      = TextEditingController();
  var noHpController      = TextEditingController();
  var addressController   = TextEditingController();
  var genderController    = TextEditingController();
  var ktpController       = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode nohpFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();
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
    if(codeCountry == ''){
      setState(() {
        codeCountry = "62";
      });
    }
    String indexHiji = noHpController.text[1];
    String rplc = noHpController.text[0];
    String replaced = '';
    String cek62 = "${rplc}${indexHiji}";

    print(replaced);
    if(rplc == '0'){
      print("nu kahiji 0");
      print("####################${noHpController.text.substring(1,noHpController.text.length)}####################");
      replaced = "${noHpController.text.substring(1,noHpController.text.length)}";
    }
    else if(cek62 == '62'){
      replaced = "${noHpController.text.substring(2,noHpController.text.length)}";
    }
    else{
      replaced = "${noHpController.text}";
      print("nu kahiji lain 0");
    }
    String no = "${codeCountry}${replaced}";
    print(no);
    final checkConnection = await userRepository.check();
    if(checkConnection == false){
      setState(() {_isLoading = false;});
      return showInSnackBar("Anda Tidak Terhubung Dengan Internet");
    }else{

      var res = await MemberProvider().resendOtp(no,reffController.text,"register");
      if(res is ResendOtp){
        ResendOtp result = res;
        print(result.status);
        if(result.status == 'success'){
          setState(() {_isLoading = false;});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => prefix1.SecondScreen(
//                pin:pinController.text,
                name:nameController.text,
                isMobile:"ya",
                noHp:no,
                kdReferral:reffController.text,
//                ktp: 'data:image/png;base64;' + base64Encode(_image.readAsBytesSync()),
                otp: result.result.otp,
                statusOtp: result.result.statusOtp,
              ),
            ),
          );
        }else{
          setState(() {_isLoading = false;});
          return showInSnackBar(result.msg);
        }
      }
      else{
        General results = res;
        setState(() {_isLoading = false;});
        return showInSnackBar(results.msg);
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
    print('cek');
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
          print(_radioValue1);
          reffController.text = '';
          break;
        case 'notAvailable':
          print(_radioValue1);
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
          print(_radioValue2);
          setState(() {
            _image = null;
          });

          break;
        case 'camera':
          print(_radioValue2);
          setState(() {
            _image = null;
          });
          break;
      }
    });
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
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        flexibleSpace: Container(
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
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Form Pendaftaran", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.all(10.0),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Lengkapi Form Dibawah Ini ..",style: TextStyle(fontWeight:FontWeight.bold,fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(40))),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nama",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),
                        TextFormField(
                          maxLength: 60,
                          autofocus: false,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          focusNode: nameFocus,
                          onFieldSubmitted: (term){
                            _fieldFocusChange(context, nameFocus, nohpFocus);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 0, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("No WhatsApp (Silahkan Masukan No WhatsApp Yang Akan Anda Daftarkan)",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),                        Row(
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
                            Container(
                              width: MediaQuery.of(context).size.width/1.5-18.0,
                              child: TextFormField(
                                maxLength: 15,
                                controller: noHpController,
                                keyboardType: TextInputType.number,
                                focusNode: nohpFocus,
                                onFieldSubmitted: (term){
                                  _fieldFocusChange(context, nohpFocus, pinFocus);
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text("PIN (buat pin sebanyak 6 digit)",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),
//                        TextFormField(
//                          obscureText: _secureText,
//                          maxLength: 6,
//                          maxLengthEnforced: true,
//                          controller: pinController,
//                          decoration: InputDecoration(
//                              suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
//                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
//                          ),
//                          keyboardType: TextInputType.number,
//                          focusNode: pinFocus,
//                          onFieldSubmitted: (term){
//                            _fieldFocusChange(context, pinFocus, reffFocus);
//                          },
//                          textInputAction: TextInputAction.next,
//                        ),
//                      ],
//                    ),
//                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16.0,right:16.0,top:16.0,bottom:0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Kode Referral",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),

                        TextFormField(
                          maxLength: 15,
                          maxLengthEnforced: true,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
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
//                  Padding(
//                    padding: EdgeInsets.only(left:16.0,right:16.0,top:16.0,bottom:0.0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text("Silahkan Upload atau Ambil Photo KTP",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),
//                        Container(
//                          width: double.infinity,
//                          margin: EdgeInsets.only(top:10.0),
//                          child: OutlineButton(
//                            borderSide: BorderSide(color: Colors.grey,width: 1.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    Radio(
//                                      value: 'camera',
//                                      groupValue: _radioValue2,
//                                      onChanged: _handleRadioValueChange2,
//                                    ),
//
//                                    new Text('Kamera',style: new TextStyle(fontSize: 11.0,fontFamily: "Rubik")),
//                                    Radio(
//                                      value: 'gallery',
//                                      groupValue: _radioValue2,
//                                      onChanged: _handleRadioValueChange2,
//                                    ),
//
//                                    new Text('Galeri',style: new TextStyle(fontSize: 11.0,fontFamily: "Rubik")),
//                                  ],
//                                ),
//                                SizedBox(height: ScreenUtil.getInstance().setHeight(50),),
//                                _radioValue2 == 'camera' ? Icon(Icons.camera_alt) : Icon(Icons.folder),
//                                _image == null ? _radioValue2 == 'camera' ? Text('Ambil Photo',style:TextStyle(fontFamily: "Rubik")) : Text('Upload Photo',style:TextStyle(fontFamily: "Rubik")) : Text('$_image',style:TextStyle(fontFamily: "Rubik")),
//                                SizedBox(height: ScreenUtil.getInstance().setHeight(50),),
//                              ],
//                            ),
//                            onPressed: () async {
//                              try{
//                                var image = await ImagePicker.pickImage(
//                                  source: _radioValue2 == 'camera' ? ImageSource.camera : ImageSource.gallery,
//                                  maxHeight: 600, maxWidth: 600,
//                                );
//                                setState(() {_image = image;});
//                              }catch(e){
//                                print(e);
//                              }
//                            },
//                          )
//                        ),
//                      ],
//                    ),
//                  ),
//                  Flexible(
//                      child: _image == null ? new Center(child: Text('')): Container(
//                        padding: EdgeInsets.only(left:16.0,right:16.0),
//                        child: new Image.file(_image,fit: BoxFit.fill,filterQuality: FilterQuality.high,),
//                      )
//                  ),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: _bottomNavBarBeli(context),
    );
  }


  Widget _bottomNavBarBeli(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
              ),
              width: MediaQuery.of(context).size.width/1,
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                onPressed: () async {
                  final checkConnection = await userRepository.check();
                  if(checkConnection == false){
                    setState(() {_isLoading = false;});
                    return showInSnackBar("Anda Tidak Terhubung Dengan Internet");
                  }else{
                    if (nameController.text == "") {
                      return showInSnackBar("Nama Harus Disi");
                    }else if(noHpController.text == ""){
                      return showInSnackBar("No Handphone Harus Disi");
                    }else if(reffController.text == ""){
                      return showInSnackBar("Kode Referral Harus Disi");
                    }
//                    else if(pinController.text == ""){
//                      return showInSnackBar("PIN Harus Disi");
//                    }else if(_image == null){
//                      return showInSnackBar("Silahkan Upload Photo KTP");
//                    }
                    else {
//                      if(pinController.text.length < 6){
//                        return showInSnackBar("PIN Yang Anda Masukan Kurang Dari 6 Digit");
//                      }else{
//                        setState(() {_isLoading = true;});
//                        create();
//                      }
                      setState(() {_isLoading = true;});
                      create();

                    }

                  }

//                  create();
                },
                child:_isLoading?Text('Pengecekan data ...', style: TextStyle(color: Colors.white)):Text("Daftar", style: TextStyle(color: Colors.white)),
              )
          )
        ],
      ),
    );
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF116240), Color(0xFF30cc23)],
              ),
              borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(90))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: AssetImage("assets/images/logoOnBoardTI.png"),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(padding:const EdgeInsets.only(bottom: 32, right: 32)),
              ),
            ],
          ),
        ),
      ],
    );
  }


}

