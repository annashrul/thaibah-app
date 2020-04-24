import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaCekTagihanModel.dart';
import 'package:thaibah/Model/PPOB/PPOBPascaModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/ppob/detailPpobPasca.dart';
import 'package:thaibah/bloc/PPOB/PPOBPascaBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/PPOB/PPOBPascaProvider.dart';

class PpobPascabayar extends StatefulWidget {
  final String param,title;
  PpobPascabayar({this.param,this.title});

  @override
  _PpobPascabayarState createState() => _PpobPascabayarState();
}

class _PpobPascabayarState extends State<PpobPascabayar> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading  = false;
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

  Future cekTagihan() async{
//    final userRepository = UserRepository();
//    final nohp = await userRepository.getNoHp();
    print("LAYANAN = $_currentItemSelectedLayanan");
    print("ID PELANGGAN = ${nominalController.text}");
    String code = '';
    String tambahan = '';
    if(widget.param == 'PDAM'){
      code='PDAM';
      tambahan=_currentItemSelectedLayanan;
    }else{
      tambahan='';
      if(_currentItemSelectedLayanan=='BPJS Kesehatan'){
        code='BPJSKS';
        tambahan='';
      }else{
        code=_currentItemSelectedLayanan;
        tambahan='';
      }
    }
    print("CODE = $code, TAMBAHAN = $tambahan, ID PELANGGAN = ${nominalController.text}");
    var res = await PpobPascaProvider().fetchPpobPascaCekTagihan(
        code,
        tambahan,
        nominalController.text
    );
//    var res = await PpobPascaProvider().fetchPpobPascaCekTagihan(_currentItemSelectedLayanan=='BPJS Kesehatan'?'BPJSKS':_currentItemSelectedLayanan,'' , nominalController.text);
    if(res == 'timeout'){
      setState(() {isLoading = false;});
      return showInSnackBar('request timeout');
    }
    else if(res == 'error'){
      setState(() {isLoading = false;});
      return showInSnackBar('terjadi kesalahan syntax');
    }
    else if(res is PpobPascaCekTagihanModel){
      PpobPascaCekTagihanModel results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
        });
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => DetailPpobPasca(
              param : "${widget.title}",
              tagihan_id:results.result.tagihanId,
              code:results.result.code,
              product_name:results.result.productName,
              type:results.result.type,
              phone:results.result.phone.toString(),
              no_pelanggan:results.result.noPelanggan,
              nama:results.result.nama,
              periode:results.result.periode,
              jumlah_tagihan:results.result.jumlahTagihan.toString(),
              admin:results.result.admin.toString(),
              jumlah_bayar:results.result.jumlahBayar.toString(),
              status:results.result.status,
              nominal:nominalController.text
          )),
        );
      }else{
        setState(() {
          isLoading = false;
        });
        return showInSnackBar(results.msg);
      }
    }
    else{
      setState(() {
        isLoading = false;
      });
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


  @override
  void initState() {
    super.initState();
//    ppobPascaBloc.fetchPpobPasca(widget.param);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text('${widget.title}',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF116240),
                Color(0xFF30cc23)
              ],
            ),
          ),
        ),
      ),
      body: ListView(
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
                      layananHarcore(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('ID Pelanggan',style: TextStyle(color:Color(0xFF116240),fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12.0),),
                      TextField(
                        controller: nominalController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: nominalFocus,
                        decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Rubik')),
                        onSubmitted: (value){
                          nominalFocus.unfocus();
                          if(_currentItemSelectedLayanan == null){
                            return showInSnackBar('Silahkan Pilih Jasa Layanan');
                          }else if(nominalController.text == ''){
                            return showInSnackBar('Silahkan Masukan Nominal');
                          }else{
                            setState(() {
                              isLoading = true;
                            });
                            cekTagihan();
                          }
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
                          if(_currentItemSelectedLayanan == null){
                            return showInSnackBar('Silahkan Pilih Jasa Layanan');
                          }else if(nominalController.text == ''){
                            return showInSnackBar('Silahkan Masukan Nominal');
                          }else{
                            setState(() {
                              isLoading = true;
                            });
                            cekTagihan();
                          }
                        },
                        icon: isLoading ? CircularProgressIndicator():Icon(Icons.arrow_forward),
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  List layananPDAM = [
    "PDAM PALYJA",
    "PDAM AETRA/TPJ",
    "PDAM KAB BANDUNG",
    "PDAM KOT BANDUNG",
    "PDAM KOT DEPOK",
    "PDAM KAB SLEMAN",
    "PDAM KAB BANYUMAS",
    "PDAM KAB BOYOLALI",
    "PDAM KAB BREBES",
    "PDAM KAB CILACAP",
    "PDAM KAB GROBOGAN",
    "PDAM KAB KARANGANYAR",
    "PDAM KAB KEBUMEN",
    "PDAM KAB KENDAL",
    "PDAM KAB PEKALONGAN",
    "PDAM KAB PURBALINGGA",
    "PDAM KAB PURWOREJO",
    "PDAM KAB REMBANG",
    "PDAM KAB SEMARANG",
    "PDAM KAB SRAGEN",
    "PDAM KAB WONOGIRI",
    "PDAM KAB WONOSOBO",
    "PDAM KAB SALATIGA",
    "PDAM KOT SEMARANG",
    "PDAM KOT SURAKARTA",
    "PDAM KAB BANGKALAN",
    "PDAM KAB BOJONEGORO",
    "PDAM KAB BONDOWOSO",
    "PDAM KAB JEMBER",
    "PDAM KAB MALANG",
    "PDAM KAB MOJOKERTO",
    "PDAM KAB PROBOLINGGO",
    "PDAM KAB SIDOARJO",
    "PDAM KAB SITUBONDO",
    "PDAM KOT MADIUN",
    "PDAM KOT SURABAYA",
    "PDAM BANDAR LAMPUNG",
    "PDAM MEDAN",
    "PDAM PALEMBANG",
    "PDAM KAB KUBU RAYA",
    "PDAM KAB BALANGAN",
    "PDAM KAB TAPIN",
    "PDAM KOT BANJARBARU",
    "PDAM KAB BERAU",
    "PDAM KOT TANAH GROGOT",
    "PDAM KOT MANADO",
    "PDAM KAB BULELENG",
    "PDAM KAB LOMBOK TENGAH",
    "PDAM KOT MATARAM",
    "PDAM KAB BOGOR",
    "PDAM KOT BOGOR",
    "PDAM KOT DENPASAR",
    "PDAM KOT BANJARMASIN",
    "PDAM KOT BALIKPAPAN",
    "PDAM KOT PONTIANAK",
    "PDAM KOT MAKASSAR",
    "PDAM KAB KLATEN",
    "PDAM KAB KARAWANG",
    "PDAM JAMBI",
    "PDAM KOT BEKASI",
  ];

  List layananMultifinance = ['BAF','FIF','MAF','MCF','WOM'];
  List layananTvKable = ['INDOVISION','TOPTV','OKEVISION','YESTV'];
  List layananBPJS = ['BPJS Kesehatan'];
  List layananTelkom = ['TELKOM','FLEXI','SPEEDY','TELKOMVISION'];


  layananHarcore(){
    if(widget.param == 'PDAM'){
      return  structureLayanan(layananPDAM);
    }
    if(widget.param == 'MULTIFINANCE'){
      return  structureLayanan(layananMultifinance);
    }
    if(widget.param == 'PEMBAYARAN_TV'){
      return  structureLayanan(layananTvKable);
    }
    if(widget.param == 'BPJS'){
      return  structureLayanan(layananBPJS);
    }
    if(widget.param == 'telkom'){
      return  structureLayanan(layananTelkom);
    }

  }

  Widget structureLayanan(List param){
    return  new InputDecorator(
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
          items: param.map((items){
            return new DropdownMenuItem<String>(
              value: items,
              child: Text(items,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
            );
          }).toList(),
        ),
      ),
    );
  }
}



