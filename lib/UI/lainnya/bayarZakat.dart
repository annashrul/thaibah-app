import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart';
import 'package:thaibah/bloc/PPOB/PPOBPascaBloc.dart';

class BayarZakat extends StatefulWidget {
  @override
  _BayarZakatState createState() => _BayarZakatState();
}

class _BayarZakatState extends State<BayarZakat> {
  bool isLoading = false;
  String _currentItemSelectedLayanan=null;
  var nominalController        = TextEditingController();
  final FocusNode nominalFocus = FocusNode();
  void _onDropDownItemSelectedLayanan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentItemSelectedLayanan = val;
    });
  }

  void getTotalZakat() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nominalController.text = prefs.getString('totalPenghasilan');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ppobPascaBloc.fetchPpobPasca('zakat');
    getTotalZakat();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding:EdgeInsets.only(left:10.0,right:10.0),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _layanan(context),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nominal',style: TextStyle(color:Color(0xFF116240),fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12.0),),
                    TextField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: nominalFocus,
                      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik')),
                      onSubmitted: (value){
                        nominalFocus.unfocus();
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle
                  ),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {

                    },
                    icon: isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                  ),
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  _layanan(BuildContext context) {
    return StreamBuilder(
        stream: ppobPascaBloc.getResult,
        builder: (context,AsyncSnapshot<PpobPascaModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ?
          new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Layanan',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rubik",fontSize: 16)
            ),
            isEmpty: _currentItemSelectedLayanan == null,
            child: DropdownButtonHideUnderline(
              child: new DropdownButton<String>(
                value:_currentItemSelectedLayanan,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _onDropDownItemSelectedLayanan(newValue);
                  });
                },
                items: snapshot.data.result.data.map((Datum items){
                  return new DropdownMenuItem<String>(
                    value: items.code.toString() != null ? items.code.toString() : null,
                    child: Text(items.note,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
          )
              : new Center(
              child: new LinearProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
              )
          );
        }
    );
  }
  
}
