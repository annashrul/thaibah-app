import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HitungZakat extends StatefulWidget {
//  final Function(String id,int harga, String qty, String weight) onItemInteraction;
  @override
  _HitungZakatState createState() => _HitungZakatState();
}

class _HitungZakatState extends State<HitungZakat> {
  final formatter = new NumberFormat("#,###");
  var field1Controller        = TextEditingController();
  var field2Controller        = TextEditingController();
  var field3Controller        = TextEditingController();
  final FocusNode field1Focus = FocusNode();
  final FocusNode field2Focus = FocusNode();
  final FocusNode field3Focus = FocusNode();

  int totalPenghasilan = 0;

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void hitung() async{
    if(field1Controller.text != ''){
      setState(() {
        totalPenghasilan = int.parse(field1Controller.text);
      });
    }
    if(field1Controller.text != '' && field2Controller.text != ''){
      setState(() {
        totalPenghasilan = int.parse(field1Controller.text)+int.parse(field2Controller.text);
      });
    }
    if(field1Controller.text != '' && field2Controller.text != '' && field3Controller.text!=''){
      setState(() {
        totalPenghasilan = (int.parse(field1Controller.text)+int.parse(field2Controller.text))-int.parse(field3Controller.text);
      });
    }
  }

  void getSession()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('totalZakat'));
    field1Controller.text = prefs.getString('field1');
    field2Controller.text = prefs.getString('field1');
    field3Controller.text = prefs.getString('field1');
    totalPenghasilan      = int.parse(prefs.getString('totalPenghasilan'));
    setState(() {
      totalPenghasilan = (int.parse(field1Controller.text)+int.parse(field2Controller.text))-int.parse(field3Controller.text);
    });
  }

  void simpan() async{
    print(totalPenghasilan);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('field1', field1Controller.text);
    prefs.setString('field2', field2Controller.text);
    prefs.setString('field3', field3Controller.text);
    prefs.setString('totalPenghasilan', totalPenghasilan.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.black26,
                offset: new Offset(0.0, 2.0),
                blurRadius: 25.0,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)
            )
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Zakat Penghasilan',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 16.0),),
              TextFormField(
                controller: field1Controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: field1Focus,
                onFieldSubmitted: (term){
                  _fieldFocusChange(context, field1Focus, field2Focus);
                },
                onChanged: (val){
                  hitung();
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  hintText: 'Penghasilan / Gaji Saya Perbulan'
                ),
              ),
              TextFormField(
                controller: field2Controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: field2Focus,
                onFieldSubmitted: (term){
                  _fieldFocusChange(context, field2Focus, field3Focus);
                },
                onChanged: (val){
                  hitung();
                },
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                    hintText: 'Penghasilan Lainnya Perbulan'
                ),
              ),
              TextFormField(
                controller: field3Controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: field3Focus,
                onFieldSubmitted: (term){
                  _fieldFocusChange(context, field3Focus, field3Focus);
                },
                onChanged: (val){
                  hitung();
                },
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                    hintText: 'Hutang / Cicilan Pokok'
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total Penghasilan Per Bulan :',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12.0)),
                  Text('${formatter.format(totalPenghasilan)}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12.0))
                ],
              ),
              Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle
                  ),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      simpan();
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                )
              ),

            ],
          ),
        )
      ],
    );
  }
}
