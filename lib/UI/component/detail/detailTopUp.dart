import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/History/buktiTransfer.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';

class DetailTopUp extends StatefulWidget {
  final String amount,raw_amount,unique,bank_name,atas_nama,no_rekening,picture,id_deposit,bank_code;
  DetailTopUp({
    this.amount,this.raw_amount,this.unique,this.bank_name,this.atas_nama,this.no_rekening,this.picture,this.id_deposit,this.bank_code
  });
  @override
  _DetailTopUpState createState() => _DetailTopUpState();
}

class _DetailTopUpState extends State<DetailTopUp> {
  double _height;
  double _width;
  File _image;
  Future<File> file;
  String base64Image;
  File tmpFile;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String fileName;
  var hari  = DateFormat.d().format( DateTime.now().add(Duration(days: 3)));
  var bulan = DateFormat.M().format( DateTime.now());
  var tahun = DateFormat.y().format( DateTime.now());

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
            return RichAlertDialogQ(
              alertTitle: richTitle("Pengisian Topup Anda Akan Segera Diproses"),
              alertSubtitle: richSubtitle("Harap Menuggu Paling Lambat 15 Menit"),
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
              alertTitle: richTitle("Error"),
              alertSubtitle: richSubtitle("Terjadi Kesalahan"),
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final key = new GlobalKey<ScaffoldState>();
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Scaffold(
        key: key,
        appBar: UserRepository().appBarWithButton(context, 'Transaksi Berhasil',warna1,warna2,(){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
        }, Container()),
        resizeToAvoidBottomInset: false,

        body: Scrollbar(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(
                  'assets/images/checkmark.gif',
                  height: MediaQuery.of(context).size.height / 7,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Silahkan transfer tepat sebesar',
                    style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold, fontSize:  ScreenUtilQ.getInstance().setSp(36)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      color:statusLevel!='0'?warna1:ThaibahColour.primary2,
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child: Text(
                        widget.amount,
                        style: TextStyle(color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold, fontSize:  ScreenUtilQ.getInstance().setSp(40)),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                  child: Text(
                    'Pembayaran dapat dilakukan ke rekening berikut :',
                    style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold, fontSize:  ScreenUtilQ.getInstance().setSp(30)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Card(
                  elevation: 0.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Container(
                    padding:EdgeInsets.all(5.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        width: 90.0,
                        height: 50.0,
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          minRadius: 150,
                          maxRadius: 150,
                          child: CachedNetworkImage(
                            imageUrl: widget.picture,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                            ),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(0.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(widget.atas_nama,style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                      subtitle: GestureDetector(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(text: widget.no_rekening));
                          key.currentState.showSnackBar(new SnackBar(content: new Text("no rekening berhasil disalin",style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(20),fontFamily: 'Rubik'),)));
                        },
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text( widget.no_rekening,style: TextStyle(fontFamily: 'Rubik',fontSize:  ScreenUtilQ.getInstance().setSp(30)),),
                              SizedBox(width: 5),
                              Icon(Icons.content_copy, color: Colors.black, size: 15,),
                            ]
                        ),

                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      color:statusLevel!='0'?warna1:ThaibahColour.primary2,
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child: Text(
                        'VERIFIKASI PENERIMAAN TRANSFER ANDA AKAN DIPROSES SELAMA 5-10 MENIT',
                        style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color:Colors.white,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                      child: RichText(
                        text: TextSpan(
                            text: 'Anda Dapat Melakukan Transfer Menggunakan ATM, Mobile Banking atau SMS Banking Dengan Memasukan Kode Bank',
                            style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: ' ${widget.bank_name} ${widget.bank_code}',style: TextStyle(color:statusLevel!='0'?warna1:ThaibahColour.primary2, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                              TextSpan(text: ' Di Depan No Rekening Atas Nama',style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ)),
                              TextSpan(text: ' ${widget.atas_nama}',style: TextStyle(color: statusLevel!='0'?warna1:ThaibahColour.primary2, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                            ]
                        ),
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                      child: Text(
                        'mohon transfer tepat hingga 3 digit terakhir agar tidak menghambat proses verifikasi',
                        style: TextStyle(fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ),
                        textAlign: TextAlign.left,
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child: Text(
                        'Pastikan anda transfer sebelum tanggal $hari-$bulan-$tahun 23:00 WIB atau transaksi anda otomatis dibatalkan oleh sistem. jika sudah melakukan transfer segera upload bukti transfer disini atau di halaman riwayat topup',
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        textAlign: TextAlign.left,
                      ),
                    )
                ),
              ],
            )
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
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => BuktiTransfer(id_deposit: widget.id_deposit)),
                  );
                },
                child: Text("SAYA SUDAH TRANSFER", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold,color: Colors.white)),
              )
          )
        ],
      ),
    );
  }


}
