import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/registUIModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/UI/component/myProfile.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';


class CreateMember extends StatefulWidget {
  CreateMember({this.kdReff,this.nama}) : super();
  final String kdReff;
  final String nama;
  @override
  _CreateMemberState createState() => _CreateMemberState();
}

class _CreateMemberState extends State<CreateMember> {
  String status = '';

  Future<File> file;
  String base64Image;
  File tmpFile;
  var pinController   = TextEditingController();
  var confirmPinController   = TextEditingController();
  var nameController = TextEditingController();
  var reffController = TextEditingController();
  var noHpController = TextEditingController();

  final FocusNode pinFocus       = FocusNode();
  final FocusNode confirmPinFocus       = FocusNode();
  final FocusNode nameFocus       = FocusNode();
  final FocusNode reffFocus       = FocusNode();
  final FocusNode nohpFocus       = FocusNode();
  String codeCountry = '';
  bool get hasFocus => false;

  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  File _image;
  bool apiCall = false;
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
  String _radioValue1 = 'gallery';

  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue1 = value;
      switch (_radioValue1) {
        case 'gallery':
          print(_radioValue1);
          _image = null;
//          reffController.text = '';
          break;
        case 'camera':
          print(_radioValue1);
          _image = null;
//          reffController.text = '-';
          break;
      }
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
    }else if(cek62 == '62'){
      replaced = "${noHpController.text.substring(2,noHpController.text.length)}";
    }
    else{
      replaced = "${noHpController.text}";
      print("nu kahiji lain 0");
    }
    String no = "${codeCountry}${replaced}";

    var res = await MemberProvider().resendOtp(no,reffController.text,"register",'whatsapp');
    if(res is ResendOtp){
      ResendOtp result = res;
      print(result.result.otp);
      print(result.status);
      if(result.status == 'success'){
        setState(() {_isLoading = false;});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              namaOld:widget.nama,
              pin:pinController.text,
              name:nameController.text,
              isMobile:"ya",
              noHp:no,
              kdReferral:reffController.text,
//              ktp: 'data:image/png;base64;' + base64Encode(_image.readAsBytesSync()),
              otp: result.result.otp,
              statusOtp: result.result.statusOtp,
            ),
          ),
        );
      }else{
        setState(() {_isLoading = false;});
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
    }

  }

  getImageFile() async {
    var image = await ImagePicker.pickImage(source: _radioValue1 == 'camera' ? ImageSource.camera : ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
//        CropAspectRatioPreset.ratio3x2,
//        CropAspectRatioPreset.original,
//        CropAspectRatioPreset.ratio4x3,
//        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      maxWidth: 512,
      maxHeight: 512,
    );
    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      croppedFile.path,
      quality: 100,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });
  }

  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTheme();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Tambah Jaringan",(){Navigator.pop(context);},<Widget>[]),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: _form(),
    );
  }


  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  Widget _form(){
    return ListView(
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
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Nama",style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(fontFamily: ThaibahFont().fontQ),
                      controller: nameController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      focusNode: nameFocus,
                      onFieldSubmitted: (term){
                        nameFocus.unfocus();
                        _fieldFocusChange(context, nameFocus, nohpFocus);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 0, top: 10, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'No WhatsApp ',
                        style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),
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
                          ),
                          width: MediaQuery.of(context).size.width/3.1-30.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/1.5-18.0,
                          child: TextFormField(
                            maxLength: 15,
                            style: TextStyle(fontFamily: ThaibahFont().fontQ),
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
                            decoration: InputDecoration(hintStyle: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontSize: 12.0)),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'PIN ',
                        style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),
//                        style: TextStyle(color:Colors.black,fontFamily: "Rubik",fontSize:ScreenUtil.getInstance().setSp(26)),
                        children: <TextSpan>[
                          TextSpan(text: '( buat pin sebanyak 6 digit )', style: TextStyle(fontFamily: ThaibahFont().fontQ,fontSize: 10,color:Colors.green,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    TextFormField(
                      obscureText: _secureText,
                      maxLength: 6,
                      style: TextStyle(fontFamily: ThaibahFont().fontQ),
                      maxLengthEnforced: true,
                      controller: pinController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: pinFocus,
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, pinFocus, confirmPinFocus);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Konfirmasi PIN ',
                        style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),
//                        style: TextStyle(color:Colors.black,fontFamily: "Rubik",fontSize:ScreenUtil.getInstance().setSp(26)),
                        children: <TextSpan>[
//                              TextSpan(text: '( buat pin sebanyak 6 digit )', style: TextStyle(fontFamily: "Rubik",fontSize: 10,color:Colors.green,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(fontFamily: ThaibahFont().fontQ),
                      obscureText: _secureText,
                      maxLength: 6,
                      maxLengthEnforced: true,
                      controller: confirmPinController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: confirmPinFocus,
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, confirmPinFocus, reffFocus);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Kode Refferal",style: TextStyle(color:Colors.black,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                    TextFormField(
                      readOnly: true,
                      enableInteractiveSelection: false, // will disable paste operation
                      enabled: false,
                      controller: reffController..text = widget.kdReff,
                      decoration: InputDecoration(hintStyle: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontSize: 12.0)),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
              UserRepository().buttonQ(context,(){
                if (nameController.text == "") {
                  UserRepository().notifNoAction(_scaffoldKey, context,"Nama Harus Diisi","failed");
                }else if(noHpController.text == ""){
                  UserRepository().notifNoAction(_scaffoldKey, context,"No WhatsApp Harus Diisi","failed");
                }else if(reffController.text == ""){
                  UserRepository().notifNoAction(_scaffoldKey, context,"Kode Referral Harus Diisi","failed");
                }
                else {
                  if(pinController.text != confirmPinController.text){
                    pinController.clear();
                    confirmPinController.clear();
                    UserRepository().notifNoAction(_scaffoldKey, context,"PIN Yang Anda Masuka Tidak Sesuai","failed");
                  }else{
                    setState(() {_isLoading = true;});
                    create();
                  }
                }
              }, 'Simpan')
            ],
          ),
        ),
      ],
    );
  }
}


class OtpPage extends StatefulWidget {
  final String namaOld,pin,name,isMobile,noHp,kdReferral/*,ktp*/,otp,statusOtp;
  OtpPage({
    Key key,
    @required
    this.namaOld,
    this.pin,
    this.name,
    this.isMobile,
    this.noHp,
    this.kdReferral,
//    this.ktp,
    this.otp,
    this.statusOtp
  }) : super(key: key);

  @override
  _OtpPageStatefulState createState() => _OtpPageStatefulState();

}

class _OtpPageStatefulState extends State<OtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool alreadyLogin = false;
  var currentText;

  String _response = '';
  bool _isLoading = false;

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
    if(res is General){
      General result = res;
      print(result.status);
      if(result.status == 'success'){
        setState(() {
          Navigator.pop(context);
        });
        print("#####################################################BERHASIL#######################################");
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
      }else{
        Navigator.of(context).pop();
        setState(() {_isLoading = false;});
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result.msg)));
      }
    }else{
      Navigator.of(context).pop();
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
//                _check(currentText.toString(),context);
              }
          ),
        )
    );
//
//
//    return Scaffold(
//      key: scaffoldKey,
//
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
//                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
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
//
//  Future _check(String txtOtp,  BuildContext context) {
//    if (widget.otp == txtOtp) {
//      print("object1");
//      print(widget.otp);
//      print(txtOtp);
//      setState((){
//        _isLoading = true;
////        _apiCall=true; // Set state like this
//      });
//      create();
//    } else {
//      setState(() {_isLoading = false;});
//      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('kode otp tidak sesuai')));
//      txtOtp.replaceRange(0, 3, '');
//      print("object2");
//      print(widget.otp);
//      print(txtOtp);
//    }
//  }
}