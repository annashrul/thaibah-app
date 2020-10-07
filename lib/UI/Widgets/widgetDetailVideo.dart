import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'SCREENUTIL/ScreenUtilQ.dart';

class WidgetDetailVideo extends StatefulWidget {
  String video,param,caption,rating,type;
  WidgetDetailVideo({this.video,this.param,this.caption,this.rating,this.type});
  @override
  _WidgetDetailVideoState createState() => _WidgetDetailVideoState();
}

class _WidgetDetailVideoState extends State<WidgetDetailVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool cek = false;
  Future cekType() async{
    cek = widget.type=='inspirasi'?true:false;
  }
  YoutubePlayerController _controller1;
  final userRepository = UserRepository();
  @override
  void initState() {
    super.initState();
    cekType();
    _controller1 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.video),
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
  }

  Future share(param) async{
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    await WcFlutterShare.share(
        sharePopupTitle: 'Share Tentang Thaibah',
        subject: 'Share Tentang Thaibah',
        text: "$param",
        mimeType: 'text/plain'
    );

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Detail ${widget.param}",(){Navigator.pop(context);},<Widget>[]),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: YoutubePlayer(controller: _controller1),
          ),
          Expanded(
            flex: 7,
            child:  cek ? Container() : Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Html(data: widget.caption,defaultTextStyle: TextStyle(color: Colors.black,fontFamily:ThaibahFont().fontQ),),
                  Divider(),
                  generateStart(int.parse(widget.rating)),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar:_bottomNavBarBeli(context),
    );
  }
  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        height: kBottomNavigationBarHeight,
        child: UserRepository().buttonQ(context, ()async{
          UserRepository().loadingQ(context);
          await share(widget.video);
        },"Bagikan video ini"),
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
