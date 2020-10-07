import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/nominalCepat.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/uploadImage.dart';
import 'package:thaibah/UI/Widgets/wrapperForm.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/bloc/transferBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';
import '../home/widget_index.dart';


class PenukaranBonus extends StatefulWidget {
  String saldo; String saldoBonus;
  PenukaranBonus({this.saldo,this.saldoBonus});
  @override
  _PenukaranBonusState createState() => _PenukaranBonusState();
}

class _PenukaranBonusState extends State<PenukaranBonus> {
  final userRepository = UserRepository();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');
  TextEditingController saldoController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();
  var amount;

  Future save() async{
    if(moneyController.text == null || moneyController.text == '0.00'){
      UserRepository().notifNoAction(scaffoldKey, context,"Nominal Harus Diisi","failed");
    }else{
      final ktp = await userRepository.getDataUser('ktp');
      if(ktp == '-' || ktp == ''){
        UserRepository().notifAlertQ(context, "warning","Perhatian","Silahkan upload KTP anda","Batal","Oke",(){
          Navigator.pop(context);
        },(){
          Navigator.pop(context);
          UserRepository().myModal(
            context,
            UploadImage(callback: (String img) async{
              var res = await updateMemberBloc.fetchUpdateMember('', '', '','', '',img);
              UserRepository().loadingQ(context);
              if(res.status == 'success'){
                final dbHelper = DbHelper.instance;
                final id = await userRepository.getDataUser('id');
                Map<String, dynamic> row = {
                  DbHelper.columnId   : id,
                  DbHelper.columnKtp : img,
                };
                await dbHelper.update(row);
                Navigator.pop(context);
                Navigator.pop(context);
                UserRepository().notifNoAction(scaffoldKey, context, "upload ktp berhasil", "success");
              }
              else{
            Navigator.pop(context);
            Navigator.pop(context);
            UserRepository().notifNoAction(scaffoldKey, context, "upload ktp gagal", "failed");
          }
            })
          );

        });
      }
      else{
        _pinBottomSheet(context);
      }
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Penukaran Bonus",(){Navigator.pop(context);},<Widget>[]),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WrapperForm(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Container(
                padding: EdgeInsets.only(top:10,bottom:10),
                decoration: new BoxDecoration(
                  border: new Border.all(
                      width: 2.0,
                      color: Colors.grey[200]
                  ),
                  borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        UserRepository().textQ('Saldo Utama', 12, Colors.black,FontWeight.bold,TextAlign.center),
                        SizedBox(height: 5),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top:10.0),
                            width: 50,
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:  BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        UserRepository().textQ(widget.saldo, 12,ThaibahColour.primary1,FontWeight.bold,TextAlign.center)
                      ],
                    ),
                    Column(
                      children: [
                        UserRepository().textQ('Saldo Bonus', 12, Colors.black,FontWeight.bold,TextAlign.center),
                        SizedBox(height: 5),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top:10.0),
                            width: 50,
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:  BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        UserRepository().textQ(widget.saldoBonus, 12,ThaibahColour.primary1,FontWeight.bold,TextAlign.center)
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserRepository().textQ("Nominal",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                      focusNode: saldoFocus,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(13),
                        WhitelistingTextInputFormatter.digitsOnly,
                        BlacklistingTextInputFormatter.singleLineFormatter,
                      ],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value){
                        saldoFocus.unfocus();
                        save();
                      },

                    ),
                  ),
                  SizedBox(height: 10.0),
                  UserRepository().textQ("Pilih nominal cepat",12,Colors.black,FontWeight.bold,TextAlign.left),
                  NominalCepat(
                    callback: (var param){
                      amount = UserRepository().allReplace(param);
                      moneyController.updateValue(double.parse(amount));
                    },
                  ),
                  SizedBox(height: 10.0),
                  UserRepository().buttonQ(context,(){
                    save();
                  },'Simpan')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _pinBottomSheet(context) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      UserRepository().loadingQ(context);
      var res = await transferBonusBloc.fetchTransferBonus(amount);
      if(res is GeneralInsertId){
        GeneralInsertId results = res;
        if(results.status=="success"){
          setState(() {Navigator.of(context).pop();});
          UserRepository().notifAlertQ(context, "success","Transaksi berhasil", "Terimakasih Telah Melakukan Transaksi", "profile", "beranda", (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: 'profile',)), (Route<dynamic> route) => false);
          },(){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
          });
        }
        else{
          setState(() {Navigator.of(context).pop();});
          setState(() {Navigator.of(context).pop();});
          UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
        }
      }
      else{
        setState(() {Navigator.of(context).pop();});
        setState(() {Navigator.of(context).pop();});
        General results = res;
        UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
      }
    }

  }

}





