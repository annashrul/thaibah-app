import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thaibah/Model/address/getListAddressModel.dart';
import 'package:thaibah/UI/component/address/formAddress.dart';
import 'package:thaibah/bloc/addressBloc.dart';
import 'package:thaibah/bloc/ongkirBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/addressProvider.dart';
import 'package:thaibah/Constants/constants.dart';

class IndexAddress extends StatefulWidget {
  IndexAddress({Key key}) : super(key: key);
  @override
  _IndexAddressState createState() => _IndexAddressState();
}

class _IndexAddressState extends State<IndexAddress> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController mainAddressController = TextEditingController();
  final userRepository = UserRepository();
  int row=0;
  bool isLoading=false;
  Future cek() async{
    var test = await AddressProvider().fetchAlamat();
    setState(() {
      row = test.result.length;
      isLoading=false;
    });
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
    isLoading=true;
    provinsiBloc.fetchProvinsiist();

  }



  Widget _buildAddCardButton() {
    return isLoading?Container():IconButton(
        icon: Icon(Icons.add, color: Colors.black,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormAddress(param: '',),
            ),
          );
        }
    );


  }

  @override
  Widget build(BuildContext context) {
    addressBloc.fetchAddressList();
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Daftar Alamat",(){Navigator.pop(context);},<Widget>[
        row>=1?Container():_buildAddCardButton()]
      ),
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
                                Navigator.push(context,MaterialPageRoute(builder: (context) => FormAddress(
                                  param: snapshot.data.result[index].id,
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
                      Navigator.push(context,MaterialPageRoute(builder: (context) => FormAddress(
                        param: snapshot.data.result[index].id,
                      ))).whenComplete(() => addressBloc.fetchAddressList());
                    }
                  );
                }
            ),
          )
        ],
      );
    }else{
      return UserRepository().noData();
    }
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
