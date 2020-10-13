import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/cardHeader.dart';
import 'package:thaibah/UI/Widgets/nominalCepat.dart';
import 'package:thaibah/UI/Widgets/radioItem.dart';
import 'package:thaibah/UI/Widgets/wrapperForm.dart';
import 'package:thaibah/UI/component/bank/getAvailableBank.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';

class FormDeposit extends StatefulWidget {
  String saldo; String name;
  FormDeposit({this.saldo,this.name});
  @override
  _FormDepositState createState() => _FormDepositState();
}

class _FormDepositState extends State<FormDeposit> {
  List<RadioModel> sampleData = new List<RadioModel>();
  final userRepository = UserRepository();
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController saldoController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');
  bool isLoading = false;
  var amount;
  getBank() async {
    setState(() {
      isLoading = false;
    });
    if(moneyController.text == null || moneyController.text == '0.00'){
      UserRepository().notifNoAction(scaffoldKey, context,"Silahkan Masukan Nominal Anda","failed");
    }else{
      final pin  = await userRepository.getDataUser('pin');
      if(pin == 0){
        UserRepository().notifWithAction(scaffoldKey, context, 'Silahkan Buat PIN untuk Melanjutkan Transaksi', 'failed',"BUAT PIN",(){
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => Pin(saldo: widget.saldo,param:'topup')),
          );
        });
      }else{
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => GetAvailableBank(amount:int.parse(UserRepository().replaceNominal(moneyController.text)),name: widget.name,saldo:widget.saldo)),
        );
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
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, "Deposit",(){Navigator.pop(context);},<Widget>[]),
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
                        controller: moneyController,
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          prefixText: 'Rp.',
                          hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                        ),
                        textInputAction: TextInputAction.done,
                        focusNode: saldoFocus,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(13),
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter.singleLineFormatter,
                        ],
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
                    UserRepository().buttonQ(context, (){
                      setState(() {isLoading = true;});
                      getBank();
                    }, 'Simpan')
                  ],
                ),
              ),



            ],
          ),
        )
    );
  }
}
