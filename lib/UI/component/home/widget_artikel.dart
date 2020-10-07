import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/newsBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../news/detail_berita_ui.dart';


class ScreenArtikel extends StatefulWidget {
  final String noScaffold;
  ScreenArtikel({this.noScaffold});
  @override
  _ScreenArtikelState createState() => _ScreenArtikelState();
}

class _ScreenArtikelState extends State<ScreenArtikel> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int perpage=5;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  void load() {
    setState(() {
      perpage = perpage += 10;
    });
    newsBloc.fetchNewsList(1, perpage,'Pengumuman');
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    newsBloc.fetchNewsList(1, perpage,'artikel');
  }
  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsBloc.fetchNewsList(1, perpage,'artikel');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Artikel",(){Navigator.pop(context);},<Widget>[]),

      // appBar: UserRepository().appBarWithButton(context,'Artikel',ThaibahColour.primary1,ThaibahColour.primary2,(){
      //   Navigator.pop(context);
      // }, Container()),
      body: StreamBuilder(
          stream: newsBloc.allNews,
          builder: (context,AsyncSnapshot<NewsModel> snapshot){
            if(snapshot.hasData){
              return snapshot.data.result.data.length>0?LiquidPullToRefresh(
                color: ThaibahColour.primary2,
                backgroundColor:Colors.white,
                key: _refresh,
                onRefresh:refresh,
                child: Padding(
                  padding: EdgeInsets.only(left:5.0,right:5.0),
                  child: LoadMoreQ(
                    child: ListView.builder(
                        primary: true,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.result.data.length,
                        itemBuilder:(context,index){
                          return WidgetArtikel(
                            id: snapshot.data.result.data[index].id,
                            category: snapshot.data.result.data[index].category,
                            image:snapshot.data.result.data[index].picture ,
                            title:snapshot.data.result.data[index].title ,
                            desc:snapshot.data.result.data[index].caption ,
                            link: snapshot.data.result.data[index].link,
                          );
                        }
                    ),
                    whenEmptyLoad: true,
                    delegate: DefaultLoadMoreDelegate(),
                    textBuilder: DefaultLoadMoreTextBuilder.english,
                    isFinish: snapshot.data.result.data.length < perpage,
                    onLoadMore: _loadMore,
                  ),
                ),

              ):UserRepository().noData();
            }
            else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return LoadingArtikel();
          }
      ),
    );
  }
}



class WidgetArtikel extends StatefulWidget {
  final String id;
  final String category;
  final String image;
  final String title;
  final String desc;
  final String link;

  WidgetArtikel({this.id,this.category,this.image,this.title,this.desc,this.link});
  @override
  _WidgetArtikelState createState() => _WidgetArtikelState();
}

class _WidgetArtikelState extends State<WidgetArtikel> {

  @override
  Widget build(BuildContext context) {

    String title=widget.title,desc=widget.desc.replaceAll('&nbsp;','').replaceAll('&ndash;','-').replaceAll('<p>','').replaceAll("(?i)<td[<p^>]*>", "");
    if(desc.length>100){
      desc = "${desc.substring(0,100)} ...";
    }
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: new Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            new Hero(
              tag: 'tagImage${widget.id}',
              child:ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:  new Image.network(widget.image, fit: BoxFit.cover)
              ),
            ),
            new Align(
              child: new Container(
                // height: 100.0,
                padding: const EdgeInsets.all(6.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.green,Colors.green]),
                        // borderRadius: BorderRadius.only(),
                        borderRadius: BorderRadius.circular(10.0),

                        // borderRadius: BorderRadius.only(bottomRight:  Radius.circular(10),bottomLeft: Radius.circular(10)),
                      ),
                      child: UserRepository().textQ(widget.category,10,Colors.white,FontWeight.bold,TextAlign.center),
                    ),
                    SizedBox(height: 5.0),
                    // UserRepository().textQ(removeAllHtmlTags(title.replaceAll('\n','')),14,Colors.white,FontWeight.bold,TextAlign.left),
                    // UserRepository().textQ(removeAllHtmlTags(desc.replaceAll('\n','')),12,Colors.white,FontWeight.normal,TextAlign.left),

                    new Html(data:title, defaultTextStyle: new TextStyle(fontFamily: ThaibahFont().fontQ,color: Colors.white, fontWeight: FontWeight.bold, fontSize:14)),

                    Html(
                      data:desc,
                      defaultTextStyle: new TextStyle(color: Colors.white,fontFamily: ThaibahFont().fontQ, fontSize: 12.0) ,
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.only(bottomRight:  Radius.circular(10),bottomLeft: Radius.circular(10)),

                ),
                width: double.infinity,
              ),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(
            builder: (context) => DetailBeritaUI(
              id:widget.id,
              category: widget.category,
              link:widget.link
            )
          )
        );
      },
    );
  }
}

class LoadingArtikel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        primary: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 5,
      itemBuilder: (context,index){
        return Container(
          padding: EdgeInsets.all(10.0),
          child: SkeletonFrame(width:double.infinity,height: 100),
        );
      }
    );
  }
}
