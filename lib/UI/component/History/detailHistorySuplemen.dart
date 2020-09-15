import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/MLM/detailHistoryPembelianSuplemen.dart';
import 'package:thaibah/Model/MLM/resiModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/alertq.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/MLM/resi.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/historyPembelianProvider.dart';

class DetailHistorySuplemen extends StatefulWidget {
  final String id, resi, param; int status;
  DetailHistorySuplemen({
    this.resi,this.id,this.status,this.param
  });
  @override
  _DetailHistorySuplemenState createState() => _DetailHistorySuplemenState();
}

class _DetailHistorySuplemenState extends State<DetailHistorySuplemen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool _isLoading = false;
  var resi = '';
  var kurir = '';
  var status;
  final formatter = new NumberFormat("#,###");

  Future cekResi(var resi, var kurir) async{
    var res = await HistoryPembelianProvider().fetchResi(resi, kurir);
    if(res is ResiModel){
      ResiModel results = res;
      if(results.status == 'success'){
        setState(() {Navigator.pop(context);});
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(
              builder: (context) => Resi(resi:resi,kurir: kurir)
          )
        );
      }else{
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(scaffoldKey, context, results.msg,"success");
      }
    }else{
      setState(() {Navigator.pop(context);});
      General results = res;
      UserRepository().notifNoAction(scaffoldKey, context, results.msg,"failed");
    }

  }

  Future confirm() async {
    var res = await HistoryPembelianProvider().fetchConfirm(widget.id);
    if(res is General){
      setState(() {Navigator.pop(context);});
      General results = res;
      if(results.status == 'success'){
        setState(() {Navigator.pop(context);});
        UserRepository().notifAlertQ(context,'success', 'Selesai', 'Terimakasih Telah Melakukan Transaksi', 'Kembali','Beranda',(){
          Navigator.pop(context);
        },(){
          Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
        });
      }else{
        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(scaffoldKey, context, results.msg,"failed");
      }
    }
  }


  Color warna1;
  Color warna2;
  String statusLevel ='0';
  Future loadTheme() async{
    final userRepository = UserRepository();
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
    detailHistoryPembelianSuplemenBloc.fetchDetailHistoryPemblianSuplemenList(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, 'Detail Pesanan',warna1,warna2,(){
        if(widget.param == 'checkout'){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
        }else{
          Navigator.of(context).pop();
        }
      }, Container()),
      body: StreamBuilder(
          stream: detailHistoryPembelianSuplemenBloc.getResult,
          builder: (context,AsyncSnapshot<DetailHistoryPembelianSuplemenModel> snapshot){
            if (snapshot.hasData) {
              resi = snapshot.data.result.pembayaran.resi==null?'kosong':snapshot.data.result.pembayaran.resi;
              kurir = snapshot.data.result.pembayaran.kurir;
              status = snapshot.data.result.detail.status;
              int rawPrice  = int.parse(snapshot.data.result.pembayaran.rawPrice);
              int rawOngkir = snapshot.data.result.pembayaran.rawOngkir;
              var total = rawPrice+rawOngkir;
              print(total);
              return  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding:EdgeInsets.only(top: 20.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Status', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:'Pesanan ${snapshot.data.result.detail.statusText}', style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Tanggal Pembelian', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:'${DateFormat.yMMMMd().format(DateTime.parse(snapshot.data.result.detail.createdAt))} ${DateFormat.Hms().format(DateTime.parse(snapshot.data.result.detail.createdAt))}', style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                            ],
                          ),
                          SizedBox(height: 0.0),
                          Divider(),
                          SizedBox(height: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'No Invoice', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:snapshot.data.result.detail.kdTrx, style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      color: Colors.white,
                      child: Divider(),
                    ),
                    Container(
                      color: Colors.white,
                      padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(text: TextSpan(text:'Daftar Produk', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    buildProduk(snapshot, context),
                    Container(
                      color: Colors.white,
                      padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(text: TextSpan(text:'Detail Pengiriman', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding:EdgeInsets.only(top: 10.0, bottom: 20.0, left: 15.0, right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Nama Toko', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:'Thaibah', style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),

                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Kurir Pengiriman', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:'${snapshot.data.result.pembayaran.kurir}-${snapshot.data.result.pembayaran.layanan}', style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),

                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'No. Resi', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:snapshot.data.result.pembayaran.resi == null ? 'Belum Ada No.Resi':snapshot.data.result.pembayaran.resi, style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),

                            ],
                          ),
                          snapshot.data.result.pembayaran.resi != null ? GestureDetector(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(text: snapshot.data.result.pembayaran.resi));
                              UserRepository().notifNoAction(scaffoldKey, context, "No Resi Berhasil Disalin","success");
                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RichText(text: TextSpan(text:'', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                                RichText(text: TextSpan(text:'Salin No.Resi', style: TextStyle(color:Colors.green,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ) : Container(),

                          Divider(),
                          RichText(text: TextSpan(text:'alamat Pengiriman : ', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                          SizedBox(height: 5.0,),
                          RichText(text: TextSpan(text:snapshot.data.result.pembayaran.alamatPengiriman, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(text: TextSpan(text:'Informasi Pembayaran', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Metode Pembayaran', style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:snapshot.data.result.pembayaran.metode, style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Total Harga (${snapshot.data.result.pembayaran.jmlItem} barang)', style: TextStyle(color: Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:"Rp ${formatter.format(rawPrice)}", style: TextStyle(color: Colors.redAccent,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),

                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Total Ongkos Kirim (${snapshot.data.result.pembayaran.weight})', style: TextStyle(color: Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:'Rp ${formatter.format(rawOngkir)}', style: TextStyle(color: Colors.redAccent,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: Divider(),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(text: TextSpan(text:'Total Pembayaran', style: TextStyle(color: Colors.grey,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                              RichText(text: TextSpan(text:"Rp ${formatter.format(total)}", style: TextStyle(color: Colors.redAccent,fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(color:Colors.white,height: 20.0,child: Container())
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return _loading(context);
          }
      ),
      bottomNavigationBar: _bottomNavBarBeli(context),
    );
  }
  Widget _bottomNavBarBeli(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                ),
                color: statusLevel!='0'?warna1:ThaibahColour.primary1,
                onPressed: (){
                  if(resi == 'kosong'){
                    setState(() {
                      _isLoading = false;
                    });
                    UserRepository().notifNoAction(scaffoldKey, context, "Maaf, No Resi Belum Ada","failed");
                  }
                  else{
                    if(status != 4){
                      UserRepository().notifAlertQ(context,'warning', 'Perhatian', 'Apakah Barang Anda Sudah Sampai', 'Belum','Sudah',(){
                        Navigator.pop(context);
                      },(){
                        setState(() {
                          UserRepository().loadingQ(context);
                        });
                        confirm();
                      });
                    }else{
                      UserRepository().notifNoAction(scaffoldKey, context, 'Barang Sudah Sudah Diterima, Terimakasih ...', 'success');
                    }
                  }
                },
                child:RichText(text: TextSpan(text:'Selesai', style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
              )
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color:statusLevel!='0'?warna2:ThaibahColour.primary2,
                onPressed: (){
                  if(resi == 'kosong' || resi.substring(0,3) == 'COD'){
                    setState(() {
                      isLoading = false;
                    });
                    if(resi == 'kosong'){
                      UserRepository().notifNoAction(scaffoldKey, context, "Maaf, No Resi Belum Ada","failed");
                    }
                    if(resi.substring(0,3) == 'COD'){
                      UserRepository().notifNoAction(scaffoldKey, context, "Barang Telah Dikirim, Terimakasih","success");
//                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Barang telah dikirim')));
                    }
                  }else{
                    setState(() {
                      UserRepository().loadingQ(context);
                    });
                    cekResi(resi,kurir);
                  }
                },
                child:RichText(text: TextSpan(text:'Lacak Resi', style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))),
              )
          )
        ],
      ),
    );
  }
  Widget buildProduk(AsyncSnapshot<DetailHistoryPembelianSuplemenModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      width:  width / 1,
      color: Colors.white,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.result.pembelian.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return new FlatButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Row(
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(left:10.0,right:5.0),
                                width: 70.0,
                                height: 70.0,
                                child: Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data.result.pembelian[i].picture,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                      ),
                                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.circular(10.0),
                                          color: Colors.transparent,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                          boxShadow: [new BoxShadow(color:Colors.transparent,blurRadius: 5.0,offset: new Offset(2.0, 5.0))],
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                            )
                          ],

                        ),
                      ),
                      new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            child: new Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  // child: new Text(snapshot.data.result.pembelian[i].title,style: new TextStyle(fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold,color: Colors.black),),
                                  child:  RichText(text: TextSpan(text:snapshot.data.result.pembelian[i].title, style: TextStyle(fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold,color: Colors.black))),
                                ),
                                SizedBox(height: 5.0),
                                RichText(text: TextSpan(text:"${snapshot.data.result.pembelian[i].qty} Barang (${snapshot.data.result.pembelian[i].weight} Gram)", style: TextStyle(fontSize: 10,fontFamily: ThaibahFont().fontQ,color:Colors.grey,fontWeight: FontWeight.bold))),
                                SizedBox(height: 5.0),
                                RichText(text: TextSpan(text:snapshot.data.result.pembelian[i].price, style: TextStyle(fontSize: 12,fontFamily: ThaibahFont().fontQ,color: Colors.redAccent,fontWeight: FontWeight.bold))),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                    color: Colors.white,
                    child: Divider(),
                  ),
//                  SizedBox(height: 10.0,child: Container(color: Colors.transparent)),
                ],
              ),
              padding: const EdgeInsets.all(0.0),
              onPressed: () {

              },
//              color: Colors.white,
            );
          }),
    );
  }

  Widget buildListPengiriman(String textLeft, textRight,double ukuran, bool isTrue){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$textLeft',style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
        SizedBox(width: ukuran),
        Flexible(
          child: Text('$textRight', style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold))
        ),
        SizedBox(width: 2.0),
        isTrue ? GestureDetector(
          child: Icon(Icons.content_copy, color: Colors.black, size: 10,),
        ) : Container()


      ],
    );
  }


  Widget _loading(BuildContext context){
    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding:EdgeInsets.only(top: 20.0, bottom: 0.0, left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,)
                  ],
                ),

                Divider(),
                SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,)
                  ],
                ),
                SizedBox(height: 0.0),
                Divider(),
                SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,)
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
            color: Colors.white,
            child: Divider(),
          ),
          Container(
            color: Colors.white,
            padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,),
                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0,)
              ],
            ),
          ),
          Container(
            width:  MediaQuery.of(context).size.width/1,
            color: Colors.transparent,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return new FlatButton(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: new Row(
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(left:10.0,right:5.0),
                                      width: 70.0,
                                      height: 70.0,
                                      child: SkeletonFrame(width: 70.0,height: 70.0,)
                                  )
                                ],

                              ),
                            ),
                            new Expanded(
                                child: new Container(
                                  margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                                  child: new Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(0.0),
                                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                      ),
                                      SizedBox(height: 5.0),
                                      SkeletonFrame(width: MediaQuery.of(context).size.width/1.5,height: 16.0),
                                      SizedBox(height: 5.0),
                                      SkeletonFrame(width: MediaQuery.of(context).size.width/1.5,height: 16.0),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                          color: Colors.white,
                          child: Divider(),
                        ),
//                  SizedBox(height: 10.0,child: Container(color: Colors.transparent)),
                      ],
                    ),
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {

                    },
//              color: Colors.white,
                  );
                }),
          ),
          Container(
            color: Colors.white,
            padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SkeletonFrame(width: MediaQuery.of(context).size.width/1.3,height: 16.0),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding:EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),

                Divider(),
                SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16.0),
                SizedBox(height: 5.0,),
                SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16.0),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SkeletonFrame(width: MediaQuery.of(context).size.width/1.7,height: 16.0),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),
                Divider(),
                SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: Divider(),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16.0),
                  ],
                ),
              ],
            ),
          ),
          Container(color:Colors.white,height: 20.0,child: Container())
        ],
      ),
    );
  }

}
