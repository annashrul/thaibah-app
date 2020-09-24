import 'dart:async';
import 'dart:core';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/configModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/member/contactModel.dart' as prefix0;
import 'package:thaibah/Model/transferDetailModel.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/component/detailTransfer.dart';
import 'package:thaibah/bloc/configBloc.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:thaibah/resources/transferProvider.dart';

import 'Widgets/SCREENUTIL/ScreenUtilQ.dart';

class TransferUI extends StatefulWidget {
  final String saldo, qr;
  TransferUI({this.saldo,this.qr});
  @override
  _TransferUIState createState() => _TransferUIState();
}

class _TransferUIState extends State<TransferUI> {
  bool isExpanded = false;
  var penerimaController  = TextEditingController();
  var pesanController     = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentItemSelectedContact=null;
  var tfController = TextEditingController();
  final FocusNode tfFocus       = FocusNode();
  final FocusNode penerimaFocus = FocusNode();
  final FocusNode pesanFocus    = FocusNode();
  var moneyMaskedTextController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  bool _apiCall = false;
  String _response = '';

  double _height;
  double _width;
  bool _isLoading = false;

  String cik = "";

  Future cek() async{
    var test = await ConfigProvider().fetchConfig();
    setState(() {
      cik = test.result.transfer;
    });
    print("IEU PRINT CIK $cik");
  }
  String barcode = "";
  Future scanCode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        penerimaController.text = barcode;
      });
    } catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }
  Future sendTransferDetail() async {
    var rplcComa = moneyMaskedTextController.text.replaceAll(",", "");
    var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
    String nominal = sbtrLast3;
    String referral_penerima = penerimaController.text != "" ? penerimaController.text : _currentItemSelectedContact ;
    String pesan = pesanController.text!=''?pesanController.text:'-';
    String saldo = widget.saldo.replaceAll(",", "").substring(0,widget.saldo.length-5);
    if(int.parse(nominal)>int.parse(saldo.replaceAll("Rp",'').replaceAll(" ",""))){
      setState(() {
        Navigator.pop(context);
      });
      UserRepository().notifNoAction(scaffoldKey, context,"nominal lebih besar dari saldo utama","failed");
    }
    else{
      var res = await TransferProvider().transferDetail(nominal, referral_penerima, pesan);
      if(res is TransferDetailModel){
        TransferDetailModel results = res;
        if(results.status == 'success'){
          setState(() {
            Navigator.pop(context);
          });
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => DetailTransfer(
                nominal: results.result.nominal.toString(),
                fee_charge: results.result.feeCharge.toString(),
                total_bayar: results.result.totalBayar.toString(),
                penerima: results.result.penerima,
                picture: results.result.picture,
                referralpenerima: results.result.referralpenerima,
                pesan:pesanController.text,
                statusFee:results.result.statusFeecharge
            )),
          );
        }else{
          setState(() {
            Navigator.pop(context);
            penerimaController.text = '';
          });
          UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
        }
      }
      else{
        General results = res;
        setState(() {
          Navigator.pop(context);
        });
        UserRepository().notifNoAction(scaffoldKey, context,results.msg,"failed");
      }
    }


  }

  void _lainnyaModalBottomSheet(context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return Container(
            height: MediaQuery.of(context).size.height/1,
            child: Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                // backgroundColor: Colors.grey,
                elevation: 5.0,
                color:Colors.grey[50],
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Text("Scan Kode Referral Anda ..", style: TextStyle(color: Colors.black,fontSize: ScreenUtilQ.getInstance().setSp(34),fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10.0,),
                      Container(
                        height:MediaQuery.of(context).size.height/2,
                        padding: EdgeInsets.all(10),
                        child: Image.network(widget.qr),
                      )
                    ]
                )
            ),
          );
        }
    );
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
    super.initState();
    loadTheme();
    cek();
    configBloc.fetchConfigList();
  }
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tfController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
        // bottomNavigationBar: _bottomNavBar(),
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, 'Transfer', warna1, warna2, (){Navigator.of(context).pop();}, InkWell(
          onTap: (){_lainnyaModalBottomSheet(context);},
          child: Container(
            margin: EdgeInsets.only(left: 10.0,right:20.0),
            child: Image.network(
              widget.qr,
              height: ScreenUtilQ.getInstance().setHeight(60),
              width: ScreenUtilQ.getInstance().setWidth(60),
            ),
          ),
        )),
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
                  CardHeader(saldo: widget.saldo),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.grey,fontFamily: ThaibahFont().fontQ),
                          controller: moneyMaskedTextController,
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

                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(13),
                            WhitelistingTextInputFormatter.digitsOnly,
                            BlacklistingTextInputFormatter.singleLineFormatter,
                          ],
                          focusNode: tfFocus,
                          onFieldSubmitted: (term){
                            tfFocus.unfocus();
                            _fieldFocusChange(context, tfFocus, penerimaFocus);
                          },
                        ),
                        SizedBox(height:cik == 'all'?0.0:5.0),
                        StreamBuilder(
                            stream: configBloc.getResult,
                            builder: (context,AsyncSnapshot<ConfigModel> snapshot){
                              return snapshot.hasData ?  snapshot.data.result.transfer == 'all' ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.grey,fontFamily: ThaibahFont().fontQ),
                                    textCapitalization: TextCapitalization.sentences,
                                    onChanged: (value) {
                                      if (penerimaController.text != value.toUpperCase())
                                        penerimaController.value = penerimaController.value.copyWith(text: value.toUpperCase());
                                    },
                                    controller: penerimaController,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      labelText: 'Penerima',
                                      labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ),
                                      hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                                      prefixText: 'Kode referral: ',
                                      suffixIcon: InkWell(
                                        onTap: scanCode,
                                        child: Padding(
                                          padding: const EdgeInsets.only( top: 0, left: 0, right: 0, bottom: 0),
                                          child: new SizedBox(
                                            height: 7,
                                            child: Image.network('https://images.vexels.com/media/users/3/157862/isolated/preview/5fc76d9e8d748db3089a489cdd492d4b-barcode-scanning-icon-by-vexels.png'),
                                          ),
                                        ),
                                      ),
                                    ),


                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      BlacklistingTextInputFormatter.singleLineFormatter,
                                    ],
                                    textInputAction: TextInputAction.next,
                                    focusNode: penerimaFocus,
                                    onFieldSubmitted: (term){
                                      penerimaFocus.unfocus();
                                      _fieldFocusChange(context, penerimaFocus, pesanFocus);
                                    },
                                  )
                                ],
                              ) : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _contact(context)
                                ],
                              ) : Center(child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))));
                            }
                        ),
                        TextFormField(
                          style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.grey,fontFamily: ThaibahFont().fontQ),
                          controller: pesanController,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelText: 'Keterangan',
                            labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ),
                            hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                            prefixText: 'pesan: ',

                          ),

                          maxLines: null,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          focusNode: pesanFocus,
                        ),


                      ],
                    ),
                  ),
                  UserRepository().buttonQ(
                      context,
                      warna1,warna2,
                          (){
                        if(moneyMaskedTextController.text == null || moneyMaskedTextController.text=='0.00'){
                          UserRepository().notifNoAction(scaffoldKey, context,"Nominal Tidak Boleh Kosong","failed");
                        }
                        else{
                          if(cik == 'all'){
                            if(penerimaController.text == ''){
                              UserRepository().notifNoAction(scaffoldKey, context,"Penerima Tidak Boleh Kosong","failed");
                            }
                            else{
                              setState(() {
                                UserRepository().loadingQ(context);
                              });
                              sendTransferDetail();
                            }
                          }
                          if(cik=='contact'){
                            if(_currentItemSelectedContact == '' || _currentItemSelectedContact == null){
                              UserRepository().notifNoAction(scaffoldKey, context,"Penerima Tidak Boleh Kosong","failed");
                            }
                            else{
                              setState(() {
                                UserRepository().loadingQ(context);
                              });
                              sendTransferDetail();
                            }
                          }

                        }
                      },
                      false,'Simpan'
                  )


                ],
              ),
            ),
          ],
        )
    );
  }
  @override

  _contact(BuildContext context) {
    contactBloc.fetchContactList();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          tfFocus.unfocus();
        }

        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: StreamBuilder(
          stream:contactBloc.getResult,
          builder: (context,AsyncSnapshot<prefix0.ContactModel> snapshot) {
            if(snapshot.hasError) print(snapshot.error);
            if(snapshot.hasData){
              if(snapshot.data.result.length > 0){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(data:"Penerima",defaultTextStyle: TextStyle(fontSize:12,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                    DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      hint: Html(data: "Pilih",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik'),),
                      value: _currentItemSelectedContact,
                      items: snapshot.data.result.map((prefix0.Result items){
                        return new DropdownMenuItem<String>(
                          value: "${items.referral}",
                          child: Html(data:"${items.name} | ${items.referral}",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik')),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          tfFocus.unfocus();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _onDropDownItemSelectedContact(newValue);
                        });
                      },
                    )
                  ],
                );
                // return new InputDecorator(
                //   decoration: const InputDecoration(
                //     labelText: 'Penerima',
                //   ),
                //   isEmpty: _currentItemSelectedContact == null,
                //   child: new DropdownButtonHideUnderline(
                //     child: new DropdownButton<String>(
                //       value: _currentItemSelectedContact,
                //       isDense: true,
                //       onChanged: (String newValue) {
                //         setState(() {
                //           tfFocus.unfocus();
                //           FocusScope.of(context).requestFocus(new FocusNode());
                //           _onDropDownItemSelectedContact(newValue);
                //         });
                //       },
                //       items: snapshot.data.result.map((prefix0.Result items){
                //         return new DropdownMenuItem<String>(
                //           value: "${items.referral}",
                //           child: Text("${items.name} | ${items.referral}"),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // );
              }else{
                return Card(
                  color: Colors.white,
                  elevation: 1.0,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text('Anda Belum Mempuya Downline',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0),),
                          ),
                        ],
                      )
                  ),
                );
              }

            }else{
              return Center(child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))));
            }

          }
      ),
    );
  }

  void _onDropDownItemSelectedContact(String newValueSelected) async{
    final val = newValueSelected;
    tfFocus.unfocus();
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedContact = val;
    });
  }



}
//
//class DetailTransfer extends StatelessWidget {
//  final String nominal;
//  final String fee_charge;
//  final String total_bayar;
//  final String penerima;
//  final String picture;
//  final String referralpenerima;
//  DetailTransfer({this.nominal,this.fee_charge,this.total_bayar,this.penerima,this.picture,this.referralpenerima});
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white.withOpacity(0.90),
//      body: detail(context),
//      bottomNavigationBar: bottomButton(context),
//    );
//  }
//  Future<void> _pinBottomSheet(context) async {
//    showDialog(
//        context: context,
//        builder: (BuildContext bc){
//          return PinScreen(callback: _callBackPin);
//        }
//    );
//  }
//
//  _callBackPin(BuildContext context,bool isTrue) async{
//    if(isTrue){
//      var res = await transferBloc.fetchTransfer(nominal,referral_penerima,pesan);
//      print(res.result.insertId);
//      print(res.status);
//      if(res.status=="success"){
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (_context) => DetailTransfer(),
//          ),
//        );
//      }else{
//        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res.msg)));
//      }
//    }else{
//      showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: new Text("Pin Salah!"),
//            content: new Text("Masukan pin yang sesuai."),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text("Close"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        },
//      );
//    }
//  }
//  Widget detail(BuildContext context){
//    return SafeArea(
//      child: SingleChildScrollView(
//        child: Container(
//          padding: EdgeInsets.all(50),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Align(
//                alignment: Alignment.centerLeft,
//                child: IconButton(
//                  icon: new Icon(Icons.close),
//                  onPressed: () => Navigator.pop(context),
//                ),
//              ),
//              Align(
//                alignment: Alignment.center,
//                child: Text("Konfirmasi Transfer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
//              ),
//              Divider(),
//              SizedBox(height: 15,),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text("pic"),
//                  Column(children: <Widget>[
//                    Text("NAMA PENERIMA"),
//                    Text("REFF PENERIMA"),
//                  ],)
//                ],),
//              SizedBox(height: 15,),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text("Sumber"),
//                  Text("SALDO UTAMA"),
//                ],),
//              SizedBox(height: 15,),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text("Pesan [Opsional]"),
//                  Text("Isi Pesan"),
//                ],),
//              SizedBox(height: 15,),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Expanded(
//                      flex: 5,
//                      child: Column(
//                        children: <Widget>[
//                          Text("Nominal Transfer"),
//                          Text("Biaya Transfer"),
//                        ],
//                      )
//                  ),
//                  Expanded(
//                      flex: 5,
//                      child: Column(
//                        children: <Widget>[
//                          Text("Rp. 100.000"),
//                          Text("Rp. 65.000"),
//                        ],
//                      )
//                  )
//                ],),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget bottomButton(context){
//    return Container(
//      height: kBottomNavigationBarHeight,
//      child: RaisedButton(
//        color: Styles.primaryColor,
//        onPressed: (){
//          print("object");
//          _pinModalBottomSheet(context);
//        },
//        child: Text("Bayar", style: TextStyle(color: Colors.white),),),);
//  }
//
//  void _pinModalBottomSheet(context){
//    showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            content: Container(
//              // padding: EdgeInsets.only(left: 10, right: 10),
//              //margin: EdgeInsets.only(top: 10),
//                child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      Text("Masukan PIN Anda"),
//                      Divider(),
//                      pinInput(),
//                      // progressWidget()
//                    ]
//                )
//            ),
//          );
//        }
//    );
//  }
//
//  Widget pinInput() {
//    return Builder(
//      builder: (context) => Padding(
//        padding: const EdgeInsets.all(5.0),
//        child: Center(
//          child: PinPut(
//            fieldsCount: 6,
//            isTextObscure: true,
//            onSubmit: (String txtPin) => _check(txtPin, context),
//            actionButtonsEnabled: false,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Future _check(String txtPin, BuildContext context) async {
//
//    if (txtPin == "123456") {
//      // Navigator.of(context).pop();
//      // Navigator.of(context).popAndPushNamed(DETAIL_STATUS_PENDING_UI);
//    } else {
//      // setState(() {
//      //     _apiCall = true;
//      //   });
//    }
//  }
//}
