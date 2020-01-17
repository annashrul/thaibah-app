//import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter/material.dart';
//import 'package:thaibah/Model/generalModel.dart';
//import 'package:thaibah/Model/islamic/cariSuratModel.dart';
//import 'package:thaibah/bloc/islamic/cariSuratBloc.dart';
//import 'package:thaibah/resources/islamic/cariSuratProvider.dart';
//enum PlayerState { stopped, playing, paused }
//
//class CariSurat extends StatefulWidget {
//  String param;
//  CariSurat({this.param});
//  @override
//  _CariSuratState createState() => _CariSuratState();
//}
//
//class _CariSuratState extends State<CariSurat> {
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//  String paramLocal = '';
//  bool isLoading = false;
//  bool isActiveFav = false;
//
//  Duration duration;
//  Duration position;
//
//  String localFilePath;
//
//  PlayerState playerState = PlayerState.stopped;
//
//  get isPlaying => playerState == PlayerState.playing;
//  get isPaused => playerState == PlayerState.paused;
//
//  get durationText => duration != null ? duration.toString().split('.').first : '';
//  get positionText => position != null ? position.toString().split('.').first : '';
//
//  bool isMuted = false;
//  bool isPlay = false;
//  bool isActive = false;
//  bool isActiveCheck = false;
//  AudioPlayer audioPlayer = AudioPlayer();
//  int total = 0;
//
//
//  void play(mp3URL) async {
//    if (!isPlay) {
//      int result = await audioPlayer.play(mp3URL);
//      setState(() {
//        isActive = false;
//      });
//      if (result == 1) {
//        setState(() {
//
//          isPlay = true;
//        });
//      }
//    } else {
//      int result = await audioPlayer.stop();
//      if (result == 1) {
//        setState(() {
//          isPlay = false;
//        });
//      }
//    }
//  }
//
//
//  Future<void> pause() async {
//    int result = await audioPlayer.pause();
//    if (result == 1) {
//      setState(() {
//        isPlay = false;
//      });
//    }
//  }
//
//  void stop() async {
//    int result = await audioPlayer.stop();
//    if (result == 1) {
//      setState(() {
//        isPlay = false;
//      });
//    }
//  }
//
//  void onComplete() {
//    setState(() => playerState = PlayerState.stopped);
//  }
//
//  Future checked(String id,String nama) async{
//    var res = await CariSuratProvider().fetchChecked(id);
//    if(res is General){
//      General results = res;
//      print(res.msg);
//      if(results.status == 'success'){
//        setState(() {
//          isActiveCheck = false;
//        });
//        return showInSnackBar("Surat $nama Berhasil Di Cek",'sukses');
//      }else{
//        setState(() {
//          isActiveCheck = false;
//        });
//        return showInSnackBar("${results.msg}",'gagal');
//
//      }
//    }
//
//  }
//  Future favorite(String id, String nama) async{
//    var res = await CariSuratProvider().fetchFavorite(id);
//    if(res is General){
//      General results = res;
//      print(res.msg);
//      if(results.status == 'success'){
//        setState(() {
//          isActiveCheck = false;
//        });
//        return showInSnackBar("Surat $nama Berhasil Ditambahkan Ke Favorite Anda",'sukses');
//      }else{
//        setState(() {
//          isActiveCheck = false;
//        });
//        return showInSnackBar("${results.msg}",'gagal');
//
//      }
//    }
//  }
//  void showInSnackBar(String value,String param) {
//    FocusScope.of(context).requestFocus(new FocusNode());
//    scaffoldKey.currentState?.removeCurrentSnackBar();
//    scaffoldKey.currentState.showSnackBar(new SnackBar(
//      content: new Text(
//        value,
//        textAlign: TextAlign.center,
//        style: TextStyle(
//            color: Colors.white,
//            fontSize: 16.0,
//            fontWeight: FontWeight.bold,
//            fontFamily: "Rubik"),
//      ),
//      backgroundColor: param == 'sukses' ? Colors.green : Colors.red,
//      duration: Duration(seconds: 3),
//    ));
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    paramLocal = widget.param;
//    cariSuratBloc.fetchCariSurat(paramLocal);
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: scaffoldKey,
//      appBar: AppBar(
//        title: Text('${paramLocal}'),
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//      ),
//      body: StreamBuilder(
//        stream:cariSuratBloc.getResult,
//        builder: (context, AsyncSnapshot<CariSuratModel> snapshot) {
//          if (snapshot.hasData) {
//            return Column(
//              children: <Widget>[
//                Expanded(
//                  flex: 10,
//                  child: buildContent(snapshot,context),
//                ),
//                Expanded(
//                  flex: 1,
//                  child: Container(
//                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Column(
//                          mainAxisSize: MainAxisSize.min,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text("Total Ayat : ${snapshot.data.result.length}", style: TextStyle(color: Colors.black54),),
//                          ],
//                        ),
//
//                      ],
//                    ),
//                  )
//                )
//              ],
//            );
//          } else if (snapshot.hasError) {
//            return Text(snapshot.error.toString());
//          }
//
//          return Container(child: Center(child: CircularProgressIndicator(),),);
//        },
//      ),
//
//    );
//  }
//
//  Widget buildContent(AsyncSnapshot<CariSuratModel> snapshot, BuildContext context){
//    return ListView.builder(
//      itemCount: snapshot.data.result.length,
//      itemBuilder: (context, index) {
//        return GestureDetector(
//          onTap: (){
//            print("object");
//          },
//          child:  Container(
//            padding: EdgeInsets.all(10.0),
//            child: Card(
//              elevation: 0,
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.only(top:10.0),
//                    child: new ListTile(
//                      title: Directionality(
//                        textDirection: TextDirection.rtl,
//                        child: Align(
//                          alignment: Alignment.topRight,
//                          child: Text(snapshot.data.result[index].arabic, style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
//                    child: Align(
//                      alignment: Alignment.topLeft,
//                      child:Text(snapshot.data.result[index].terjemahan,style: TextStyle(fontFamily: 'Rubik',fontSize: 12)),
//                    ),
//                  ),
//                  Container(
//                    padding: EdgeInsets.only(left:13.0,bottom:10.0, right:16.0),
//                    child: Align(
//                      alignment: Alignment.topLeft,
//                      child:Text(snapshot.data.result[index].surahAyat,style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 12)),
//                    ),
//                  ),
//                  Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: [
//                        new IconButton(
//                            onPressed: () async {
//                              setState(() {
//                                isActive = true;
//                              });
//                              play(snapshot.data.result[index].audio);
//                            },
//                            iconSize: 30.0,
//                            icon: Icon(Icons.play_circle_filled,color: !isActive?Colors.black:Colors.green,)
//
//                        ),
//                        new IconButton(
//                            onPressed: () async {
//                              setState(() {
//                                isActiveCheck = true;
//                              });
//                              checked(snapshot.data.result[index].id,snapshot.data.result[index].surahAyat);
//                            },
//                            iconSize: 30.0,
//                            icon: Icon(Icons.check_circle,color: isActiveCheck?Colors.black:Colors.green)
//                        ),
//                        new IconButton(
//                            onPressed: () async {
//                              favorite(snapshot.data.result[index].id,snapshot.data.result[index].surahAyat);
//                            },
//                            iconSize: 30.0,
//                            icon: Icon(Icons.favorite,color: isActiveFav?Colors.black:Colors.green)
//
//                        ),
//                      ]
//                  )
////                  HandleChecked(url:snapshot.data.result[index].audio,id:snapshot.data.result[index].id)
//                ],
//              ),
//            ),
//          ),
//
//        );
//      },
//    );
//  }
//
//
//}
//
//class HandleTotal extends StatefulWidget {
//  int total;
//  HandleTotal({this.total});
//  @override
//  _HandleTotalState createState() => _HandleTotalState();
//}
//
//class _HandleTotalState extends State<HandleTotal> {
//  int totalLocal = 0;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    totalLocal = widget.total;
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Container(
//              height: kBottomNavigationBarHeight,
//              child: FlatButton(
//                shape:RoundedRectangleBorder(
//                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
//                ),
//                color: Colors.green,
//                onPressed: (){
//
//                },
//                child:Text("Total = $totalLocal", style: TextStyle(color: Colors.white)),
//              )
//          )
//        ],
//      ),
//    );
//  }
//}
//
//
//class HandleChecked extends StatefulWidget {
//  String url,id;
//  HandleChecked({this.url,this.id});
//  @override
//  _HandleCheckedState createState() => _HandleCheckedState();
//}
//
//class _HandleCheckedState extends State<HandleChecked> {
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//
//  String urlLocal = '';
//  String idLocal = '';
//
//  Duration duration;
//  Duration position;
//
////  AudioPlayer audioPlayer;
//
//  String localFilePath;
//
//  PlayerState playerState = PlayerState.stopped;
//
//  get isPlaying => playerState == PlayerState.playing;
//  get isPaused => playerState == PlayerState.paused;
//
//  get durationText => duration != null ? duration.toString().split('.').first : '';
//  get positionText => position != null ? position.toString().split('.').first : '';
//
//  bool isMuted = false;
//  bool isPlay = false;
//  bool isActive = false;
//  bool isActiveCheck = false;
//  AudioPlayer audioPlayer = AudioPlayer();
//  int total = 0;
//
//
//  void play(mp3URL) async {
//    if (!isPlay) {
//      int result = await audioPlayer.play(mp3URL);
//      setState(() {
//        isActive = false;
//      });
//      if (result == 1) {
//        setState(() {
//
//          isPlay = true;
//        });
//      }
//    } else {
//      int result = await audioPlayer.stop();
//      if (result == 1) {
//        setState(() {
//          isPlay = false;
//        });
//      }
//    }
//  }
//
//
//  Future<void> pause() async {
//    int result = await audioPlayer.pause();
//    if (result == 1) {
//      setState(() {
//        isPlay = false;
//      });
//    }
//  }
//
//  void stop() async {
//    int result = await audioPlayer.stop();
//    if (result == 1) {
//      setState(() {
//        isPlay = false;
//      });
//    }
//  }
//
//  void onComplete() {
//    setState(() => playerState = PlayerState.stopped);
//  }
//
//  Future checked(String id) async{
//    var res = await CariSuratProvider().fetchChecked(id);
//    if(res is General){
//      General results = res;
//      print(res.msg);
//      if(results.status == 'success'){
//        setState(() {
//          isActiveCheck = false;
//        });
////        return showInSnackBar("Produk Berhasil Dimasukan Ke Keranjang",'sukses');
//      }else{
//        setState(() {
//          isActiveCheck = false;
//        });
////        return showInSnackBar("Produk Berhasil Dimasukan Ke Keranjang",'gagal');
//
//      }
//    }
//
//  }
//  Future favorite(String id){
//    print(id);
//  }
//
//  void showInSnackBar(String value,String param) {
//    FocusScope.of(context).requestFocus(new FocusNode());
//    scaffoldKey.currentState?.removeCurrentSnackBar();
//    scaffoldKey.currentState.showSnackBar(new SnackBar(
//      content: new Text(
//        value,
//        textAlign: TextAlign.center,
//        style: TextStyle(
//            color: Colors.white,
//            fontSize: 16.0,
//            fontWeight: FontWeight.bold,
//            fontFamily: "Rubik"),
//      ),
//      backgroundColor: param == 'sukses' ? Colors.green : Colors.red,
//      duration: Duration(seconds: 3),
//    ));
//  }
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    urlLocal = widget.url;
//    idLocal = widget.id;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return  new Row(
//        mainAxisSize: MainAxisSize.min,
//        children: [
//          new IconButton(
//            onPressed: () async {
//              setState(() {
//                isActive = true;
//              });
//              play(urlLocal);
//            },
//            iconSize: 30.0,
//            icon: Icon(Icons.play_circle_filled,color: !isActive?Colors.black:Colors.green,)
//
//          ),
//          new IconButton(
//            onPressed: () async {
//              setState(() {
//                isActiveCheck = true;
//              });
//              checked(idLocal);
//            },
//            iconSize: 30.0,
//            icon: Icon(Icons.check_circle,color: isActiveCheck?Colors.black:Colors.green)
//          ),
//          new IconButton(
//            onPressed: () async {
//              favorite(idLocal);
//            },
//            iconSize: 30.0,
//            icon: Icon(Icons.favorite,color: Colors.green)
//
//          ),
//        ]
//    );
//  }
//}
//
//
