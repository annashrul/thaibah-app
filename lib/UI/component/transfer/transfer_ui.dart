import 'dart:async';
import 'dart:core';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/configModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/member/contactModel.dart' as prefix0;
import 'package:thaibah/Model/transferDetailModel.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/Widgets/nominalCepat.dart';
import 'package:thaibah/UI/Widgets/wrapperForm.dart';
import 'package:thaibah/UI/component/transfer/detailTransfer.dart';
import 'package:thaibah/bloc/configBloc.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:thaibah/resources/transferProvider.dart';

import '../../Widgets/SCREENUTIL/ScreenUtilQ.dart';
import '../../Widgets/skeletonFrame.dart';

class TransferUI extends StatefulWidget {
  final String saldo, qr;
  TransferUI({this.saldo,this.qr});
  @override
  _TransferUIState createState() => _TransferUIState();
}

class _TransferUIState extends State<TransferUI> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController tfController = TextEditingController();
  TextEditingController penerimaController = TextEditingController();
  TextEditingController pesanController = TextEditingController();
  final FocusNode tfFocus       = FocusNode();
  final FocusNode penerimaFocus = FocusNode();
  final FocusNode pesanFocus    = FocusNode();
  var moneyMaskedTextController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');
  var amount;
  String cik = "";
  String barcode = "";
  final userRepository = UserRepository();
  String _currentItemSelectedContact=null;
  Future cek() async{
    var test = await ConfigProvider().fetchConfig();
    setState(() {
      cik = test.result.transfer;
    });
  }
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
    String referral_penerima = penerimaController.text != "" ? penerimaController.text : _currentItemSelectedContact ;
    String pesan = pesanController.text!=''?pesanController.text:'-';
    print("##################################### ${UserRepository().replaceNominal(moneyMaskedTextController.text)} #####################################");

    if(int.parse(UserRepository().replaceNominal(moneyMaskedTextController.text)) > int.parse(widget.saldo)) {
      setState(() {
        Navigator.pop(context);
      });
      UserRepository().notifNoAction(scaffoldKey, context,"Nominal melebihi saldo utama anda","failed");
    }
    else{
      var res = await TransferProvider().transferDetail(UserRepository().replaceNominal(moneyMaskedTextController.text), referral_penerima, pesan);
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
  @override
  void initState() {
    super.initState();
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
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, 'Transfer', (){Navigator.of(context).pop();}, <Widget>[
          InkWell(
            onTap: (){_lainnyaModalBottomSheet(context);},
            child: Container(
              margin: EdgeInsets.only(left: 10.0,right:20.0),
              child: Image.network(
                widget.qr,
                height: ScreenUtilQ.getInstance().setHeight(60),
                width: ScreenUtilQ.getInstance().setWidth(60),
              ),
            ),
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: WrapperForm(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CardHeader(saldo: widget.saldo),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        controller: moneyMaskedTextController,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          border:UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          prefixText: 'Rp.',
                          hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: tfFocus,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(13),
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter.singleLineFormatter,
                        ],
                        onFieldSubmitted: (term){
                          tfFocus.unfocus();
                          UserRepository().fieldFocusChange(context, tfFocus, penerimaFocus);
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    UserRepository().textQ("Penerima",12,Colors.black,FontWeight.bold,TextAlign.left),
                    SizedBox(height: 10.0),
                    StreamBuilder(
                        stream: configBloc.getResult,
                        builder: (context,AsyncSnapshot<ConfigModel> snapshot){
                          return snapshot.hasData ?  snapshot.data.result.transfer == 'all' ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                                  controller: penerimaController,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    prefixText: 'Kode referral: ',
                                    suffixIcon: InkWell(
                                      onTap: scanCode,
                                      child: Padding(
                                        padding: const EdgeInsets.only( top: 0, left: 0, right: 0, bottom: 0),
                                        child: new SizedBox(
                                          height: 2,
                                          child: Image.network('https://images.vexels.com/media/users/3/157862/isolated/preview/5fc76d9e8d748db3089a489cdd492d4b-barcode-scanning-icon-by-vexels.png',height: 10,),
                                        ),
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
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
                                    UserRepository().fieldFocusChange(context, penerimaFocus, pesanFocus);
                                  },
                                  textCapitalization: TextCapitalization.sentences,
                                  onChanged: (value) {
                                    if (penerimaController.text != value.toUpperCase())
                                      penerimaController.value = penerimaController.value.copyWith(text: value.toUpperCase());
                                  },
                                ),
                              ),
                            ],
                          ) : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              contact(context)
                            ],
                          ) : SkeletonFrame(width:double.infinity,height: 50);
                        }
                    ),
                    SizedBox(height: 10.0),
                    UserRepository().textQ("Pesan",12,Colors.black,FontWeight.bold,TextAlign.left),
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
                        controller: pesanController,
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 3,
                        focusNode: pesanFocus,
                        decoration: InputDecoration(
                          prefixText: 'pesan: ',
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    NominalCepat(
                      callback: (var param){
                        amount = UserRepository().allReplace(param);
                        moneyMaskedTextController.updateValue(double.parse(amount));
                      },
                    ),
                    UserRepository().buttonQ(
                        context,
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
                        'Simpan'
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
  @override
  contact(BuildContext context) {
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
      child:StreamBuilder(
          stream: contactBloc.getResult,
          builder: (context,AsyncSnapshot<prefix0.ContactModel> snapshot) {
            if(snapshot.hasError) print(snapshot.error);
            if(snapshot.hasData){
              _currentItemSelectedContact= _currentItemSelectedContact==''?snapshot.data.result[0].referral:_currentItemSelectedContact;
              if(snapshot.data.result.length > 0){
                return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: DropdownButton<String>(
                      isDense: true,
                      isExpanded: true,
                      value: _currentItemSelectedContact,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        setState(() {
                          tfFocus.unfocus();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _onDropDownItemSelectedContact(newValue);
                        });
                      },
                      items: snapshot.data.result.map((prefix0.Result items){
                        var name = "";
                        if(items.name.length > 30){
                          name = "${items.name.substring(0,30)}..";
                        }else{
                          name = items.name;
                        }
                        return new DropdownMenuItem<String>(
                          value: "${items.referral}",
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
              }
              else{
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
            }
            return SkeletonFrame(width: double.infinity,height: 50);
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

