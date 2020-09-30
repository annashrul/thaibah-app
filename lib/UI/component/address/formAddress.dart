import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/address/indexAddress.dart';
import 'package:thaibah/bloc/addressBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/Model/provinsiModel.dart' as prefix0;
import 'package:thaibah/Model/kotaModel.dart' as prefix1;
import 'package:thaibah/Model/kecamatanModel.dart' as prefix2;
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/addressProvider.dart';
class FormAddress extends StatefulWidget {
  final String param;
  FormAddress({this.param});
  @override
  _FormAddressState createState() => _FormAddressState();
}

class _FormAddressState extends State<FormAddress> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _currentItemSelectedProvinsi=null;
  String _currentItemSelectedKota=null;
  String _currentItemSelectedKecamatan=null;
  String tProvinsi = '', tKota='',tKecamatan='',name = "",nohp = "",sProv='',sKota='',sKec='';
  var mainAddressController = TextEditingController();
  final FocusNode mainAddressFocus = FocusNode();
  getPref() async{
    final prefs = await SharedPreferences.getInstance();
    final userRepository = UserRepository();
    String nama = await userRepository.getDataUser('name');
    String phone = await userRepository.getDataUser('phone');
    setState(() {
      name = nama;
      nohp = phone;
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
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"success");
        await Future.delayed(Duration(seconds: 1000));
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_context) => IndexAddress()),);
      }else{
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"success");
      }
    }else{
      General result = res;
      Navigator.pop(context);
      UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"success");
    }

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
        widget.param
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
  @override
  void initState() {
    super.initState();
    provinsiBloc.fetchProvinsiist();
    getPref();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: UserRepository().appBarWithButton(context, "${widget.param==''?'Tambah Alamat':'Ubah Alamat'}",(){Navigator.pop(context);},<Widget>[]),
        body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(left:10.0,right:10.0,bottom: 10.0),
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
                        SizedBox(height: 10.0),
                        UserRepository().textQ("Alamat Lengkap",12,Colors.black,FontWeight.bold,TextAlign.left),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                            controller: mainAddressController,
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 3,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: "nama jalan, rt, rw, blok, no rumah,kelurahan",
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            textInputAction: TextInputAction.done,
                            focusNode: mainAddressFocus,
                            onChanged: (v){
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        UserRepository().textQ("Detail Alamat Anda",12,Colors.black,FontWeight.bold,TextAlign.left),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: UserRepository().textQ("${mainAddressController.text}$tKecamatan$tKota$tProvinsi",12,Colors.black,FontWeight.bold,TextAlign.left),
                        ),
                        SizedBox(height: 10.0),
                        UserRepository().buttonQ(context,(){
                          mainAddressFocus.unfocus();
                          if(_currentItemSelectedProvinsi == '' || _currentItemSelectedProvinsi == null){
                            UserRepository().notifNoAction(_scaffoldKey, context, "Provinsi tidak boleh kosong", 'failed');
                          }
                          else if(_currentItemSelectedKota == '' || _currentItemSelectedKota == null){
                            UserRepository().notifNoAction(_scaffoldKey, context, "Kota tidak boleh kosong", 'failed');
                          }
                          else if(_currentItemSelectedKecamatan == '' || _currentItemSelectedKecamatan == null){
                            UserRepository().notifNoAction(_scaffoldKey, context, "Kecamatan tidak boleh kosong", 'failed');
                          }
                          else if(mainAddressController.text == ''){
                            UserRepository().notifNoAction(_scaffoldKey, context, "Alamat lengkap tidak boleh kosong", 'failed');
                          }
                          else{
                            UserRepository().loadingQ(context);
                            if(widget.param==''){
                              create();
                            }
                            else{

                            }

                          }
                        }, 'Simpan')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
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
                          UserRepository().textQ(items.name,10,Colors.black,FontWeight.bold,TextAlign.left)
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
                          UserRepository().textQ(items.name,10,Colors.black,FontWeight.bold,TextAlign.left)
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
                          UserRepository().textQ(items.subdistrictName,10,Colors.black,FontWeight.bold,TextAlign.left)
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
