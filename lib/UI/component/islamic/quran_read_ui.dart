
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/islamic/ayatModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/islamic/islamicProvider.dart';

import '../../Widgets/loadMoreQ.dart';


typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }
class QuranReadUI extends StatefulWidget {
  final String total, id,param,param1,suratAyat;
  QuranReadUI({Key key, @required this.total, this.id,this.param,this.param1,this.suratAyat}) : super(key: key);
  
  @override
  QuranReadUIState createState() => new QuranReadUIState();
}

class QuranReadUIState extends State<QuranReadUI> {
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();



  Future actionPost(bool isCheck,String id,String nama,param) async{
    var res = await IslamicProvider().fetchActionPost(id,param);
    if(res is General){
      General results = res;
      print(res.msg);
      if(results.status == 'success'){
        if(isCheck != true){
          UserRepository().notifNoAction(scaffoldKey, context,"Surat $nama Berhasil Di $param", "success");
        }else{
          UserRepository().notifNoAction(scaffoldKey, context,"Surat $nama Berhasil Di dibuang", "failed");
        }
      }else{
        setState(() {});
        UserRepository().notifNoAction(scaffoldKey, context,results.msg, "failed");
      }
    }

  }

  var noteController = TextEditingController();
  final FocusNode noteFocus = FocusNode();

  Future Note(var id,bool note) async{
    var res = await IslamicProvider().fetchNote(id, noteController.text);
    if(res is General){
      noteController.text = '';
      General results = res;
      print(res.msg);
      if(results.status == 'success'){
        if(note != true){
          UserRepository().notifNoAction(scaffoldKey, context, "berhasil ditambahkan ke daftar note anda", "success");
        }else{
          UserRepository().notifNoAction(scaffoldKey, context, "berhasil dihapus di daftar note anda", "success");
        }
      }else{
        setState(() {});
        UserRepository().notifNoAction(scaffoldKey, context, results.msg, "failed");
      }
    }
  }



  String id='';
  String param='';
  String tampung = '';
  int perpage = 10;
  int total = 0;
  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    ayatBloc.fetchAyatList(int.parse(id),param,1,perpage);
//    historyBloc.fetchHistoryList('bonus',1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}','');
    print(perpage);
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
//    historyBloc.fetchHistoryList('bonus',1, perpage,'$tahun-${fromBulan}-${fromHari}','${tahun}-${toBulan}-${toHari}','');
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
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
    // TODO: implement initState
    super.initState();
    id    = widget.id;
    param = widget.param;
    ayatBloc.fetchAyatList(int.parse(id),param,1,perpage);
    loadTheme();
  }

  Duration duration;
  Duration position;

//  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  bool isPlay = false;

  AudioPlayer audioPlayer = AudioPlayer();



  void play(mp3URL) async {
    if (!isPlay) {
      int result = await audioPlayer.play(mp3URL);
      if (result == 1) {
        setState(() {
          isLoading = false;
          isPlay = true;
        });
      }
    } else {
      int result = await audioPlayer.stop();
      if (result == 1) {
        setState(() {
          isLoading = false;
          isPlay = false;
        });
      }
    }
  }


  Future<void> pause() async {
//    await audioPlayer.pause();
//    setState(() => playerState = PlayerState.paused);
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlay = false;
      });
    }
  }

  void stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        isPlay = false;
      });
    }
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, param == 'detail' ? 'Daftar ${widget.param1}' : 'Hasil Pencarian $param',(){Navigator.pop(context);},<Widget>[]),

      // appBar: UserRepository().appBarWithButton(context, param == 'detail' ? 'Daftar ${widget.param1}' : 'Hasil Pencarian $param', warna1,warna2,(){Navigator.pop(context);},Container()),
      body: StreamBuilder(
        stream: ayatBloc.allAyat,
        builder: (context, AsyncSnapshot<AyatModel> snapshot) {
          if (snapshot.hasData) {
            total = snapshot.data.result.data.length;
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: buildContent(snapshot,context),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              param == 'detail' ? Text("Total Ayat : ${widget.total}", style: TextStyle(fontSize:ScreenUtilQ().setSp(40),fontFamily:ThaibahFont().fontQ,color: Colors.black54),):Text("Total Pencarian : ${snapshot.data.result.data.length}", style: TextStyle(fontSize:ScreenUtilQ().setSp(40),color: Colors.black54,fontFamily:ThaibahFont().fontQ),),
                            ],
                          ),

                        ],
                      ),
                    )
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return _loading();
        },
      ),
//      bottomNavigationBar: ,
    );
  }

  Widget buildContent(AsyncSnapshot<AyatModel> snapshot, BuildContext context){
    if(snapshot.data.result.data.length > 0){
      return isLoading?_loading(): RefreshIndicator(
        child: LoadMoreQ(
          child: ListView.builder(
            itemCount: snapshot.data.result.data.length,
            itemBuilder: (context, index) {
              bool cekChecked = snapshot.data.result.data[index].checked;
              bool cekFavorite = snapshot.data.result.data[index].fav;
              tampung = snapshot.data.result.data[index].terjemahan.toString().replaceAll(param, param.toUpperCase());
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  color: param=='detail' && widget.suratAyat == snapshot.data.result.data[index].surahAyat ? Colors.blueGrey : Colors.white,
                  elevation: 0.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top:10.0),
                        child: new ListTile(
                          title: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Html(customTextAlign: (_) => TextAlign.right,data:snapshot.data.result.data[index].arabic, defaultTextStyle: TextStyle(fontSize: 20, fontFamily:ThaibahFont().fontQ)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                        child: Html(
                          defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12,color:Colors.black),
                          data: tampung.replaceAll(r'\', r' '),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:13.0,bottom:10.0, right:16.0),
                        child: Html(
                          defaultTextStyle: TextStyle(fontFamily:ThaibahFont().fontQ,fontSize: 12,color:Colors.black),
                          data: snapshot.data.result.data[index].surahAyat.replaceAll(r'\', r' '),
                        ),
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  play(snapshot.data.result.data[index].audio);
                                },
                                iconSize: 20.0,
                                icon: isLoading ? Icon(Icons.pause,color: Colors.green) : Icon(Icons.play_circle_filled,color: Colors.green)
                            ),
                            IconButton(
                                onPressed: () async {
//                                  setState(() {
//                                    isLoading = true;
//                                  });
                                  actionPost(cekChecked,snapshot.data.result.data[index].id,snapshot.data.result.data[index].surahAyat,'checked');
                                },
                                iconSize: 20.0,
                                icon: Icon(Icons.check_circle,color: snapshot.data.result.data[index].checked == false ?Colors.black:Colors.green)
                            ),
                            new IconButton(
                                onPressed: () async {
//                                  setState(() {
//                                    isLoading = true;
//                                  });
                                  actionPost(cekFavorite,snapshot.data.result.data[index].id,snapshot.data.result.data[index].surahAyat,'fav');
                                },
                                iconSize: 20.0,
                                icon: Icon(Icons.favorite,color: snapshot.data.result.data[index].fav == false ?Colors.black:Colors.green)
                            ),
                            new IconButton(
                                onPressed: () async {
                                  _lainnyaModalBottomSheet(context,snapshot.data.result.data[index].id,snapshot.data.result.data[index].note);
                                },
                                iconSize: 20.0,
                                icon: Icon(Icons.edit,color: snapshot.data.result.data[index].note == false ?Colors.black:Colors.green)
                            ),
                          ]
                      )

                    ],
                  ),
                ),
              );
            },
          ),
          onLoadMore: _loadMore,
          whenEmptyLoad: true,
          delegate: DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
          isFinish: snapshot.data.result.data.length < perpage,
        ),
        onRefresh: _refresh
      );
    }else{
      return Container(
        child: Center(
          child: Text('Data Tidak Ada'),
        ),
      );
    }
  }
  void _lainnyaModalBottomSheet(context,id,note){
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return Container(
            height: MediaQuery.of(context).size.height/1,
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              elevation: 5.0,
              color:Colors.grey[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  SizedBox(height: 10.0,),
                  Expanded(
                    flex: 10,
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0,right: 10.0),
                      child: TextFormField(
                        autofocus: true,
                        controller: noteController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        minLines: null,
                        focusNode: noteFocus,
                        onFieldSubmitted: (value){
                          if(noteController.text == ''){
                            UserRepository().notifNoAction(scaffoldKey, context, "Form tidak boleh kosong", "failed");
                          }else{
                            Navigator.pop(context);
                            setState(() {
                              isLoading = true;
                            });
                            noteFocus.unfocus();
                            Note(id,note);
                          }

                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                          hintText: 'Tulis sesuatu disini .....'
                        ),
                      ),
                    ),
                  ),
                ]
              )
            ),
          );
//            return Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Expanded( // wrap your Column in Expanded
//                  child: Column(
//                    children: <Widget>[
//                      Text('item 1'),
//                      Container(child: TextField()),
//                    ],
//                  ),
//                ),
//                Expanded( // wrap your Column in Expanded
//                  child: Column(
//                    children: <Widget>[
//                      Text('item 2'),
//                      Container(child: TextField()),
//                    ],
//                  ),
//                ),
//              ],
//            );


        }
    );
  }

  Widget _loading(){
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          child:  Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:10.0),
                    child: new ListTile(
                      title: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

        );
      },
    );
  }
}

class HandlePlay extends StatefulWidget {
  String url;
  HandlePlay({this.url});
  @override
  _HandlePlayState createState() => _HandlePlayState();
}

class _HandlePlayState extends State<HandlePlay> {
  Duration duration;
  Duration position;

//  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  bool isPlay = false;
  bool isLoading = false;

  AudioPlayer audioPlayer = AudioPlayer();



  void play(mp3URL) async {
    if (!isPlay) {
      int result = await audioPlayer.play(mp3URL);
      if (result == 1) {
        setState(() {
          isLoading = false;
          isPlay = true;
        });
      }
    } else {
      int result = await audioPlayer.stop();
      if (result == 1) {
        setState(() {
          isLoading = false;
          isPlay = false;
        });
      }
    }
  }


  Future<void> pause() async {
//    await audioPlayer.pause();
//    setState(() => playerState = PlayerState.paused);
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlay = false;
      });
    }
  }

  void stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        isPlay = false;
      });
    }
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  String urlLocal= '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urlLocal = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Text('memuar') : InkWell(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        play(urlLocal);
      },
      child: IconButton(
          iconSize: 20.0,
          icon: isLoading ? Icon(Icons.pause,color: Colors.green) : Icon(Icons.play_circle_filled,color: Colors.green)

      ),
    );
  }
}


