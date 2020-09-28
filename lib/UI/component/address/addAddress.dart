import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/address/indexAddress.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/Model/provinsiModel.dart' as prefix0;
import 'package:thaibah/Model/kotaModel.dart' as prefix1;
import 'package:thaibah/Model/kecamatanModel.dart' as prefix2;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/addressProvider.dart';
class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String _currentItemSelectedProvinsi=null;
  String _currentItemSelectedKota=null;
  String _currentItemSelectedKecamatan=null;
  String tProvinsi = '', tKota='',tKecamatan='';

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
  String sProv='',sKota='',sKec='';
  getKota(id) async{

    kotaBloc.fetchKotaList(id.toString());
    setState(() {});
  }

  getKecamatan(id) async{
    kecamatanBloc.fetchKecamatanList(id.toString());
    setState(() {});
  }

  Future create() async{
    print("${sProv} - $sKota - $sKec");
    var res = await AddressProvider().fetchCreateAddress(
        "Alamat Rumah",
        name,
        "${mainAddressController.text}$tKecamatan$tKota$tProvinsi",
        sProv,
        sKota,
        sKec,
        nohp
    );
    if(res is GeneralInsertId){
      GeneralInsertId result = res;
      if(result.status == 'success'){
        setState(() {
          _isLoading  = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_context) => IndexAddress()
          ),
        );
//        return showInSnackBar(result.msg);
      }else{
        setState(() {_isLoading = false;});
        return showInSnackBar(result.msg);
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      return showInSnackBar(results.msg);
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
    provinsiBloc.fetchProvinsiist();
    getPref();
    loadTheme();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mainAddressController.dispose();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily:ThaibahFont().fontQ),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
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
        appBar: UserRepository().appBarWithButton(context, "Tambah Alamat",(){Navigator.pop(context);},<Widget>[]),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

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
                                TextSpan(text: ' ( nama jalan, rt, rw, blok, no rumah,kelurahan)',style: TextStyle(color: Colors.green,fontSize: 10,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                              ]
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
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
                              return showInSnackBar("Detail Alamat Harus Diisi");
                            }else if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
                              return showInSnackBar("Provinsi Harus Diisi");
                            }else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
                              return showInSnackBar("Kota Harus Diisi");
                            }else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
                              return showInSnackBar("Kecamatan Harus Diisi");
                            }
                            else{
                              setState(() {
                                _isLoading = true;
                              });
                              create();
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
                  UserRepository().buttonQ(context,(){
                    mainAddressFocus.unfocus();
                    if(mainAddressController.text == ''){
                      return showInSnackBar("Detail Alamat Harus Diisi");
                    }else if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
                      return showInSnackBar("Provinsi Harus Diisi");
                    }else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
                      return showInSnackBar("Kota Harus Diisi");
                    }else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
                      return showInSnackBar("Kecamatan Harus Diisi");
                    }
                    else{
                      setState(() {
                        _isLoading = true;
                      });
                      create();
                    }
                  }, 'Simpan')

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
                    child: Text(items.name,style: TextStyle(fontSize: 12),),
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
  _kecamatan(BuildContext context) {
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
                    sKec = cik[0];
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
