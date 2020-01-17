import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:google_places_picker/google_places_picker.dart';
import 'package:intl/intl.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:thaibah/Model/MLM/checkoutToDetailModel.dart';
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart' as prefix4;
import 'package:thaibah/Model/MLM/getDetailChekoutSuplemenModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/kecamatanModel.dart' as prefix2;
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/kotaModel.dart' as prefix1;
import 'package:thaibah/Model/ongkirModel.dart' as prefix3;
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/Model/provinsiModel.dart' as prefix0;
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailHistorySuplemen.dart';
import 'package:thaibah/UI/component/address/indexAddress.dart';
import 'package:thaibah/bloc/MLM/detailChekoutSuplemenBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart' as prefix4;
import 'package:thaibah/bloc/productMlmBloc.dart';
import 'package:thaibah/resources/MLM/getDetailChekoutSuplemenProvider.dart';
import 'package:thaibah/resources/productMlmProvider.dart';


class CheckOutSuplemen extends StatefulWidget {
  final total; final berat; final totQty;
  CheckOutSuplemen({this.total,this.berat,this.totQty});
  @override
  _CheckOutSuplemenState createState() => _CheckOutSuplemenState();
}

class _CheckOutSuplemenState extends State<CheckOutSuplemen>{
  bool isExpanded = false;
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var otherAddress = TextEditingController();
  var otherAddress1 = TextEditingController();
  var kodePos = TextEditingController();
  var vouncher = TextEditingController();
  final FocusNode otherAddressFocus = FocusNode();
  final FocusNode otherAddressFocus1 = FocusNode();
  final FocusNode kodePosFocus = FocusNode();
  final FocusNode voucherFocus = FocusNode();

  int addressType = 0;
  String mainAddress = '';
  String _currentItemSelectedProvinsi=null;
  String _currentItemSelectedKota=null;
  String _currentItemSelectedKecamatan=null;
  String _currentItemSelectedJasa=null;
  String _currentItemSelectedKurir=null;

  int total = 0;
  int sendTotal = 0;
  String id = "";
  String address="";
  String email="";
  String name="";
  String jasper='';
  String asal = '';
  int totOngkir = 0;

  String tProvinsi = '', tKota='',tKecamatan='';
  String tampungAddress = '';

  var paket;
  String dropdownValue = 'Saya';
  String dropdownPaket = 'pilih';
  String kdKec = '';
  String kec_pengirim = '';
  bool isTrue = false;
  bool isLoadingJasa = false;
  int totQty=0;
  int totBayar = 0;
  Future pilih() async{
    var res = await DetailCheckoutSuplemenProvider().fetchDetailCheckoutSuplemen();
//    var res =  detailChekoutSuplemenBloc.fetchDetailChekoutSuplemenList();
    if(dropdownValue == 'Saya'){
      setState(() {
        isTrue = false;
        mainAddress = res.result.address;
        kdKec = res.result.kdKec;
        kec_pengirim = res.result.kecPengirim;
        otherAddress.text = '';
        addressType = 0;
      });
      detailChekoutSuplemenBloc.fetchDetailChekoutSuplemenList();
    }else{
      setState(() {
        isTrue = true;
        mainAddress = otherAddress.text;
        kec_pengirim = res.result.kecPengirim;
        addressType = 1;
      });
      provinsiBloc.fetchProvinsiist();
    }
    print(mainAddress);
  }

  getKota(id) async{
    kotaBloc.fetchKotaList(id.toString());
//    setState(() {});
  }

  getKecamatan(id) async{
    kecamatanBloc.fetchKecamatanList(id.toString());
//    setState(() {});
  }

  getOngkir() async {
    var cekKec;
    if(dropdownValue=='Lainnya'){
      cekKec = _currentItemSelectedKecamatan;
    }else{
      cekKec = kdKec;
    }

    await ongkirBloc.fetchOngkirList(kec_pengirim,"${cekKec}","${widget.berat}",_currentItemSelectedKurir);
  }

  void showInSnackBar(String value) {
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
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  String _placeName = '';
  String alamat = '';


  @override
  void initState() {
    super.initState();
    pilih();
    provinsiBloc.fetchProvinsiist();
    detailChekoutSuplemenBloc.fetchDetailChekoutSuplemenList();
    totQty   = widget.totQty;
    totBayar = widget.total;
//    PluginGooglePlacePicker.initialize(
//      androidApiKey: "AIzaSyA1uxab8JTufkfuXgCX8ULSIhhSPJs-WC0",
//    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final formatter = new NumberFormat("#,###");
  var totBar = '';
  Widget _optionAddress(){
    return Container(
      margin: EdgeInsets.only(left:10.0,right:10.0),
      width: _width,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Pilih Alamat',
          labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize:20),
        ),
        isEmpty: dropdownValue == null,
        child: new DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue  = newValue;
                _onDropDownItemSelectedProvinsi(null);
                _onDropDownItemSelectedKurir(null);
                _onDropDownItemSelectedJasa(null);
              });
              pilih();
            },
            items: <String>['Saya', 'Lainnya'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontSize: 12.0),),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Widget _alamatPengirim(){
    return Container(
      margin: EdgeInsets.only(top:10.0,left:10.0,right:10.0),
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Alamat Pengiriman:", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubik'),),
          StreamBuilder(
              stream: detailChekoutSuplemenBloc.getResult,
              builder: (context,AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot){
                if(snapshot.hasError) print(snapshot.error);
                return snapshot.hasData? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(snapshot.data.result.address, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12,color:Colors.grey)),
                  ],
                ): Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16.0),
                    Divider(),
                    SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16.0),
                  ],
                );
              }
          ),
        ],
      ),
    );
  }
  Widget _address(BuildContext context){
    return Container(
      margin: EdgeInsets.only(left:10.0,right:10.0),
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _provinsi(context),
          _kota(context),
          _kecamatan(context),
        ],
      ),
    );
  }
  Widget _provinsi(BuildContext context) {
    return StreamBuilder(
        stream: provinsiBloc.allProvinsi,
        builder: (context,AsyncSnapshot<ProvinsiModel> snapshot) {
          if(snapshot.hasData){
            return new InputDecorator(
              decoration: const InputDecoration(
                  labelText: 'Provinsi:',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 20)
              ),
              isEmpty: _currentItemSelectedProvinsi == null,
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _currentItemSelectedProvinsi,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      var cik = newValue.split("|");
                      _onDropDownItemSelectedProvinsi(newValue);
                      getKota(cik[0]);
                      _onDropDownItemSelectedKota(null);
                      _onDropDownItemSelectedKecamatan(null);
                      tProvinsi = ", Provinsi "+cik[1];
                    });
                  },
                  items: snapshot.data.result.map((prefix0.Result items) {
                    print("############################### ${items.name} ###################");
                    String cek = "${items.id.toString()}|${items.name}";
                    return new DropdownMenuItem<String>(
                      value: "${cek}",
                      child: Text(items.name,style: TextStyle(fontFamily: 'Rubik',fontSize: 12.0),),
                    );
                  }).toList()
                  ,
                ),
              ),
            );
          }else if(snapshot.hasError){
            return Text(snapshot.error);
          }
          return Center(
              child: new LinearProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
              )
          );
        }
    );
  }
  Widget _kota(BuildContext context) {
    return StreamBuilder(
        stream: kotaBloc.allKota,
        builder: (context,AsyncSnapshot<KotaModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Kota:',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 20)
            ),
            isEmpty: _currentItemSelectedKota == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                value: _currentItemSelectedKota,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    var cik = newValue.split("|");
                    _onDropDownItemSelectedKota(newValue);
                    getKecamatan(cik[0]);
                    _onDropDownItemSelectedKecamatan(null);
                    tKota = ", Kota "+cik[1];
                  });
                },
                items: snapshot.data.result.map((prefix1.Result items) {
                  String cek = "${items.id}|${items.name}";
                  return new DropdownMenuItem<String>(
                    value: "$cek",
                    child: new Text(items.name,style: TextStyle(fontFamily: 'Rubik',fontSize: 12)),
                  );
                }).toList()
                ,
              ),
            ),
          )
              :  Container();
        }
    );
  }
  Widget _kecamatan(BuildContext context) {
    return StreamBuilder(
        stream: kecamatanBloc.allKecamatan,
        builder: (context,AsyncSnapshot<prefix2.KecamatanModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Kecamatan:',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 20)
            ),
            isEmpty: _currentItemSelectedKecamatan == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                value: _currentItemSelectedKecamatan,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    var cik = newValue.split("|");
                    tKecamatan = ", Kecamatan "+cik[1];
                    _onDropDownItemSelectedKecamatan(newValue);
                  });
                },
                items: snapshot.data.result.map((prefix2.Result items) {
                  String cek = "${items.subdistrictId}|${items.subdistrictName}";
                  return new DropdownMenuItem<String>(
                    value: "$cek",
                    child: new Text(items.subdistrictName,style: TextStyle(fontFamily: 'Rubik',fontSize: 12)),
                  );
                }).toList(),
              ),
            ),
          )
              : Container();
        }
    );
  }
  Widget _kurir(BuildContext context) {
    return StreamBuilder(
        stream: detailChekoutSuplemenBloc.getResult,
        builder: (context,AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot) {
          if(snapshot.hasData){
            return new InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Kurir',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize:20),
              ),
              isEmpty: _currentItemSelectedKurir == null,
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _currentItemSelectedKurir,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      print("############################ ${newValue} #########################");
                      _onDropDownItemSelectedKurir(newValue);
                      newValue !='COD'?getOngkir():null;
                      _onDropDownItemSelectedJasa(null);
                    });
                  },
                  items: snapshot.data.result.kurir.map((prefix4.Kurir items){
                    return new DropdownMenuItem<String>(
                      value: "${items.kurir}",
                      child: Text("${items.kurir}",style:TextStyle(fontFamily: 'Rubik',fontSize: 12.0)),
                    );
                  }).toList(),
                ),
              ),
            );
          }else if(snapshot.hasError){
            print(snapshot.error);
          }
          return new Center(
              child: new LinearProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
              )
          );
        }
    );
  }
  Widget _jasa(BuildContext context) {
    return _currentItemSelectedKurir != 'COD' ? StreamBuilder(
        stream: ongkirBloc.allOngkir,
        builder: (context,AsyncSnapshot<prefix3.OngkirModel> snapshot) {
          if(snapshot.hasData){
            jasper = snapshot.data.result.kurir;
            return InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Jenis Layanan',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize:20),

              ),
              isEmpty: _currentItemSelectedJasa == null,
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _currentItemSelectedJasa,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _onDropDownItemSelectedJasa(newValue);
                      paket = newValue.split("|");
                      total=widget.total+int.parse(paket[1]);
                      totOngkir = int.parse(paket[1]);
                      print(total);
                    });
                  },
                  items: snapshot.data.result.ongkir.map((prefix3.Ongkir items) {
                    jasper = "${items.description}|${items.cost}";
                    return new DropdownMenuItem<String>(
                      value: "${jasper}",
                      child: Text("${snapshot.data.result.kurir} - ${items.description} | ${items.cost} | ${items.estimasi} (hari)",style:TextStyle(fontFamily: 'Rubik',fontSize: 12.0)),
                    );
                  }).toList(),
                ),
              ),
            );
          }else if(snapshot.hasError) {
            return Text(snapshot.error);
          }

          return Center();
        }
    ):Container();
  }

  void _onDropDownItemSelectedJasa(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedJasa = val;
    });
  }
  void _onDropDownItemSelectedKurir(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedKurir = val;
    });
  }
  void _onDropDownItemSelectedProvinsi(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedProvinsi = val;
    });
  }
  void _onDropDownItemSelectedKota(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedKota = val;
    });
  }
  void _onDropDownItemSelectedKecamatan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedKecamatan = val;
    });
  }

  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Total Tagihan", style: TextStyle(color: Colors.black54),),
              Text("Rp ${formatter.format(total==0?widget.total:total)}",style:TextStyle(color:Colors.red,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
            ],
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: Colors.green,
                onPressed: (){
                  if(dropdownValue == 'Saya'){
                    if(_currentItemSelectedKurir==null){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih kurir')));

                    }
                    else if(_currentItemSelectedKurir != 'COD'){
                      if(_currentItemSelectedJasa == null){
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih jasa layanan')));
                      }else{
                        _lainnyaModalBottomSheet(context);
                      }
                    }
                    else if(_currentItemSelectedKurir == 'COD'){
                      if(vouncher.text == ''){
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan masukan kode voucher')));
                      }else{
                        _lainnyaModalBottomSheet(context);
                      }
                    }

                  }
                  if(dropdownValue == 'Lainnya'){
                    if(_currentItemSelectedProvinsi == null){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih provinsi')));
                    }else if(_currentItemSelectedKota == null){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih kota')));
                    }else if(_currentItemSelectedKecamatan == null){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih kecamatan')));
                    }else if(_currentItemSelectedKurir==null){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih kurir')));
                    }else if(_currentItemSelectedJasa == null){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan pilih jasa layanan')));
                    }else if(otherAddress.text == ''){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan isi alamat lengkap anda')));
                    }else if(kodePos.text == ''){
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('silahkan isi kode pos')));
                    }else{
                      _lainnyaModalBottomSheet(context);
                    }
                  }
                },
                child: Text("Bayar", style: TextStyle(color: Colors.white)),
              )
          )
        ],
      ),
    );
  }

  Future<void> _pinBottomSheet(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
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
      var sendAddress; var sendVoucher; var sendKurir; var sendOngkir;
      if(dropdownValue == 'Lainnya'){
        sendAddress = "${otherAddress.text}$tKecamatan$tKota$tProvinsi, ${kodePos.text}";
        addressType = 1;
      }
      if(dropdownValue == 'Saya'){
        sendAddress = mainAddress;
        addressType = 0;
      }
      if(_currentItemSelectedKurir == 'COD'){
        sendVoucher = vouncher.text;
        sendKurir = 'COD | Cash On Delivery';
        sendOngkir = '0';
      }else{
        sendVoucher = '-';
        sendKurir = "${_currentItemSelectedKurir} | ${paket[0]}";
        sendOngkir = "${paket[1]}";
      }
      print("#################################### $sendVoucher ##################################");

      var res = await ProductMlmProvider().fetchCheckoutCart(widget.total,sendKurir,sendOngkir,sendAddress,addressType,sendVoucher,'');
      setState(() {Navigator.of(context).pop();});
      if(res.status=="success"){
        setState(() {Navigator.of(context).pop();});
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                alertTitle: richTitle("Transaksi Berhasil"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Lihat Riwayat"),
                    onPressed: (){
                      setState(() {
                        Navigator.pop(context);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailHistorySuplemen(
                              id: res.result,
                              resi: 'kosong',
                              status: 0,
                              param:'checkout'
                          ),
                        ),
                      );
                    },
                  ),
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
      else{
        setState(() {Navigator.of(context).pop();});
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res.msg)));
      }
    }
    else{
      setState(() {Navigator.of(context).pop();});
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!"),
            content: new Text("Masukan pin yang sesuai."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
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
        title: new Text("Pengiriman", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      bottomNavigationBar: _bottomNavBarBeli(context),
      // drawer: _drawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        color: Colors.white,
        height: _height,
        width: _width,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:20.0),
              color: Colors.white,
              padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Daftar Produk', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            StreamBuilder(
                stream: detailChekoutSuplemenBloc.getResult,
                builder: (context, AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot){
                  if (snapshot.hasData) {
                    totBar = snapshot.data.result.totalQty.toString();
                    return buildProduk(snapshot,context);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return _loadingProduk(context);
                }
            ),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 10.0, bottom: 0.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Informasi Pengiriman', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _optionAddress(),
            isTrue?_address(context):_alamatPengirim(),
            Container(
              padding: EdgeInsets.only(left:10.0,right:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _kurir(context),
                  _jasa(context),
                ],
              ),
            ),
            SizedBox(height:10.0),
            _currentItemSelectedKurir == 'COD'?Container(
              padding: EdgeInsets.only(left:10.0,right:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: 'Voucher',
                        style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( masukan kode voucher yang telah anda dapatkan )',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  TextField(
                    controller: vouncher,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      if (vouncher.text != value.toUpperCase())
                        vouncher.value = vouncher.value.copyWith(text: value.toUpperCase());
                    },
                  ),
                ],
              ),
            ):Container(),
            isTrue ? Container(
              padding: EdgeInsets.only(left:10.0,right:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: 'Detail Alamat',
                        style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( nama jalan, rt, rw, blok, no rumah,kelurahan)',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  TextField(
                    controller: otherAddress,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    onChanged: (v){
                      setState(() {});
                    },
                  ),
                  SizedBox(height:10.0),
                  RichText(
                    text: TextSpan(
                        text: 'Kode Pos',
                        style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( contoh : 4207081 )',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  TextField(
                    controller: kodePos,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (v){
                      setState(() {});
                    },
                  ),
                  SizedBox(height:10.0),
                  Text("Alamat Pengiriman :", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubik')),
                  Text("${otherAddress.text}$tKecamatan$tKota$tProvinsi, ${kodePos.text}", style: TextStyle(color:Colors.grey,fontSize:11.0,fontWeight: FontWeight.bold, fontFamily: 'Rubik'))
                ],
              ),
            )
                :Text(''),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ringkasan Belanja', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            buildHarga(context),
            SizedBox(height: 20.0,)
          ],
        ),
      ),
    );
  }

  Widget buildHarga(BuildContext context){
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total Harga (${totQty.toString()} Barang)', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              Text("Rp ${formatter.format(totBayar)}",style: TextStyle(color: Colors.red, fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 0.0),
          Divider(),
          SizedBox(height: 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total Ongkos Kirim', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              Text('Rp ${totOngkir==0?0:formatter.format(totOngkir)}', style: TextStyle(color: Colors.red,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProduk(AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      width:  width / 1,
      color: Colors.white,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.result.produk.length,
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
                                      imageUrl: snapshot.data.result.produk[i].picture,
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
                                  child: new Text('${snapshot.data.result.produk[i].title}',style: new TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                                SizedBox(height: 5.0),
                                Text('${snapshot.data.result.produk[i].qty} Barang (${snapshot.data.result.produk[i].weight} Gram) x ${formatter.format(int.parse(snapshot.data.result.produk[i].rawPrice))}',style: TextStyle(fontSize: 10,fontFamily: 'Rubik',color:Colors.grey,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5.0),
                                Text('Rp ${formatter.format(int.parse(snapshot.data.result.produk[i].rawPrice)*int.parse(snapshot.data.result.produk[i].qty) )}',style: TextStyle(fontSize: 12,fontFamily: 'Rubik',color: Colors.redAccent,fontWeight: FontWeight.bold),)
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

  Widget _loadingProduk(BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      width:  width / 1,
      color: Colors.white,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 3,
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
                                      imageUrl: 'http://design-ec.com/d/e_others_50/l_e_others_500.png',
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
                                    child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0)
                                ),
                                SizedBox(height: 5.0),
                                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                SizedBox(height: 5.0),
                                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0)
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

  void _lainnyaModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext bc){
          var addr;
          if(dropdownValue == 'Lainnya'){
            addr = "${otherAddress.text}$tKecamatan$tKota$tProvinsi, ${kodePos.text}";
          }
          if(dropdownValue == 'Saya'){
            addr = "$mainAddress";
          }
          return Container(
            padding: EdgeInsets.all(20.0),
            width: ScreenUtil.getInstance().setWidth(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Apakah alamat anda sudah benar ?", style:TextStyle(color:Colors.green,fontFamily: 'Rubik',fontSize: 16.0,fontWeight: FontWeight.bold)),
                Divider(),
                Text("Alamat Anda :", style:TextStyle(color:Colors.black,fontFamily: 'Rubik',fontSize: 14.0,fontWeight: FontWeight.bold)),
                SizedBox(height:10.0),
                Text("$addr", style:TextStyle(color:Colors.grey,fontFamily: 'Rubik',fontSize: 14.0,fontWeight: FontWeight.bold)),
                Divider(),
                Text("* Apabila alamat anda salah akan menghambat proses pengiriman *", style:TextStyle(color:Colors.red,fontFamily: 'Rubik',fontSize: 14.0,fontWeight: FontWeight.bold)),
                Divider(),
                SizedBox(height:20.0),
                Divider(),
                Text("Gunakan Metode Pembayaran Dari ?", style:TextStyle(color:Colors.green,fontFamily: 'Rubik',fontSize: 16.0,fontWeight: FontWeight.bold)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          color: Colors.green,
                          padding: EdgeInsets.only(top:10.0,bottom:10.0,left:20.0,right:20.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Text("Kembali",style:TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          ),
                        )
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          color: Colors.green,
                          padding: EdgeInsets.only(top:10.0,bottom:10.0,left:20.0,right:20.0),
                          child: InkWell(
                            onTap: (){
                              _pinBottomSheet(context);
                            },
                            child: Text("Lanjut",style:TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          );

        }
    );
  }
}
