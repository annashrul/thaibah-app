import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/dataDiri/updateKtp.dart';
import 'package:thaibah/UI/saldo_ui.dart';
import 'package:thaibah/bloc/transferBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';


String pin = "";


class PenukaranBonus extends StatefulWidget {

  String saldo; String saldoBonus;

  PenukaranBonus({this.saldo,this.saldoBonus});
  @override
  _PenukaranBonusState createState() => _PenukaranBonusState();
}

class _PenukaranBonusState extends State<PenukaranBonus> {
  List<RadioModel> sampleData = new List<RadioModel>();
  final userRepository = UserRepository();
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');

  double _height;
  TextEditingController saldoController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();
  double _width;
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 3;
  bool _isLoading = false;


  showInSnackBar(String title,String param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: param == 'success' ? Colors.green : Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  int selectedRadioTile;
  int selectedRadio;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
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

  Future save() async{
    if(moneyController.text == null || moneyController.text == '0.00'){
      print('cek');
      return showInSnackBar("Nominal Harus Diisi","gagal");
    }else{
      final ktp = await userRepository.getDataUser('ktp');
      print(ktp);
      if(ktp == '-'){
        scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              content: Text('Silahkan Upload KTP Anda Untuk Melanjutkan Transaksi',style: TextStyle(color:Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
              action: SnackBarAction(
                textColor: Colors.green,
                label: 'Upload KTP',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => UpdateKtp(saldo: widget.saldo,saldoBonus: widget.saldoBonus)),
                  );
                },
              ),
            )
        );
      }else{
        _pinBottomSheet(context);
      }
    }
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
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
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Penukaran Bonus", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),

      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                  child:Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          width: 2.0,
                          color: Colors.green
                      ),
                      borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.bottomCenter,
                              width: 40.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(height: 20,width: 8.0,color: Color(0xFF30cc23)),
                                  const SizedBox(width: 1.0),
                                  Container(height: 25,width: 8.0, color: Colors.lightGreen),
                                  const SizedBox(width: 1.0),
                                  Container(height: 40,width: 8.0, color: Color(0xFF116240)),
                                ],
                              ),
                            ),
                            title: Text("Saldo Utama", style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: 'Rubik')),
                            subtitle: Text(widget.saldo, style: TextStyle(fontSize: 11.0,color: Colors.black,fontFamily: 'Rubik')),
                          ),
                        ),

                        Expanded(
                          child: ListTile(
                            leading: Container(
                              alignment: Alignment.bottomCenter,
                              width: 45.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(height: 20,width: 8.0,color: Color(0xFF116240)),
                                  const SizedBox(width: 1.0),
                                  Container(height: 25,width: 8.0, color: Colors.lightGreen),
                                  const SizedBox(width: 1.0),
                                  Container(height: 40,width: 8.0, color: Color(0xFF30cc23)),
                                ],
                              ),
                            ),
                            title: Text("Saldo Bonus", style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: 'Rubik')),
                            subtitle: Text(widget.saldoBonus, style: TextStyle(fontSize: 11.0,color: Colors.black,fontFamily: 'Rubik')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          save();
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
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          save();
                        },
                        icon: Icon(Icons.arrow_forward),
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }



  Future<void> _pinBottomSheet(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
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
      var rplcComa = moneyController.text.replaceAll(",", "");
      var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
      print("##################################### $sbtrLast3 #####################################");
      var res = await transferBonusBloc.fetchTransferBonus(sbtrLast3);
      if(res is GeneralInsertId){
        GeneralInsertId results = res;
        setState(() {Navigator.of(context).pop();});
        if(results.status=="success"){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialogQ(
                  alertTitle: richTitle("Transaksi Berhasil"),
                  alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.green,
                      child: Text("Kembali", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              }
          );
        }
        else{
//          Navigator.of(context).pop();
//          setState(() {Navigator.of(context).pop();});
          return showInSnackBar(results.msg, 'gagal');
        }
      }else{
        setState(() {Navigator.of(context).pop();});
        General results = res;
        setState(() {Navigator.pop(context);});
        return showInSnackBar(results.msg, 'gagal');
      }
    }
    else{
      setState(() {Navigator.pop(context);});
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



}

