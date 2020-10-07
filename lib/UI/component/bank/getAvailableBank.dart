import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/depositManual/listAvailableBank.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/deposit/successScreenDeposit.dart';
import 'file:///E:/THAIBAH/mobile/thaibah-app/lib/UI/component/deposit/detailDeposit.dart';
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
          new CupertinoPageRoute(builder: (context) => SuccessScreenDeposit(
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
  }

  final userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    cek();
    listAvailableBankBloc.fetchListAvailableBank();
    _isLoading=false;

  }
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return  Scaffold(
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, "Metode Pembayaran",(){Navigator.pop(context);},<Widget>[]),
        body: StreamBuilder(
          stream: listAvailableBankBloc.getResult,
          builder: (context, AsyncSnapshot<ListAvailableBankModel> snapshot) {
            if (snapshot.hasData) {
              return buildContent(snapshot, context);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return ListView.builder(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0.0,
                  margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        width: 90.0,
                        height: 100.0,
                        padding: EdgeInsets.all(10),
                        child: SkeletonFrame(width: 90,height: 50),
                      ),
                      title: SkeletonFrame(width: 100,height: 15),
                      subtitle: SkeletonFrame(width: 70,height: 15),
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          width: ScreenUtilQ.getInstance().setWidth(710),
          height: ScreenUtilQ.getInstance().setHeight(100),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ThaibahColour.primary1,ThaibahColour.primary2]),
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
                  Text("Nominal", style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(30), color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Rp ${formatter.format(widget.amount)}", style: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(28), color: Colors.white,fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
        )
    );
  }


  Widget buildContent(AsyncSnapshot<ListAvailableBankModel> snapshot, BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    if(snapshot.data.result.length > 0){
      return ListView.builder(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
        itemCount: snapshot.data.result.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                UserRepository().loadingQ(context);
              });
              create(snapshot.data.result[index].idBank,snapshot.data.result[index].picture,snapshot.data.result[index].bankCode.toString());
            },
            child:Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Image.network(
                  snapshot.data.result[index].picture,
                  fit: BoxFit.fitWidth,
                ),
                // title: Text(snapshot.data.result[index].atasNama,style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold),),
                title: UserRepository().textQ(snapshot.data.result[index].atasNama, 12, Colors.black, FontWeight.bold, TextAlign.left),
                subtitle: UserRepository().textQ(snapshot.data.result[index].noRekening, 12, Colors.black, FontWeight.bold, TextAlign.left),
                trailing: Icon(Icons.navigate_next),
                // subtitle:Text(snapshot.data.result[index].noRekening, style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      );
    }else{
      return UserRepository().noData();
    }

  }
}
