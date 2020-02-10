
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/resources/memberProvider.dart';

class UpdateDataDiri extends StatefulWidget {
  final String name;
  final String nohp;
  final String gender;
  final String picture;
  UpdateDataDiri({
    this.name,this.nohp,this.gender,this.picture
  });
  @override
  _UpdateDataDiriState createState() => _UpdateDataDiriState();
}

class _UpdateDataDiriState extends State<UpdateDataDiri> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var nameController = TextEditingController();
  var nohpController = TextEditingController();
  var jkController = TextEditingController();
  final FocusNode nameFocus       = FocusNode();
  final FocusNode nohpFocus       = FocusNode();

  String dropdownValue = 'pilih';
  Future<File> file;
  File _image;
  File _image2;
  bool _isLoading = false;
  String base64Image;
  String base64Image2;



  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    nohpController.text = widget.nohp;
    dropdownValue = widget.gender;

  }

  @override
  void dispose() {
    nameController.dispose();
    nohpController.dispose();
    super.dispose();
  }
  String fileName;
  String fileName2;
  String codeCountry = '';

  Future update() async {
    if(codeCountry == ''){
      setState(() {
        codeCountry = "62";
      });
    }
    String indexHiji = nohpController.text[1];
    String rplc = nohpController.text[0];
    String replaced = '';
    String cek62 = "${rplc}${indexHiji}";

    print(replaced);
    if(rplc == '0'){
      print("nu kahiji 0");
      print("####################${nohpController.text.substring(1,nohpController.text.length)}####################");
      replaced = "${nohpController.text.substring(1,nohpController.text.length)}";
    }
    else if(cek62 == '62'){
      replaced = "${nohpController.text.substring(2,nohpController.text.length)}";
    }
    else{
      replaced = "${nohpController.text}";
      print("nu kahiji lain 0");
    }
    String no = "${codeCountry}${replaced}";

    if(_image != null){
      fileName = _image.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(_image.readAsBytesSync());
    }else{
      base64Image = "";
    }

    if(_image2 != null){
      fileName2 = _image2.path.split("/").last;
      var type = fileName2.split('.');
      base64Image2 = 'data:image/' + type[1] + ';base64,' + base64Encode(_image2.readAsBytesSync());
    }else{
      base64Image2 = "";
    }

    String cloneHp = '';

    print("${nameController.text}-${nohpController.text}-${dropdownValue}");

    if(widget.nohp != nohpController.text){
      setState(() {_isLoading = false;});
      var res = await MemberProvider().resendOtp(no,'-',"update");
      if(res is ResendOtp){
        ResendOtp result = res;
        print(result.status);
        if(result.status == 'success'){
          setState(() {_isLoading = false;});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpUpdate(
                otp: result.result.otp,
                name:nameController.text,
                nohp: nohpController.text,
                gender:dropdownValue,
                profile:base64Image,
                cover:base64Image2
              ),
            ),
          );
        }else{
          setState(() {_isLoading = false;});
          return showInSnackBar(result.msg,'gagal');
        }
      }
      else{
        General results = res;
        setState(() {_isLoading = false;});
        return showInSnackBar(results.msg,'gagal');
      }
    }
    else{
      var res = await updateMemberBloc.fetchUpdateMember(nameController.text, no, dropdownValue,base64Image, base64Image2,'');
      if(res.status == 'success'){
        print(dropdownValue);
        setState(() {_isLoading = false;});
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
        });
        return showInSnackBar(res.msg,'sukses');

      }else{
        setState(() {_isLoading = false;});
        return showInSnackBar(res.msg,'gagal');
      }
    }


  }
  getImageFile(ImageSource source) async {
    print('image 1');
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
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
      '/data/user/0/com.thaibah/cache/${image.path.substring(51,image.path.length)}',
      quality: 50,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });
  }

  getImageFile2(ImageSource source) async {
    print('image 2');
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
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
      '/data/user/0/com.thaibah/cache/${image.path.substring(51,image.path.length)}',
      quality: 50,
    );

    setState(() {
      _image2 = result;
      print(_image2.lengthSync());
    });
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  void showInSnackBar(String value,String param) {
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
      backgroundColor: param=='sukses'?Colors.green:Colors.redAccent,
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
        title: new Text("Data Diri", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: _form(),
    );
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
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 0, top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("No WhatsApp  (Silahkan Masukan No WhatsApp Yang Akan Anda Daftarkan) ",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            maxLength: 15,
                            controller: nohpController,
                            keyboardType: TextInputType.number,
                            focusNode: nohpFocus,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize:20),
                  ),
                  isEmpty: dropdownValue == null,
                  child: new DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          _onDropDownItemSelectedGender(newValue);
                        });
                      },
                      items: <String>['pilih','male', 'female'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:16,right:16,top:10,bottom:8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: ScreenUtil.getInstance().setHeight(130),
                      child: new OutlineButton(
                        borderSide: BorderSide(color: Colors.grey,width: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: ScreenUtil.getInstance().setHeight(30),),
                            Icon(Icons.cloud_upload),
                            _image == null || _image == "" ? Text('pilih photo profile',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red)) : Text('photo profile sudah dipilih',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green))
                          ],
                        ),
                        onPressed: () => getImageFile(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left:16,right:16,top:10,bottom:8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: ScreenUtil.getInstance().setHeight(130),
                      child: new OutlineButton(
                        borderSide: BorderSide(color: Colors.grey,width: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: ScreenUtil.getInstance().setHeight(30),),
                            Icon(Icons.cloud_upload),
                            _image2 == null || _image2 == "" ? Text('pilih photo cover',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red)) : Text('photo cover sudah dipilih',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green))
                          ],
                        ),
                        onPressed: () => getImageFile2(ImageSource.gallery),
//                        onPressed: () async {
//                          try{
//                            var image = await ImagePicker.pickImage(
//                              source: ImageSource.gallery,
//                              maxHeight: 600, maxWidth: 600,
//                            );
//                            setState(() {
//                              _image2 = image;
//                            });
//                          }catch(e){
//                            print(e);
//                          }
//                        },
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (nameController.text == "") {
                          return showInSnackBar("Nama Harus Disi",'gagal');
                        }
                        else if(nohpController.text == ""){
                          return showInSnackBar("No Handphone Harus Disi",'gagal');
                        }
                        else {
                          setState(() {_isLoading = true;});
                          update();
                        }
                      },
                      icon: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Icon(Icons.arrow_forward),
                    ),
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }
  void _onDropDownItemSelectedGender(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());

      dropdownValue = val;
    });
  }
  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
//  File _image;
//
//  getImageFile(ImageSource source) async {
//
//    //Clicking or Picking from Gallery
//
//    var image = await ImagePicker.pickImage(source: source);
////    print(image.readAsStringSync());
//    //Cropping the image
//    print(image.path.substring(51,image.path.length));
//    File croppedFile = await ImageCropper.cropImage(
//      sourcePath: image.path,
//      aspectRatioPresets: [
//        CropAspectRatioPreset.square,
//      ],
//      androidUiSettings: AndroidUiSettings(
//          toolbarTitle: 'Cropper',
//          toolbarColor: Colors.deepOrange,
//          toolbarWidgetColor: Colors.white,
//          initAspectRatio: CropAspectRatioPreset.original,
//          lockAspectRatio: false),
//      iosUiSettings: IOSUiSettings(
//        minimumAspectRatio: 1.0,
//      ),
//      maxWidth: 512,
//      maxHeight: 512,
//    );
////
//////    File croppedFile = await ImageCropper.cropImage(
//////      sourcePath: image.path,
//////      ratioX: 1.0,
//////      ratioY: 1.0,
//////      maxWidth: 512,
//////      maxHeight: 512,
//////    );
////
////    //Compress the image
////    print(croppedFile.path);
////    var rng = new Random();
////    var l = new List.generate(12, (_) => rng.nextInt(100));
//
//    var result = await FlutterImageCompress.compressAndGetFile(
//      croppedFile.path,
//      '/data/user/0/com.thaibah/cache/${image.path.substring(51,image.path.length)}',
//      quality: 50,
//    );
////    print('/data/user/0/com.thaibah/cache/$l');
////
//    setState(() {
//      _image = result;
//      print(_image.lengthSync());
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print(_image?.lengthSync());
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Click | Pick | Crop | Compress"),
//      ),
//      body: Center(
//        child: _image == null
//            ? Text("Image")
//            : Image.file(
//          _image,
//          height: 200,
//          width: 200,
//        ),
//      ),
//      floatingActionButton: Row(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          FloatingActionButton.extended(
//            label: Text("Camera"),
//            onPressed: () => getImageFile(ImageSource.camera),
//            heroTag: UniqueKey(),
//            icon: Icon(Icons.camera),
//          ),
//          SizedBox(
//            width: 20,
//          ),
//          FloatingActionButton.extended(
//            label: Text("Gallery"),
//            onPressed: () => getImageFile(ImageSource.gallery),
//            heroTag: UniqueKey(),
//            icon: Icon(Icons.photo_library),
//          )
//        ],
//      ),
//    );
//  }

}


class OtpUpdate extends StatefulWidget {
  final String otp;
  final String name;
  final String nohp;
  final String gender;
  final String profile;
  final String cover;
  OtpUpdate({this.otp,this.name,this.nohp,this.gender,this.profile,this.cover});
  @override
  _OtpUpdateState createState() => _OtpUpdateState();
}

class _OtpUpdateState extends State<OtpUpdate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool alreadyLogin = false;
  bool isLoading = false;
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop()
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
      key: _scaffoldKey,
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
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
//      bottomNavigationBar: _bottomNavBarBeli(context),
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

  Future update() async{
    var res = await updateMemberBloc.fetchUpdateMember(widget.name, widget.nohp, widget.gender,widget.profile, widget.cover,'');
    if(res.status == 'success'){
      setState(() {isLoading = false;});
      Timer(Duration(seconds: 3), () {
        Navigator.pop(context, showInSnackBar(res.msg));
      });
      return showInSnackBar(res.msg);

    }else{
      setState(() {isLoading = false;});
      return showInSnackBar(res.msg);
    }
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
        prefs.setString('nohp', widget.nohp);

      });
      update();
      CircularProgressIndicator();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
    } else {
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
}
