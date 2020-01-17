//import 'dart:async';
//import 'dart:convert';
//
////import 'package:assets_audio_player/assets_audio_player.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
//import 'package:adhara_socket_io/manager.dart';
//import 'package:adhara_socket_io/socket.dart';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_svg/svg.dart';
//import 'package:http/io_client.dart';
//import 'package:intl/intl.dart';
////import 'package:socket_io_client/socket_io_client.dart';
////import 'package:laravel_echo/laravel_echo.dart';
//import 'package:thaibah/Model/imsakiyahModel.dart';
//import 'package:thaibah/Model/productMlmModel.dart';
//import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
//import 'package:thaibah/UI/component/detailTransfer.dart';
//import 'package:thaibah/UI/detail_produk_mlm_ui.dart';
//import 'package:thaibah/UI/loginPhone.dart';
//import 'package:thaibah/bloc/productMlmBloc.dart';
//import 'package:thaibah/config/api.dart';
//import 'package:thaibah/config/style.dart';
//import 'package:http/http.dart' as http;
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_compass/flutter_compass.dart';
//
//import 'dart:math' as Math;
//import 'package:flutter/services.dart';
////import 'package:laravel_echo/laravel_echo.dart';
////import 'package:socket_io_client/socket_io_client.dart' as IO;
//
//import 'package:fluttertoast/fluttertoast.dart';
//
//import '../quran_read_ui.dart';
//
////import 'package:flutter_socket_io/flutter_socket_io.dart';
////import 'package:flutter_socket_io/socket_io_manager.dart';
//const String URI = "http://thaibah.com:3010/";
//const String URILOCAL  = "http:192.168.1.9:3010";
////const String URI = "http://192.168.0.106:7000/";
//
//class TabKavlingUI extends StatefulWidget {
//  @override
//  _TabKavlingUIState createState() => _TabKavlingUIState();
//}
//
//class _TabKavlingUIState extends State<TabKavlingUI>{
////  bool isExpanded = false;
////  var scaffoldKey = GlobalKey<ScaffoldState>();
////  bool isLoading = false;
//
//
////  Widget build(BuildContext context) {
////    productMlmBloc.fetchProductMlmList(1,50);
////    return StreamBuilder(
////      stream: productMlmBloc.allProductMlm,
////      builder: (context, AsyncSnapshot<ProductMlmModel> snapshot) {
////        // print(snapshot.hasData);
////        if (snapshot.hasData) {
////          return buildContent(snapshot, context);
////        } else if (snapshot.hasError) {
////          return Text(snapshot.error.toString());
////        }
////        return Container(
////          child: Padding(
////              padding: const EdgeInsets.all(5.0),
////              child: new StaggeredGridView.countBuilder(
////                primary: false,
////                physics: ScrollPhysics(),
////                crossAxisCount: 2,
////                mainAxisSpacing: 2.0,
////                crossAxisSpacing: 2.0,
////                itemCount: 2,
////                itemBuilder: (context, index) {
////                  return new InkWell(
////                      child: Card(
////                        elevation: 1,
////                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
////                        child: new Column(
////                          children: <Widget>[
////                            new Stack(
////                              children: <Widget>[
////                                //new Center(child: new CircularProgressIndicator()),
////                                new Center(
////                                  child: ClipRRect(
////                                    borderRadius: BorderRadius.only(
////                                        topLeft: Radius.circular(0.0),
////                                        topRight: Radius.circular(0.0)
////                                    ),
////                                    child: Image.network("http://lequytong.com/Content/Images/no-image-02.png"),
////                                  ),
////                                ),
////                              ],
////                            ),
////                            new Padding(
////                              padding: const EdgeInsets.all(20.0),
////                              child: new Column(
////                                children: <Widget>[
////                                  Column(
////                                    crossAxisAlignment: CrossAxisAlignment.start,
////                                    children: <Widget>[
////                                      Padding(
////                                        padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,4.0),
////                                        child: Row(children: <Widget>[
////                                          Expanded(
////                                            flex: 6,
////                                            child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16)
////                                          ),
////                                          SizedBox(width: 5,),
////                                          Expanded(
////                                            flex: 3,
////                                            child: Container(
////                                              padding: EdgeInsets.all(5),
////                                              decoration: BoxDecoration(
////                                                borderRadius: BorderRadius.all(Radius.circular(5)),
////                                                color: Colors.white
////                                              ),
////                                              child: Align(
////                                                alignment: Alignment.center,
////                                                child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16),
////                                              )
////                                            ),
////                                          ),
////                                        ],),
////                                      ),
////                                      Row(
////                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                                        crossAxisAlignment: CrossAxisAlignment.start,
////                                        children: <Widget>[
////                                          Expanded(
////                                              flex: 1,
////                                              child: Column(
////                                                  crossAxisAlignment: CrossAxisAlignment.center,
////                                                  mainAxisSize: MainAxisSize.max,
////                                                  children: <Widget>[
////                                                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
////                                                    SizedBox(height:10.0),
////                                                    SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
////                                                  ])
////                                          ),
////                                          Container(height: 35, child: VerticalDivider(color: Colors.grey)),
////                                          Expanded(
////                                            flex: 3,
////                                            child: Column(
////                                              crossAxisAlignment: CrossAxisAlignment.center,
////                                              children: <Widget>[
////                                                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
////                                                SizedBox(height:10.0),
////                                                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
////                                              ],),
////                                          ),
////                                          Container(height: 35, child: VerticalDivider(color: Colors.grey)),
////                                          Expanded(
////                                            flex: 3,
////                                            child: Column(
////                                              crossAxisAlignment: CrossAxisAlignment.center,
////                                              children: <Widget>[
////                                                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
////                                                SizedBox(height:10.0),
////                                                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
////                                              ],
////                                            ),
////                                          ),
////                                        ],)
////                                    ],
////                                  )
////                                ],
////                              ),
////                            )
////                          ],
////                        ),
////                      )
////                  );
////                },
////                staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
////              )
////          ),
////        );
////      },
////    );
////  }
////
////  Widget buildContent(AsyncSnapshot<ProductMlmModel> snapshot, BuildContext context) {
////    if(snapshot.data.result.data.length > 0){
////      return Container(
////        child: Padding(
////            padding: const EdgeInsets.all(5.0),
////            child: new StaggeredGridView.countBuilder(
////              primary: false,
////              physics: ScrollPhysics(),
////              crossAxisCount: 2,
////              mainAxisSpacing: 2.0,
////              crossAxisSpacing: 2.0,
////              itemCount: snapshot.data.result.data.length,
////              itemBuilder: (context, index) {
////                return new InkWell(
////                    onTap: (){
////                      Navigator.of(context, rootNavigator: true).push(
////                        new CupertinoPageRoute(
////                          fullscreenDialog: true,
////                          builder: (context) => DetailProdukMlmiUI(
////                            id:snapshot.data.result.data[index].id,
////                            penjual: snapshot.data.result.data[index].penjual,
////                            title: snapshot.data.result.data[index].title,
////                            type: snapshot.data.result.data[index].type.toString(),
////                            price: snapshot.data.result.data[index].price,
////                            satuan: snapshot.data.result.data[index].satuan,
////                            raw_price: int.parse(snapshot.data.result.data[index].rawPrice),
////                            qty: snapshot.data.result.data[index].qty.toString(),
////                            picture: snapshot.data.result.data[index].picture,
////                            descriptions: snapshot.data.result.data[index].descriptions,
////                            category: snapshot.data.result.data[index].category,
////                          ),
////                        ),
////                      );
//////                    Navigator.of(context, rootNavigator: true).push(
//////                      new CupertinoPageRoute(
//////                          fullscreenDialog: true,
//////                          builder: (context) => DetailProdukMlmiUI(id:snapshot.data.result.data[index].id)
//////                      ),
//////                    );
////                    },
////                    child: Card(
////                      elevation: 1,
////                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
////                      child: new Column(
////                        children: <Widget>[
////                          new Stack(
////                            children: <Widget>[
////                              //new Center(child: new CircularProgressIndicator()),
////                              new Center(
////                                child: ClipRRect(
////                                  borderRadius: BorderRadius.only(
////                                      topLeft: Radius.circular(0.0),
////                                      topRight: Radius.circular(0.0)
////                                  ),
////                                  child: Image.network(snapshot.data.result.data[index].picture),
////                                ),
////                              ),
////                            ],
////                          ),
////                          new Padding(
////                            padding: const EdgeInsets.all(20.0),
////                            child: new Column(
////                              children: <Widget>[
////                                Column(
////                                  crossAxisAlignment: CrossAxisAlignment.start,
////                                  children: <Widget>[
////                                    Padding(
////                                      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,4.0),
////                                      child: Row(children: <Widget>[
////                                        Expanded(
////                                          flex: 6,
////                                          child: Text(snapshot.data.result.data[index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Rubik'),),),
////                                        SizedBox(width: 5,),
////                                        Expanded(
////                                          flex: 3,
////                                          child: Container(
////                                              padding: EdgeInsets.all(5),
////                                              decoration: BoxDecoration(
////                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
////                                                  color: Styles.primaryColor),
////                                              child: Align(
////                                                alignment: Alignment.center,
////                                                child: Text(snapshot.data.result.data[index].satuan, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Rubik'),),
////                                              )
////                                          ),
////                                        ),
////                                      ],),
////                                    ),
////                                    Row(
////                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                                      crossAxisAlignment: CrossAxisAlignment.start,
////                                      children: <Widget>[
////                                        Expanded(
////                                            flex: 1,
////                                            child: Column(
////                                                crossAxisAlignment: CrossAxisAlignment.center,
////                                                mainAxisSize: MainAxisSize.max,
////                                                children: <Widget>[
////                                                  Text("Tipe", style: TextStyle(fontFamily: 'Rubik', color: Colors.black45)),
////                                                  Text("KQ", style: TextStyle(fontFamily: 'Rubik', color: Colors.black)),
////                                                  // Text("200m2"),
////                                                ])
////                                        ),
////                                        Container(height: 35, child: VerticalDivider(color: Colors.grey)),
////                                        Expanded(
////                                          flex: 3,
////                                          child: Column(
////                                            crossAxisAlignment: CrossAxisAlignment.center,
////                                            children: <Widget>[
////                                              Text("Luas Tanah", style: TextStyle(fontFamily: 'Rubik', color: Colors.black45)),
////                                              Text("200m2"),
////                                            ],),
////                                        ),
////                                        Container(height: 35, child: VerticalDivider(color: Colors.grey)),
////                                        Expanded(
////                                          flex: 3,
////                                          child: Column(
////                                            crossAxisAlignment: CrossAxisAlignment.center,
////                                            children: <Widget>[
////                                              Text("Harga/m2", style: TextStyle(fontFamily: 'Rubik', color: Colors.black45)),
////                                              Text(snapshot.data.result.data[index].price),
////                                            ],),
////                                        ),
////                                      ],)
////                                  ],
////                                )
////                              ],
////                            ),
////                          )
////                        ],
////                      ),
////                    )
////                );
////              },
////              staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
////            )
////        ),
////      );
////    }else{
////      return Container(child: Center(child: Text('Data Tidak Tersedia',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),),);
////    }
////  }
//
//  var shubuh; var sunrise; var dzuhur; var ashar; var maghrib; var isya;
//  var menitShubuh;var menitSunrise;var menitDzuhur;var menitAshar; var menitMaghrib; var menitIsya;
//  String _timeString, _timeStringClone;
//  String detikDzuhur = '0';
//
//  PrayerModel prayerModel;
//  Future<void> loadPrayer() async {
//    var jsonString = await http.get(ApiService().baseUrl+'islamic/jadwalsholat?long=107.61861&lat=-6.90389');
//    print("###################################### JADWAL SHOLAT ###################################");
//    print(jsonString.body);
//    if (jsonString.statusCode == 200) {
//      final jsonResponse = json.decode(jsonString.body);
//      prayerModel = new PrayerModel.fromJson(jsonResponse);
//      shubuh = new DateFormat('HH').format(prayerModel.result.fajr);
//      sunrise = new DateFormat('HH').format(prayerModel.result.sunrise);
//      dzuhur = new DateFormat('HH').format(prayerModel.result.dhuhr);
//      ashar = new DateFormat('HH').format(prayerModel.result.asr);
//      maghrib = new DateFormat('HH').format(prayerModel.result.maghrib);
//      isya = new DateFormat('HH').format(prayerModel.result.isha);
//      menitShubuh = new DateFormat('mm').format(prayerModel.result.fajr);
//      menitSunrise = new DateFormat('mm').format(prayerModel.result.sunrise);
//      menitDzuhur = new DateFormat('mm').format(prayerModel.result.dhuhr);
//      menitAshar = new DateFormat('mm').format(prayerModel.result.asr);
//      menitMaghrib = new DateFormat('mm').format(prayerModel.result.maghrib);
//      menitIsya = new DateFormat('mm').format(prayerModel.result.isha);
//
//      DateTime dt = DateTime.now();
//      int hours  = dt.hour;
//      int minute = dt.minute;
//
//      print("SEKARANG =  $hours ");
//      print("DZUHUR =  $dzuhur ");
//      print("ASHAR =  $ashar $menitAshar");
//      print("MAGHRIB =  $maghrib $menitMaghrib");
//      print("ISYA =  $isya ");
//      print("SHUBUH =  $shubuh ");
//      print("SUNRISE =  $sunrise ");
//
//    } else {
//      throw Exception('Failed to load info');
//    }
//  }
//  SocketIOManager manager = SocketIOManager();
//  SocketIO socket;
//
//  void _getCurrentTime()  async{
//
//    String strHour    = '${DateTime.now().hour}';
//    String strMinute  = '${DateTime.now().minute}';
//    String strSecond  = '${DateTime.now().second}';
//
//    String resMinute = '';
//    String resHours  = '';
//    if(strMinute.toString().length == '1' || strMinute.toString().length == 1 ){
//      resMinute = "0${strMinute}";
//    }else{
//      resMinute = "${strMinute}";
//    }
//    if(strHour.toString().length == 1){
//      resHours  = "0${strHour}";
//    }else{
//      resHours  = "${strHour}";
//    }
//    String compareNow     = "${resHours}${resMinute}${strSecond}";
//    String compareMagrib  = "${maghrib}${menitMaghrib}0";
//    String compareIsya    = "${isya}${menitIsya}0";
//    String compareShubuh  = "${shubuh}${menitShubuh}0";
//    String compareDzuhur  = "${dzuhur}${menitDzuhur}0";
//    String compareAshar   = "${ashar}${menitAshar}0";
//
//    print("########################MAGRIB = $compareMagrib###########################");
//
//    socket = await manager.createInstance(
//        'http://192.168.1.9:3010/',
//        query: {
//          'id' : '45498967-168a-4677-813f-04bf696a2879'
//        }
//    );
//
//    if('acuy' == 'acuy'){
//      socket.onConnect((data){
//        print("connected...");
//        print("#####################################$data####################################");
//        socket.emit('message', [{
//          'adzan': 'Isya',
//        }]);
//      });
//      socket.connect();
//    }
//    else if(int.parse(compareNow) == int.parse(compareShubuh)){
//      socket.onConnect((data){
//        print("connected...");
//        print("#####################################$data####################################");
//        socket.emit('message', [{
//          'adzan': 'Shubuh',
//        }]);
//      });
//      socket.connect();
//    }
//    else if(int.parse(compareDzuhur) == int.parse(compareNow)){
//      socket.onConnect((data){
//        print("connected...");
//        print("#####################################$data####################################");
//        socket.emit('message', [{
//          'adzan': 'Dzuhur',
//        }]);
//      });
//      socket.connect();
//    }
//    else if(int.parse(compareAshar) == int.parse(compareNow)){
//      socket.onConnect((data){
//        print("connected...");
//        print("#####################################$data####################################");
//        socket.emit('message', [{
//          'adzan': 'Ashar',
//        }]);
//
//      });
//      socket.connect();
//    }
//
//    else if(int.parse(compareMagrib) == int.parse(compareNow)){
//      socket.onConnect((data){
//        print("connected...");
//        print("#####################################$data####################################");
//        socket.emit('message', [{
//          'adzan': 'Magrhrib',
//        }]);
//
//      });
//      socket.connect();
//    }
//
//  }
//
//
//  @override
//  void initState() {
//    super.initState();
//    cek();
//    loadPrayer();
//    _getCurrentTime();
//
//  }
//
//  void cek () async{
//    socket = await manager.createInstance(
//      'http://192.168.1.9:3010/',
//      query: {
//        'id' : '45498967-168a-4677-813f-04bf696a2879'
//      }
//    );       //TODO change the port  accordingly
//    socket.onConnect((data){
//      print("connected...");
//      print("#####################################$data####################################");
//      socket.emit('message', [{
//        'from': '45498967-168a-4677-813f-04bf696a2879',
//        'to'  : '45498967-168a-4677-813f-04bf696a2879',
//        'msg' : ''
//      }]);
//    });
//    socket.on("adzan", (data){   //sample event
//      print("adzan");
//      print(data);
//    });
//    socket.connect();
//  }
//
//
//
//  @override
//  Widget build(BuildContext context){
//    return InkWell(
////      onTap: (){send();},
//      child: Text('kirim'),
//    );
//  }
//
//}
//
//
