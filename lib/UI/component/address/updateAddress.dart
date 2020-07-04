import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/bloc/addressBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/Model/provinsiModel.dart' as prefix0;
import 'package:thaibah/Model/kotaModel.dart' as prefix1;
import 'package:thaibah/Model/kecamatanModel.dart' as prefix2;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/Constants/constants.dart';

class UpdateAddress extends StatefulWidget {
  final String main_address,kd_prov,kd_kota,kd_kec,id;
  UpdateAddress({this.main_address,this.kd_prov,this.kd_kota,this.kd_kec,this.id});
  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
//  TextEditingController mainAddressController = TextEditingController();
  String _currentItemSelectedProvinsi=null;
  String _currentItemSelectedKota=null;
  String _currentItemSelectedKecamatan=null;

  String tProvinsi='', tKota='', tKecamatan='';
  String sProv='',sKota='',sKec='';

  var mainAddressController = TextEditingController();
  final FocusNode mainAddressFocus = FocusNode();

  String name = "";
  String nohp = "";
  getPref() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      nohp = prefs.getString('nohp');
    });
  }
  getKota(id) async{
    kotaBloc.fetchKotaList(id.toString());
    setState(() {});

  }

  getKecamatan(id) async{
    kecamatanBloc.fetchKecamatanList(id.toString());
    setState(() {});
  }

  Future update() async{
    var res = await updateAddressBloc.fetcUpdateAddress(
        "Alamat Rumah",
        name,
        "${mainAddressController.text}$tKecamatan$tKota$tProvinsi",
        sProv,
        sKota,
        sKec,
        nohp,
        widget.id
    );
    
    if(res is General){
      General result = res;
      if(result.status == 'success'){
        setState(() {
          _isLoading  = false;
        });
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
        UserRepository().notifNoAction(_scaffoldKey, context, result.msg,"success");
//        return showInSnackBar(result.msg,'sukses');
      }else{
        setState(() {_isLoading = false;});
        UserRepository().notifNoAction(_scaffoldKey, context, result.msg,"failed");
//        return showInSnackBar(result.msg,'gagal');
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      UserRepository().notifNoAction(_scaffoldKey, context, results.msg,"success");
//      return showInSnackBar(results.msg,'gagal');
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
    super.initState();
    loadTheme();
    provinsiBloc.fetchProvinsiist();
//    kotaBloc.fetchKotaList(widget.kd_prov);
//    kecamatanBloc.fetchKecamatanList(widget.kd_kota);
//    getKota();
//    mainAddressController.text    = widget.main_address;
//    _currentItemSelectedProvinsi  = int.parse(widget.kd_prov);
//    _currentItemSelectedKota      = int.parse(widget.kd_kota);
//    _currentItemSelectedKecamatan = int.parse(widget.kd_kec);
    print("IEU KODE KOTA ${widget.kd_kota}");
    getPref();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mainAddressController.dispose();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtilQ.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar:UserRepository().appBarWithButton(context,"Ubah Alamat",warna1,warna2,(){Navigator.pop(context);},Container()),
        body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      offset: new Offset(0.0, 2.0),
                      blurRadius: 25.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32)
                  )
              ),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _provinsi(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _kota(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _kecamatan(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16.0,right:16.0,top:16.0,bottom:0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                              text: 'Alamat',
                              style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(text: ' ( nama jalan, rt, rw, blok, no rumah,kelurahan)',style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                              ]
                          ),
                        ),
                        TextField(
                          style: TextStyle(fontFamily:  ThaibahFont().fontQ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ)
                          ),
                          controller: mainAddressController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          focusNode: mainAddressFocus,
                          onChanged: (v){
                            setState(() {});
                          },
                          onSubmitted: (value){
                            mainAddressFocus.unfocus();
                            if(mainAddressController.text == ''){
                              UserRepository().notifNoAction(_scaffoldKey, context,"Detail Alamat Harus Diisi","failed");
//                              return showInSnackBar("Detail Alamat Harus Diisi",'gagal');
                            }else if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
                              UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Provinsi","failed");
//                              return showInSnackBar("Provinsi Harus Diisi",'gagal');
                            }else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
//                              return showInSnackBar("Kota Harus Diisi",'gagal');
                              UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Kota","failed");

                            }else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
//                              return showInSnackBar("Kecamatan Harus Diisi",'gagal');
                              UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Kecamatan","failed");

                            }
                            else{
                              setState(() {
                                _isLoading = true;
                              });
                              update();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Alamat Pengiriman :", style: TextStyle(fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ)),
                        Text("${mainAddressController.text}$tKecamatan$tKota$tProvinsi", style: TextStyle(color:Colors.grey,fontSize:11.0,fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ))
                      ],
                    ),
                  ),
                  UserRepository().buttonQ(context,warna1,warna2,(){
                    mainAddressFocus.unfocus();
                    if(mainAddressController.text == ''){
                      UserRepository().notifNoAction(_scaffoldKey, context,"Detail Alamat Harus Diisi","failed");
//                              return showInSnackBar("Detail Alamat Harus Diisi",'gagal');
                    }else if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
                      UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Provinsi","failed");
//                              return showInSnackBar("Provinsi Harus Diisi",'gagal');
                    }else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
//                              return showInSnackBar("Kota Harus Diisi",'gagal');
                      UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Kota","failed");

                    }else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
//                              return showInSnackBar("Kecamatan Harus Diisi",'gagal');
                      UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Kecamatan","failed");

                    }
                    else{
                      setState(() {
                        _isLoading = true;
                      });
                      update();
                    }
                  }, _isLoading)
//                  Align(
//                      alignment: Alignment.centerRight,
//                      child: Container(
//                        margin: EdgeInsets.all(16),
//                        decoration: BoxDecoration(
//                            color: Colors.green, shape: BoxShape.circle
//                        ),
//                        child: IconButton(
//                          color: Colors.white,
//                          onPressed: () {
//                            if(mainAddressController.text == ''){
//                              return showInSnackBar("Detail Alamat Harus Diisi",'gagal');
//                            }else if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
//                              return showInSnackBar("Provinsi Harus Diisi",'gagal');
//                            }else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
//                              return showInSnackBar("Kota Harus Diisi",'gagal');
//                            }else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
//                              return showInSnackBar("Kecamatan Harus Diisi",'gagal');
//                            }
//                            else{
//                              setState(() {
//                                _isLoading = true;
//                              });
//                              update();
//                            }
//                          },
//                          icon: _isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
//                        ),
//                      )
//                  ),
                ],
              ),
            ),
          ],
        )
    );
  }


  _provinsi(BuildContext context) {
    return StreamBuilder(
        stream: provinsiBloc.allProvinsi,
        builder: (context,AsyncSnapshot<ProvinsiModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Provinsi:',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rosemary",fontSize: 20)
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
                    print(cik[0]);
                    sProv = cik[0];
                    _onDropDownItemSelectedKota(null);
                    _onDropDownItemSelectedKecamatan(null);
                    tProvinsi = ", Provinsi "+cik[1];
                  });
                },
                items: snapshot.data.result.map((prefix0.Result items) {
                  String cek = "${items.id.toString()}|${items.name}";
                  return new DropdownMenuItem<String>(
                    value: "$cek",
                    child: Text(items.name,style: TextStyle(fontSize: 12,fontFamily: ThaibahFont().fontQ),),
                  );
                }).toList(),
              ),
            ),
          ):  new Center(
              child: new LinearProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
              )
          );
        }
    );
  }
  _kota(BuildContext context) {
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
                    print(cik[0]);
                    sKota = cik[0];
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
  _kecamatan(BuildContext context) {
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
                    sKec = cik[0];
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

  void _onDropDownItemSelectedProvinsi(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedProvinsi = val;
    });
  }

  void _onDropDownItemSelectedKota(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedKota = val;
    });
  }

  void _onDropDownItemSelectedKecamatan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedKecamatan = val;
    });
  }
}
