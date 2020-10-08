import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final userRepository = UserRepository();
  final formatter = new NumberFormat("#,###");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            color: Colors.grey[200]
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      ),
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child:UserRepository().textQ("Saldo Anda",14,Colors.black,FontWeight.bold,TextAlign.center)
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Container(
              padding: EdgeInsets.only(top:10.0),
              width: 50,
              height: 2.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child:UserRepository().textQ("Rp "+formatter.format(int.parse(widget.saldo)),14,ThaibahColour.primary1,FontWeight.bold,TextAlign.center),
            ),
          ),
        ],
      )
    );
  }
}
