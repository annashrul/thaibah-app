import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';
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
  bool versi = false;
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
    super.initState();
    loadTheme();
    cekType();
    convertUrlYoutube();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:UserRepository().appBarWithButton(context,"Detail Testimoni Produk",warna1,warna2,(){Navigator.pop(context);},Container()),
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
                  Text("Deksripsi",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily:ThaibahFont().fontQ)),
                  Html(data: widget.caption,defaultTextStyle: TextStyle(color: Colors.black,fontFamily:ThaibahFont().fontQ),),
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
