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
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/bloc/myBankBloc.dart';
import 'package:thaibah/bloc/withdrawBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';

import '../saldo_ui.dart';
import 'home/widget_index.dart';

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


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, "Penarikan",(){Navigator.pop(context);},<Widget>[]),

        // appBar:UserRepository().appBarWithButton(context,'Penarikan',warna1,warna2,(){Navigator.of(context).pop();},Container()),
        body: ListView(
          children: <Widget>[
            Container(
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
              child:Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              onFieldSubmitted: (value){
                                saldoFocus.unfocus();
                                if(moneyController.text == '0.00' || moneyController.text == null || bankCodeController == '' || bankCodeController == null){
                                  UserRepository().notifNoAction(scaffoldKey, context,"Lengkapi Form Yang SUdah Tersedia","failed");
                                }
                                else{
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _pinBottomSheet(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10.0),
                          UserRepository().textQ("Pilih nominal cepat",10,Colors.black,FontWeight.bold,TextAlign.left),
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
                          SizedBox(height: 10.0),
                          UserRepository().buttonQ(context,(){
                            if(moneyController.text == '0.00' || moneyController.text == null ||  bankCodeController == '' || bankCodeController == null){
                              UserRepository().notifNoAction(scaffoldKey, context, "Lengkapi Form Yang Tersedia", "failed");
                            }
                            else{

                              _pinBottomSheet(context);
                            }
                          },'Simpan')
                        ],
                      ),
                    )
                  ],
                ),
            )

              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: <Widget>[
              //     Padding(
              //       padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 8),
              //       child:CardHeader(saldo: widget.saldoMain),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              //       child: _bank(context),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text("Nominal",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
              //           TextFormField(
              //             controller: moneyController,
              //             keyboardType: TextInputType.number,
              //             maxLines: 1,
              //             style: TextStyle(color:Colors.grey,fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
              //             autofocus: false,
              //             decoration: InputDecoration(
              //               hintStyle: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey, fontSize: ScreenUtilQ.getInstance().setSp(30)),
              //               prefixText: 'Rp.',
              //             ),
              //             inputFormatters: <TextInputFormatter>[
              //               WhitelistingTextInputFormatter.digitsOnly
              //             ],
              //             textInputAction: TextInputAction.done,
              //             focusNode: saldoFocus,
              //             onFieldSubmitted: (value){
              //               saldoFocus.unfocus();
              //               if(moneyController.text == '0.00' || moneyController.text == null || bankCodeController == '' || bankCodeController == null){
              //                 UserRepository().notifNoAction(scaffoldKey, context,"Lengkapi Form Yang SUdah Tersedia","failed");
              //               }
              //               else{
              //                 setState(() {
              //                   _isLoading = true;
              //                 });
              //                 _pinBottomSheet(context);
              //               }
              //             },
              //           )
              //         ],
              //       ),
              //     ),
              //
              //     Padding(
              //       padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text("Pilih Nominal Cepat",style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold)),
              //           GridView.builder(
              //             padding: EdgeInsets.only(top:10, bottom: 10, right: 2),
              //             physics: NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: _crossAxisCount,
              //               crossAxisSpacing: _crossAxisSpacing,
              //               mainAxisSpacing: _mainAxisSpacing,
              //               childAspectRatio: _aspectRatio,
              //             ),
              //             itemCount: sampleData.length,
              //             itemBuilder: (BuildContext context, int index){
              //               return new InkWell(
              //                 onTap: () {
              //                   setState(() {
              //                     sampleData.forEach((element) => element.isSelected = false);
              //                     sampleData[index].isSelected = true;
              //                     FocusScope.of(context).requestFocus(FocusNode());
              //                   });
              //                   allReplace(sampleData[index].buttonText);
              //                 },
              //                 child: RadioItem(sampleData[index]),
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //     UserRepository().buttonQ(context,(){
              //       if(moneyController.text == '0.00' || moneyController.text == null ||  bankCodeController == '' || bankCodeController == null){
              //         UserRepository().notifNoAction(scaffoldKey, context, "Lengkapi Form Yang Tersedia", "failed");
              //       }
              //       else{
              //
              //         _pinBottomSheet(context);
              //       }
              //     },'Simpan')
              //
              //   ],
              // ),
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
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Html(data:"Bank",defaultTextStyle: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
              //     DropdownButton(
              //       isDense: true,
              //       isExpanded: true,
              //       hint: Html(data: "Pilih",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik'),),
              //       value: bankCodeController,
              //       items: snapshot.data.result.map((prefix0.Result items){
              //         return new DropdownMenuItem<String>(
              //             value: items.id,
              //             child: Html(data:items.bankname!=''?items.bankname:'kosong',defaultTextStyle: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ))
              //         );
              //       }).toList(),
              //       onChanged: (String newValue) {
              //         setState(() {
              //           _onDropDownItemSelectedBank(newValue);
              //         });
              //       },
              //     )
              //   ],
              // );
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
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      setState(() {
        UserRepository().loadingQ(context);
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
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WidgetIndex(param: '',)), (Route<dynamic> route) => false);
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