//
//import 'dart:async';
//import 'dart:io';
//
//import 'package:flutter/material.dart';
//
//class HelperPIN extends StatefulWidget {
//  final int passLength;
//  final Function passCodeVerify;
//  final Function onSuccess;
//  final bool showWrongPassDialog;
//  final String wrongPassTitle;
//  final String wrongPassContent;
//  final String wrongPassCancelButtonText;
//  final Color numColor;
//
//  HelperPIN({
//    this.passLength,
//    this.passCodeVerify,
//    this.onSuccess,
//    this.showWrongPassDialog,
//    this.wrongPassTitle,
//    this.wrongPassContent,
//    this.wrongPassCancelButtonText,
//    this.numColor,
//  });
//  @override
//  _HelperPINState createState() => _HelperPINState();
//}
//
//class _HelperPINState extends State<HelperPIN> {
//
//  var _currentCodeLength = 0;
//  var _inputCodes = <int>[];
//  var _currentState = 0;
//  Color circleColor = Colors.white;
//
//  _onCodeClick(int code) {
//    if (_currentCodeLength < widget.passLength) {
//      setState(() {
//        _currentCodeLength++;
//        _inputCodes.add(code);
//      });
//
//      if (_currentCodeLength == widget.passLength) {
//        widget.passCodeVerify(_inputCodes).then((onValue) {
//          if (onValue) {
//            setState(() {
//              _currentState = 1;
//            });
//            widget.onSuccess();
//          } else {
//            _currentState = 2;
//            new Timer(new Duration(milliseconds: 1000), () {
//              setState(() {
//                _currentState = 0;
//                _currentCodeLength = 0;
//                _inputCodes.clear();
//              });
//            });
//            if (widget.showWrongPassDialog) {
//              showDialog(
//                  barrierDismissible: false,
//                  context: context,
//                  builder: (BuildContext context) {
//                    return Center(
//                      child: AlertDialog(
//                        title: Text(
//                          widget.wrongPassTitle,
//                          style: TextStyle(fontFamily: "Rubik"),
//                        ),
//                        content: Text(
//                          widget.wrongPassContent,
//                          style: TextStyle(fontFamily: "Rubik"),
//                        ),
//                        actions: <Widget>[
//                          FlatButton(
//                            onPressed: () => Navigator.pop(context),
//                            child: Text(
//                              widget.wrongPassCancelButtonText,
//                              style: TextStyle(color: Colors.blue),
//                            ),
//                          )
//                        ],
//                      ),
//                    );
//                  });
//            }
//          }
//        });
//      }
//    }
//  }
//  _deleteAllCode() {
//    setState(() {
//      if (_currentCodeLength > 0) {
//        _currentState = 0;
//        _currentCodeLength = 0;
//        _inputCodes.clear();
//      }
//    });
//  }
//  _deleteCode() {
//    setState(() {
//      if (_currentCodeLength > 0) {
//        _currentState = 0;
//        _currentCodeLength--;
//        _inputCodes.removeAt(_currentCodeLength);
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Expanded(
//      flex: Platform.isIOS ? 5 : 6,
//      child: Container(
//        padding: EdgeInsets.only(left: 0, top: 0),
//        child:GridView.count(
//          crossAxisCount: 3,
//          childAspectRatio: 1.6,
//          mainAxisSpacing: 35,
//          padding: EdgeInsets.all(8),
//          children: <Widget>[
//            buildContainerCircle(1),
//            buildContainerCircle(2),
//            buildContainerCircle(3),
//            buildContainerCircle(4),
//            buildContainerCircle(5),
//            buildContainerCircle(6),
//            buildContainerCircle(7),
//            buildContainerCircle(8),
//            buildContainerCircle(9),
//            buildRemoveIcon(Icons.close),
//            buildContainerCircle(0),
//            buildContainerIcon(Icons.arrow_back),
//          ],
//        )
//      ),
//    );
//  }
//
//
//  Widget buildContainerCircle(int number) {
//    return InkResponse(
//      highlightColor: Colors.red,
//      onTap: () {
//        _onCodeClick(number);
//      },
//      child: Container(
//        height: 50,
//        width: 50,
//        decoration: BoxDecoration(
//            color: Colors.white,
//            shape: BoxShape.circle,
//            boxShadow: [
//              BoxShadow(
//                color: Colors.green,
//                blurRadius: 10,
//                spreadRadius: 0,
//              )
//            ]),
//        child: Center(
//          child: Text(
//            number.toString(),
//            style: TextStyle(
//                fontFamily: 'Rubik',
//                fontSize: 28,
//                fontWeight: FontWeight.bold,
//                color: widget.numColor
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//
//  Widget buildRemoveIcon(IconData icon) {
//    return InkResponse(
//      onTap: () {
//        if (0 < _currentCodeLength) {
//          _deleteAllCode();
//        }
//      },
//      child: Container(
//        height: 50,
//        width: 50,
//        decoration: BoxDecoration(
//            color: Colors.white,
//            shape: BoxShape.circle,
//            boxShadow: [
//              BoxShadow(
//                color: Colors.green,
//                blurRadius: 10,
//                spreadRadius: 0,
//              )
//            ]),
//        child: Center(
//          child: Text('Ulangi',style:TextStyle(fontSize:16.0,color:widget.numColor,fontWeight:FontWeight.bold,fontFamily: 'Rubik')),
//        ),
//      ),
//    );
//  }
//
//  Widget buildContainerIcon(IconData icon) {
//    return InkResponse(
//      onTap: () {
//        if (0 < _currentCodeLength) {
//          setState(() {
//            circleColor = Colors.grey.shade300;
//          });
//          Future.delayed(Duration(milliseconds: 200)).then((func) {
//            setState(() {
//              circleColor = Colors.white;
//            });
//          });
//        }
//        _deleteCode();
//      },
//      child: Container(
//        height: 50,
//        width: 50,
//        decoration: BoxDecoration(
//            color: circleColor,
//            shape: BoxShape.circle,
//            boxShadow: [
//              BoxShadow(
//                color: Colors.green,
//                blurRadius: 10,
//                spreadRadius: 0,
//              )
//            ]),
//        child: Center(
//          child: Text('Hapus',style:TextStyle(fontSize:16.0,color:widget.numColor,fontWeight:FontWeight.bold,fontFamily: 'Rubik')),
//
//        ),
//      ),
//    );
//  }
//
//}
