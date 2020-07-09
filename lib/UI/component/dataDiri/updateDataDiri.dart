
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/lockScreenQ.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
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
    super.initState();
    loadTheme();
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
    final dbHelper = DbHelper.instance;
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
      var res = await MemberProvider().resendOtp(no,'-',"update",'whatsapp');
      if(res is ResendOtp){
        ResendOtp result = res;
        print(result.status);
        if(result.status == 'success'){
          setState(() {_isLoading = false;});
          Navigator.push(
            context,
            CupertinoPageRoute(
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
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
        }
      }
      else{
        General results = res;
        setState(() {_isLoading = false;});
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
      }
    }
    else{
      var res = await updateMemberBloc.fetchUpdateMember(nameController.text, no, dropdownValue,base64Image, base64Image2,'');
      if(res.status == 'success'){
        final userRepository = UserRepository();
        final id = await userRepository.getDataUser('id');
        Map<String, dynamic> row = {
          DbHelper.columnId   : id,
          DbHelper.columnName : nameController.text,
          DbHelper.columnPhone : no,
          DbHelper.columnPicture : base64Image,
          DbHelper.columnCover : base64Image2,
        };
        await dbHelper.update(row);
        setState(() {_isLoading = false;});
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
        });
        UserRepository().notifNoAction(_scaffoldKey, context,res.msg,"success");

//        return showInSnackBar(res.msg,'sukses');

      }else{
        setState(() {_isLoading = false;});
        UserRepository().notifNoAction(_scaffoldKey, context,res.msg,"failed");

//        return showInSnackBar(res.msg,'gagal');
      }
    }


  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
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

    final quality = 90;
    final tmpDir = (await getTemporaryDirectory()).path;
    final target ="$tmpDir/${DateTime.now().millisecondsSinceEpoch}-$quality.png";

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      target,
      format: CompressFormat.png,
      quality: 90,
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
    final quality = 90;
    final tmpDir = (await getTemporaryDirectory()).path;
    final target ="$tmpDir/${DateTime.now().millisecondsSinceEpoch}-$quality.png";

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      target,
      format: CompressFormat.png,
      quality: 90,
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






  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context,"Data Diri",warna1,warna2,(){Navigator.of(context).pop();},Container()),
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
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 0, top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("No WhatsApp  (Silahkan Masukan No WhatsApp Yang Akan Anda Daftarkan) ",style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
                            style: TextStyle(fontFamily: ThaibahFont().fontQ),
                            decoration: InputDecoration(hintStyle: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontSize: 12.0)),
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
                    labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rosemary",fontSize:20),
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
                          child: Text(value,style: TextStyle(fontFamily: ThaibahFont().fontQ),),
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
                      height: ScreenUtilQ.getInstance().setHeight(130),
                      child: new OutlineButton(
                        borderSide: BorderSide(color: Colors.grey,width: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: ScreenUtilQ.getInstance().setHeight(30),),
                            Icon(Icons.cloud_upload),
                            _image == null || _image == "" ? Text('pilih photo profile',style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:Colors.red)) : Text('photo profile sudah dipilih',style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:Colors.green))
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
                      height: ScreenUtilQ.getInstance().setHeight(130),
                      child: new OutlineButton(
                        borderSide: BorderSide(color: Colors.grey,width: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: ScreenUtilQ.getInstance().setHeight(30),),
                            Icon(Icons.cloud_upload),
                            _image2 == null || _image2 == "" ? Text('pilih photo cover',style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:Colors.red)) : Text('photo cover sudah dipilih',style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:Colors.green))
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
              UserRepository().buttonQ(context,warna1,warna2,(){
                if (nameController.text == "") {
                  UserRepository().notifNoAction(_scaffoldKey, context,"Nama Harus Diisi","failed");
//                          return showInSnackBar("Nama Harus Disi",'gagal');
                }
                else if(nohpController.text == ""){
                  UserRepository().notifNoAction(_scaffoldKey, context,"No Handphone Harus Disi","failed");

//                          return showInSnackBar("No Handphone Harus Disi",'gagal');
                }
                else {
                  setState(() {_isLoading = true;});
                  update();
                }
              }, _isLoading)
//              Align(
//                  alignment: Alignment.centerRight,
//                  child: Container(
//                    margin: EdgeInsets.all(16),
//                    decoration: BoxDecoration(
//                        color: Colors.green, shape: BoxShape.circle
//                    ),
//                    child: IconButton(
//                      color: Colors.white,
//                      onPressed: () {
//                        if (nameController.text == "") {
//                          UserRepository().notifNoAction(_scaffoldKey, context,"Nama Harus Diisi","failed");
////                          return showInSnackBar("Nama Harus Disi",'gagal');
//                        }
//                        else if(nohpController.text == ""){
//                          UserRepository().notifNoAction(_scaffoldKey, context,"No Handphone Harus Disi","failed");
//
////                          return showInSnackBar("No Handphone Harus Disi",'gagal');
//                        }
//                        else {
//                          setState(() {_isLoading = true;});
//                          update();
//                        }
//                      },
//                      icon: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Icon(Icons.arrow_forward),
//                    ),
//                  )
//              ),
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
      width: ScreenUtilQ.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

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
  var currentText;

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
            fontFamily:ThaibahFont().fontQ),
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
      body: LockScreenQ(
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

            update();
//                _check(currentText.toString(),context);
          }
      ),
    );
  }


  Future update() async{
    final dbHelper = DbHelper.instance;
    var res = await updateMemberBloc.fetchUpdateMember(widget.name, widget.nohp, widget.gender,widget.profile, widget.cover,'');
    if(res.status == 'success'){
      final userRepository = UserRepository();
      final id = await userRepository.getDataUser('id');
      Map<String, dynamic> row = {
        DbHelper.columnId   : id,
        DbHelper.columnName : widget.name,
        DbHelper.columnPhone : widget.nohp,
        DbHelper.columnPicture : widget.profile,
        DbHelper.columnCover : widget.cover,
      };
      await dbHelper.update(row);
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

//  Future _check(String txtOtp, BuildContext context) async {
//    isLoading ? showDialog(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          content: LinearProgressIndicator(),
//        );
//      },
//    ):Container();
//    if (widget.otp == txtOtp) {
//      final prefs = await SharedPreferences.getInstance();
//      setState(() {
//        isLoading = false;
//        prefs.setString('nohp', widget.nohp);
//
//      });
//      update();
//      CircularProgressIndicator();
//      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
//    } else {
//      showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: new Text("Terjadi Kesalahan!"),
//            content: new Text("Kode OTP Tidak Sesuai"),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text("Close"),
//                onPressed: () {
//                  setState(() {
//                    isLoading = false;
//                  });
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        },
//      );
//    }
//  }
}
