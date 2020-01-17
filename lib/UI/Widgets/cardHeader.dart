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
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: Container(
        color: Color.fromRGBO(178,223,219,1),
//        decoration: BoxDecoration(gradient: RadialGradient(colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Saldo Anda",style: TextStyle(color: Colors.black54, fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(widget.saldo,style: TextStyle(color: Colors.black54, fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              ),
            ),

          ],
        )
      ),
    );
  }
}
