import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
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
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/History/detailHistorySuplemen.dart';
import 'package:thaibah/UI/component/MLM/produkCheckoutSuplemen.dart';
import 'package:thaibah/bloc/MLM/detailChekoutSuplemenBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart' as prefix4;
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/productMlmProvider.dart';


class CheckOutSuplemen extends StatefulWidget {
  final total; final berat; final totQty; final saldoVoucher;final saldoMain;final address;final kdKec;final kecPengirim;final masaVoucher;final showPlatinum;final saldoPlatinum;final saldoGabungan;
  CheckOutSuplemen({this.total,this.berat,this.totQty,this.saldoVoucher,this.saldoMain,this.address,this.kdKec,this.kecPengirim,this.masaVoucher,this.showPlatinum,this.saldoPlatinum,this.saldoGabungan});
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
  String saldoMain = "0";
  String saldoVoucher = "0";
  String saldoPlatinum = "0";
  String saldoGabungan = "0";
  var expiredVoucher;
  var showPlatinum;

  Future pilih() async{
    expiredVoucher = widget.masaVoucher;
    showPlatinum = widget.showPlatinum;
    setState(() {
      saldoVoucher = widget.saldoVoucher;
      saldoMain = widget.saldoMain;
      saldoPlatinum = widget.saldoPlatinum;
      saldoGabungan = widget.saldoGabungan;
    });

    if(dropdownValue == 'Saya'){
      setState(() {
        isTrue = false;
        mainAddress = widget.address;
        kdKec = widget.kdKec;
        kec_pengirim = widget.kecPengirim;
        otherAddress.text = '';
        addressType = 0;
      });
      detailChekoutSuplemenBloc.fetchDetailChekoutSuplemenList();

    }else{
      setState(() {
        isTrue = true;
        mainAddress = otherAddress.text;
        kec_pengirim = widget.kecPengirim;
        addressType = 1;
      });
      provinsiBloc.fetchProvinsiist();
    }
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

    await ongkirBloc.fetchOngkirList(kec_pengirim,"$cekKec","${widget.berat}",_currentItemSelectedKurir);
  }


  String alamat = '';
  bool cekColor = true;
  String _radioValue2 = 'saldo';
  void _handleRadioValueChange2(String value) {
    _radioValue2 = value;
    switch (_radioValue2) {
      case 'saldo':
        setState(() {
          cekColor = false;
        });
        break;
      case 'voucher':
        setState(() {
          cekColor = false;
        });
        break;
      case 'platinum':
        setState(() {
          cekColor = false;
        });
        break;
      case 'gabungan':
        setState(() {
          cekColor = false;
        });
        break;
    }

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
    pilih();
    loadTheme();
    _handleRadioValueChange2(_radioValue2);
    totQty   = widget.totQty;
    totBayar = widget.total;
    dropdownValue = 'Saya';
  }


  @override
  void dispose() {
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
          labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily:'Rosemary',fontSize:20),
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
                child: Text(value,style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontSize: 12.0),),
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
          Text("Alamat Pengiriman:", style: TextStyle(fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ),),
          Text(widget.address, style: TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize: 12,color:Colors.grey)),

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
                  labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily:'Rosemary',fontSize: 20)
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
                    String cek = "${items.id.toString()}|${items.name}";
                    return new DropdownMenuItem<String>(
                      value: "${cek}",
                      child: Text(items.name,style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12.0),),
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
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rosemary",fontSize: 20)
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
                    child: new Text(items.name,style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12)),
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
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rosemary",fontSize: 20)
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
                    child: new Text(items.subdistrictName,style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12)),
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
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rosemary",fontSize:20),
              ),
              isEmpty: _currentItemSelectedKurir == null,
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _currentItemSelectedKurir,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _onDropDownItemSelectedKurir(newValue);
                      newValue !='COD' ? getOngkir():null;
                      if(newValue=='COD'){
                        totOngkir=0;
                      }
                      _onDropDownItemSelectedJasa(null);
                    });
                  },
                  items: snapshot.data.result.kurir.map((prefix4.Kurir items){
                    return new DropdownMenuItem<String>(
                      value: "${items.kurir}",
                      child: Text("${items.kurir}",style:TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12.0)),
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
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rosemary",fontSize:20),

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
                    });
                  },
                  items: snapshot.data.result.ongkir.map((prefix3.Ongkir items) {
                    jasper = "${items.description}|${items.cost}";
                    return new DropdownMenuItem<String>(
                      value: "$jasper",
                      child: Text("${snapshot.data.result.kurir} - ${items.description} | ${formatter.format(items.cost)} | ${items.estimasi} (hari)",style:TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12.0)),
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

  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
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
              Text("Rp ${_currentItemSelectedKurir=='COD'?widget.total: formatter.format(total==0?widget.total:total)}",style:TextStyle(color:Colors.red,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
            ],
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: statusLevel!='0'?warna1:ThaibahColour.primary2,
                onPressed: (){
                  if(dropdownValue == 'Saya'){
                    if(_currentItemSelectedKurir==null){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Kurir', 'failed');
                    }
                    else if(_currentItemSelectedKurir != 'COD'){
                      if(_currentItemSelectedJasa == null){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Jasa Layanan', 'failed');
                      }else{
                        _lainnyaModalBottomSheet(context);
                      }
                    }
                    else if(_currentItemSelectedKurir == 'COD'){
                      if(vouncher.text == ''){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Masukan Kode Voucher Anda', 'failed');
                      }else{
                        _lainnyaModalBottomSheet(context);
                      }
                    }

                  }
                  if(dropdownValue == 'Lainnya'){
                    if(_currentItemSelectedProvinsi == null){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Provinsi', 'failed');
                    }else if(_currentItemSelectedKota == null){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Kota', 'failed');
                    }else if(_currentItemSelectedKecamatan == null){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Kecamatan', 'failed');
                    }else if(_currentItemSelectedKurir==null){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Kurir', 'failed');
                    }else if(_currentItemSelectedJasa == null){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Jasa Layanan', 'failed');
                    }else if(otherAddress.text == ''){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Isi Alamat Lengkap Anda', 'failed');
                    }else if(kodePos.text == ''){
                      UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Isi Kode Pos', 'failed');
                    }else{
                      _lainnyaModalBottomSheet(context);
                    }
                  }
                },
                child: Text("Bayar", style: TextStyle(color: Colors.white,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold,fontSize: 14.0)),
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
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    final dbHelper = DbHelper.instance;
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

    var res = await ProductMlmProvider().fetchCheckoutCart(widget.total,sendKurir,sendOngkir,sendAddress,addressType,sendVoucher,_radioValue2);
    print("######################## STATUS CHECKOUT ${res.status}");
    if(res is CheckoutToDetailModel){
      CheckoutToDetailModel result = res;
      if(result.status=="success"){
        final userRepo = UserRepository();
        final id = await userRepo.getDataUser("id");
        final statusLevel = await userRepo.getDataUser("statusLevel");
        Map<String, dynamic> row = {
          DbHelper.columnId    : id,
          DbHelper.columnStatusLevel  : result.result.levelStatus,
          DbHelper.columnWarna1       : result.result.tema.warna1,
          DbHelper.columnWarna2       : result.result.tema.warna2,
        };
        if(int.parse(statusLevel) < result.result.levelStatus){
          await dbHelper.update(row);
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialogQ(
                alertTitle: richTitle("Transaksi Berhasil"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Lihat Riwayat",style:TextStyle(fontWeight:FontWeight.bold,fontFamily: ThaibahFont().fontQ)),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailHistorySuplemen(
                              id: result.result.id.toString(),
                              resi: 'kosong',
                              status: 0,
                              param:'checkout'
                          ),
                        ),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text("Kembali",style:TextStyle(fontWeight:FontWeight.bold,fontFamily: ThaibahFont().fontQ),),
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
        setState(() {Navigator.of(context).pop();});
        UserRepository().notifNoAction(scaffoldKey, context,result.msg,"failed");
//        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result.msg)));
      }
    }else{
      setState(() {Navigator.of(context).pop();});
      setState(() {Navigator.of(context).pop();});
      General result = res;
      UserRepository().notifNoAction(scaffoldKey, context,result.msg,"failed");
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
      appBar:UserRepository().appBarWithButton(context,"Form Pengiriman",warna1,warna2,(){Navigator.of(context).pop();},Container()),
      bottomNavigationBar: _bottomNavBarBeli(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        color: Colors.white,
        height: _height,
        width: _width,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:20.0,bottom:10.0),
              color: Colors.white,
              padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
              child:Text('Daftar Produk', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
            ),
            ProdukCheckoutSuplemen(),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Informasi Pengiriman', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
            _currentItemSelectedKurir == 'COD' ? Container(
              padding: EdgeInsets.only(left:10.0,right:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: 'Voucher',
                        style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( masukan kode voucher yang telah anda dapatkan )',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
                        style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( nama jalan, rt, rw, blok, no rumah,kelurahan)',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontFamily: ThaibahFont().fontQ),
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
                        style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( contoh : 4207081 )',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontFamily: ThaibahFont().fontQ),
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
                  Text("Alamat Pengiriman :", style: TextStyle(fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ)),
                  Text("${otherAddress.text}$tKecamatan$tKota$tProvinsi, ${kodePos.text}", style: TextStyle(color:Colors.grey,fontSize:11.0,fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ))
                ],
              ),
            ):Text(''),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Gunakan Metode Pembayaran Dari ?', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'saldo',
                              groupValue: _radioValue2,
                              onChanged: _handleRadioValueChange2,
                            ),
                            Text('Saldo Utama',style: new TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$saldoMain",style: new TextStyle(color:Colors.red,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))

                      ],
                    ),
                  ),
                  expiredVoucher == true ? SizedBox(height: 5.0) : SizedBox(height: 0.0),
                  expiredVoucher == true ? Container(
                    padding:EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'voucher',
                              groupValue: _radioValue2,
                              onChanged: _handleRadioValueChange2,
                            ),
                            new Text('Saldo Voucher',style: new TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$saldoVoucher",style: new TextStyle(color:Colors.red,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ) : Container(),
                  showPlatinum == true ? SizedBox(height: 5.0) : SizedBox(height: 0.0),
                  showPlatinum == true ? Container(
                    padding:EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'platinum',
                              groupValue: _radioValue2,
                              onChanged: _handleRadioValueChange2,
                            ),
                            new Text('Saldo Platinum',style: new TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$saldoPlatinum",style: new TextStyle(color:Colors.red,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))

                      ],
                    ),
                  ) : Container(),
                  showPlatinum == true ? SizedBox(height: 5.0) : SizedBox(height: 0.0),
                  showPlatinum == true ? Container(
                    padding:EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'gabungan',
                              groupValue: _radioValue2,
                              onChanged: _handleRadioValueChange2,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Saldo Gabungan',style: new TextStyle(fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                                Text('gabungan saldo platinum & utama',style: new TextStyle(color:Colors.green,fontStyle: FontStyle.italic,fontSize: 10.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                              ],
                            )

                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("$saldoPlatinum",textAlign:TextAlign.right,style: new TextStyle(color:Colors.red,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                            Text("$saldoGabungan",textAlign:TextAlign.left,style: new TextStyle(color:Colors.red,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                          ],
                        )

                      ],
                    ),
                  ) : Container(),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ringkasan Belanja', style: TextStyle(color:Colors.green,fontSize: 14.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
              Text('Total Harga (${totQty.toString()} Barang)', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
              Text("Rp ${formatter.format(totBayar)}",style: TextStyle(color: Colors.red, fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 0.0),
          Divider(),
          SizedBox(height: 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total Ongkos Kirim', style: TextStyle(color:Colors.grey,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
              Text('Rp ${totOngkir==0?0:formatter.format(totOngkir)}', style: TextStyle(color: Colors.red,fontSize: 12.0,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
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
            width: ScreenUtilQ.getInstance().setWidth(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Apakah alamat anda sudah benar ?", style:TextStyle(color:Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 16.0,fontWeight: FontWeight.bold)),
                Divider(),
                Text("Alamat Anda :", style:TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontSize: 14.0,fontWeight: FontWeight.bold)),
                SizedBox(height:10.0),
                Text("$addr", style:TextStyle(color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontSize: 14.0,fontWeight: FontWeight.bold)),
                Divider(),
                Text("* Apabila alamat anda salah akan menghambat proses pengiriman *", style:TextStyle(color:Colors.red,fontFamily:ThaibahFont().fontQ,fontSize: 14.0,fontWeight: FontWeight.bold)),
                SizedBox(height:20.0),

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
                            child: Text("Kembali",style:TextStyle(color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
                            child: Text("Lanjut",style:TextStyle(color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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

