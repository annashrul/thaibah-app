
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';

import 'SCREENUTIL/ScreenUtilQ.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return new Container(
      padding:EdgeInsets.all(10.0),
      child: new Center(
        child: new Text(
            _item.buttonText,
            style: new TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold,color:_item.isSelected ? ThaibahColour.primary1 : Colors.grey,fontSize:ScreenUtilQ.getInstance().setSp(30))
        ),
      ),
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
            width: 1.0,
            color: _item.isSelected ? ThaibahColour.primary1 : Colors.grey[200]
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}