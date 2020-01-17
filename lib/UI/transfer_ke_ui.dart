//
//import 'package:flutter/material.dart';
//import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';
//import 'package:thaibah/config/style.dart';
//
//
//class TransferKeUI extends StatefulWidget {
//
//  final String reff;
//  TransferKeUI({Key key, @required this.reff}) : super(key: key);
//
//  @override
//  TransferKeUIState createState() => new TransferKeUIState();
//}
//
//class TransferKeUIState extends State<TransferKeUI> {
//  List data;
//  bool isLoading = false;
//
//  double _height;
//  double _width;
//
//  final NumpadController _numpadController =
//      NumpadController(format: NumpadFormat.NONE, hintText: "Jumlah Saldo");
//
//  @override
//  Widget build(BuildContext context){
//
//    _height = MediaQuery.of(context).size.height;
//    _width = MediaQuery.of(context).size.width;
//
//    return new Scaffold(
//      appBar: new AppBar(title: new Text("Penerima"), backgroundColor: Styles.primaryColor),
//      body: Stack(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(16.0),
//              child: NumpadText(
//                style: TextStyle(fontSize: 40),
//                controller: _numpadController,
//              ),
//            ),
//
//        ]
//      ),
//      bottomNavigationBar: Row(
//                children: <Widget>[
//                  Expanded(
//                    flex: 8, // 20%
//                    child: Container(
//                      height: _height/3,
//                      child: Numpad (
//                        buttonColor: Styles.primaryColor,
//                        textColor: Colors.white,
//                        controller: _numpadController,
//                        buttonTextSize: 30,
//                      ),
//                    )
//                  ),
//                  Expanded(
//                    flex: 2, // 20%
//                    child: Container(
//                      padding: EdgeInsets.fromLTRB(0, 8, 5, 8),
//                      height: _height/3,
//                      child: FlatButton(
//                        color: Styles.primaryColor,
//                        onPressed: (){},
//                        child: Icon(Icons.arrow_right, size: 50, color: Colors.white,),
//                      ),
//                    )
//                  ),
//                ],
//              ),
//    );
//  }
//}