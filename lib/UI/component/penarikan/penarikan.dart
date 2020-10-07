import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/myBankModel.dart' as prefix0;
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/Widgets/nominalCepat.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/radioItem.dart';
import 'package:thaibah/UI/Widgets/wrapperForm.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/bloc/myBankBloc.dart';
import 'package:thaibah/bloc/withdrawBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import '../home/widget_index.dart';

class Penarikan extends StatefulWidget {
  final String saldoMain;
  Penarikan({this.saldoMain});
  @override
  _PenarikanState createState() => _PenarikanState();
}

class _PenarikanState extends State<Penarikan> {
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String bankCodeController=null;
  TextEditingController saldoController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();

  var amount;
  Future allReplace(String saldo) async {
    var rplcComa = saldo.replaceAll(",", "");
    var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
    moneyController.updateValue(double.parse(sbtrLast3));
    amount = sbtrLast3;
  }

  final userRepository = UserRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Penarikan",(){Navigator.pop(context);},<Widget>[]),
      body: WrapperForm(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CardHeader(saldo: widget.saldoMain),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserRepository().textQ("Bank",10,Colors.black,FontWeight.bold,TextAlign.left),
                    SizedBox(height: 10.0),
                    _bank(context),
                    SizedBox(height: 10.0),
                    UserRepository().textQ("Nominal",10,Colors.black,FontWeight.bold,TextAlign.left),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                        controller: moneyController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        decoration: InputDecoration(
                          prefixText: 'Rp.',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        ),
                        textInputAction: TextInputAction.done,
                        focusNode: saldoFocus,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    UserRepository().textQ("Pilih nominal cepat",10,Colors.black,FontWeight.bold,TextAlign.left),
                    NominalCepat(
                      callback: (var param){
                        allReplace(param);
                      },
                    ),
                    SizedBox(height: 10.0),
                    UserRepository().buttonQ(context,(){
                      if(moneyController.text == '0.00' || moneyController.text == null ||  bankCodeController == '' || bankCodeController == null){
                        UserRepository().notifNoAction(scaffoldKey, context, "Lengkapi Form Yang Tersedia", "failed");
                      }
                      else{
                        print('bus');
                        _pinBottomSheet(context);
                      }
                    },'Simpan')
                  ],
                ),
              )
            ],
          ),
        ),
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
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    myBankBloc.fetchMyBankList();
    return StreamBuilder(
        stream: myBankBloc.allBank,
        builder: (context,AsyncSnapshot<prefix0.MyBankModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            if(snapshot.data.result.length > 0){
              bankCodeController= bankCodeController==''?snapshot.data.result[0].id:bankCodeController;
              return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButton<String>(
                    isDense: true,
                    isExpanded: true,
                    value: bankCodeController,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    underline: SizedBox(),
                    onChanged: (String newValue) {
                      setState(() {
                        _onDropDownItemSelectedBank(newValue);
                      });
                    },
                    items: snapshot.data.result.map((prefix0.Result items){
                      var name = "";
                      if(items.bankname.length > 30){
                        name = "${items.bankname.substring(0,30)}..";
                      }else{
                        name = items.bankname;
                      }
                      return new DropdownMenuItem<String>(
                        value: items.id,
                        child: Row(
                          children: [
                            Image.network(items.picture,width: 50,height: 10,),
                            SizedBox(width: 10.0),
                            UserRepository().textQ(name,10,Colors.black,FontWeight.bold,TextAlign.left)
                          ],
                        ),
                      );
                    }).toList(),

                  )
              );
            }else{
              return Card(
                color: Colors.white,
                elevation: 0.0,
                child: Padding(
                    padding: EdgeInsets.only(top:10.0,bottom:10.0),
                    child: Column(
                      children: <Widget>[
                        Html(customTextAlign: (_) => TextAlign.center, data:'Anda Belum Mempuya Akun Bank',defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold,fontSize:14)),
                        SizedBox(height: 10.0,),
                        RichText(
                          text: TextSpan(
                              text: 'Buat Akun Bank ? ',
                              style: TextStyle(fontSize: 14,fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: new TapGestureRecognizer()..onTap = (){
                                      Navigator.of(context, rootNavigator: true).push(
                                        new CupertinoPageRoute(builder: (context) =>  Bank()),
                                      );
                                    },
                                    text: 'Tap Disini',
                                    style: TextStyle(color: Colors.green,fontSize: 14,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)
                                ),
                              ]
                          ),
                        ),
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
    print('bus');
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    print('bus');
    if(isTrue){
      UserRepository().loadingQ(context);
      var rplcComa = moneyController.text.replaceAll(",", "");
      var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
      var res = await withdrawBloc.fetchWithdraw(sbtrLast3, bankCodeController);
      Navigator.of(context).pop();
      if(res is GeneralInsertId){
        GeneralInsertId results = res;
        if(results.status=="success"){
          UserRepository().notifAlertQ(context, "success","Transaksi berhasil", "Terimakasih Telah Melakukan Transaksi", "profile", "beranda", (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: 'profile',)), (Route<dynamic> route) => false);
          }, (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
          });
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
    }
  }
}