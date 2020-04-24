import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCekTagihanModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/lainnya/bayarZakat.dart';
import 'package:thaibah/UI/lainnya/hitungZakat.dart';
import 'package:thaibah/UI/ppob/detailPpobPasca.dart';
import 'package:thaibah/bloc/PPOB/PPOBPascaBloc.dart';
import 'package:thaibah/bloc/cekTagihanBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/PPOB/PPOBPascaProvider.dart';


class ZakatUI extends StatefulWidget {
  @override
  _ZakatUIState createState() => _ZakatUIState();
}

class _ZakatUIState extends State<ZakatUI>{
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  String _currentItemSelectedLayanan=null;
  var nominalController        = TextEditingController();
  final FocusNode nominalFocus = FocusNode();

  void _onDropDownItemSelectedLayanan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedLayanan = val;
    });
  }

  Future cekTagihan() async{
    final userRepository = UserRepository();
    final nohp = await userRepository.getNoHp();
    var res = await PpobPascaProvider().fetchPpobPascaCekTagihan(_currentItemSelectedLayanan, nohp, 0);
    if(res is PpobPascaCekTagihanModel){
      PpobPascaCekTagihanModel results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
        });
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => DetailPpobPasca(
            param : "Zakat",
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
            nominal:nominalController.text
          )),
        );
      }
      else{
        setState(() {
          isLoading = false;
        });
        return showInSnackBar(results.msg);
      }
    }else{
      General results = res;
      return showInSnackBar(results.msg);
    }
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




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ppobPascaBloc.fetchPpobPasca('zakat');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Zakat', style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding:EdgeInsets.only(left:10.0,right:10.0),
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
                      _layanan(context),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Nominal',style: TextStyle(color:Color(0xFF116240),fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12.0),),
                      TextField(
                        controller: nominalController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: nominalFocus,
                        decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik')),
                        onSubmitted: (value){
                          nominalFocus.unfocus();
                          if(_currentItemSelectedLayanan == null){
                            return showInSnackBar('Silahkan Pilih Jasa Layanan');
                          }else if(nominalController.text == ''){
                            return showInSnackBar('Silahkan Masukan Nominal');
                          }else{
                            setState(() {
                              isLoading = true;
                            });
                            cekTagihan();
                          }
                        },
                      ),
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
                          if(_currentItemSelectedLayanan == null){
                            return showInSnackBar('Silahkan Pilih Jasa Layanan');
                          }else if(nominalController.text == ''){
                            return showInSnackBar('Silahkan Masukan Nominal');
                          }else{
                            setState(() {
                              isLoading = true;
                            });
                            cekTagihan();
                          }
                        },
                        icon: isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  _layanan(BuildContext context) {
    return StreamBuilder(
        stream: ppobPascaBloc.getResult,
        builder: (context,AsyncSnapshot<PpobPascaModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ?
          new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Layanan',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: 16)
            ),
            isEmpty: _currentItemSelectedLayanan == null,
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                value:_currentItemSelectedLayanan,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _onDropDownItemSelectedLayanan(newValue);
                  });
                },
                items: snapshot.data.result.data.map((Datum items){
                  return new DropdownMenuItem<String>(
                    value: items.code.toString() != null ? items.code.toString() : null,
                    child: Text(items.note,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
          ): new Center(
              child: new LinearProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
              )
          );
        }
    );
  }

}

