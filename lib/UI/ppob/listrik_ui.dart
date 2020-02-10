import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCekTagihanModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart' as prefix0;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/tabTokenPasca.dart';
import 'package:thaibah/UI/component/tabTokenPra.dart';
import 'package:thaibah/UI/lainnya/produkPpobPra.dart';
import 'package:thaibah/UI/ppob/detailPpobPasca.dart';
import 'package:thaibah/bloc/PPOB/PPOBPascaBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/PPOB/PPOBPascaProvider.dart';


class ListrikUI extends StatefulWidget {
  final String nohp;
  ListrikUI({this.nohp});
  @override
  _ListrikUIState createState() => _ListrikUIState();
}

class _ListrikUIState extends State<ListrikUI> with SingleTickerProviderStateMixin{
  bool isExpanded = false;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
//  TextEditingController nohpController = TextEditingController();
//  TextEditingController nometeran = TextEditingController();
  var nohpController  = TextEditingController();
  var nometeran       = TextEditingController();
  final FocusNode nohpFocus = FocusNode();
  final FocusNode noMeteranFocus = FocusNode();
  String _currentItemSelectedLayanan=null;
  TextEditingController noController = TextEditingController();
  TextEditingController idPelangganController = TextEditingController();
  final FocusNode idPelangganFocus = FocusNode();
  final FocusNode noFocus = FocusNode();
  var noMeteran = "";
  var noHp = "";
  double _height;
  double _width;
  void _onDropDownItemSelectedLayanan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedLayanan = val;
    });
  }
  void showInSnackBar(String value, String param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Rubik"),
      ),
      backgroundColor: param == 'failed' ? Color(0xFFd50000) : Colors.green,
      duration: Duration(seconds: 5),
    ));
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future cekTagihan(var layanan,var meteran,var nohp) async{
    if(layanan == '' || layanan == null){
      setState(() {isLoading = false;});
      return showInSnackBar("Silahkan Pilih Layanan",'failed');
    }
    else if(meteran == '' || layanan == null){
      setState(() {isLoading = false;});
      return showInSnackBar("Silahkan Isi No Meteran",'failed');
    }else if(nohp == '' || nohp == null){
      setState(() {isLoading = false;});
      return showInSnackBar("Silahkan Isi No Telepon",'failed');
    }else{

      print("$layanan, $nohp, $meteran");
      var res = await PpobPascaProvider().fetchPpobPascaCekTagihan(layanan, nohp, meteran);
      if(res is PpobPascaCekTagihanModel){
        PpobPascaCekTagihanModel results = res;
        if(results.status == 'success'){
          Timer(Duration(seconds: 1), () {
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => DetailPpobPasca(
                param : "TOKEN",
                tagihan_id:results.result.tagihanId,
                code:results.result.code,
                product_name:results.result.productName,
                type:results.result.type,
                phone:results.result.phone,
                no_pelanggan:results.result.noPelanggan,
                nama:results.result.nama,
                periode:results.result.periode,
                jumlah_tagihan:results.result.jumlahTagihan.toString(),
                admin:results.result.admin.toString(),
                jumlah_bayar:results.result.jumlahBayar.toString(),
                status:results.result.status,
                nominal:'0'
              )),
            ).whenComplete(loadingFalse);
          });
          return showInSnackBar(results.msg,'success');
        }else{
          setState(() {
            isLoading = false;
          });
          return showInSnackBar(results.msg,'failed');
        }
      }else{
        setState(() {
          isLoading = false;
        });
        General results = res;
        return showInSnackBar(results.msg,'failed');
      }
    }

  }

  Future cekPra() async{
    setState(() {
      _isLoading = false;
    });
    if(nometeran.text == ''){
      return showInSnackBar("No Meteran / ID Pelanggan Harus Diisi",'failed');
    }
    else if(nohpController.text == ""){
      return showInSnackBar("No Handphone Harus Diisi",'failed');
    }
    else{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('idpelanggan',nometeran.text);
      setState(() {
        _isLoading = false;
        noHp = nohpController.text;
        noMeteran = nometeran.text;
      });
      Navigator.of(context, rootNavigator: true).push(
        new CupertinoPageRoute(builder: (context) => ProdukPpobPra(param: "TOKEN".toUpperCase(),layanan: '',nohp: noMeteran)),
      );
      print("ID PELANGGAN" + prefs.getString('idpelanggan'));
    }

  }


  Future<void> loadingFalse() async{
    setState(() {
      isLoading = false;
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nohpController.text = widget.nohp;
//    _isLoading = false;
//    _initializeTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        new MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DefaultTabController(
              length:2,
              child: Scaffold(
                key: scaffoldKey,
                // backgroundColor: Styles.primaryColor,
                appBar: new AppBar(
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
                  title: new Text("Pembayaran Listrik", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                  automaticallyImplyLeading: true,
                  backgroundColor: Styles.primaryColor,
                  elevation: 0.0,
                  bottom: TabBar(
                    indicatorColor: Colors.white54,
                    tabs: <Widget>[
                      Tab(text: "Token Listrik",),
                      Tab(text: "Listrik Pascabayar"),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    tokenPra(context),
                    isLoading?Container(child: Center(child: CircularProgressIndicator())) : TabTokenPasca(nohp:widget.nohp,valid:(String layanan,String meteran, String nohp ){
                      setState(() {
                        isLoading = true;
                      });
                      cekTagihan(layanan,meteran,nohp);
                    })
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget tokenPra(BuildContext context){
    return ListView(
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
          ),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("No Meteran / ID Pelanggan",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: nometeran,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      focusNode: noMeteranFocus,
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, noMeteranFocus, nohpFocus);
                      },
                    ),
                    SizedBox(height: 20.0),

                    Text("No Telepon",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                      textInputAction: TextInputAction.done,
                      controller: nohpController,
                      focusNode: nohpFocus,
                      onFieldSubmitted: (value){
                        nohpFocus.unfocus();
                        setState(() {
                          _isLoading = true;
                        });
                        cekPra();

                      },
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        cekPra();

                      },
                      icon: _isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                    ),
                  )
              ),
//              noMeteran != "" ? TabTokenPra(nohp: noMeteran) : Center(child: Text('Data Belum Tersedia',style: TextStyle(fontWeight: FontWeight.bold),),),
//              SizedBox(height: 20.0),
            ],
          ),
        ),
        SizedBox(height: 20.0,)
      ],
    );
  }


}
