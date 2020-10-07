import 'package:flutter/material.dart';

class WrapperForm extends StatefulWidget {
  final Widget child;
  WrapperForm({this.child});
  @override
  _WrapperFormState createState() => _WrapperFormState();
}

class _WrapperFormState extends State<WrapperForm> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding:EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              boxShadow: [new BoxShadow(color: Colors.grey[200], offset: new Offset(0.0, 2.0), blurRadius: 25.0,)],
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
          ),
          alignment: Alignment.topCenter,
          child: widget.child,
        ),
      ],
    );
  }
}
