import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/Model/MLM/detailHistoryPembelianSuplemen.dart';
import 'package:thaibah/Model/MLM/resiModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/indexHistory.dart';
import 'package:thaibah/UI/component/MLM/resi.dart';
import 'package:thaibah/UI/profile_ui.dart';
import 'package:thaibah/bloc/historyPembelianBloc.dart';
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
//    var res = await resiBloc.fetchResi(resi, kurir);
    var res = await HistoryPembelianProvider().fetchResi(resi, kurir);
    if(res is ResiModel){
      ResiModel results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Resi(resi:resi,kurir: kurir),
          ),
        );
      }else{
        setState(() {
          isLoading = false;
        });
        return scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(results.msg)));
      }
    }else{
      setState(() {
        isLoading = false;
      });
      General results = res;
      return scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(results.msg)));
    }

  }

  Future confirm() async {
    var res = await HistoryPembelianProvider().fetchConfirm(widget.id);
    if(res is General){
      General results = res;
      if(results.status == 'success'){
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                alertTitle: richTitle("Selesai"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
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
        setState(() {
          _isLoading = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));

      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailHistoryPembelianSuplemenBloc.fetchDetailHistoryPemblianSuplemenList(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size;
    print(widget.id);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () {
            if(widget.param == 'checkout'){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
            }else{
              Navigator.of(context).pop();
            }

          },
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
        title: new Text("Detail Pesanan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
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
                              Text('Status', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text("Pesanan "+snapshot.data.result.detail.statusText,style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            ],
                          ),

                          Divider(),
                          SizedBox(height: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Tanggal Pembelian', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.detail.createdAt, style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(height: 0.0),
                          Divider(),
                          SizedBox(height: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('No Invoice', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.detail.kdTrx, style: TextStyle(color: Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
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
                          Text('Daftar Produk', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    buildProduk(snapshot, context),
                    Container(
                      color: Colors.white,
                      padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Detail Pengiriman', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
                              Text('Nama Toko', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text('Thaibah', style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Kurir Pengiriman', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text('${snapshot.data.result.pembayaran.kurir}-${snapshot.data.result.pembayaran.layanan}', style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('No.Resi', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.pembayaran.resi == null ? 'Belum Ada No.Resi':snapshot.data.result.pembayaran.resi, style: TextStyle(color:Colors.black87,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            ],
                          ),
                          snapshot.data.result.pembayaran.resi != null ? GestureDetector(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(text: snapshot.data.result.pembayaran.resi));
                              scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("No.Resi Berhasil Disalin")));
                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                                Text('Salin No.Resi', style: TextStyle(color:Colors.green,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ) : Container(),

                          Divider(),
                          Text('alamat Pengiriman : ', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.0,),
                          Text(snapshot.data.result.pembayaran.alamatPengiriman, style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      padding:EdgeInsets.only(top: 0.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Informasi Pembayaran', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
                              Text("Metode Pembayaran ",style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text(snapshot.data.result.pembayaran.metode, style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Total Harga (${snapshot.data.result.pembayaran.jmlItem} barang)', style: TextStyle(color: Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text("${formatter.format(rawPrice)}", style: TextStyle(color: Colors.redAccent,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Total Ongkos Kirim (${snapshot.data.result.pembayaran.weight})', style: TextStyle(color: Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text('${formatter.format(rawOngkir)}', style: TextStyle(color: Colors.redAccent,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
                              Text("Total Pembayaran",style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              Text("${formatter.format(total)}", style: TextStyle(color: Colors.redAccent, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
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
                color: Color(0xFF116240),
                onPressed: (){
                  if(resi == 'kosong'){
                    setState(() {
                      _isLoading = false;
                    });
                    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('maaf no resi belum ada')));
                  }
                  else{
                    if(status != 4){
                      Alert(
                        style: AlertStyle(
                            titleStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                            descStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik')
                        ),
                        context: context,
                        type: AlertType.warning,
                        title: "Perhatian",
                        desc: "Apakah Barang Sudah Sampai ??",
                        buttons: [
                          DialogButton(
                            child: Text("BELUM",style: TextStyle(color: Colors.white, fontSize: 20)),
                            onPressed: () => Navigator.of(context).pop(false),
                            color: Color.fromRGBO(0, 179, 134, 1.0),
                          ),
                          DialogButton(
                            child: Text("SUDAH",style: TextStyle(color: Colors.white, fontSize: 20)),
                            onPressed: () async {
                              setState(() {
                                _isLoading = false;
                              });
                              confirm();
                            },
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(116, 116, 191, 1.0),
                              Color.fromRGBO(52, 138, 199, 1.0)
                            ]),
                          )
                        ],
                      ).show();
                    }else{
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Barang Sudah Sudah Diterima, Terimakasih ...')));
                    }


                  }
                },
                child:_isLoading?Text('Pengecekan data ...', style: TextStyle(color: Colors.white)):Text("Selesai", style: TextStyle(color: Colors.white)),

              )
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: Colors.green,
                onPressed: (){
                  if(resi == 'kosong' || resi.substring(0,3) == 'COD'){
                    setState(() {
                      isLoading = false;
                    });
                    if(resi == 'kosong'){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('maaf no resi belum ada')));
                    }
                    if(resi.substring(0,3) == 'COD'){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Barang telah dikirim')));
                    }
                  }else{
                    setState(() {
                      isLoading = true;
                    });
                    print(resi.substring(0,3));
                    cekResi(resi,kurir);
                  }
                },
                child:isLoading?Text('Pengecekan data ...', style: TextStyle(color: Colors.white)):Text("Lacak Resi", style: TextStyle(color: Colors.white)),
              )
          )
        ],
      ),
    );
  }
  Widget buildProduk(AsyncSnapshot<DetailHistoryPembelianSuplemenModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
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
                                  child: new Text(snapshot.data.result.pembelian[i].title,style: new TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                                SizedBox(height: 5.0),
                                Text('${snapshot.data.result.pembelian[i].qty} Barang (${snapshot.data.result.pembelian[i].weight} Gram)',style: TextStyle(fontSize: 10,fontFamily: 'Rubik',color:Colors.grey,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5.0),
                                Text(snapshot.data.result.pembelian[i].price,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.redAccent,fontWeight: FontWeight.bold),)
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
        Text('$textLeft',style: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
        SizedBox(width: ukuran),
        Flexible(
          child: Text('$textRight', style: TextStyle(color: Colors.black, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
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
