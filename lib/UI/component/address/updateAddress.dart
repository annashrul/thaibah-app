import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    final userRepository = UserRepository();
    setState(() async {
      name = await userRepository.getDataUser('name');
      nohp = await userRepository.getDataUser('phone');
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
        Navigator.pop(context);
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
        UserRepository().notifNoAction(_scaffoldKey, context, result.msg,"success");
      }else{
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context, result.msg,"failed");
      }
    }else{
      General results = res;
      Navigator.pop(context);
      UserRepository().notifNoAction(_scaffoldKey, context, results.msg,"success");
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _provinsi(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _kota(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _kecamatan(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16.0,right:16.0,top:0,bottom:16),
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

                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
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
                    }else if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
                      UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Provinsi","failed");
                    }else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
                      UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Kota","failed");

                    }else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
                      UserRepository().notifNoAction(_scaffoldKey, context,"Silahkan Pilih Kecamatan","failed");
                    }
                    else{
                      UserRepository().loadingQ(context);
                      update();
                    }
                  }, false,'Simpan')
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
          if(snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(data:"Provinsi",defaultTextStyle: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                DropdownButton(
                  isDense: true,
                  isExpanded: true,
                  hint: Html(data: "Pilih",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik'),),
                  value: _currentItemSelectedProvinsi,
                  items: snapshot.data.result.map((prefix0.Result items) {
                    String cek = "${items.id.toString()}|${items.name}";
                    return new DropdownMenuItem<String>(
                      value: "${cek}",
                      child: Html(data:items.name,defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize:12),),
                    );
                  }).toList(),
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
                )
              ],
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
  _kota(BuildContext context) {
    return StreamBuilder(
        stream: kotaBloc.allKota,
        builder: (context,AsyncSnapshot<KotaModel> snapshot) {
          if(snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(data:"Kota",defaultTextStyle: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                DropdownButton(
                  isDense: true,
                  isExpanded: true,
                  hint: Html(data: "Pilih",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik'),),
                  value: _currentItemSelectedKota,
                  items: snapshot.data.result.map((prefix1.Result items) {
                    String cek = "${items.id}|${items.name}";
                    return new DropdownMenuItem<String>(
                      value: "$cek",
                      child: Html(data:items.name,defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize:12),),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      var cik = newValue.split("|");
                      _onDropDownItemSelectedKota(newValue);
                      getKecamatan(cik[0]);
                      sKota = cik[0];
                      _onDropDownItemSelectedKecamatan(null);
                      tKota = ", Kota "+cik[1];
                    });
                  },
                )
              ],
            );
          }else if(snapshot.hasError){
            return Text(snapshot.error);
          }
          return Container();
        }
    );

  }
  _kecamatan(BuildContext context) {
    return StreamBuilder(
        stream: kecamatanBloc.allKecamatan,
        builder: (context,AsyncSnapshot<prefix2.KecamatanModel> snapshot) {
          if(snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(data:"Kecamatan",defaultTextStyle: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                DropdownButton(
                  isDense: true,
                  isExpanded: true,
                  hint: Html(data: "Pilih",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik'),),
                  value: _currentItemSelectedKecamatan,
                  items: snapshot.data.result.map((prefix2.Result items) {
                    String cek = "${items.subdistrictId}|${items.subdistrictName}";
                    return new DropdownMenuItem<String>(
                      value: "$cek",
                      child: Html(data:items.subdistrictName,defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize:12),),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      var cik = newValue.split("|");
                      tKecamatan = ", Kecamatan "+cik[1];
                      sKec = cik[0];
                      _onDropDownItemSelectedKecamatan(newValue);
                    });
                  },
                )
              ],
            );
          }else if(snapshot.hasError){
            return Text(snapshot.error);
          }
          return Container();
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
