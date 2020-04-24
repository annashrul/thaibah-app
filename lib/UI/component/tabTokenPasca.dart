import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCekTagihanModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart' as prefix0;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/plnModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/detailTagihan.dart';
import 'package:thaibah/UI/ppob/detailPpobPasca.dart';
import 'package:thaibah/UI/ppob/listrik_ui.dart';
import 'package:thaibah/bloc/PPOB/PPOBPascaBloc.dart';
import 'package:thaibah/bloc/cekTagihanBloc.dart';
import 'package:thaibah/bloc/plnBloc.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/PPOB/PPOBPascaProvider.dart';

class TabTokenPasca extends StatefulWidget {
  final Function(String layanan,String meteran) valid;
  TabTokenPasca({this.valid});
  @override
  _TabTokenPascaState createState() => _TabTokenPascaState();
}

class _TabTokenPascaState extends State<TabTokenPasca> {
  bool _isLoading = false;
  String _currentItemSelectedLayanan=null;
  TextEditingController noController = TextEditingController();
  TextEditingController idPelangganController = TextEditingController();
  final FocusNode idPelangganFocus = FocusNode();
  final FocusNode noFocus = FocusNode();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void _onDropDownItemSelectedLayanan(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedLayanan = val;
    });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    ppobPascaBloc.fetchPpobPasca('PLN');
//    noController.text = widget.nohp;
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
                padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('No. Meteran / ID Pelanggan',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                    TextField(
                      controller: idPelangganController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: idPelangganFocus,
                      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Rubik')),
//                      onFieldSubmitted: (term){
//                        _fieldFocusChange(context, idPelangganFocus, noFocus);
//                      },
                      onSubmitted: (value){
                        noFocus.unfocus();
                        widget.valid(_currentItemSelectedLayanan,idPelangganController.text);
                      },
                    ),
                  ],
                ),
              ),
//              Padding(
//                padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    layananHardcore()
//                  ],
//                ),
//              ),
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
                        widget.valid(_currentItemSelectedLayanan,idPelangganController.text);
                      },
                      icon: _isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                    ),
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }



}
