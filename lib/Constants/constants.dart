
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

const BUBBLE_WIDTH = 55.0;

const FULL_TARNSITION_PX = 300.0;

const PERCENT_PER_MILLISECOND = 0.00125;

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

enum TransitionGoal {
  open,
  close,
}

removeTag(String htmlString){
  var document = parse(htmlString);
 String parsedString = parse(document.body.text).documentElement.text;
 return parsedString;
}
removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}
Color hexToColors(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}
class ThaibahColour{
  static Color primary1 = Colors.green;
  static Color primary2 = Colors.green;
  // static Color primary1 = Color(0xFF116240);
  // static Color primary2 = Color(0xFF30cc23);
}
class ThaibahFont{
  final fontQ = 'Rubik';
}

