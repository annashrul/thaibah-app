import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/Model/createMemberModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/registUIModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Widgets/responsive_ui.dart';
import 'package:thaibah/UI/jaringan_ui.dart';
import 'package:thaibah/UI/profile_ui.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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


enum SingingCharacter { lafayette, jefferson }

class CreateMember extends StatefulWidget {
  CreateMember({this.kdReff}) : super();
  final String kdReff;
  @override
  _CreateMemberState createState() => _CreateMemberState();
}

class _CreateMemberState extends State<CreateMember> {
  String status = '';

  Future<File> file;
  String base64Image;
  File tmpFile;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  var pinController   = TextEditingController();
  var nameController = TextEditingController();
  var reffController = TextEditingController();
  var noHpController = TextEditingController();

  final FocusNode pinFocus       = FocusNode();
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
    print(no);
//    if(codeCountry == ''){
//      setState(() {
//        codeCountry = "62";
//      });
//    }
//    String rplc = noHpController.text[0];
//    String replaced = '';
//    if(rplc == '0'){
//      print("nu kahiji 0");
//      print("####################${noHpController.text.substring(1,noHpController.text.length)}####################");
//      replaced = "${noHpController.text.substring(1,noHpController.text.length)}";
//    }else{
//      replaced = "${noHpController.text}";
//      print("nu kahiji lain 0");
//    }
//    String no = "${codeCountry}${replaced}";
    var res = await MemberProvider().resendOtp(no,reffController.text,"register");
    if(res is ResendOtp){
      ResendOtp result = res;
      print(result.status);
      if(result.status == 'success'){
        setState(() {_isLoading = false;});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
//              pin:pinController.text,
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
        return showInSnackBar(result.msg);
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      return showInSnackBar(results.msg);
    }

  }

  getImageFile() async {
//    print('image 1');
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


  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text("Tambah Jaringan",style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: _form(),
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

              onPressed: (){
                if (nameController.text == "") {
                  return showInSnackBar("Nama Harus Disi");
                }else if(noHpController.text == ""){
                  return showInSnackBar("No Handphone Harus Disi");
                }else if(reffController.text == ""){
                  return showInSnackBar("Kode Referral Harus Disi");
                }
//                else if(pinController.text == ""){
//                  return showInSnackBar("PIN Harus Diisi");
//                }else if(_image == null || _image == ""){
//                  return showInSnackBar("Silahkan Upload Photo KTP");
//                }
                else {
//                  if(pinController.text.length < 6){
//                    return showInSnackBar("PIN Yang Anda Masukan Kurang Dari 6 Digit");
//                  }else{
//                    setState(() {_isLoading = true;});
//                    create();
//                  }
                  setState(() {_isLoading = true;});
                  create();

                }
              },
              child:_isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Text("Daftar", style: TextStyle(color: Colors.white)),
            )
          )
        ],
      ),
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
                padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Nama",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
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
                    Text("No WhatsApp",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Kode Refferal",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    TextFormField(
                      readOnly: true,
                      enableInteractiveSelection: false, // will disable paste operation
                      enabled: false,
                      controller: reffController..text = widget.kdReff,
                      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
//              Padding(
//                padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text("PIN (buat pin sebanyak 6 digit)",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//                    TextFormField(
//                      obscureText: _secureText,
//                      maxLength: 6,
//                      maxLengthEnforced: true,
//                      controller: pinController,
//                      decoration: InputDecoration(
//                          suffixIcon: IconButton(onPressed: showHide,icon: Icon(_secureText? Icons.visibility_off: Icons.visibility)),
//                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
//                      ),
//                      keyboardType: TextInputType.number,
//                      maxLines: null,
//                      textInputAction: TextInputAction.done,
//                      focusNode: pinFocus,
//                      onFieldSubmitted: (term){
//                        pinFocus.unfocus();
//                      },
//                    ),
//                  ],
//                ),
//              ),
//              Padding(
//                padding: EdgeInsets.only(left:16.0,right:16.0,top:16.0,bottom:0.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text("Silahkan Upload atau Ambil Photo KTP",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//                    Container(
//                        width: double.infinity,
//                        margin: EdgeInsets.only(top:10.0),
//                        child: OutlineButton(
//                          borderSide: BorderSide(color: Colors.grey,width: 1.0),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Radio(
//                                    value: 'camera',
//                                    groupValue: _radioValue1,
//                                    onChanged: _handleRadioValueChange1,
//                                  ),
//                                  new Text('Kamera',style: new TextStyle(fontSize: 11.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//                                  Radio(
//                                    value: 'gallery',
//                                    groupValue: _radioValue1,
//                                    onChanged: _handleRadioValueChange1,
//                                  ),
//                                  new Text('Galeri',style: new TextStyle(fontSize: 11.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//                                ],
//                              ),
//                              SizedBox(height: ScreenUtil.getInstance().setHeight(50),),
//                              _radioValue1 == 'camera' ? Icon(Icons.camera_alt) : Icon(Icons.folder),
//                              _image == null ? _radioValue1 == 'camera' ? Text('Ambil Photo',style: new TextStyle(fontSize: 11.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)) : Text('Upload Photo',style: new TextStyle(fontSize: 11.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)) : Text('$_image',style: new TextStyle(fontSize: 11.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//                              SizedBox(height: ScreenUtil.getInstance().setHeight(50),),
//                            ],
//                          ),
//                          onPressed: () => getImageFile(),
//
//                        )
//                    ),
//                  ],
//                ),
//              ),
//
//              Flexible(
//                  child: _image == null ? new Center(child: Text('')): Container(
//                    padding: EdgeInsets.only(left:16.0,right:16.0),
//                    child: new Image.file(_image,fit: BoxFit.fill,filterQuality: FilterQuality.high,),
//                  )
//              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget imgPicker(){
    return Container(
      height: 100,
      child: _image == null
          ? new Text('Tidak ada gambar dipilih')
          : new Image.file(_image),
    );
  }

  Widget pickerImg(){
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    bool large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    bool medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return MaterialButton(
      elevation: large? 4 : (medium? 3 : 2),
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      onPressed: () async {

      },
      textColor: Colors.black45,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/1.2,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
        ),
        child: Text('Ambil Gambar',style: TextStyle(fontSize: _large? 19: (_medium? 17: 15))),
      ),
    );
  }


}


class OtpPage extends StatefulWidget {
  final String /*pin,*/name,isMobile,noHp,kdReferral/*,ktp*/,otp,statusOtp;
  OtpPage({
    Key key,
    @required
//    this.pin,
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
  final _txtOtp = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool alreadyLogin = false;

  bool _apiCall = false;

  String _response = '';
  bool _isLoading = false;

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
//      widget.pin,
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
              return RichAlertDialog(
                alertTitle: richTitle("Berhasil"),
                alertSubtitle: richSubtitle("Anda Berhasil Menambahkan Member"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ProfileUI()), (Route<dynamic> route) => false);
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
      key: scaffoldKey,

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
        title: new Text("Keamanan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                'assets/images/verify.png',
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Masukan Kode OTP',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Rubik'),textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
                child: Text(
                  'Masukan kode OTP yang telah kami kirim melalui pesan ke no whatsApp anda',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,fontFamily: 'Rubik'),textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
                  child: Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: otpInput(),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  // receive data from the FirstScreen as a parameter


  Widget otpInput() {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: PinPut(
            fieldsCount: 4,
            onSubmit: (String txtOtp) => _check(txtOtp, context),
            actionButtonsEnabled: false,
          ),
        ),
      ),
    );
  }

  Future _check(String txtOtp,  BuildContext context) {
    if (widget.otp == txtOtp) {
      print("object1");
      print(widget.otp);
      print(txtOtp);
      setState((){
        _isLoading = true;
//        _apiCall=true; // Set state like this
      });
      create();
    } else {
      setState(() {_isLoading = false;});
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('kode otp tidak sesuai')));
      txtOtp.replaceRange(0, 3, '');
      print("object2");
      print(widget.otp);
      print(txtOtp);
    }
  }
}