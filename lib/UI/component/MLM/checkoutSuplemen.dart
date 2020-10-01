import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/detailHistorySuplemen.dart';
import 'package:thaibah/UI/component/MLM/produkCheckoutSuplemen.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
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
      margin: EdgeInsets.only(left:10.0,right:10.0,top:10),
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserRepository().textQ("Pilih Alamat",12,Colors.black,FontWeight.bold,TextAlign.left),
          SizedBox(height: 10.0),
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 20,
                underline: SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue  = newValue;
                    _onDropDownItemSelectedProvinsi(null);
                    _onDropDownItemSelectedKurir(null);
                    _onDropDownItemSelectedJasa(null);
                  });
                  pilih();
                },
                items: <String>['Saya', 'Lainnya'].map<DropdownMenuItem<String>>((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        UserRepository().textQ(value,12,Colors.grey,FontWeight.bold,TextAlign.left)
                      ],
                    ),
                  );
                }).toList(),

              )
          )
        ],
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
          Text("Alamat Pengiriman:", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ),),
          Text(widget.address, style: TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(26),color:Colors.grey)),

        ],
      ),
    );
  }
  Widget _address(BuildContext context){
    return Container(
      margin: EdgeInsets.only(left:10.0,right:10.0,top:10),
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserRepository().textQ("Provinsi",12,Colors.black,FontWeight.bold,TextAlign.left),
          SizedBox(height: 10.0),
          _provinsi(context),
          SizedBox(height: 10.0),
          UserRepository().textQ("Kota",12,Colors.black,FontWeight.bold,TextAlign.left),
          SizedBox(height: 10.0),
          _kota(context),
          SizedBox(height: 10.0),
          UserRepository().textQ("Kecamatan",12,Colors.black,FontWeight.bold,TextAlign.left),
          SizedBox(height: 10.0),
          _kecamatan(context),
        ],
      ),
    );
  }
  Widget _provinsi(BuildContext context) {
    return StreamBuilder(
        stream: provinsiBloc.allProvinsi,
        builder: (context,AsyncSnapshot<ProvinsiModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _currentItemSelectedProvinsi,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  underline: SizedBox(),
                  onChanged: (newValue) {
                    setState(() {
                      var cik = newValue.split("|");
                      _onDropDownItemSelectedProvinsi(newValue);
                      getKota(cik[0]);
                      _onDropDownItemSelectedKota(null);
                      _onDropDownItemSelectedKecamatan(null);
                      tProvinsi = ", Provinsi "+cik[1];
                    });
                  },
                  items: snapshot.data.result.map((prefix0.Result items){
                    String cek = "${items.id.toString()}|${items.name}";
                    return new DropdownMenuItem<String>(
                      value: "$cek",
                      child: Row(
                        children: [
                          UserRepository().textQ(items.name,12,Colors.grey,FontWeight.bold,TextAlign.left)
                        ],
                      ),
                    );
                  }).toList(),
                )
            );
          }
          return SkeletonFrame(width: double.infinity,height: 50);
        }
    );

  }
  Widget _kota(BuildContext context) {
    return StreamBuilder(
        stream: kotaBloc.allKota,
        builder: (context,AsyncSnapshot<KotaModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _currentItemSelectedKota,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  underline: SizedBox(),
                  onChanged: (newValue) {
                    setState(() {
                      var cik = newValue.split("|");
                      _onDropDownItemSelectedKota(newValue);
                      getKecamatan(cik[0]);
                      _onDropDownItemSelectedKecamatan(null);
                      tKota = ", Kota "+cik[1];
                    });
                  },
                  items: snapshot.data.result.map((prefix1.Result items){
                    String cek = "${items.id.toString()}|${items.name}";
                    return new DropdownMenuItem<String>(
                      value: "$cek",
                      child: Row(
                        children: [
                          UserRepository().textQ(items.name,12,Colors.grey,FontWeight.bold,TextAlign.left)
                        ],
                      ),
                    );
                  }).toList(),
                )
            );
          }
          return SkeletonFrame(width: double.infinity,height: 50);
        }
    );

  }
  Widget _kecamatan(BuildContext context) {
    return StreamBuilder(
        stream: kecamatanBloc.allKecamatan,
        builder: (context,AsyncSnapshot<prefix2.KecamatanModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _currentItemSelectedKecamatan,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  underline: SizedBox(),
                  onChanged: (newValue) {
                    setState(() {
                      var cik = newValue.split("|");
                      tKecamatan = ", Kecamatan "+cik[1];
                      _onDropDownItemSelectedKecamatan(newValue);
                    });
                  },
                  items: snapshot.data.result.map((prefix2.Result items){
                    String cek = "${items.subdistrictId}|${items.subdistrictName}";
                    return new DropdownMenuItem<String>(
                      value: "$cek",
                      child: Row(
                        children: [
                          UserRepository().textQ(items.subdistrictName,12,Colors.grey,FontWeight.bold,TextAlign.left)
                        ],
                      ),
                    );
                  }).toList(),
                )
            );
          }
          return SkeletonFrame(width: double.infinity,height: 50);
        }
    );
  }
  Widget _kurir(BuildContext context) {
    return StreamBuilder(
        stream: detailChekoutSuplemenBloc.getResult,
        builder: (context,AsyncSnapshot<GetDetailChekoutSuplemenModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _currentItemSelectedKurir,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  underline: SizedBox(),
                  onChanged: (newValue) {
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
                      child: Row(
                        children: [
                          UserRepository().textQ(items.kurir,12,Colors.grey,FontWeight.bold,TextAlign.left)
                        ],
                      ),
                    );
                  }).toList(),
                )
            );
          }else if(snapshot.hasError){
            print(snapshot.error);
          }
          return SkeletonFrame(width: double.infinity,height: 50);
        }
    );

  }
  Widget _jasa(BuildContext context) {
    return _currentItemSelectedKurir != 'COD' ? StreamBuilder(
        stream: ongkirBloc.allOngkir,
        builder: (context,AsyncSnapshot<prefix3.OngkirModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            jasper = snapshot.data.result.kurir;
            return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _currentItemSelectedJasa,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  underline: SizedBox(),
                  onChanged: (newValue) {
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
                      child: Row(
                        children: [
                          UserRepository().textQ("${snapshot.data.result.kurir} - ${items.description} | ${formatter.format(items.cost)} | ${items.estimasi} (hari)",12,Colors.grey,FontWeight.bold,TextAlign.left)
                        ],
                      ),
                    );
                  }).toList(),
                )
            );
          }else if(snapshot.hasError){
            print(snapshot.error);
          }
          return SkeletonFrame(width: double.infinity,height: 50);
        }
    ):Container();

  }

  Widget _bottomNavBarBeli(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Total Tagihan", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.grey,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),),
              Text("Rp ${_currentItemSelectedKurir=='COD'?widget.total: formatter.format(total==0?widget.total:total)}",style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.red,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
            ],
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: ThaibahColour.primary2,
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
                    }
                    else if(_currentItemSelectedKurir != 'COD'){
                      if(_currentItemSelectedJasa == null){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Pilih Jasa Layanan', 'failed');
                      }
                      else if(otherAddress.text == ''){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Isi Alamat Lengkap Anda', 'failed');
                      }else if(kodePos.text == ''){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Isi Kode Pos', 'failed');
                      }else{
                        _lainnyaModalBottomSheet(context);
                      }
                    }else if(_currentItemSelectedKurir == 'COD'){
                      if(vouncher.text == ''){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Masukan Kode Voucher Anda', 'failed');
                      }
                      else if(otherAddress.text == ''){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Isi Alamat Lengkap Anda', 'failed');
                      }else if(kodePos.text == ''){
                        UserRepository().notifNoAction(scaffoldKey, context,'Silahkan Isi Kode Pos', 'failed');
                      }else{
                        _lainnyaModalBottomSheet(context);
                      }
                    }


                  }
                },
                child: Text("Bayar", style: TextStyle(color: Colors.white,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold,fontSize: ScreenUtilQ.getInstance().setSp(34))),
              )
          )
        ],
      ),
    );
  }

  Future<void> _pinBottomSheet(context) async {
    Navigator.pop(context);
    Navigator.push(context, CupertinoPageRoute(builder: (context) =>   PinScreen(callback: _callBackPin)));
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    setState(() {
      UserRepository().loadingQ(context);
    });
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
    }
    else{
      sendVoucher = '-';
      sendKurir = "${_currentItemSelectedKurir} | ${paket[0]}";
      sendOngkir = "${paket[1]}";
    }
    var res = await ProductMlmProvider().fetchCheckoutCart(widget.total,sendKurir,sendOngkir,sendAddress,addressType,sendVoucher,_radioValue2);

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
        Navigator.of(context).pop();
        UserRepository().notifAlertQ(context,'success', 'Transaksi Berhasil', 'Terimakasih Telah Melakukan Transaksi', 'Kembali','Lihat Riwayat',(){
            Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
          },(){
          Navigator.push(context, CupertinoPageRoute(builder: (context) =>   DetailHistorySuplemen(
              id: result.result.id.toString(),
              resi: 'kosong',
              status: 0,
              param:'checkout'
          )));
        });
      }
      else{
        setState(() {Navigator.of(context).pop();});
        setState(() {Navigator.of(context).pop();});
        UserRepository().notifNoAction(scaffoldKey, context,result.msg,"failed");
      }
    }
    else{
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
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: UserRepository().appBarWithButton(context, "Form Pengiriman",(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context,"Form Pengiriman",warna1,warna2,(){Navigator.of(context).pop();},Container()),
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
              child:UserRepository().textQ("Daftar Produk",14,Colors.green,FontWeight.bold,TextAlign.left),
            ),
            ProdukCheckoutSuplemen(),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UserRepository().textQ("Informasi Pengiriman",14,Colors.green,FontWeight.bold,TextAlign.left),
                ],
              ),
            ),
            _optionAddress(),
            isTrue?_address(context):_alamatPengirim(),
            Container(
              padding: EdgeInsets.only(left:10.0,right:10.0,top:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserRepository().textQ("Kurir",12,Colors.black,FontWeight.bold,TextAlign.left),
                  SizedBox(height:10.0),
                  _kurir(context),
                  SizedBox(height:10.0),
                  _currentItemSelectedKurir != 'COD' ? UserRepository().textQ("Jenis Layanan",12,Colors.black,FontWeight.bold,TextAlign.left):Container(),
                  _currentItemSelectedKurir != 'COD' ?SizedBox(height:10.0):Container(),
                  _currentItemSelectedKurir != 'COD' ?_jasa(context):Container(),
                ],
              ),
            ),
            // SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
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
                          TextSpan(text: ' ( masukan kode voucher yang telah anda dapatkan )',style: TextStyle(color: Colors.green,fontSize: 12,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: vouncher,
                      keyboardType: TextInputType.streetAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'contoh : COD200812W4',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        if (vouncher.text != value.toUpperCase())
                          vouncher.value = vouncher.value.copyWith(text: value.toUpperCase());
                      },
                    ),
                  )

                ],
              ),
            ):Container(),
            isTrue ? SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)):Container(),
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
                          TextSpan(text: ' ( nama jalan, rt, rw, blok, no rumah,kelurahan)',style: TextStyle(color: Colors.green,fontSize: 12,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: otherAddress,
                      keyboardType: TextInputType.streetAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'contoh : nama jalan, rt, rw, blok, no rumah,kelurahan',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (v){
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                  RichText(
                    text: TextSpan(
                        text: 'Kode Pos',
                        style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: ' ( contoh : 4207081 )',style: TextStyle(color: Colors.green,fontSize: 12,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        ]
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                      controller: kodePos,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'contoh : 4207081',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: (v){
                        setState(() {});
                      },
                    ),
                  ),

                  SizedBox(height:10.0),
                  Text("Alamat Pengiriman :", style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ,color: Colors.green)),
                  Text("${otherAddress.text}$tKecamatan$tKota$tProvinsi, ${kodePos.text}", style: TextStyle(color:Colors.grey,fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ))
                ],
              ),
            ):Text(''),
            Container(
              color: Colors.white,
              padding:EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Gunakan Metode Pembayaran Dari ?', style: TextStyle(color:Colors.green,fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      // border: Border.all(color: Colors.grey),
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
                            Text('Saldo Utama',style: new TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$saldoMain",style: new TextStyle(color:Colors.red,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))

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
                            new Text('Saldo Voucher',style: new TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$saldoVoucher",style: new TextStyle(color:Colors.red,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ) : Container(),
                  showPlatinum == true ? SizedBox(height: 5.0) : SizedBox(height: 0.0),
                  showPlatinum == true ? Container(
                    padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                            new Text('Saldo Platinum',style: new TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$saldoPlatinum",style: new TextStyle(color:Colors.red,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))

                      ],
                    ),
                  ) : Container(),
                  showPlatinum == true ? SizedBox(height: 5.0) : SizedBox(height: 0.0),
                  showPlatinum == true ? Container(
                    padding:EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                                Text('Saldo Gabungan',style: new TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                                Text('gabungan saldo platinum & utama',style: new TextStyle(color:Colors.green,fontStyle: FontStyle.italic,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                              ],
                            )

                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("$saldoPlatinum",textAlign:TextAlign.right,style: new TextStyle(color:Colors.red,fontSize:  ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                            Text("$saldoGabungan",textAlign:TextAlign.left,style: new TextStyle(color:Colors.red,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
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
                  Text('Ringkasan Belanja', style: TextStyle(color:Colors.green,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
              Text('Total Harga (${totQty.toString()} Barang)', style: TextStyle(color:Colors.grey,fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
              Text("Rp ${formatter.format(totBayar)}",style: TextStyle(color: Colors.red, fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 0.0),
          Divider(),
          SizedBox(height: 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Total Ongkos Kirim', style: TextStyle(color:Colors.grey,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
              Text('Rp ${totOngkir==0?0:formatter.format(totOngkir)}', style: TextStyle(color: Colors.red,fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
    );
  }

  void _lainnyaModalBottomSheet(context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
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
                Html(data:"Apakah alamat anda sudah benar ?", defaultTextStyle:TextStyle(color:Colors.green,fontFamily:ThaibahFont().fontQ,fontSize:14,fontWeight: FontWeight.bold)),
                Divider(),
                Html(data:"Alamat Anda :", defaultTextStyle:TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontSize:14,fontWeight: FontWeight.bold)),
                SizedBox(height:10.0),
                Html(data:"$addr", defaultTextStyle:TextStyle(color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontSize:14,fontWeight: FontWeight.bold)),
                Divider(),
                Html(data:"* Apabila alamat anda salah akan menghambat proses pengiriman *", defaultTextStyle:TextStyle(color:Colors.red,fontFamily:ThaibahFont().fontQ,fontSize:12,fontWeight: FontWeight.bold)),
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
                            child: Text("Kembali",style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
                            child: Text("Lanjut",style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(34),color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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

