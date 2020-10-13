import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/listBank.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/bloc/myBankBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class FormBank extends StatefulWidget {
  @override
  _FormBankState createState() => _FormBankState();
}

class _FormBankState extends State<FormBank> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var accNoController = TextEditingController();
  var accNameController = TextEditingController();
  String bankCodeController='';

  Future simpan() async {
    if(bankCodeController==''){
      UserRepository().notifNoAction(_scaffoldKey, context, "bank tidak boleh kosong", "failed");
    }
    else if(accNoController.text==''){
      UserRepository().notifNoAction(_scaffoldKey, context, "no rekening tidak boleh kosong", "failed");
    }
    else if(accNameController.text==''){
      UserRepository().notifNoAction(_scaffoldKey, context, "atas nama tidak boleh kosong", "failed");
    }
    else{
      UserRepository().loadingQ(context);
      var res = await createMyBankBloc.fetchCreateMyBank(bankCodeController.split("|")[1], bankCodeController.split("|")[0], accNoController.text, accNameController.text);
      if(res is GeneralInsertId){
        GeneralInsertId result = res;
        if(result.status == 'success'){
          Navigator.of(context).pop();
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"success");
          await Future.delayed(Duration(seconds: 1));
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => Bank()),
          );
        }
        else{
          setState(() {Navigator.of(context).pop();});
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
        }
      }else{
        General results = res;
        setState(() {Navigator.of(context).pop();});
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: UserRepository().appBarWithButton(context, "Tambah Akun Bank",(){Navigator.pop(context);},<Widget>[]),
        body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(left:10.0,right:10.0,bottom: 10.0),
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
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserRepository().textQ("Nama Bank",12,Colors.black,FontWeight.bold,TextAlign.left),
                        SizedBox(height: 10.0),
                        ListBank(callback: (String val){
                          print("CALLBACK BANK $val");
                          setState(() {
                            bankCodeController = val;
                          });
                        }),
                        SizedBox(height: 10.0),
                        UserRepository().textQ("No. Rekening",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                            controller: accNoController,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        UserRepository().textQ("Atas Nama",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                            controller: accNameController,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        UserRepository().buttonQ(context,(){

                          simpan();

                        }, 'Simpan')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
