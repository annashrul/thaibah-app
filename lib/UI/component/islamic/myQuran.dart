import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/islamic/checkedModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/resources/islamic/islamicProvider.dart';


enum PlayerState { stopped, playing, paused }

class MyQuran extends StatefulWidget {
  String param;
  MyQuran({this.param});
  @override
  _MyQuranState createState() => _MyQuranState();
}

class _MyQuranState extends State<MyQuran> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String title='';
  bool isLoading = false;
  bool isChecked = false;
  bool isNote = false;
  bool isFavorite = false;
  String param = '';
  Duration duration;
  Duration position;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  bool isPlay = false;
  bool isActive = false;
  bool isActiveCheck = false;
  AudioPlayer audioPlayer = AudioPlayer();
  int total = 0;

  void play(mp3URL) async {
    if (!isPlay) {
      int result = await audioPlayer.play(mp3URL);
      setState(() {
        isActive = false;
      });
      if (result == 1) {
        setState(() {

          isPlay = true;
        });
      }
    } else {
      int result = await audioPlayer.stop();
      if (result == 1) {
        setState(() {
          isPlay = false;
        });
      }
    }
  }


  Future<void> pause() async {
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



  Future actionPost(String id,String nama,param) async{
    var res = await IslamicProvider().fetchActionPost(id,param);
    if(res is General){
      General results = res;
      print(res.msg);
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
          checkFavBloc.fetchCheckFav(widget.param);
        });
//        if(isCheck != true){
//          return showInSnackBar("Surat $nama Berhasil Di $param",'sukses');
//        }else{
//          return showInSnackBar("Surat $nama Berhasil Di dibuang",'gagal');
//        }
      }else{
        setState(() {});
        return showInSnackBar("${results.msg}",'gagal');
      }
    }

  }

  var noteController = TextEditingController();

  final FocusNode noteFocus = FocusNode();

  Future Note(var id) async{
    print("##################################### ID AYAT = $id ##################################");
    var res = await IslamicProvider().fetchNote(id, noteController.text);
    if(res is General){
      noteController.text = '';
      General results = res;
      print(res.msg);
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
          checkFavBloc.fetchCheckFav(widget.param);
        });
        return showInSnackBar("note berhasil diubah",'sukses');
      }else{
        setState(() {});
        return showInSnackBar("${results.msg}",'gagal');
      }
    }
  }

  void showInSnackBar(String value,String param) {
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
      backgroundColor: param == 'sukses' ? Colors.green : Colors.red,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    param = widget.param;
    checkFavBloc.fetchCheckFav(param);
    if(param == 'checked'){
      title = 'Checked';
      isChecked = true;
    }else if(param == 'fav'){
      title = 'Favorite';
      isFavorite = true;
    }else{
      title = 'Note';
      isNote = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
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
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Daftar ${title}", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      body: StreamBuilder(
        stream:checkFavBloc.getResult,
        builder: (context, AsyncSnapshot<CheckFavModel> snapshot) {
          if (snapshot.hasData) {
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
                              Text("Total ${title} : ${snapshot.data.result.length}", style: TextStyle(color: Colors.black54),),
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
    );
  }

  Widget buildContent(AsyncSnapshot<CheckFavModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return isLoading? _loading() : ListView.builder(
        itemCount: snapshot.data.result.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              print("object");
            },
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
                            child: Text(snapshot.data.result[index].arabic, style: TextStyle(fontSize: 20, fontFamily: 'Rubik'),),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Html(
                          defaultTextStyle: TextStyle(fontFamily: 'Rubik',fontSize: 12,color:Colors.black),
                          data: snapshot.data.result[index].terjemahan.replaceAll(r'\', r' '),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:16.0,bottom:10.0, right:16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Html(
                          defaultTextStyle: TextStyle(fontFamily: 'Rubik',fontSize: 12,color:Colors.black),
                          data: snapshot.data.result[index].surahAyat.replaceAll(r'\', r' '),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        new IconButton(
                            onPressed: () async {
                              setState(() {
                                isActive = true;
                              });
                              play(snapshot.data.result[index].audio);
                            },
                            iconSize: 20.0,
                            icon: Icon(Icons.play_circle_filled,color: !isActive?Colors.black:Colors.green,)

                        ),
                        param == 'checked' ?IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              actionPost(snapshot.data.result[index].idAyat,snapshot.data.result[index].surahAyat,'checked');
                            },
                            iconSize: 20.0,
                            icon: Icon(Icons.check_circle,color: Colors.green)
                        ):Container(),
                        param == 'fav' ?new IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              actionPost(snapshot.data.result[index].idAyat,snapshot.data.result[index].surahAyat,'fav');
                            },
                            iconSize: 20.0,
                            icon: Icon(Icons.favorite,color: Colors.green)
                        ):Container(),

                        param == 'note' ? new IconButton(
                            onPressed: () async {
                              _lainnyaModalBottomSheet(context,snapshot.data.result[index].idAyat,snapshot.data.result[index].note);
                            },
                            iconSize: 20.0,
                            icon: Icon(Icons.edit,color: Colors.green)
                        ) : Container(),
//                          Text(snapshot.data.result[index].note.toString())
                      ]
                    )
                  ],
                ),
              ),
            ),

          );
        },
      );
    }else{
      return Container(
        child: Center(
          child: Text('Data Tidak Ada',style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
      );
    }
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


  void _lainnyaModalBottomSheet(context,id,String note){
    print(note);
    noteController.text = note;
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
                            controller:  noteController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            minLines: null,
                            focusNode: noteFocus,
                            onFieldSubmitted: (value){
                              if(noteController.text == ''){
                                return showInSnackBar("Form tidak boleh kosong",'gagal');
                              }else{
                                Navigator.pop(context);
                                setState(() {
                                  isLoading = true;
                                });
                                noteFocus.unfocus();
                                Note(id);
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

}
