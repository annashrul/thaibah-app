import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'package:thaibah/bloc/productMlmBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';

import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';

class CheckoutMlmUI extends StatefulWidget {
  String id, harga, qty;

  CheckoutMlmUI({this.id, this.harga, this.qty});
  @override
  _CheckoutMlmUIState createState() => _CheckoutMlmUIState();
}

class _CheckoutMlmUIState extends State<CheckoutMlmUI> with SingleTickerProviderStateMixin{
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
//  BuildContext context;
  TabController _controller;
  double _height;
  double _width;
  bool _isLoading = false;
  var namaController = TextEditingController();
  var telpController = TextEditingController();
  var npwpController = TextEditingController();
  var ktpController = TextEditingController();
  var pekerjaanController = TextEditingController();
  var alamatController = TextEditingController();
  var kkController = TextEditingController();
  var reffController = TextEditingController();
  String dropdownValue = 'Lainnya';

  String reff;

  final FocusNode namaFocus    = FocusNode();
  final FocusNode telpFocus    = FocusNode();
  final FocusNode npwpFocus    = FocusNode();
  final FocusNode ktpFocus    = FocusNode();
  final FocusNode pekerjaanFocus    = FocusNode();
  final FocusNode alamatFocus    = FocusNode();
  final FocusNode kkFocus    = FocusNode();
  final FocusNode reffFocus    = FocusNode();

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  Future pilih() async{
    final prefs = await SharedPreferences.getInstance();
    if(dropdownValue == 'Saya'){
      setState(() {
        namaController.text = prefs.getString('name');
        alamatController.text = prefs.getString('alamat');
        telpController.text = prefs.getString('nohp');
      });
    }else{
      namaController.text = '';
      alamatController.text = '';
      telpController.text = '';
    }

  }

  getReff() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reff = prefs.getString("kd_referral");
  }

  @override
  void initState() {
    getReff();
    reffController.text = reff;
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
  Widget _form(){
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Pilih Identitas',
              labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize:20),
            ),
            isEmpty: dropdownValue == null,
            child: new DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue  = newValue;
                  });
                  pilih();
                },
                items: <String>['Lainnya', 'Saya'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("Nama",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: namaController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("Pekerjaan",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: pekerjaanController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("No KTP",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: ktpController,
            keyboardType: TextInputType.number,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("No KK",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: kkController,
            keyboardType: TextInputType.number,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("No Telepon",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: telpController,
            keyboardType: TextInputType.number,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("No NPWP",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: npwpController,
            keyboardType: TextInputType.number,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
          Text("Alamat",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
          TextField(
            controller: alamatController,
            keyboardType: TextInputType.text,
            // maxLines: 1,
            maxLines: null,
            autofocus: false,
            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
          SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: ScreenUtilQ.getInstance().setWidth(330),
                  height: ScreenUtilQ.getInstance().setHeight(100),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        cek();
                      },
                      child: _isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):Center(
                        child: Text("Simpan",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pinBottomSheet(context) async {
    setState(() {
      _isLoading = false;
    });
    showDialog(
        context: context,
        // backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return PinScreen(callback: _callBackPin);
        }
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

      print("#####################################################BERHASIL#######################################");
      var res = await productCheckoutBloc.fetchCheckoutSuplemen(
          widget.id,
          widget.harga,
          widget.qty,
          namaController.text.toString(),
          pekerjaanController.text.toString(),
          alamatController.text.toString(),
          ktpController.text.toString(),
          kkController.text.toString(),
          npwpController.text.toString(),
          telpController.text.toString()
      );
      print(res.status);
      if(res is General){
        General result = res;
        if(result.status == 'success'){
          setState(() {
            Navigator.pop(context);
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialogQ(
                alertTitle: richTitle("Transaksi Berhasil"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => WidgetIndex(param: '',)
                      ));
                    },
                  ),
                ],
              );
            });
        }else{
          Navigator.pop(context);
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result.msg)));
        }
      }
      else{
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res.msg)));
      }

    }
    else{
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

  cek(){
    if(namaController.text == ''){
      return showInSnackBar('nama harus diisi');
    }else if(pekerjaanController.text == ''){
      return showInSnackBar('pekerjaan harus diisi');
    }else if(ktpController.text == ''){
      return showInSnackBar('No KTP harus diisi');
    }else if(kkController.text == ''){
      return showInSnackBar('No KK harus diisi');
    }else if(telpController.text == ''){
      return showInSnackBar('No Telepon harus diisi');
    }else if(npwpController.text == ''){
      return showInSnackBar('No NPWP harus diisi');
    }else if(alamatController.text == ''){
      return showInSnackBar('Alamat harus diisi');
    }else{
      _pinBottomSheet(context);
    }
  }

  Widget btnProses(){
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: new RaisedButton(
        color: Colors.green[900],
        onPressed: () {
          print(namaController.text);
          print(kkController.text);
          print(ktpController.text);
          print(npwpController.text);
          print(alamatController.text);
          print(pekerjaanController.text);
          print(telpController.text);
//          print(reff);
          _pinBottomSheet(context);

        },
        child: Text("Proses", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget build(BuildContext context) {
    // getReff();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
        title: new Text("Data Pembeli", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

      ),
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView(
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
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Pilih Identitas',
                              labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize:20),
                            ),
                            isEmpty: dropdownValue == null,
                            child: new DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue  = newValue;
                                  });
                                  pilih();
                                },
                                items: <String>['Lainnya', 'Saya'].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nama",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: namaController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.next,
                            focusNode: namaFocus,
                            onFieldSubmitted: (term){
                              namaFocus.unfocus();
                              _fieldFocusChange(context, namaFocus, telpFocus);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("No Telepon",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: telpController,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.next,
                            focusNode: telpFocus,
                            onFieldSubmitted: (term){
                              telpFocus.unfocus();
                              _fieldFocusChange(context, telpFocus, pekerjaanFocus);
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Pekerjaan",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: pekerjaanController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.next,
                            focusNode: pekerjaanFocus,
                            onFieldSubmitted: (term){
                              pekerjaanFocus.unfocus();
                              _fieldFocusChange(context, pekerjaanFocus, ktpFocus);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("No KTP",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: ktpController,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.next,
                            focusNode: ktpFocus,
                            onFieldSubmitted: (term){
                              ktpFocus.unfocus();
                              _fieldFocusChange(context, ktpFocus, kkFocus);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("No KK (Kartu Keluarga)",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: kkController,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.next,
                            focusNode: kkFocus,
                            onFieldSubmitted: (term){
                              kkFocus.unfocus();
                              _fieldFocusChange(context, kkFocus, npwpFocus);
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("No NPWP (Nomor Pokok Wajib Pajak)",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: npwpController,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.next,
                            focusNode: npwpFocus,
                            onFieldSubmitted: (term){
                              npwpFocus.unfocus();
                              _fieldFocusChange(context, npwpFocus, alamatFocus);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Alamat",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: alamatController,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            autofocus: false,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            textInputAction: TextInputAction.done,
                            focusNode: alamatFocus,
                            onFieldSubmitted: (term){
                              alamatFocus.unfocus();
                              setState(() {
                                _isLoading = true;
                              });
                              cek();
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
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {

                            },
                            icon: _isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

