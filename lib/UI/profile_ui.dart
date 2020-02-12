import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/Model/profileModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/deposit.dart';
import 'package:thaibah/UI/component/History/historyDeposit.dart';
import 'package:thaibah/UI/component/History/historyPenarikan.dart';
import 'package:thaibah/UI/component/History/indexHistory.dart';
import 'package:thaibah/UI/component/dataDiri/indexMember.dart';
import 'package:thaibah/UI/component/penarikan.dart';
import 'package:thaibah/UI/component/penukaranBonus.dart';
import 'package:thaibah/UI/component/privacyPolicy.dart';
import 'package:thaibah/UI/history_ui.dart';
import 'package:thaibah/UI/jaringan_ui.dart';
import 'package:thaibah/UI/saldo_ui.dart';
import 'package:thaibah/UI/socmed/listFeed.dart';
import 'package:thaibah/UI/video_list_ui.dart';
import 'package:thaibah/bloc/profileBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/style.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';
import 'package:http/http.dart' as http;

import 'Widgets/pin_screen.dart';
import 'loginPhone.dart';


class ProfileUI extends StatefulWidget {
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
  String spCover, spPicture, spName, spReff, spUnique, id;
  bool loginStatus;
  Future<File> file;
  File _image;
  String base64Image;
  final formatter = new NumberFormat("#,###");
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  final _bloc=ProfileBloc();
  Future cekVersion() async {
//    String id = await userRepository.getID();
//    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
//    if (jsonString.statusCode == 200) {
//      final jsonResponse = json.decode(jsonString.body);
//      Info response = new Info.fromJson(jsonResponse);
//      versionCode = (response.result.versionCode);
//      if(versionCode != ApiService().versionCode){
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdatePage()), (Route<dynamic> route) => false);
//      }
//      setState(() {
//        isLoading = false;
//      });
//      print("###########################################################LOAD DATA HOME###############################################################");
//      print(jsonResponse);
//    } else {
//      throw Exception('########################################################### FALIED LOAD DATA HOME###############################################################');
//    }
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    profileBloc.fetchProfileList();
    _bloc.fetchProfileList();
  }
  Future getProfile() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginStatus = prefs.getBool('login');
      spCover = prefs.getString('cover');
      spPicture = prefs.getString('picture');
      spName = prefs.getString('name');
      spReff = prefs.getString('kd_referral');
      id    = prefs.getString("id");
    });
    return;
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

  Future logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Alert(
      style: AlertStyle(
          titleStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
          descStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik')
      ),
      context: context,
      type: AlertType.warning,
      title: "ANDA YAKIN",
      desc: "Akan Keluar Aplikasi Ini ??",
      buttons: [
        DialogButton(
          child: Text("TIDAK",style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => Navigator.of(context).pop(false),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text("YA",style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var res = await MemberProvider().logout();
            if(res.status == 'success'){
//              prefs.clear();
              prefs.setBool('cek', true);
              prefs.setString('id', null);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
            }
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }



  @override
  void initState() {
    super.initState();
    _bloc.fetchProfileList();
//    profileBloc.fetchProfileList();
    cekVersion();
  }
  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: RefreshIndicator(
          child: Container(
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: _bloc.subject,
                      builder: (context,AsyncSnapshot<ProfileModel> snapshot){
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              _headerProfile(snapshot.data.result.jumlahJaringan,snapshot.data.result.name, snapshot.data.result.picture, snapshot.data.result.cover, snapshot.data.result.kdReferral, snapshot.data.result.saldo, snapshot.data.result.rawSaldo, snapshot.data.result.saldoMain, snapshot.data.result.saldoBonus, snapshot.data.result.downline),
                              _menuMember(snapshot.data.result.kaki1,snapshot.data.result.kaki2,snapshot.data.result.kaki3,snapshot.data.result.privacy,snapshot.data.result.kdReferral,snapshot.data.result.jumlahJaringan,snapshot.data.result.omsetJaringan,snapshot.data.result.name,snapshot.data.result.saldoMain,snapshot.data.result.saldoBonus,snapshot.data.result.id),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return _loading();
                      }
                  ),
                ],
              ),
            ),
          ),
          onRefresh: _refresh
      ),

    );
  }

  Widget _headerProfile(var jumlahJaringan,var name,picture,var cover,var kdRefferal,var saldo,var rawSaldo,var saldoMain,var saldoBonus,var downline){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: (){

          },
          child: Container(
            height: 200,
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: new NetworkImage(
                  cover,
                ),
              ),
            ),
//            child: CachedNetworkImage(
//              imageUrl: cover,
//              placeholder: (context, url) => Center(
//                child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//              ),
//              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
//              imageBuilder: (context, imageProvider) => Container(
//                decoration: BoxDecoration(
//                  borderRadius: new BorderRadius.circular(0.0),
//                  color:Colors.black.withOpacity(0.5),
//                  image: DecorationImage(
//                    image: imageProvider,
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),
//            ),
          ),
        ),


//              Image.network(snapshot.data.result.cover, fit: BoxFit.cover, height: 300,),
//        Positioned(
//          top: 0.0,
//          right: 0,
//          child: Align(
//            alignment: Alignment.topRight,
//            child: Padding(
//              padding: EdgeInsets.only(left: 10, right: 10, top: _width/10),
//              child: FlatButton(
//                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
//                color: Styles.primaryColor,
//                onPressed: (){
//
//                },
//                child: Row(
//                  children: <Widget>[
//                    Container(
//                      child: Image.asset("assets/images/ic_wallet_100.png", width: 20, height: 20, color: Colors.white,),
//                    ),
//                    SizedBox(width: 5,),
//                    Text(saldoMain, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),)
//                  ],
//                ),
//              ),),
//          ),
//        ),
        Positioned(
          // bottom: _height/6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
//                  color:Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    minRadius: 90,
                    maxRadius: 150,
                    child: CachedNetworkImage(
                      imageUrl: picture,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                      ),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(50.0),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(name, style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Rubik', fontWeight: FontWeight.bold, shadows: [Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(0.0, 1.0),
                ),
                ]),),
                GestureDetector(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          kdRefferal,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'Rubik',
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black,
                                  offset: Offset(0.0, 1.0),
                                ),
                              ]
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.content_copy, color: Colors.white, size: 15,),]),
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: kdRefferal));
                    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Kode Referral Berhasil Disalin")));
                  },
                ),
                SizedBox(height: 20,),
              ],
            )
        ),

//        Positioned(
//            bottom: 0.0,
//            child: Container(
//                padding: EdgeInsets.all(15),
//                width: _width,
//                margin: EdgeInsets.only(top:5),
//                // color: Colors.white,
//                decoration: BoxDecoration(
//                    shape: BoxShape.rectangle,
//                    color: Colors.white
//                ),
//                child: Column(
//                    children: <Widget>[
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          FlatButton(
//                            onPressed: (){
//                              print("tapped");
//                              Navigator.of(context, rootNavigator: true).push(
//                                new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'profile')),
//                              );
//                            },
//                            child: Row(children: <Widget>[
//                              Container(
//                                width: 40.0,
//                                height: 50.0,
//                                // color: Colors.white,
//                                padding: EdgeInsets.fromLTRB(0,10,10,10),
//                                child: Image.asset('assets/images/ic_money_bag_100.png'),
//                              ),
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.end,
//                                children: <Widget>[
//                                  Text("Bonus Saya", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                  Text(saldoBonus, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                ],
//                              ),
//                            ]
//                            ),
//                          ),
//                          FlatButton(
//                            onPressed: (){
//                              print("tapped");
//                              Navigator.of(context, rootNavigator: true).push(
//                                new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral:kdRefferal)),
//                              );
//                            },
//                            child: Row(
//                              children: <Widget>[
//                                Container(
//                                  width: 40.0,
//                                  height: 50.0,
//                                  // color: Colors.white,
//                                  padding: EdgeInsets.fromLTRB(0,10,10,10),
//                                  child: Image.asset('assets/images/icons8-tree-structure-100.png'),
//                                ),
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.end,
//                                  children: <Widget>[
//                                    Text("Jaringan Saya", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                    Text(jumlahJaringan, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Rubik')),
//                                  ],
//                                ),
//                              ]
//                            ),
//                          )
//                        ],
//                      ),
//                    ]
//                )
//            )
//        )
      ],


    );

  }

  Widget _menuMember(var kaki1,var kaki2,var kaki3,var privasi,var kdReferral, var jumlahJaringan,var omsetJaringan,var name,var saldoMain,var saldoBonus, var id){
    return Container(
      margin: EdgeInsets.only(top: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => VideoListUI()),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Debugging", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Permintaan untuk isi saldo", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => SaldoUI(page:'profile',saldo: saldoMain,name: name)),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Topup Saldo", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Permintaan untuk isi saldo", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
                color: Color(0xFF116240),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[

                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Omset Jaringan Anda", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("Rp ${formatter.format(int.parse(omsetJaringan))}", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Jaringan Saya", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$jumlahJaringan ( Orang )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Kaki Besar 1", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$kaki1 ( STP )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Kaki Besar 2", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$kaki2 ( STP )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Kaki Besar 3", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                          Text("$kaki3 ( STP )", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                        ],
                      ),
                    )

                  ],
                )
            ),

          ),
          SizedBox(height:4.0,child: Container(color: Color(0xFFf5f5f5)),),

          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => PenukaranBonus(saldo: saldoMain, saldoBonus:saldoBonus)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Penukaran Bonus", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan Untuk Penukaran Bonus", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => Penarikan(saldoMain: saldoMain)),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text("Penarikan", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubik'),),
//                        Text("Penarikan dana ke rekening anda", style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.normal, fontSize: 12)),
//                      ]
//                  ),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => HistoryPenarikan()),
                );
                print('Routing to Electronics item list');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Riwayat Penarikan", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk melihat riwayat penarikan", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'profile')),
//                );
//                print('Routing to Electronics item list');
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Riwayat Transaksi", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Permintaan untuk melihat riwayat transaksi", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
//          Divider(),
          FlatButton(
              onPressed: (){
                print("tapped");
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => IndexHistory()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Riwayat Pembelian", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk melihat riwayat pembelian", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: (){
                print("tapped");
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => HistoryDeposit()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Riwayat Topup", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk melihat riwayat topup", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => IndexMember(id: id)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk mengedit profile", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
//          Divider(),
//          FlatButton(
//              onPressed: (){
//                Navigator.of(context, rootNavigator: true).push(
//                  new CupertinoPageRoute(builder: (context) => ListFeed()),
//                );
//              },
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text("Sosial Media", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
//                      Text("Membuat Member Saling Bersilaturhami", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
//                    ],),
//                  Icon(Icons.arrow_right)
//                ],
//              )
//          ),
          Divider(),
          FlatButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(builder: (context) => PrivacyPolicy(privasi: privasi)),
                );
//                logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Kebijakan & Privasi", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Informasi Tentang Kebijakan & Privasi", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],
                  ),
                  Icon(Icons.arrow_right)
                ],
              )
          ),
          Divider(),
          FlatButton(
              onPressed: () async {
                logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                      Text("Permintaan untuk keluar sesi aplikasi", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,fontFamily: 'Rubik')),
                    ],
                  ),
                  Icon(Icons.arrow_right)
                ],
              )
          ),

        ],
      ),
    );
  }


  Widget _loading(){
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){

              },
              child: Container(
                height: 300,
                child: CachedNetworkImage(
                  imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(0.0),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: _width/10),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    color: Styles.primaryColor,
                    onPressed: (){

                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SkeletonFrame(width: 80.0, height: 16.0),
                        ),
                        SizedBox(width: 5,),
                        SkeletonFrame(width: 80.0, height: 16.0),
                      ],
                    ),
                  ),),
              ),
            ),
            Positioned(
              // bottom: _height/6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 80.0,
                      height: 80.0,
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        minRadius: 90,
                        maxRadius: 150,
                        child: CachedNetworkImage(
                          imageUrl: "",
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                          ),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(50.0),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SkeletonFrame(width: 80.0, height: 16.0),

                    GestureDetector(
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SkeletonFrame(width: 80.0, height: 16.0),
                            SizedBox(width: 5),
                            Icon(Icons.content_copy, color: Colors.white, size: 15,),]),

                    ),
                    SizedBox(height: 20,),
                  ],
                )
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top:5),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
              FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: 80.0, height: 16.0),
                          SizedBox(height:5.0),
                          SkeletonFrame(width: 250.0, height: 16.0),
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  )
              ),
              Divider(),
            ],
          ),
        )
      ],
    );
  }



}