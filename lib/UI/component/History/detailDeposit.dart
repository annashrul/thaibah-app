import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/buktiTransfer.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/style.dart';


var orange = Color(0xFFfc9f6a);
var pink = Color(0xFFee528c);
var blue = Color(0xFF8bccd6);
var darkBlue = Color(0xFF60a0d7);
var valueBlue = Color(0xFF5fa0d6);
class DetailDeposit extends StatefulWidget {
  final String amount,bank_name,atas_nama,no_rekening,id_deposit,picture,created_at,name,bukti;
  final int status;
  DetailDeposit({
    this.amount,this.bank_name,this.atas_nama,this.no_rekening,this.id_deposit,this.picture,this.status,this.created_at,this.name,this.bukti
  });
  @override
  _DetailDepositState createState() => _DetailDepositState();
}

class _DetailDepositState extends State<DetailDeposit> {

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
              alertTitle: richTitle("Uplod Bukti Transfer Berhasil"),
              alertSubtitle: richSubtitle("Silahkan Tunggu Konfirmasi Dari Admin"),
              alertType: RichAlertType.SUCCESS,
              actions: <Widget>[
                FlatButton(
                  child: Text("Kembali"),
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => DashboardThreePage()),
                    );

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
              alertSubtitle: richSubtitle("Uplod Bukti Transfer Berhasil"),
              alertType: RichAlertType.ERROR,
              actions: <Widget>[
                FlatButton(
                  child: Text("Kembali"),
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => DashboardThreePage()),
                    );
                  },
                ),
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var cek;
    if(widget.status == 0){
      cek = 'Pending';
    }else if(widget.status == 1){
      cek = 'Diterima';
    }else{
      cek = 'Ditolak';
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          automaticallyImplyLeading: true,
          title: new Text("Riwayat Topup", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
          centerTitle: true,
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
          elevation: 0.0,
        ),
        body: Container(
          color: Color(0xFFf7f8fc),
          child: ListView(
            children: <Widget>[
              CreditCardContainer(noRekening: widget.no_rekening,atasNama: widget.atas_nama,bankName: widget.bank_name,picture: widget.picture),
              ItemCard(widget.amount, widget.created_at, cek, [blue, darkBlue]),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(

                  children: <Widget>[
                    Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width/1.060,
                      child: CachedNetworkImage(
                          imageUrl: widget.bukti != '' ? widget.bukti:'http://lequytong.com/Content/Images/no-image-02.png',
                          placeholder: (context, url) => Center(
                            child: SkeletonFrame(width: 400,height: 400),
                          ),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.0,
              ),

            ],
          ),
        ),
        bottomNavigationBar: _bottomNavBarBeli(context)
    );
  }
  Widget _bottomNavBarBeli(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: Styles.primaryColor,
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => BuktiTransfer(id_deposit: widget.id_deposit)),
                  );
//                  showDialog(
//                    context: context,
//                    builder: (BuildContext context) {
//                      // return object of type Dialog
//                      return AlertDialog(
//                        title:SizedBox(
//                          width: double.infinity,
//                          height: ScreenUtil.getInstance().setHeight(130),
//                          child: new OutlineButton(
//                            borderSide: BorderSide(color: Colors.grey,width: 1.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                SizedBox(height: ScreenUtil.getInstance().setHeight(30),),
//                                Icon(Icons.cloud_upload),
//                                _image == null ? Text('Upload Photo',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red)) : Text('Photo KTP Berhasil DIupload',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green))
//                              ],
//                            ),
//                            onPressed: () async {
//                              try{
//                                var image = await ImagePicker.pickImage(
//                                    source: ImageSource.gallery,
//
//                                );
//                                setState(() {
//                                  _image = image;
//                                });
//                              }catch(e){
//                                print(e);
//                              }
//
//                            },
//                          ),
//                        ),
//                        actions: <Widget>[
//                          Row (
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                FlatButton(
//                                  child: new Text("Kembali"),
//                                  onPressed: () {
//                                    Navigator.of(context).pop();
//                                  },
//                                ), // button 1
//                                FlatButton(
//                                  child: new Text("Simpan"),
//                                  onPressed: () {
//                                    if(_image!=null){
//                                      upload();
//                                    }
//
//                                  },
//                                ), // button 2
//                              ]
//                          ),
//
//                        ],
//                      );
//                    },
//                  );
                },
                child: Text("Upload Bukti Transfer", style: TextStyle(color: Colors.white)),
              )
          )

        ],
      ),
    );
  }
}

class ValueCard extends StatelessWidget {
  final name;
  final value;
  final date;
  final bank;
  ValueCard(this.name,this.value,this.date, this.bank);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.6)),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: valueBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  bank,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            SizedBox(height: 4.0,),
            Divider()
          ],
        ));
  }
}

class ItemCard extends StatelessWidget {
  final titel;
  final subtitle;
  final value;
  final colors;
  ItemCard(this.titel, this.subtitle, this.value, this.colors);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: colors),
            borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titel,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
class CreditCardContainer extends StatelessWidget {
  final String noRekening,atasNama,bankName,picture;
  const CreditCardContainer({
    Key key, this.noRekening,this.atasNama,this.bankName,this.picture
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 21),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 5.0, color: Colors.red[200], offset: Offset(0, 5)),
        ],
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [
            Color(0xffff8964),
            Color(0xffff5d6e),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image.network(
                picture,
                width: 51,
                height: 51,
              ),
            ),
            Text(
              noRekening,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              bankName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              atasNama,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}