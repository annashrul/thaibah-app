import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/buttonBottom.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'file:///E:/THAIBAH/mobile/thaibah-app/lib/UI/component/transfer/buktiTransfer.dart';
import 'package:thaibah/UI/component/deposit/formDeposit.dart';
import 'package:thaibah/UI/component/home/widget_index.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/depositManual/detailDepositProvider.dart';


var orange = Color(0xFFfc9f6a);
var pink = Color(0xFFee528c);
var blue = Color(0xFF8bccd6);
var darkBlue = Color(0xFF60a0d7);
var valueBlue = Color(0xFF5fa0d6);
class DetailDeposit extends StatefulWidget {
  final String amount,bank_name,atas_nama,no_rekening,id_deposit,picture,created_at,bukti,saldo;
  final int status;
  DetailDeposit({
    this.amount,this.bank_name,this.atas_nama,this.no_rekening,this.id_deposit,this.picture,this.status,this.created_at,this.bukti,this.saldo
  });
  @override
  _DetailDepositState createState() => _DetailDepositState();
}

class _DetailDepositState extends State<DetailDeposit> {
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final userRepository = UserRepository();
  Future cancelDeposit() async{
    final name = await userRepository.getDataUser('name');
    var res = await DetailDepositProvider().cancelDeposit(widget.id_deposit);
    if(res.status == 'success'){
      Navigator.pop(context);
      Timer(Duration(seconds: 5), () {
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => FormDeposit(
            saldo: widget.saldo,name: name,
          )),
        );
      });
      UserRepository().notifNoAction(scaffoldKey, context,"Berhasil !!!! \nanda akan dialihkan ke halaman deposit","success");

    }else{
      Navigator.pop(context);
      UserRepository().notifNoAction(scaffoldKey, context,res.msg,"failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cek;
    if(widget.status == 0){
      cek = 'Pending';
    }else if(widget.status == 1){
      cek = 'Diterima';
    }else{
      cek = 'Ditolak';
    }
    return Scaffold(
        key: scaffoldKey,
        appBar: UserRepository().appBarWithButton(context, "Riwayat Deposit",(){Navigator.pop(context);},<Widget>[]),
        body: Container(
          color: Color(0xFFf7f8fc),
          child: ListView(
            children: <Widget>[
              CreditCardContainer(noRekening: widget.no_rekening,atasNama: widget.atas_nama,bankName: widget.bank_name,picture: widget.picture),
              ItemCard(widget.amount, widget.created_at, cek, [blue, darkBlue]),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding:EdgeInsets.only(left:10.0,right:10.0),
                height: MediaQuery.of(context).size.height/1.3,
                width: MediaQuery.of(context).size.width/1,
                child: CachedNetworkImage(
                  imageUrl: widget.bukti != '' ? widget.bukti:'http://lequytong.com/Content/Images/no-image-02.png',
                  placeholder: (context, url) => Center(
                    child: SkeletonFrame(width: 400,height: 400),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),

            ],
          ),
        ),
        bottomNavigationBar: ButtonBottom(
          callback: (){
            UserRepository().notifAlertQ(context, "warning","Perhatian","Anda yakin akan membatalkan deposit anda", "batal","oke",(){Navigator.pop(context);}, (){
              Navigator.pop(context);
              UserRepository().loadingQ(context);
              cancelDeposit();
            });
          },
          label: 'Batalkan Deposit',
        )
    );
  }
  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                ),
                color: Colors.green,
                onPressed: (){
                  UserRepository().notifAlertQ(context, "warning","Perhatian","Anda yakin akan membatalkan deposit anda", "batal","oke",(){Navigator.pop(context);}, (){
                    Navigator.pop(context);
                    UserRepository().loadingQ(context);
                    cancelDeposit();
                  });
                },
                child: Text(isLoading ? "Pengecekan data ...." : "Batalkan Deposit", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(40),color: Colors.white,fontFamily: ThaibahFont().fontQ)),
              )
          ),
          Container(
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
                color: Colors.green,
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => BuktiTransfer(id_deposit: widget.id_deposit)),
                  );
                },
                child: Text("Upload Bukti Transfer", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(40),color: Colors.white,fontFamily: ThaibahFont().fontQ)),
              )
          ),
        ],
      ),
    );
  }
}



class ItemCard extends StatelessWidget {
  final titel;
  final subtitle;
  final value;
  final colors;
  ItemCard(this.titel, this.subtitle, this.value, this.colors);
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: colors),
            borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                 titel,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtilQ.getInstance().setSp(40),
                    fontFamily: ThaibahFont().fontQ
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(40),color: Colors.white,fontFamily: ThaibahFont().fontQ),
                )
              ],
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize:ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ),
            )
          ],
        ),
      ),
    );
  }
}
class CreditCardContainer extends StatelessWidget {
  final String noRekening,atasNama,bankName,picture;
  const CreditCardContainer({
    Key key, this.noRekening,this.atasNama,this.bankName,this.picture
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 21),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 5.0, color: Colors.red[200], offset: Offset(0, 5)),
        ],
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [
            Color(0xffff8964),
            Color(0xffff5d6e),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image.network(
                picture,
                width: 51,
                height: 51,
              ),
            ),
            Text(
              noRekening,
              style: TextStyle(color: Colors.white, fontSize:ScreenUtilQ.getInstance().setSp(50),fontFamily: ThaibahFont().fontQ),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              bankName,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtilQ.getInstance().setSp(50),fontFamily: ThaibahFont().fontQ
              ),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              atasNama,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtilQ.getInstance().setSp(50),fontFamily: ThaibahFont().fontQ
              ),
            ),

          ],
        ),
      ),
    );
  }
}