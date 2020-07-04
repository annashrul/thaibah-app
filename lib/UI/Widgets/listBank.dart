import 'package:flutter/material.dart';
import 'package:thaibah/Model/bankModel.dart';
import 'package:thaibah/bloc/bankBloc.dart';
import 'package:thaibah/Constants/constants.dart';

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
    bankBloc.fetchBankList();
    return StreamBuilder(
        stream: bankBloc.allBank,
        builder: (context,AsyncSnapshot<BankModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Bank',labelStyle: TextStyle(fontFamily: 'Rosemary')
            ),
            isEmpty: BankCodeController == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                value: BankCodeController,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _onDropDownItemSelectedBank(newValue);
                  });
                },
                items: snapshot.data.result.map((Result items){
                  var name = "";
                  if(items.name.length > 50){
                    name = items.name.substring(0,50)+'\n';
                  }else{
                    name = items.name;
                  }
                  return new DropdownMenuItem<String>(
                      value: items.code + " | "+ items.name,
                      child: Text(name,style: TextStyle(fontSize: 12,fontFamily:ThaibahFont().fontQ),maxLines: 2,softWrap: true,overflow: TextOverflow.ellipsis,)
                  );
                }).toList(),
              ),
            ),
          ): new Center(
              child: new CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.blue),
              )
          );
        }
    );
  }



}
