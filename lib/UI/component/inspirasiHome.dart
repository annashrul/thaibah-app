
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaibah/UI/component/detailInspirasi.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:http/http.dart' show Client,Response;


class InspirasiHome extends StatefulWidget {
  final String imgInspiration, kdReferral,thumbnail;
  InspirasiHome({this.imgInspiration,this.kdReferral,this.thumbnail});
  @override
  _InspirasiHomeState createState() => _InspirasiHomeState();
}

class _InspirasiHomeState extends State<InspirasiHome> {
  final userRepository = UserRepository();


  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  double _height;
  double _width;

  Future<Null> shareInspirasi() async{
    var response = await Client().get(widget.imgInspiration);
    final bytes = response.bodyBytes;
    await WcFlutterShare.share(
        sharePopupTitle: 'Thaibah Share Inspirasi & Informasi',
        subject: 'Thaibah Share Inspirasi & Informasi',
        text: 'Thaibah Share Inspirasi & Informasi\n\n\nKunjungi Link Berikut Untuk Bergabung https://thaibah.com/signup/${widget.kdReferral}',
        fileName: 'share.png',
        mimeType: 'image/png',
        bytesOfFile:bytes
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;

  }

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }



  Widget buildContent(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      padding: EdgeInsets.only(left:12.0,right:12.0),
      child:  Column(
        children: <Widget>[
          InkWell(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(top:0.0,bottom:0.0),
              alignment: Alignment.bottomLeft,
              height: ScreenUtil.getInstance().setHeight(500),
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: NetworkImage(widget.thumbnail),
//                  fit: BoxFit.cover,
//                ),
//                borderRadius: BorderRadius.circular(12),
//              ),
//              child: Container(),
              child: CachedNetworkImage(
                  imageUrl: widget.thumbnail,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
//                      borderRadius: new BorderRadius.circular(12.0),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
              )
            ),
            onTap: (){
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Inspirasi & Informasi',video: widget.imgInspiration,caption: '',rating: '0',type: 'inspirasi',)),
              );
            },
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(0.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Color(0xFF116240),Color(0xFF30cc23)],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width/2,
                    height: ScreenUtil.getInstance().setHeight(100),
                    child: InkWell(
                      onTap: () async {
                        await WcFlutterShare.share(
                            sharePopupTitle: 'Thaibah Share Inspirasi & Informasi',
                            subject: 'Thaibah Share Inspirasi & Informasi',
                            text: 'Thaibah Share Inspirasi & Informasi \n ${widget.imgInspiration} \n\n\nKunjungi Link Berikut Untuk Bergabung https://thaibah.com/signup/${widget.kdReferral}',
                            mimeType: 'text/plain'
                        );
                      },
                      child: Center(
                        child: Text("BAGIKAN",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Color(0xFF30cc23),Color(0xFF116240)],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width/2,
                    height: ScreenUtil.getInstance().setHeight(100),
//                      color:Color(0xFF116240),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Inspirasi & Informasi',video: widget.imgInspiration,caption: '',rating: '0',type: 'inspirasi',)),
                        );
                      },
                      child: Center(
                        child: Text("PUTAR VIDEO",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                )
              )
            ],
          )
        ],
      ),
    );
  }
}
