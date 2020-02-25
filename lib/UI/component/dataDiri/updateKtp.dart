import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/UI/component/penukaranBonus.dart';
import 'package:thaibah/bloc/memberBloc.dart';


class UpdateKtp extends StatefulWidget {
  final String saldo,saldoBonus;
  UpdateKtp({this.saldo,this.saldoBonus});
  @override
  _UpdateKtpState createState() => _UpdateKtpState();
}

class _UpdateKtpState extends State<UpdateKtp> {
  bool _isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String _radioValue2 = 'camera';
  File _image;
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: new Text("Upload Ktp", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:16.0,right:16.0,top:16.0,bottom:0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Silahkan Upload atau Ambil Photo KTP",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtil.getInstance().setSp(26))),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top:10.0),
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.grey,width: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: 'camera',
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChange2,
                                ),

                                new Text('Kamera',style: new TextStyle(fontSize: 11.0,fontFamily: "Rubik")),
                                Radio(
                                  value: 'gallery',
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChange2,
                                ),
                                new Text('Galeri',style: new TextStyle(fontSize: 11.0,fontFamily: "Rubik")),
                              ],
                            ),
                            SizedBox(height: ScreenUtil.getInstance().setHeight(50),),
                            _radioValue2 == 'camera' ? Icon(Icons.camera_alt) : Icon(Icons.folder),
                            _image == null ? _radioValue2 == 'camera' ? Text('Ambil Photo',style:TextStyle(fontFamily: "Rubik")) : Text('Upload Photo',style:TextStyle(fontFamily: "Rubik")) : Text('$_image',style:TextStyle(fontFamily: "Rubik")),
                            SizedBox(height: ScreenUtil.getInstance().setHeight(50),),
                          ],
                        ),
                        onPressed: () async {
                          try{
                            var image = await ImagePicker.pickImage(
                              source: _radioValue2 == 'camera' ? ImageSource.camera : ImageSource.gallery,
                              maxHeight: 600, maxWidth: 600,
                            );
                            setState(() {_image = image;});
                          }catch(e){
                            print(e);
                          }
                        },
                      )
                  ),
                ],
              ),
            ),
            Flexible(
                child: _image == null ? new Center(child: Text('')): Container(
                  padding: EdgeInsets.only(left:16.0,right:16.0),
                  child: new Image.file(_image,fit: BoxFit.fill,filterQuality: FilterQuality.high,),
                )
            ),
          ],
        ),
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
                  setState(() {
                    _isLoading = true;
                  });
                  update();
                },
                child:_isLoading?Text('Pengecekan data ...', style: TextStyle(color: Colors.white)):Text("Simpan", style: TextStyle(color: Colors.white)),
              )
          )
        ],
      ),
    );
  }

  String fileName;
  String base64Image;

  Future update() async{
    if(_image != null){
      fileName = _image.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(_image.readAsBytesSync());
    }else{
      base64Image = "";
    }
    if(_image == null){
      return showInSnackBar("Silahkan Upload Photo KTP",'gagal');
    }else{
      var res = await updateMemberBloc.fetchUpdateMember('', '', '','', '',base64Image);
      if(res.status == 'success'){
        SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {_isLoading = false;});
        Timer(Duration(seconds: 3), () {
          prefs.setString('ktp', 'ktp');
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => PenukaranBonus(saldo: widget.saldo,saldoBonus: widget.saldoBonus,)),
          );
        });
        return showInSnackBar("Upload KTP Berhasil. Anda Akan Diarahkan Kehalaman Penarikan Bonus",'sukses');
      }else{
        setState(() {_isLoading = false;});
        return showInSnackBar(res.msg,'gagal');
      }
    }
  }
  void showInSnackBar(String value,String param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
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

}
