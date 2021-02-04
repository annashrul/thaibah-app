
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/autoSizeTextQ.dart';
import 'package:thaibah/config/user_repo.dart';

class CardSaldoNoPlatinum extends StatefulWidget {
  final String saldoMain;
  final String saldoBonus;
  final String saldoVoucher;
  final String saldoPlatinum;
  CardSaldoNoPlatinum({this.saldoMain,this.saldoBonus,this.saldoVoucher,this.saldoPlatinum});
  @override
  _CardSaldoNoPlatinumState createState() => _CardSaldoNoPlatinumState();
}

class _CardSaldoNoPlatinumState extends State<CardSaldoNoPlatinum> {
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                  'Saldo Utama',
                  style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold,),
                  maxLines: 2,
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(
                    widget.saldoMain,
                    style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                    'Saldo Bonus',
                    style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoBonus,style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ('Saldo Voucher',style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoVoucher,style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ('Saldo Platinum',style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoPlatinum,style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
          ],
        )
    );
  }
}

class CardSaldo extends StatefulWidget {
  final String title;
  final String desc;
  final double wdt;
  CardSaldo({this.title,this.desc,this.wdt});
  @override
  _CardSaldoState createState() => _CardSaldoState();
}

class _CardSaldoState extends State<CardSaldo> {
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    BorderStyle borderStyle;
    if(widget.wdt==0.0){
      borderStyle = BorderStyle.none;
    }
    else{
      borderStyle = BorderStyle.solid;
    }
    return Container(
      width: MediaQuery.of(context).size.width/2.5,
      padding: EdgeInsets.only(top:5.0,bottom:5.0),
      decoration: BoxDecoration(
          border: BorderDirectional(end: BorderSide(width:widget.wdt,color: Colors.white,style:borderStyle))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          UserRepository().textQ(widget.title,12,Colors.black.withOpacity(0.7),FontWeight.bold,TextAlign.center),
          SizedBox(height:2.0),
          UserRepository().textQ(widget.desc,12,Colors.green,FontWeight.bold,TextAlign.center)
        ],
      ),
    );
  }
}


class CardEmoney extends StatefulWidget {
  final String imgUrl;final String title; final Function xFunction;
  CardEmoney({this.imgUrl,this.title,this.xFunction});
  @override
  _CardEmoneyState createState() => _CardEmoneyState();
}

class _CardEmoneyState extends State<CardEmoney> {
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Expanded(
      child: GestureDetector(
        onTap: (){
          widget.xFunction();
        },
        child: Center(
            child: Container(
              decoration:BoxDecoration(
                // border: Border.all(color: Colors.black,width: 1.0),
                borderRadius:  BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: SvgPicture.network(
                        "${ApiService().baseAssetsRevisi}${widget.imgUrl}.svg",
                        placeholderBuilder: (context) => SkeletonFrame(width: ScreenUtilQ.getInstance().setWidth(60),height: ScreenUtilQ.getInstance().setHeight(60)),
                        height: ScreenUtilQ.getInstance().setHeight(80),
                        width: ScreenUtilQ.getInstance().setWidth(80),
                      )
                  ),
                  SizedBox(height: 5.0),
                  UserRepository().textQ(widget.title, 12, Colors.black,FontWeight.bold,TextAlign.center),
                  // Text(widget.title,textAlign: TextAlign.center, style: TextStyle(color:ThaibahColour.primary1,fontSize:ScreenUtilQ.getInstance().setSp(30),fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                ],
              ),
            )
        ),
      ),
    );
  }
}