import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Model/bankModel.dart';
import 'package:thaibah/bloc/bankBloc.dart';
import 'package:thaibah/Constants/constants.dart';

import 'SCREENUTIL/ScreenUtilQ.dart';

class ListBank extends StatefulWidget {
  final Function(String val) callback;
  ListBank({this.callback});

  @override
  _ListBankState createState() => _ListBankState();
}

class _ListBankState extends State<ListBank> {

  String BankCodeController;

  void _onDropDownItemSelectedBank(String newValueSelected) async{
    final val = newValueSelected;
    widget.callback(val);
    setState(() {
      BankCodeController = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    bankBloc.fetchBankList();
    return StreamBuilder(
        stream: bankBloc.allBank,
        builder: (context,AsyncSnapshot<BankModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(data:"Bank",defaultTextStyle: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
              DropdownButton(
                isDense: true,
                isExpanded: true,
                hint: Html(data: "Pilih",defaultTextStyle: TextStyle(fontSize:12.0,fontFamily: 'Rubik'),),
                value: BankCodeController,
                items: snapshot.data.result.map((Result items){
                  var name = "";
                  if(items.name.length > 50){
                    name = items.name.substring(0,50)+'\n';
                  }else{
                    name = items.name;
                  }
                  return new DropdownMenuItem<String>(
                      value: items.code + " | "+ items.name,
                      child: Html(data:name,defaultTextStyle: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ))
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    _onDropDownItemSelectedBank(newValue);
                  });
                },
              )
            ],
          ):new Center(
              child: new CircularProgressIndicator(
                strokeWidth: 10.0,
                valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1),
              )
          );
        }
    );
  }



}
