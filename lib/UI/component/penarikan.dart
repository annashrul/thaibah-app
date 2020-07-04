import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/myBankModel.dart' as prefix0;
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/bloc/myBankBloc.dart';
import 'package:thaibah/bloc/withdrawBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';

import '../saldo_ui.dart';

class Penarikan extends StatefulWidget {
  final String saldoMain;
  Penarikan({this.saldoMain});
  @override
  _PenarikanState createState() => _PenarikanState();
}

class _PenarikanState extends State<Penarikan> {
  List<RadioModel> sampleData = new List<RadioModel>();
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 3;
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');

  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool _isLoading = false;
  String bankCodeController=null;
  TextEditingController saldoController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();

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


  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
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
            fontFamily:ThaibahFont().fontQ
        ),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        appBar:UserRepository().appBarWithButton(context,'Penarikan',warna1,warna2,(){Navigator.of(context).pop();},Container()),
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
                  CardHeader(saldo: widget.saldoMain),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _bank(context)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nominal",style: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: moneyController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          style: TextStyle(fontFamily: ThaibahFont().fontQ),
                          autofocus: false,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontSize: 12.0),
                            prefixText: 'Rp.',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.done,
                          focusNode: saldoFocus,
                          onFieldSubmitted: (value){
                            saldoFocus.unfocus();
                            if(moneyController.text == '0.00' || moneyController.text == null || bankCodeController == '' || bankCodeController == null){
                              UserRepository().notifNoAction(scaffoldKey, context,"Lengkapi Form Yang SUdah Tersedia","failed");
//                              return showInSnackBar("Lengkapi Form Yang Tersedia");
                            }
                            else{
                              setState(() {
                                _isLoading = true;
                              });

                              _pinBottomSheet(context);
                            }
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
                    if(moneyController.text == '0.00' || moneyController.text == null ||  bankCodeController == '' || bankCodeController == null){
                      return showInSnackBar("Lengkapi Form Yang Tersedia");
                    }
                    else{
                      _isLoading = true;
                      _pinBottomSheet(context);
                    }
                  }, _isLoading)

                ],
              ),
            ),
          ],
        )

    );

  }

  void _onDropDownItemSelectedBank(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      bankCodeController = val;
    });
  }

  _bank(BuildContext context) {
    myBankBloc.fetchMyBankList();
    return StreamBuilder(
        stream: myBankBloc.allBank,
        builder: (context,AsyncSnapshot<prefix0.MyBankModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            if(snapshot.data.result.length > 0){
              return InputDecorator(
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color:Colors.black,fontFamily:'Rosemary',fontWeight: FontWeight.bold),
                  labelText: 'Bank',
                ),
                isEmpty: bankCodeController == null,
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    value: bankCodeController,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _onDropDownItemSelectedBank(newValue);
                      });
                    },
                    items: snapshot.data.result.map((prefix0.Result items){
                      return new DropdownMenuItem<String>(
                          value: items.id,

                          child: Text(items.bankname!=''?items.bankname:'kosong',style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ),maxLines: 2,softWrap: true,overflow: TextOverflow.ellipsis,)
                      );
                    }).toList(),
                  ),
                ),
              );
            }else{
              return Card(
                color: Colors.white,
                elevation: 1.0,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text('Anda Belum Mempuya Akun Bank',style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0),),
                        ),
                        SizedBox(height: 10.0,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context, rootNavigator: true).push(
                              new CupertinoPageRoute(builder: (context) =>  Bank()),
                            );
//                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => Bank()), (Route<dynamic> route) => false);
                          },
                          child:Center(
                            child: Text('Buat Akun Bank ? Klik Disini',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),
                          ),
                        )
                      ],
                    )
                ),
              );
            }

          }else{
            return new Center(
                child: new LinearProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))
                )
            );
          }
        }
    );
  }



  Future<void> _pinBottomSheet(context) async {
//    setState(() {
//
//    });
    _isLoading = false;
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
      print(saldoController.text);
      var rplcComa = moneyController.text.replaceAll(",", "");
      var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
      var res = await withdrawBloc.fetchWithdraw(sbtrLast3, bankCodeController);
      Navigator.of(context).pop();
      if(res is GeneralInsertId){
        GeneralInsertId results = res;
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
                    child: Text("Kembali",style:TextStyle(fontFamily: ThaibahFont().fontQ)),
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
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
        }
      }else{
        General results = res;
        Navigator.of(context).pop();
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
      }
    }else{
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!",style:TextStyle(fontFamily: ThaibahFont().fontQ)),
            content: new Text("Masukan pin yang sesuai.",style:TextStyle(fontFamily: ThaibahFont().fontQ)),
            actions: <Widget>[
              FlatButton(
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