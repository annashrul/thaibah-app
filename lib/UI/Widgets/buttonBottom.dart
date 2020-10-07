import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';

class ButtonBottom extends StatefulWidget {
  final Function callback;
  final String label;
  ButtonBottom({this.callback,this.label});
  @override
  _ButtonBottomState createState() => _ButtonBottomState();
}

class _ButtonBottomState extends State<ButtonBottom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.callback,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          height: kBottomNavigationBarHeight,
          decoration: BoxDecoration(
            color: ThaibahColour.primary1,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.only(top:20.0),
          child:UserRepository().textQ(widget.label,14,Colors.white,FontWeight.bold,TextAlign.center),
        ),
      ),
    );
  }
}
