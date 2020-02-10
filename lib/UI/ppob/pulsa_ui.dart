import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parallax/flutter_parallax.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/tabData.dart';
import 'package:thaibah/UI/component/tabPulsa.dart';
import 'package:thaibah/UI/lainnya/produkPpobPra.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/style.dart';


class PulsaUI extends StatefulWidget {
  final String nohp;
  PulsaUI({this.nohp});
  @override
  _PulsaUIState createState() => _PulsaUIState();
}

class _PulsaUIState extends State<PulsaUI> with SingleTickerProviderStateMixin{
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TabController _controller;
  var nohpController = TextEditingController();
  final FocusNode nohpFoucs = FocusNode();
  double _height;
  double _width;
  Widget vtabpulsa;
  Widget dataV;
  var nohp = "";
  String _currentItemSelectedLayanan = 'Pulsa';
  Timer _timer;

  Future cek() async{
    String layanan = '';
    if(_currentItemSelectedLayanan == null){
      return showInSnackBar("Silahkan Pilih Layanan");
    }else if(nohpController.text == ''){
      return showInSnackBar("Silahkan Masukan No Telepon");
    }else{
      print('lolos');
      if(_currentItemSelectedLayanan.length > 5){
        layanan = 'data';
      }else{
        layanan = 'pulsa';
      }
      _timer.cancel();
      Navigator.of(context, rootNavigator: true).push(
        new CupertinoPageRoute(builder: (context) => ProdukPpobPra(param: layanan.toUpperCase(),layanan: '',nohp: nohpController.text)),
      );
    }
  }




  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    nohpController.text = widget.nohp;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Rubik"),
      ),
      backgroundColor: Color(0xFFd50000),
      duration: Duration(seconds: 5),
    ));
  }

  Widget clipShape() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            // transform: Matrix4.translationValues(0.0, -120.0, 0.0),
            margin: EdgeInsets.only(top: _height/5.5,),
            child: Material(
                color: Colors.white,
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new ExactAssetImage("assets/images/ic_cell_phone_100.png")),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: new TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: nohpController,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukan No Handphone",
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: nohpFoucs,
                        onFieldSubmitted: (value){
                          nohpFoucs.unfocus();
                          if(nohpController.text == ""){
                            return showInSnackBar("No Handphone Harus Diisi");
                          }else{
                            setState(() {
                              _isLoading = true;
                              nohp = nohpController.text;
                            });
                          }
                          nohpController.clear();
                          _isLoading = false;
                        },
                      ),
                    ),
                    Container(
                        height: 40.0,
                        width: 40.0,
                        child: InkWell(
                          onTap: (){
                            if(nohpController.text == ""){
                              return showInSnackBar("No Handphone Harus Diisi");
                            }else{
                              setState(() {
                                _isLoading = true;
                                nohp = nohpController.text;
                              });
                            }
                            nohpController.clear();
                            _isLoading = false;
                          },
                          child: _isLoading?
                          Center(
                              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black))
                          ):Center(
                            child: Icon(Icons.send),
                          ),
                          //                            child: Icon(Icons.send),
                        )
                    ),
                  ],),
                )
            )
        ),

        _pulsaCepat(),
      ],
    );
  }

  Widget _pulsaCepat(){
    return Column(
      children: <Widget>[
        new Container(
          // decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child: new TabBar(
            indicatorColor: Colors.green[900],
            labelColor: Styles.primaryColor,
            unselectedLabelColor: Colors.green[100],
            controller: _controller,
            tabs: [
              new Tab(text: 'Pulsa'),
              new Tab(text: 'Paket Data'),
            ],
          ),
        ),
        new Container(
          height: _height*0.8,
          child: new TabBarView(
            controller: _controller,
            children: <Widget>[
              nohp != "" ? TabPulsa(nohp: nohp) : Center(child: Text('Paket Pulsa Belum Tersedia',style: TextStyle(fontWeight: FontWeight.bold),),),
              nohp != "" ? TabData(nohp: nohp) : Center(child: Text('Paket Data Belum Tersedia',style: TextStyle(fontWeight: FontWeight.bold),),),
            ],
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    // getPin();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
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
        automaticallyImplyLeading: false,
        title: new Text("Pulsa", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

      ),

      body: Scrollbar(
          child: ListView(
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
                      padding: EdgeInsets.only(left:16,right:16,top:32,bottom:8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new InputDecorator(
                            decoration: const InputDecoration(
                                labelText: 'Layanan',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 16)
                            ),
                            isEmpty: _currentItemSelectedLayanan == null,
                            child: DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                value:_currentItemSelectedLayanan,
                                isDense: true,
                                items: <String>['Pulsa', 'Paket Data'].map((String value){
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
//                                  print(newValue);
//                                  print(newValue.substring(6,newValue.length));
//                                  if(newValue.length > 5){
//                                    _currentItemSelectedLayanan = 'Data';
//                                  }else{
//
//                                  }
                                    _currentItemSelectedLayanan = newValue;
                                    print(_currentItemSelectedLayanan);

                                  });
                                },

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
                            focusNode: nohpFoucs,
                            onFieldSubmitted: (value){
                              nohpFoucs.unfocus();
                              cek();
//                            if(nohpController.text == ""){
//                              return showInSnackBar("No Handphone Harus Diisi");
//                            }else{
//                              setState(() {
//                                _isLoading = true;
//                                nohp = nohpController.text;
//                              });
//                            }
//                            nohpController.clear();
//                            _isLoading = false;
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
                              cek();
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        )
                    ),
//                  _pulsaCepat(),
                  ],
                ),
              ),
            ],
          )
      ),

    );
  }


}

