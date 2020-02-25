
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/detail_berita_ui.dart';
import 'package:thaibah/bloc/newsBloc.dart';


class NewsHome extends StatefulWidget {
  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsBloc.fetchNewsList(1,4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: newsBloc.allNews,
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))))
        );
      },
    );
  }

  Widget buildContent(AsyncSnapshot<NewsModel> snapshot, BuildContext context){
    var width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      height: ScreenUtil.getInstance().setHeight(750),
      width:  width / 1,
//      margin: EdgeInsets.only(bottom: 5, top: 10),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.result.data.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            var cap = ""; var tit = "";
            if(snapshot.data.result.data[i].title.length > 40){
              tit = snapshot.data.result.data[i].title.substring(0,40)+" ...";
            }else{
              tit = snapshot.data.result.data[i].title;
            }
            if(snapshot.data.result.data[i].caption.length > 70){
              cap = snapshot.data.result.data[i].caption.substring(0,70)+" ...";
            }else{
              cap = snapshot.data.result.data[i].caption;
            }
            return new FlatButton(
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Row(
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(left:10.0,right:5.0),
                                width: 70.0,
                                height: 70.0,
                                child: Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data.result.data[i].thumbnail,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                      ),
                                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.circular(10.0),
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                          boxShadow: [new BoxShadow(color:mainColor,blurRadius: 5.0,offset: new Offset(2.0, 5.0))],
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                            )
                          ],

                        ),
                      ),
                      new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 16.0, 0.0),
                            child: new Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2.0),
                                  child: new Text(
                                    tit,
                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: Colors.black),
                                  ),
                                ),

                                new Padding(padding: const EdgeInsets.all(0.0)),
                                Html(data:cap),
                                Text(snapshot.data.result.data[i].createdAt,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',),)
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )),
                    ],
                  ),

                  SizedBox(height: 10.0,child: Container(color: Color(0xFFf5f5f5))),
                ],
              ),
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBeritaUI(id: snapshot.data.result.data[i].id, category: snapshot.data.result.data[i].category)
                  ),
                );
              },
//              color: Colors.white,
            );
          }),
    );
  }
}

