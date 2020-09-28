import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thaibah/Model/address/getListAddressModel.dart';
import 'package:thaibah/Model/kotaModel.dart';
import 'package:thaibah/Model/provinsiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/address/addAddress.dart';
import 'package:thaibah/UI/component/address/updateAddress.dart';
import 'package:thaibah/bloc/addressBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/addressProvider.dart';
import 'package:thaibah/Model/provinsiModel.dart' as prefix0;
import 'package:thaibah/Model/kotaModel.dart' as prefix1;
import 'package:thaibah/Model/kecamatanModel.dart' as prefix2;
import 'package:thaibah/Constants/constants.dart';

class IndexAddress extends StatefulWidget {
  IndexAddress({Key key}) : super(key: key);
  @override
  _IndexAddressState createState() => _IndexAddressState();
}

class _IndexAddressState extends State<IndexAddress> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TextEditingController mainAddressController = TextEditingController();
  int _currentItemSelectedProvinsi=null;
  int _currentItemSelectedKota=null;
  int _currentItemSelectedKecamatan=null;
  bool _addNewCard = false;

  final userRepository = UserRepository();

  int row=0;

  Future cek() async{
    var test = await AddressProvider().fetchAlamat();
    setState(() {
      row = test.result.length;
    });

    print(row);
  }


  getKota(id) async{
    kotaBloc.fetchKotaList(id.toString());
    setState(() {});
  }

  getKecamatan(id) async{
    kecamatanBloc.fetchKecamatanList(id.toString());
    setState(() {});
  }


  Color warna1;
  Color warna2;
  String statusLevel ='0';
  Future loadTheme() async{
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
      statusLevel = levelStatus;
    });
  }


  @override
  void initState() {
    super.initState();
    loadTheme();
    cek();
    provinsiBloc.fetchProvinsiist();
  }



  Widget _buildAddCardButton() {
    return IconButton(
      icon: Icon(Icons.add, color: Colors.white,),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAddress(),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    addressBloc.fetchAddressList();
    return Scaffold(
      key: scaffoldKey,
      appBar: row>=1?UserRepository().appBarWithButton(context, "Tambah Alamat",(){Navigator.pop(context);},<Widget>[]):UserRepository().appBarWithButton(context, "Tambah Alamat",(){Navigator.pop(context);},<Widget>[_buildAddCardButton()]),

      // appBar: row>=1?UserRepository().appBarWithButton(context,"Daftar Alamat",warna1,warna2,(){Navigator.pop(context);},Container()):UserRepository().appBarWithButton(context, "Daftar Alamat",warna1,warna2,(){Navigator.pop(context);}, _buildAddCardButton()),
      body: StreamBuilder(
        stream: addressBloc.allAddress,
        builder: (context, AsyncSnapshot<AddressModel> snapshot) {
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return UserRepository().loadingWidget();
        },
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<AddressModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return Column(
        children: <Widget>[
          (!_addNewCard) ? Text('') : _buildNewCard(),

          Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.result.length,
                itemBuilder: (context,index){
                  return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                title: UserRepository().textQ(snapshot.data.result[index].mainAddress, 12, Colors.black, FontWeight.bold, TextAlign.left),
                                // title: Text(snapshot.data.result[index].mainAddress,style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold),),
                              ),
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => UpdateAddress(
                                  main_address: snapshot.data.result[index].mainAddress,
                                  kd_prov: snapshot.data.result[index].kdProv,
                                  kd_kota: snapshot.data.result[index].kdKota,
                                  kd_kec: snapshot.data.result[index].kdKec,
                                  id: snapshot.data.result[index].id,
                                ))).whenComplete(() => addressBloc.fetchAddressList());
                              },
                              child: Icon(Icons.edit),
                            )
                          )
                        ],
                      ),
                    ),
                    background: slideLeftBackground(),
                    confirmDismiss: (direction) async {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => UpdateAddress(
                        main_address: snapshot.data.result[index].mainAddress,
                        kd_prov: snapshot.data.result[index].kdProv,
                        kd_kota: snapshot.data.result[index].kdKota,
                        kd_kec: snapshot.data.result[index].kdKec,
                        id: snapshot.data.result[index].id,
                      ))).whenComplete(() => addressBloc.fetchAddressList());
                    }
                  );
                }
            ),
          )

        ],
      );
    }else{
      return Column(
        children: <Widget>[
          (!_addNewCard) ? Text('') : _buildNewCard(),
          UserRepository().noData()
        ],
      );
    }

  }


  Widget _buildNewCard() {
    return Container(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
      child: _newCardForm(),
    );
  }

  Widget _newCardForm() {
    final height = 22.0;
    return Column(
      children: <Widget>[
        SizedBox(height: height),
        SizedBox(height: ScreenUtilQ.getInstance().setHeight(30)),
        Text("Detail Alamat",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: ThaibahFont().fontQ,fontSize: ScreenUtilQ.getInstance().setSp(24))),
        TextField(
          decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: ThaibahFont().fontQ)
          ),
          controller: mainAddressController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: ScreenUtilQ.getInstance().setHeight(35)),
        _provinsi(context),
        SizedBox(height: ScreenUtilQ.getInstance().setHeight(35)),
        _kota(context),
        SizedBox(height: ScreenUtilQ.getInstance().setHeight(35)),
        _kecamatan(context),
        SizedBox(height: ScreenUtilQ.getInstance().setHeight(35)),
        SizedBox(height: height),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  _addNewCard = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('BATAL', style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              color: Colors.white,
            ),
            MaterialButton(
              onPressed: () {

              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                  child: Text("Daftar",style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
              ),
              color: Color(0xFF116240),
            )
          ],
        )
      ],
    );
  }

  _provinsi(BuildContext context) {
    return StreamBuilder(
        stream: provinsiBloc.allProvinsi,
        builder: (context,AsyncSnapshot<ProvinsiModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Provinsi:',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rosemary",fontSize: 20)
            ),
            isEmpty: _currentItemSelectedProvinsi == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<int>(
                value: _currentItemSelectedProvinsi,
                isDense: true,
                onChanged: (int newValue) {
                  setState(() {
                    _onDropDownItemSelectedProvinsi(newValue);
                    getKota(newValue);
                    _onDropDownItemSelectedKota(null);
                    _onDropDownItemSelectedKecamatan(null);
                  });
                },
                items: snapshot.data.result.map((prefix0.Result items) {
                  return new DropdownMenuItem<int>(
                    value: items.id != null ? int.parse(items.id) : null,
                    child: Text(items.name,style: TextStyle(fontSize: 12,fontFamily: ThaibahFont().fontQ),),
                  );
                }).toList()
                ,
              ),
            ),
          )
              : new Center(
              child: new CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.blue),
              ));
        }
    );
  }
  _kota(BuildContext context) {
    return StreamBuilder(
        stream: kotaBloc.allKota,
        builder: (context,AsyncSnapshot<KotaModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Kota:',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rosemary",fontSize: 20)
            ),
            isEmpty: _currentItemSelectedKota == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<int>(
                value: _currentItemSelectedKota,
                isDense: true,
                onChanged: (int newValue) {
                  setState(() {
                    _onDropDownItemSelectedKota(newValue);
                    getKecamatan(newValue);
                    _onDropDownItemSelectedKecamatan(null);

                  });
                },
                items: snapshot.data.result.map((prefix1.Result items) {
                  return new DropdownMenuItem<int>(
                    value: items.id != null ? int.parse(items.id) : null,
                    child: new Text(items.name,style: TextStyle(fontSize: 12,fontFamily: ThaibahFont().fontQ)),
                  );
                }).toList()
                ,
              ),
            ),
          )
              :  Container();
        }
    );
  }
  _kecamatan(BuildContext context) {
    return StreamBuilder(
        stream: kecamatanBloc.allKecamatan,
        builder: (context,AsyncSnapshot<prefix2.KecamatanModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData ? new InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Kecamatan:',
                labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFF116240),fontFamily: "Rosemary",fontSize: 20)

            ),
            isEmpty: _currentItemSelectedKecamatan == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<int>(
                value: _currentItemSelectedKecamatan,
                isDense: true,
                onChanged: (int newValue) {
                  setState(() {
                    _onDropDownItemSelectedKecamatan(newValue);
                  });
                },
                items: snapshot.data.result.map((prefix2.Result items) {
                  return new DropdownMenuItem<int>(
                    value: items.subdistrictId != null ? int.parse(items.subdistrictId) : null,
                    child: new Text(items.subdistrictName,style: TextStyle(fontSize: 12,fontFamily: ThaibahFont().fontQ)),
                  );
                }).toList(),
              ),
            ),
          )
              : Container();
        }
    );
  }

  void _onDropDownItemSelectedProvinsi(int newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedProvinsi = val;
    });
  }

  void _onDropDownItemSelectedKota(int newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedKota = val;
    });
  }

  void _onDropDownItemSelectedKecamatan(int newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedKecamatan = val;
    });
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.white,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            UserRepository().textQ(" Ubah Data Alamat", 12, Colors.black, FontWeight.bold,  TextAlign.center),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
