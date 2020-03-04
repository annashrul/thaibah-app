import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/quran_read_ui.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class SuratHome extends StatefulWidget {
  SuratHome({Key key, @required this.idSurat,this.surat,this.ayat,this.suratAyat,this.terjemahan,this.kdReferral,this.suratNama}) : super(key: key);
  final String idSurat;
  final String surat;
  final String ayat;
  final String suratAyat;
  final String terjemahan;
  final String kdReferral;
  final String suratNama;
  @override
  _SuratHomeState createState() => _SuratHomeState();
}

class _SuratHomeState extends State<SuratHome> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(builder: (context) => QuranReadUI(
              total:'-',
              id: widget.surat,
              param: 'detail',
              param1:widget.suratNama,
            suratAyat: widget.suratAyat,
          )),
        );


      },
      child: Container(
        padding: EdgeInsets.only(left:11.0,right:11.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: Icon(Icons.bookmark,size: 40.0,color:Color(0xFF116240)),
                title: Text("Ayat untuk hari ini", style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 14,color:Colors.black)),
                subtitle: Text(removeAllHtmlTags(widget.suratAyat),style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 12,color:Colors.black))
              ),
              Container(
                padding: EdgeInsets.only(left:25.0,right:25.0),
                child: Divider(color: Colors.grey),
              ),

              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Html(
                        defaultTextStyle: TextStyle(fontFamily: 'Rubik',fontSize: 14,color:Colors.black,fontStyle: FontStyle.italic),
                          data: widget.terjemahan.replaceAll(r'\', r' '),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:25.0,right:25.0),
                child: Divider(color: Colors.grey),
              ),
              Container(
                padding: EdgeInsets.only(right:12.0),
                child: FlatButton(
                  child: Text("Bagikan",style:TextStyle(color:Color(0xFF116240),fontFamily: 'Rubik',fontSize: 14,fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await WcFlutterShare.share(
                      sharePopupTitle: 'Thaibah Share Ayah Hari Ini',
                      subject: 'Thaibah Share Ayah Hari Ini',
                      text: "THAIBAH SHARE AYAT HARI INI\n\n${widget.suratAyat}\n${widget.terjemahan.replaceAll(r'\', r' ')}\n\n\nKunjungi Link Berikut Untuk Bergabung https://thaibah.com/signup/${widget.kdReferral}",
                      mimeType: 'text/plain'
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            primary: false,
            physics: ScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return new GestureDetector(
                  onTap: (){

                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: new Column(
                      children: <Widget>[
                        new Stack(
                          children: <Widget>[
                            //new Center(child: new CircularProgressIndicator()),
                            new Center(
                              child: Container(
                                height: ScreenUtilQ.getInstance().setHeight(400),
//                                width:  _width / 1,
                                child: CachedNetworkImage(
                                  imageUrl: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                  ),
                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                    child: Row(children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.white),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: FlatButton(
                                                  child: Icon(Icons.share, color: Colors.black),
                                                  onPressed: () {

                                                  },
                                                )
                                            )
                                        ),
                                      ),
                                    ],),
                                  ),

                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              );
            },

          )
      ),
    );
  }
}


class SuratHomeLoading extends StatefulWidget {
  @override
  _SuratHomeLoadingState createState() => _SuratHomeLoadingState();
}

class _SuratHomeLoadingState extends State<SuratHomeLoading> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left:11.0,right:11.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                  leading: SkeletonFrame(width: 10.0, height: 16.0),
                  title: SkeletonFrame(width: 50.0, height: 16.0),
                  subtitle: SkeletonFrame(width: 60.0, height: 16.0),
              ),
              Divider(color: Colors.white),
              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: SkeletonFrame(width: 60.0, height: 16.0),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.white),
              Container(
                padding: EdgeInsets.only(right:12.0),
                child:ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: SkeletonFrame(width: 10.0, height: 16.0),
                        onPressed: () {  },
                      ),

                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

