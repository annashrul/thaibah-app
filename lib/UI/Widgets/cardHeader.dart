import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';

import 'SCREENUTIL/ScreenUtilQ.dart';

class CardHeader extends StatefulWidget {
  final String saldo;
  CardHeader({this.saldo});
  @override
  _CardHeaderState createState() => _CardHeaderState();
}

class _CardHeaderState extends State<CardHeader> {
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
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        border: new Border.all(
            width: 2.0,
            color: statusLevel!='0'?warna1:Colors.green
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      ),
//        color: Color.fromRGBO(178,223,219,1),
//        decoration: BoxDecoration(gradient: RadialGradient(colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text("Saldo Anda",style: TextStyle(color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(36),fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(widget.saldo,style: TextStyle(color: Colors.black, fontSize:ScreenUtilQ.getInstance().setSp(36),fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
            ),
          ),
        ],
      )
    );
  }
}
