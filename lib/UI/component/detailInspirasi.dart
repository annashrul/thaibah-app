import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailInspirasi extends StatefulWidget {
  String video,param,caption,rating,type;
  DetailInspirasi({this.video,this.param,this.caption,this.rating,this.type});
  @override
  _DetailInspirasiState createState() => _DetailInspirasiState();
}

class _DetailInspirasiState extends State<DetailInspirasi> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  static String urlVideo = '';
  List<String> playlist = [];
  final List<String> _ids = [];
  String videoId;
  Future arr() async{
    _ids.add(widget.video);
    videoId = YoutubePlayer.convertUrlToId(widget.video);
    print(videoId); // BBAyRBTfsOU
  }
  bool cek = false;
  Future cekType() async{
    if(widget.type == 'inspirasi'){
      setState(() {
        cek = true;
      });
    }else{
      setState(() {
        cek = false;
      });
    }
    print(cek);
    print(widget.type);
  }
  int currentPos;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  int count = 0;



  @override
  void initState() {
    super.initState();
    cekType();
    arr();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHideAnnotation: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:  AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text('Detail ${widget.param}',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      body: Container(
        child: Center(
          child: ListView(
            children: [
              YoutubePlayer(
                aspectRatio: 16 / 9,
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Color(0xFF116240),
                topActions: <Widget>[
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _controller.metadata.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),

                ],
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (id) {
                  _controller.load(_ids[count++]);

                },
              ),
              cek ? Container() : Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Deksripsi",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Rubik')),
                    Html(data: widget.caption,defaultTextStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik'),),
                    Divider(),
                    generateStart(int.parse(widget.rating)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget generateStart(int rating){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          if(index < rating){
            return Icon(Icons.star,color: Colors.amberAccent,size: 20);
          }else{
            return Icon(Icons.star_border);
          }
        }),
      ),
    );
  }

}
