import 'package:flutter/material.dart';
import 'package:thaibah/Model/bankModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/bankBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    bankBloc.fetchBankList();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    return StreamBuilder(
        stream: bankBloc.allBank,
        builder: (context,AsyncSnapshot<BankModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            print("BANK CODE $BankCodeController");
            // BankCodeController= BankCodeController==null?snapshot.data.result[0].code + " | "+ snapshot.data.result[0].name:BankCodeController;
            // BankCodeController = snapshot.data.result[0].code + " | "+ snapshot.data.result[0].name;
          return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: BankCodeController,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  underline: SizedBox(),
                  onChanged: (String newValue) {
                    setState(() {
                      _onDropDownItemSelectedBank(newValue);
                    });
                  },
                  items: snapshot.data.result.map((Result items){
                    var name = "";
                    if(items.name.length > 30){
                      name = "${items.name.substring(0,30)}..";
                    }else{
                      name = items.name;
                    }
                    return new DropdownMenuItem<String>(
                      value: items.code + "|"+ items.name,
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: ScreenUtilQ.getInstance().setHeight(30),
                              backgroundImage: NetworkImage(ApiService().noImage)
                          ),
                          SizedBox(width: 10.0),
                          UserRepository().textQ(name,10,Colors.black,FontWeight.bold,TextAlign.left)
                        ],
                      ),
                    );
                  }).toList(),

                )
            );
          }
          return SkeletonFrame(width: double.infinity,height: 50);
       }
    );
  }



}
