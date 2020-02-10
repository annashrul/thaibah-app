import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/api.dart';

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
            return RichAlertDialog(
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
            return RichAlertDialog(
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: new Text("Upload Bukti Transfer", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
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
                    _image == null ? Text('Upload Bukti Transfer',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red)) : Center(child: Text('$_image',textAlign:TextAlign.center,style: TextStyle(fontSize:12.0,fontWeight: FontWeight.bold,color:Colors.grey)))
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_image!=null){
            upload();
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }
}
