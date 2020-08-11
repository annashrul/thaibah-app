import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
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
      UserRepository().notifNoAction(scaffoldKey, context,"Nominal Harus Diisi","failed");
    }else{
      final ktp = await userRepository.getDataUser('ktp');
      print(ktp);
      if(ktp == '-' || ktp == ''){
//        UserRepository().notifWithAction(scaffoldKey, context, 'Silahkan Upload KTP Anda Untuk Melanjutkan Transaksi','failed',"UPLOAD KTP",(){
//          Navigator.of(context, rootNavigator: true).push(
//            new CupertinoPageRoute(builder: (context) => UpdateKtp(saldo: widget.saldo,saldoBonus: widget.saldoBonus)),
//          );
//        });
        FocusScope.of(context).requestFocus(new FocusNode());
        scaffoldKey.currentState?.removeCurrentSnackBar();
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(
            'Silahkan Upload KTP Anda Untuk Melanjutkan Transaksi',

            style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold, fontFamily:ThaibahFont().fontQ),
          ),
          action: SnackBarAction(
            textColor: Colors.white,
            label:'Upload KTP',
            onPressed:(){
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => UpdateKtp(saldo: widget.saldo,saldoBonus: widget.saldoBonus)),
              );
            },
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 5),
        ));
//        UserRepository().notifNoAction(scaffoldKey, context, 'Silahkan Upload KTP Anda Untuk Melanjutkan Transaksi', 'failed');

      }else{
        _pinBottomSheet(context);
      }
    }
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
    sampleData.add(new RadioModel(false, '100,000.00', 'Rp 100,000.00'));
    sampleData.add(new RadioModel(false, '200,000.00', 'Rp 200,000.00'));
    sampleData.add(new RadioModel(false, '300,000.00', 'Rp 300,000.00'));
    sampleData.add(new RadioModel(false, '400,000.00', 'Rp 400,000.00'));
    sampleData.add(new RadioModel(false, '500,000.00', 'Rp 500,000.00'));
    sampleData.add(new RadioModel(false, '1,000,000.00', 'Rp 1,000,000.00'));
    loadTheme();
  }




  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar:UserRepository().appBarWithButton(context,"Penukaran Bonus",warna1,warna2,(){Navigator.pop(context);},Container()),
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
                            title: Text("Saldo Utama", style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold,color: Colors.black,fontFamily:ThaibahFont().fontQ)),
                            subtitle: Text(widget.saldo, style: TextStyle(fontSize: 11.0,color: Colors.black,fontFamily:ThaibahFont().fontQ)),
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
                            title: Text("Saldo Bonus", style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold,color: Colors.black,fontFamily:ThaibahFont().fontQ)),
                            subtitle: Text(widget.saldoBonus, style: TextStyle(fontSize: 11.0,color: Colors.black,fontFamily:ThaibahFont().fontQ)),
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
                      Text("Nominal",style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                      TextFormField(
                        style: TextStyle(fontFamily: ThaibahFont().fontQ),
                        controller: moneyController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ),
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
                      Text("Pilih Nominal Cepat",style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
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
                UserRepository().buttonQ(context,warna1,warna2,(){
                  save();
                }, false)
//                Align(
//                    alignment: Alignment.centerRight,
//                    child: Container(
//                      margin: EdgeInsets.all(16),
//                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
//                      child: IconButton(
//                        color: Colors.white,
//                        onPressed: () async {
//                          save();
//                        },
//                        icon: Icon(Icons.arrow_forward),
//                      ),
//                    )
//                ),
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
            return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 100.0),
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(strokeWidth: 10.0, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                      SizedBox(height:5.0),
                      Text("Tunggu Sebentar .....",style:TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                    ],
                  ),
                )
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
          setState(() {Navigator.of(context).pop();});
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
                      child: Text("Kembali", style: TextStyle(fontFamily:ThaibahFont().fontQ,color:Colors.white,fontWeight: FontWeight.bold)),
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
          print("###################### KADIEU ##################");
          setState(() {Navigator.of(context).pop();});
          setState(() {Navigator.of(context).pop();});
//          Navigator.of(context).pop();
//          setState(() {Navigator.of(context).pop();});
          UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
//          return showInSnackBar(results.msg, 'gagal');
        }
      }else{
        print("###################### KADIEU 2 ##################");
        setState(() {Navigator.of(context).pop();});

        setState(() {Navigator.of(context).pop();});
        General results = res;
//        setState(() {Navigator.pop(context);});
        UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");

//        return showInSnackBar(results.msg, 'gagal');
      }
    }
    else{
      setState(() {Navigator.pop(context);});
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!",style:TextStyle(fontFamily: ThaibahFont().fontQ)),
            content: new Text("Masukan pin yang sesuai.",style:TextStyle(fontFamily: ThaibahFont().fontQ)),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close",style:TextStyle(fontFamily: ThaibahFont().fontQ)),
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

