import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailInspirasi extends StatefulWidget {
  String video,param,caption,rating,type;
  DetailInspirasi({this.video,this.param,this.caption,this.rating,this.type});
  @override
  _DetailInspirasiState createState() => _DetailInspirasiState();
}

class _DetailInspirasiState extends State<DetailInspirasi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool cek = false;
  static String videoId;
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
    isLoadingShare=false;
    loadTheme();
    cekType();
    convertUrlYoutube();
  }
  bool isLoadingShare=true;
  Future share(param) async{
    setState(() {
      isLoadingShare = true;
    });

    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
      await WcFlutterShare.share(
          sharePopupTitle: 'Share Tentang Thaibah',
          subject: 'Share Tentang Thaibah',
          text: "$param",
          mimeType: 'text/plain'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:UserRepository().appBarWithButton(context,"Detail ${widget.param}",warna1,warna2,(){Navigator.pop(context);},Container()),
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
      bottomNavigationBar:  widget.param!='Tentang Thaibah'?Text(''):InkWell(
        onTap: () async {
          setState(() {
            isLoadingShare = true;
          });
          await share(widget.video);
        },
        child: Container(
          width: ScreenUtilQ.getInstance().setWidth(710),
          height: ScreenUtilQ.getInstance().setHeight(100),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
              borderRadius: BorderRadius.circular(0.0),
              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              isLoadingShare?CircularProgressIndicator(strokeWidth:10, valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)):Text("BAGIKAN", style: TextStyle(fontFamily: ThaibahFont().fontQ,fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
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
