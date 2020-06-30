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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  static String videoId;
  bool cek = false;
  Future convertUrlYoutube() async{
    setState(() {videoId = YoutubePlayer.convertUrlToId("${widget.video}");});
  }

  Future cekType() async{
    cek = widget.type=='inspirasi'?true:false;
  }

  final List<YoutubePlayerController> _controllers = ['$videoId',].map<YoutubePlayerController>(
    (videoId) => YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    ),
  ).toList();

  @override
  void initState() {
    super.initState();
    cekType();
    convertUrlYoutube();
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return YoutubePlayer(
                  key: ObjectKey(_controllers[index]),
                  controller: _controllers[index],
                  actionsPadding: EdgeInsets.only(left: 16.0),
                  bottomActions: [
                    CurrentPosition(),
                    SizedBox(width: 10.0),
                    ProgressBar(isExpanded: true),
                    SizedBox(width: 10.0),
                    RemainingDuration(),
                    FullScreenButton(),
                  ],
                );
              },
              itemCount: _controllers.length,
              separatorBuilder: (context, _) => SizedBox(height: 10.0),
            ),
          ),
          Expanded(
            flex: 7,
            child:  cek ? Container() : Container(
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
            ),
          )
        ],
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
