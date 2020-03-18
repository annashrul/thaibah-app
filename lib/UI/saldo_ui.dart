import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/component/bank/getAvailableBank.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';
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
      return showInSnackBar("Masukan Nominal Anda");
    }else{
      final pin  = await userRepository.getPin();
      if(pin == 0){
        scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              content: Text('Silahkan Buat PIN untuk Melanjutkan Transaksi',style: TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
              action: SnackBarAction(
                textColor: Colors.green,
                label: 'Buat PIN',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => Pin(saldo: widget.saldo,param:'topup')),
                  );
                },
              ),
            )
        );
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(false, '100,000.00', 'Rp 100,000.00'));
    sampleData.add(new RadioModel(false, '200,000.00', 'Rp 200,000.00'));
    sampleData.add(new RadioModel(false, '300,000.00', 'Rp 300,000.00'));
    sampleData.add(new RadioModel(false, '400,000.00', 'Rp 400,000.00'));
    sampleData.add(new RadioModel(false, '500,000.00', 'Rp 500,000.00'));
    sampleData.add(new RadioModel(false, '1,000,000.00', 'Rp 1,000,000.00'));

  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var height = width / _aspectRatio;
    return Scaffold(
        key: scaffoldKey,
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
          automaticallyImplyLeading: true,
          title: new Text("Topup", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

        ),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nominal",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: moneyController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
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
                        Text("Pilih Nominal Cepat",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
                              child: RadioItem(sampleData[index]),
                            );
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
                            setState(() {isLoading = true;});
                            getBank();
                          },
                          icon: isLoading?CircularProgressIndicator():Icon(Icons.arrow_forward),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {

    return new Container(
      padding:EdgeInsets.all(10.0),
      child: new Center(
        child: new Text(
          _item.buttonText,
          style: new TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold,color:_item.isSelected ? Colors.green : Colors.black,fontSize: 12.0)
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
