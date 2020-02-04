import 'package:flutter/material.dart';

class CardHeader extends StatefulWidget {
  final String saldo;
  CardHeader({this.saldo});
  @override
  _CardHeaderState createState() => _CardHeaderState();
}

class _CardHeaderState extends State<CardHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        border: new Border.all(
            width: 2.0,
            color: Colors.green
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
              child: Text("Saldo Anda",style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(widget.saldo,style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            ),
          ),
        ],
      )
    );
  }
}
