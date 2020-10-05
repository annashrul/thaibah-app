import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/depositManual/listAvailableBank.dart';
import 'package:thaibah/Model/donasi/checkoutDonasiModel.dart' as Prefix2;
import 'package:thaibah/Model/generalModel.dart' as Prefix1;
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/detail/detailTopUp.dart';
import 'package:thaibah/UI/component/donasi/screen_detail_donasi.dart';
import 'package:thaibah/UI/component/donasi/screen_success_donasi.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/donasi/donasiProvider.dart';

class FormDonasi extends StatefulWidget {
  final String id;
  FormDonasi({this.id});
  @override
  _FormDonasiState createState() => _FormDonasiState();
}

class _FormDonasiState extends State<FormDonasi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode nominalFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode noFocus = FocusNode();
  final FocusNode msgFocus = FocusNode();
  TextEditingController nominalController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  String bankId='',name='';
  bool _switchValue=true;
  final userRepository=UserRepository();
  Future<void> load() async {
    final nama = await userRepository.getDataUser('name');
    setState(() {
      name = nama;
    });
    print("NAMA SAYA ADALAH $nama");
  }

  Future donasi() async{
    var expBank = bankId.split('|');
    if(nominalController.text==''||nominalController.text=='0'){
      UserRepository().notifNoAction(_scaffoldKey, context,'nominal donasi tidak boleh kosonh',"failed");
      await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
      nominalFocus.requestFocus();
    }
    else if(nameController.text==''){
      UserRepository().notifNoAction(_scaffoldKey, context,'nama tidak boleh kosonh',"failed");
      await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
      nameFocus.requestFocus();
    }
    else{
      UserRepository().loadingQ(context);
      var res = await CheckoutDonasiProvider().checkoutDonasi(widget.id,nominalController.text,_switchValue?'1':'0',msgController.text,expBank[0]);
      if(res is Prefix2.CheckoutDonasiModel){
        Prefix2.CheckoutDonasiModel result = res;
        if(result.status=='success'){
          Navigator.pop(context);
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"success");
          await Future.delayed(Duration(seconds: 0, milliseconds: 1000));
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => ScreenSuccessDonasi(
                amount: result.result.amount,
                raw_amount: result.result.rawAmount,
                unique: result.result.unique,
                bank_name: result.result.bankName,
                atas_nama: result.result.atasNama,
                no_rekening: result.result.noRekening,
                picture:result.result.picture,
                id_deposit:result.result.idDeposit,
                bank_code : expBank[1]
            )),
          );

        }
        else{
          Navigator.pop(context);
          UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
        }
      }
      else{
        Prefix1.General result = res;
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = 'Hamba Allah';
    listAvailableBankBloc.fetchListAvailableBank();
    load();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Form Donasi",(){Navigator.pop(context);},<Widget>[]),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          UserRepository().textQ("Bank",10,Colors.black,FontWeight.bold,TextAlign.left),
          SizedBox(height: 10.0),
          StreamBuilder(
              stream: listAvailableBankBloc.getResult,
              builder: (context,AsyncSnapshot<ListAvailableBankModel> snapshot) {
                if(snapshot.hasError) print(snapshot.error);
                if(snapshot.hasData){
                  bankId = bankId==''?"${snapshot.data.result[0].idBank}|${snapshot.data.result[0].bankCode}":bankId;
                  // BankCodeController = snapshot.data.result[0].code + " | "+ snapshot.data.result[0].name;
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
                        value: bankId,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        underline: SizedBox(),
                        onChanged: (String newValue) {

                          setState(() {
                            bankId = newValue;
                          });
                        },
                        items: snapshot.data.result.map((Result items){
                          var name = "";
                          if(items.name.length > 30){
                            name = "${items.name.substring(0,30)}..";
                          }else{
                            name = items.name;
                          }

                          // print("BANK ${items.idBank},${items.picture}, ${items.bankCode.toString()}");
                          return new DropdownMenuItem<String>(
                            value: "${items.idBank}|${items.bankCode.toString()}",
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
                return SkeletonFrame(width: double.infinity,height: 50);
              }
          ),
          Divider(color:Colors.white),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserRepository().textQ("Nominal",10,Colors.black,FontWeight.bold,TextAlign.left),
                SizedBox(height: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width/2.3,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                    controller: nominalController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    autofocus: false,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: nominalFocus,

                    onFieldSubmitted: (term){
                      UserRepository().fieldFocusChange(context, nominalFocus,nameFocus);
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserRepository().textQ("nama",10,Colors.black,FontWeight.bold,TextAlign.left),
                    SizedBox(
                        width: 70,
                        height: 10,
                        child: Switch(
                          activeColor: ThaibahColour.primary2,
                          value: _switchValue,
                          onChanged: (bool value) {
                            print(value);
                            setState(() {
                              _switchValue = value;
                              if(_switchValue){
                                setState(() {
                                  nameController.text='Hamba Allah';
                                });
                              }
                              else{
                                setState(() {
                                  nameController.text = name;
                                });

                              }
                            });
                          },
                        )
                    )
                  ],
                ),

                SizedBox(height: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width/2.3,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ,color: Colors.grey),
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    autofocus: false,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: nameFocus,
                    onFieldSubmitted: (term){
                      UserRepository().fieldFocusChange(context, nameFocus,msgFocus);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
          Divider(color:Colors.white),
          UserRepository().textQ("Pesan",10,Colors.black,FontWeight.bold,TextAlign.left),
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
              controller: msgController,
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              autofocus: false,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily: ThaibahFont().fontQ),
              ),
              textInputAction: TextInputAction.done,
              focusNode: msgFocus,
            ),
          ),
          Divider(color:Colors.white),
          UserRepository().buttonQ(context, (){
            donasi();
          }, 'Simpan')
        ],
      ),

    );
  }
}
