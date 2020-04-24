import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPraModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/lainnya/produkPpobPra.dart';
import 'package:thaibah/bloc/PPOB/PPOBPraBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/resources/PPOB/PPOBPraProvider.dart';

class PpobPrabayar extends StatefulWidget {
  final String param,title,nohp;
  PpobPrabayar({this.nohp,this.param,this.title});
  @override
  _PpobPrabayarState createState() => _PpobPrabayarState();
}

class _PpobPrabayarState extends State<PpobPrabayar> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var nohpController = TextEditingController();
  final FocusNode nohpFoucs = FocusNode();
  String _currentItemSelectedLayanan=null;
  bool _isLoading = false;
  bool cekType = true;
  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Rubik"),
      ),
      backgroundColor: Color(0xFFd50000),
      duration: Duration(seconds: 5),
    ));
  }

  var param='';

  void _onDropDownItemSelectedLayanan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedLayanan = val;
    });
  }

  Future cekTagihan() async{
    if(widget.param == 'E_MONEY'){
      if(_currentItemSelectedLayanan == null){
        setState(() {_isLoading=false;});
        return showInSnackBar('Silahkan Pilih Jasa Layanan');
      }
    }
    if(nohpController.text == ''){
      setState(() {_isLoading=false;});
      return showInSnackBar('Silahkan Masukan No Telepon');
    }else{
      setState(() {
        cekType=true;
        _isLoading=false;
      });
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) => ProdukPpobPra(
          param:widget.param,layanan:_currentItemSelectedLayanan,nohp:nohpController.text
      ))).whenComplete(cekStatus);

//      Navigator.of(context, rootNavigator: true).push(
//        new CupertinoPageRoute(builder: (context) => ProdukPpobPra(
//           param:widget.param,layanan:_currentItemSelectedLayanan,nohp:nohpController.text
//        )),
//      );
    }
  }

  Future<void> cekStatus() async{
    param = widget.param;
    if(param == 'E_MONEY'){
//      ppobPraBloc.fetchPpobPra(param, '');
      setState(() {
        cekType = true;
      });
    }else{
      setState(() {
        cekType = false;
      });
    }
    print(param);
    print(cekType);
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekStatus();
    nohpController.text = widget.nohp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text('${widget.title}',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.param == 'E_MONEY' ? layanan(context) : Container(),
                SizedBox(height: 20.0,),
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
                    setState(() {_isLoading = true;});
                    cekTagihan();
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
                    setState(() {_isLoading = true;});
                    cekTagihan();
                  },
                  icon: _isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                ),
              )
          ),

        ],
      ),
    );
  }

  List layananEmoney = ["OVO","DANA","GOPAY","LINKAJA"];
  layanan(BuildContext context){
    return new InputDecorator(
      decoration: const InputDecoration(
          labelText: 'Layanan',
          labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 16)
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
          items: layananEmoney.map((items){
            return new DropdownMenuItem<String>(
              value: items,
              child: Text(items,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
            );
          }).toList(),
        ),
      ),
    );
  }

}
