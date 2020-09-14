import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';

class BuktiTransfer extends StatefulWidget {
  final String id_deposit;
  BuktiTransfer({this.id_deposit});
  @override
  _BuktiTransferState createState() => _BuktiTransferState();
}

class _BuktiTransferState extends State<BuktiTransfer> {
  File _image;
  Future<File> file;
  String base64Image;
  File tmpFile;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String fileName;
  Future upload() async{

    if(_image != null){
      fileName = _image.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(_image.readAsBytesSync());
    }else{
      base64Image = "";
    }
    var res = await uploadBuktiTransferBloc.fetchUploadBuktiTransfer(widget.id_deposit, base64Image);
    if(res.status == 'success'){
      setState(() {Navigator.pop(context);});
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return RichAlertDialogQ(
              alertTitle: richTitle("Upload Bukti Transfer Berhasil"),
              alertSubtitle: richSubtitle("Silahkan Tunggu Konfirmasi Dari Admin"),
              alertType: RichAlertType.SUCCESS,
              actions: <Widget>[
                FlatButton(
                  child: Text("Kembali"),
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          }
      );
    }else{
      setState(() {Navigator.pop(context);});
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return RichAlertDialogQ(
              alertTitle: richTitle("Terjadi Kesalahan"),
              alertSubtitle: richSubtitle(res.msg),
              alertType: RichAlertType.ERROR,
              actions: <Widget>[
                FlatButton(
                  child: Text("Kembali"),
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          }
      );
    }
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
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Scaffold(
      appBar:UserRepository().appBarWithButton(context,'Upload Bukti Transfer',warna1,warna2,(){Navigator.of(context).pop();},Container()),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: ScreenUtilQ.getInstance().setHeight(170),
              child: new OutlineButton(
                borderSide: BorderSide(color: Colors.grey,width: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtilQ.getInstance().setHeight(30),),
                    Icon(Icons.cloud_upload),
                    _image == null ? Text('Upload Bukti Transfer',style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:Colors.red)) : Center(child: Text('$_image',textAlign:TextAlign.center,style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,color:Colors.grey))),
                  ],
                ),
                onPressed: () async {
                  try{
                    var image = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 800, maxWidth: 600,
                    );
                    setState(() {
                      _image = image;
                    });
                  }catch(e){
                    print(e);
                  }

                },
              ),
            ),
            SizedBox(height: 10.0),
            Flexible(
                child: _image == null ? new Center(child: Image.network("https://bandungumroh.com/sie/assets/no_image.png")): new Image.file(_image,width: 1300,height: 800,filterQuality: FilterQuality.high,)
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBarBeli(context)

    );
  }

  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width/1,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [statusLevel!='0'?warna1:ThaibahColour.primary1,statusLevel!='0'?warna2:ThaibahColour.primary2]),
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
              ),
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
                ),
                color: statusLevel!='0'?warna1:ThaibahColour.primary2,
                onPressed: (){
                  if(_image!=null){
                    setState(() {
                      UserRepository().loadingQ(context);
                    });
                    upload();
                  }
                },
                child: Text("SIMPAN", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(45),fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold,color: Colors.white)),
              )
          )
        ],
      ),
    );
  }

}
