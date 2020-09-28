import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
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
      UserRepository().notifAlertQ(context, "success","Upload Bukti Transfer Berhasil", "Silahkan Tunggu Konfirmasi Dari Admin","Kembali","Beranda", ()=>Navigator.pop(context), (){
        Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
      });

    }else{
      setState(() {Navigator.pop(context);});
      UserRepository().notifNoAction(scaffoldKey, context,res.msg,"failed");
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
        appBar: UserRepository().appBarWithButton(context, "Upload Bukti Transfer",(){Navigator.pop(context);},<Widget>[]),

        // appBar:UserRepository().appBarWithButton(context,'Upload Bukti Transfer',warna1,warna2,(){Navigator.of(context).pop();},Container()),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            itemContent(context),
            SizedBox(height: 10.0),
            Flexible(
                child: _image == null ? new Center(child: Image.network("http://lequytong.com/Content/Images/no-image-02.png")): new Image.file(_image,width: 1300,height: 800,filterQuality: FilterQuality.high,)
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
  
  Widget itemContent(BuildContext context){
    return InkWell(
      onTap: () async {
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
      child: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: UserRepository().textQ("Upload Bukti Transfer",12,Colors.grey,FontWeight.bold,TextAlign.left),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Center(child: Icon(Icons.satellite, color: Colors.grey)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 20,),
      ),
    );
  }

}
