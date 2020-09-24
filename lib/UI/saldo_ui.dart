import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/component/bank/getAvailableBank.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';

import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';
String pin = "";
class SaldoUI extends StatefulWidget {

  String saldo; String name;

  SaldoUI({this.saldo,this.name});
  @override
  _SaldoUIState createState() => _SaldoUIState();
}

class _SaldoUIState extends State<SaldoUI> {
  List<RadioModel> sampleData = new List<RadioModel>();
  final userRepository = UserRepository();
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  TextEditingController saldoController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();
//  MoneyMaskedTextController moneyMaskedTextController;
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');
  String _saldo;
  bool isLoading = false;
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 3;
  getBank() async {
    setState(() {
      isLoading = false;
    });
    print("##################################### ${moneyController.text} #####################################");
    if(moneyController.text == null || moneyController.text == '0.00'){
      UserRepository().notifNoAction(scaffoldKey, context,"Silahkan Masukan Nominal Anda","failed");
    }else{
      final pin  = await userRepository.getDataUser('pin');
      if(pin == 0){
        UserRepository().notifWithAction(scaffoldKey, context, 'Silahkan Buat PIN untuk Melanjutkan Transaksi', 'failed',"BUAT PIN",(){
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => Pin(saldo: widget.saldo,param:'topup')),
          );
        });

      }else{
        var rplcComa = moneyController.text.replaceAll(",", "");
        var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
        print("##################################### $sbtrLast3 #####################################");
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => GetAvailableBank(amount:int.parse(sbtrLast3),name: widget.name,saldo:widget.saldo)),
        );
      }
    }
  }


  var amount;
  Future allReplace(String saldo) async {
    print(saldo);
    var rplcComa = saldo.replaceAll(",", "");
    var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
    moneyController.updateValue(double.parse(sbtrLast3));
    amount = sbtrLast3;
    print(amount);
  }
  int selectedRadioTile;
  int selectedRadio;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Color warna1;
  Color warna2;
  String statusLevel ='0';
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
    // TODO: implement initState
    super.initState();
    loadTheme();
    sampleData.add(new RadioModel(false, '100,000.00', 'Rp 100,000.00'));
    sampleData.add(new RadioModel(false, '200,000.00', 'Rp 200,000.00'));
    sampleData.add(new RadioModel(false, '300,000.00', 'Rp 300,000.00'));
    sampleData.add(new RadioModel(false, '400,000.00', 'Rp 400,000.00'));
    sampleData.add(new RadioModel(false, '500,000.00', 'Rp 500,000.00'));
    sampleData.add(new RadioModel(false, '1,000,000.00', 'Rp 1,000,000.00'));

  }


  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, 'Top Up', warna1, warna2, (){
          Navigator.of(context).pop();
        },Container()),
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
                  CardHeader(saldo: widget.saldo),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Text("Nominal",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        TextFormField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                          controller: moneyController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          autofocus: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelText: 'Nominal',
                            labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ),
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            prefixText: 'Rp.',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(13),
                            WhitelistingTextInputFormatter.digitsOnly,
                            BlacklistingTextInputFormatter.singleLineFormatter,
                          ],
                          textInputAction: TextInputAction.done,
                          focusNode: saldoFocus,
                          onFieldSubmitted: (value){
                            saldoFocus.unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            getBank();
                          },
                          onChanged: (par){
                            sampleData.forEach((element) => element.isSelected = false);
                          },
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Pilih Nominal Cepat",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        GridView.builder(
                          padding: EdgeInsets.only(top:10, bottom: 10, right: 2),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _crossAxisCount,
                            crossAxisSpacing: _crossAxisSpacing,
                            mainAxisSpacing: _mainAxisSpacing,
                            childAspectRatio: _aspectRatio,
                          ),
                          itemCount: sampleData.length,
                          itemBuilder: (BuildContext context, int index){
                            return new InkWell(
                              onTap: () {
                                setState(() {
                                  sampleData.forEach((element) => element.isSelected = false);
                                  sampleData[index].isSelected = true;
                                  FocusScope.of(context).requestFocus(FocusNode());
                                });
                                allReplace(sampleData[index].buttonText);
                              },
                              child: radioItem(sampleData[index]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  UserRepository().buttonQ(context, warna1, warna2, (){
                    setState(() {isLoading = true;});
                    getBank();
                  }, isLoading,'Simpan')

                ],
              ),
            ),
          ],
        )
    );
  }
  Widget radioItem(RadioModel _item) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return new Container(
      padding:EdgeInsets.all(10.0),
      child: new Center(
        child: new Text(
            _item.buttonText,
            style: new TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:_item.isSelected ? statusLevel!='0'?warna1:Colors.green : Colors.black,fontSize:ScreenUtilQ.getInstance().setSp(30))
        ),
      ),
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
            width: 1.0,
            color: _item.isSelected ?  statusLevel!='0'?warna1:Colors.green : Colors.black
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return new Container(
      padding:EdgeInsets.all(10.0),
      child: new Center(
        child: new Text(
          _item.buttonText,
          style: new TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:_item.isSelected ? Colors.green : Colors.black,fontSize:ScreenUtilQ.getInstance().setSp(30))
        ),
      ),
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
          width: 1.0,
          color: _item.isSelected ? Colors.green : Colors.black
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
