import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/depositManual/listAvailableBank.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/History/detailDeposit.dart';
import 'package:thaibah/UI/component/detail/detailTopUp.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/virtualAccount/virtualAccountProvider.dart';

class GetAvailableBank extends StatefulWidget {
  final String name,saldo;
  final int amount;
  GetAvailableBank({this.amount,this.name,this.saldo});
  @override
  _GetAvailableBankState createState() => _GetAvailableBankState();
}

class _GetAvailableBankState extends State<GetAvailableBank> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  int adminFee = 0;

  int totalPembayaran = 0;

  Future create(var id_bank,var picture, var bank_code) async {
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
                    Text("Tunggu Sebentar .....",style: TextStyle(fontFamily: ThaibahFont().fontQ),)
                  ],
                ),
              )
          );

        },
      );
    });
    var res = await detailDepositBloc.fetchDetailDeposit(id_bank, widget.amount);
    if(res.status == 'success'){
      setState(() {Navigator.pop(context);});
      if(res.result.status == 1){
        Timer(Duration(seconds: 5), () {
          setState(() {Navigator.pop(context);});
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => DetailDeposit(
              amount: res.result.amount,
              bank_name: res.result.bankName,
              atas_nama: res.result.atasNama,
              no_rekening: res.result.noRekening,
              id_deposit: res.result.idDeposit,
              picture: res.result.picture,
              status: res.result.status,
              created_at: DateFormat.yMMMd().add_jm().format(res.result.createdAt.toLocal()),
              bukti: res.result.bukti,
              saldo: widget.saldo,
            )),
          );
        });
        UserRepository().notifNoAction(scaffoldKey, context, "anda telah melakukan deposit, silahkan cancel untuk membuat deposit baru. Anda akan dialihkan ke halaman detail deposit","failed");

      }else{
        setState(() {Navigator.pop(context);});
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => DetailTopUp(
              amount: res.result.amount,
              raw_amount: res.result.rawAmount,
              unique: res.result.unique,
              bank_name: res.result.bankName,
              atas_nama: res.result.atasNama,
              no_rekening: res.result.noRekening,
              picture:picture,
              id_deposit:res.result.idDeposit,
              bank_code : bank_code
          )),
        );
      }

    }
  }
  Future cek() async{
    setState(() {
      _isLoading=false;
    });
    var test = await VirtualAccountProvider().fetchAvailableBank();
    adminFee = test.result.adminFee;
//    totalPembayaran = widget.amount - adminFee;
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
    cek();
    loadTheme();
    listAvailableBankBloc.fetchListAvailableBank();
    _isLoading=false;

  }
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, 'Metode Pembayaran',warna1,warna2,(){Navigator.of(context).pop();},Container()),
        body: StreamBuilder(
          stream: listAvailableBankBloc.getResult,
          builder: (context, AsyncSnapshot<ListAvailableBankModel> snapshot) {
            if (snapshot.hasData) {
              return buildContent(snapshot, context);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Container(child:Center(child:CircularProgressIndicator(strokeWidth: 10, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1))));
          },
        ),
        bottomNavigationBar: Container(
          width: ScreenUtilQ.getInstance().setWidth(710),
          height: ScreenUtilQ.getInstance().setHeight(100),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [statusLevel!='0'?warna1:ThaibahColour.primary1,statusLevel!='0'?warna2:ThaibahColour.primary2]),
              borderRadius: BorderRadius.circular(0.0),
              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Nominal", style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Rp ${formatter.format(widget.amount)}", style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
        )
    );
  }


  Widget buildContent(AsyncSnapshot<ListAvailableBankModel> snapshot, BuildContext context) {
    if(snapshot.data.result.length > 0){
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              'Pilih Bank Yang Akan Dituju',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily:ThaibahFont().fontQ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                itemCount: snapshot.data.result.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _isLoading = true;
                      });
                      create(snapshot.data.result[index].idBank,snapshot.data.result[index].picture,snapshot.data.result[index].bankCode.toString());
                    },
                    child:Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            width: 90.0,
                            height: 50.0,
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              minRadius: 150,
                              maxRadius: 150,
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data.result[index].picture,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                ),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            snapshot.data.result[index].atasNama,style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(snapshot.data.result[index].noRekening, style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          )
        ],
      );
    }else{
      return Column(
        children: <Widget>[
          Container(
              child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily:ThaibahFont().fontQ),))
          ),
        ],
      );
    }

  }
}
