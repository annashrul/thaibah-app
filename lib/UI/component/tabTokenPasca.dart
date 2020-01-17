import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCekTagihanModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart' as prefix0;
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/plnModel.dart';
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
  final Function(String layanan,String meteran, String nohp) valid;
  final String nohp;
  TabTokenPasca({this.nohp,this.valid});
  @override
  _TabTokenPascaState createState() => _TabTokenPascaState();
}

class _TabTokenPascaState extends State<TabTokenPasca> {
  double _height;
  double _width;
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

  Future periksa(String code,no,idpelanggan) async{
    var res = await cekTagihanBloc.fetchCekTagihan(code, no, idpelanggan);
    if(res.status == 'success'){
      print(res.result);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => DetailTagihan(
            tagihan_id: res.result.tagihanId,
            code: res.result.code,
            product_name: res.result.productName,
            type: res.result.type,
            phone: res.result.phone,
            no_pelanggan: res.result.noPelanggan,
            nama: res.result.nama,
            periode: res.result.periode,
            jumlah_tagihan: res.result.jumlahTagihan,
            admin: res.result.admin,
            jumlah_bayar: res.result.jumlahBayar,
            status: res.result.status,
          ))
      );

    }else{
      print(res.msg);
      setState(() {
        _isLoading = false;
      });
    }

  }

  Future cekTagihan() async{
    final userRepository = UserRepository();
    var res = await PpobPascaProvider().fetchPpobPascaCekTagihan(_currentItemSelectedLayanan, noController.text, idPelangganController.text);
    if(res is PpobPascaCekTagihanModel){
      PpobPascaCekTagihanModel results = res;
      if(results.status == 'success'){
        setState(() {
          _isLoading = false;
        });
        noController.clear();
        idPelangganController.clear();
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => DetailPpobPasca(
              param : "TOKEN",
              tagihan_id:results.result.tagihanId,
              code:results.result.code,
              product_name:results.result.productName,
              type:results.result.type,
              phone:results.result.phone,
              no_pelanggan:results.result.noPelanggan,
              nama:results.result.nama,
              periode:results.result.periode,
              jumlah_tagihan:results.result.jumlahTagihan.toString(),
              admin:results.result.admin.toString(),
              jumlah_bayar:results.result.jumlahBayar.toString(),
              status:results.result.status,
              nominal:'0'
          )),
        );
      }else{
        setState(() {
          _isLoading = false;
        });
        return showInSnackBar(results.msg);
      }
    }else{
      General results = res;
      return showInSnackBar(results.msg);
    }
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
    ppobPascaBloc.fetchPpobPasca('PLN');
    noController.text = widget.nohp;
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
                    Text('No. Meteran / ID Pelanggan',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                    TextFormField(
                      controller: idPelangganController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: idPelangganFocus,
                      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Rubik')),
                      onFieldSubmitted: (term){
                        _fieldFocusChange(context, idPelangganFocus, noFocus);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('No. Telepon',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                    TextField(
                      controller: noController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: noFocus,
                      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Rubik')),
                      onSubmitted: (value){
                        noFocus.unfocus();
                        widget.valid(_currentItemSelectedLayanan,idPelangganController.text,noController.text);
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
                        widget.valid(_currentItemSelectedLayanan,idPelangganController.text,noController.text);
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

  _layanan(BuildContext context) {
    return StreamBuilder(
        stream: ppobPascaBloc.getResult,
        builder: (context,AsyncSnapshot<prefix0.PpobPascaModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ?
          new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Layanan',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 16)
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
                items: snapshot.data.result.data.map((prefix0.Datum items){
                  return new DropdownMenuItem<String>(
                    value: items.code.toString() != null ? items.code.toString() : null,
                    child: Text(items.note,style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
          ): new Center(
              child: new LinearProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
              )
          );
        }
    );
  }

}
