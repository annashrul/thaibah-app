import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:thaibah/Model/detailNewsPerCategoryModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/detail_berita_ui.dart';
import 'package:thaibah/bloc/newsBloc.dart';
import 'package:thaibah/UI/Widgets/theme.dart' as AppTheme;
import 'package:thaibah/config/api.dart';

import 'Widgets/loadMoreQ.dart';
import 'Widgets/pin_screen.dart';

class DetailNewsPerCategory extends StatefulWidget {
  DetailNewsPerCategory({this.title,Key key})  : super(key: key);
  final String title;
  @override
  _DetailNewsPerCategoryState createState() => _DetailNewsPerCategoryState();
}

class _DetailNewsPerCategoryState extends State<DetailNewsPerCategory> with WidgetsBindingObserver  {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var localTitle;
  int perpage = 10;
  @override
  Color mainColor = const Color(0xff3C3261);



  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    newsDetailPerCategory.fetchDetailNewsPerCategory(1, perpage,localTitle);
    print(perpage);
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    localTitle = widget.title;
    super.initState();
//    load();
    newsDetailPerCategory.fetchDetailNewsPerCategory(1,perpage,localTitle);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                floating: true,
                elevation: 0,
                snap: true,
                backgroundColor: AppTheme.Colors.white,
                brightness: Brightness.light,
                actions: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: Icon(SimpleLineIcons.getIconData("arrow-left")),
                            color: AppTheme.Colors.black,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                new CupertinoPageRoute(builder: (context) => DashboardThreePage()),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ToggleButton(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ];
          },
          body: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: new Text(
                    localTitle,
                    style: new TextStyle(fontSize: 20.0,color: mainColor,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                    textAlign: TextAlign.left,
                  ),
                ),
                new Expanded(
                  child: StreamBuilder(
                    stream: newsDetailPerCategory.allDetailNewsPerCategory,
                    builder: (context, AsyncSnapshot<DetailNewsPerCategoryModel> snapshot) {
                      if (snapshot.hasData) {
                        return itemContent(snapshot, context);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return new ListView.builder(
                          itemCount: 6,
                          itemBuilder: (context, i) {
                            return new FlatButton(
                              child: Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: new Container(
                                          margin: const EdgeInsets.all(16.0),
                                          child: new Container(width: 70.0,height: 70.0),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            color: Colors.grey,
                                            image: new DecorationImage(
                                                image: new NetworkImage("http://lequytong.com/Content/Images/no-image-02.png"),
                                                fit: BoxFit.cover
                                            ),
                                            boxShadow: [
                                              new BoxShadow(
                                                  color: mainColor,
                                                  blurRadius: 5.0,
                                                  offset: new Offset(2.0, 5.0)
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      new Expanded(
                                          child: new Container(
                                            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                            child: new Column(children: [
                                              SkeletonFrame(width: 300,height: 15),
                                              new Padding(padding: const EdgeInsets.all(2.0)),
                                              SkeletonFrame(width: 300,height: 50),
                                              new Padding(padding: const EdgeInsets.all(2.0)),
                                              SkeletonFrame(width: 300,height: 15),
                                            ],
                                              crossAxisAlignment: CrossAxisAlignment.start,),
                                          )
                                      ),
                                    ],
                                  ),
                                  new Container(
                                    width: 300.0,
                                    height: 0.5,
                                    color: const Color(0xD2D2E1ff),
                                    margin: const EdgeInsets.all(16.0),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(0.0),
                              color: Colors.white,
                            );
                          }
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )

    );
  }



  Widget itemContent(AsyncSnapshot<DetailNewsPerCategoryModel> snapshot, BuildContext context){
    if(snapshot.data.result.data.length > 0){
      return RefreshIndicator(
        child: LoadMoreQ(
          isFinish: snapshot.data.result.data.length < perpage,
          child: ListView.builder(
              itemCount: snapshot.data.result.data.length,
              itemBuilder: (context, i) {
                var caption = "";
                var title = "";
                if(snapshot.data.result.data[i].caption.length > 50){
                  caption = snapshot.data.result.data[i].caption.substring(0,50)+' ...';
                }else{
                  caption = snapshot.data.result.data[i].caption;
                }
                if(snapshot.data.result.data[i].title.length > 50){
                  title = snapshot.data.result.data[i].title.substring(0,50)+' ...';
                }else{
                  title = snapshot.data.result.data[i].title;
                }
                return new FlatButton(
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(15.0),
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
                                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 16.0, 10.0),
                                child: new Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: new Text(
                                        title,
                                        style: new TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: Colors.black),
                                      ),
                                    ),

                                    new Padding(padding: const EdgeInsets.all(0.0)),
                                    Html(data:caption),
                                    Text(snapshot.data.result.data[i].createdAt,style: TextStyle(fontSize: 12,fontFamily: 'Rubik',),)
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              )),
                        ],
                      ),

                      SizedBox(height: 2.0,child: Container(color: Color(0xFFf5f5f5))),
                    ],
                  ),
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => DetailBeritaUI(id: snapshot.data.result.data[i].id, category: snapshot.data.result.data[i].category)),
                    );

                  },
                );
              }
          ),
          onLoadMore: _loadMore,
          whenEmptyLoad: true,
          delegate: DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
        ),
        onRefresh: _refresh
      );
    }
    else{
      return Container(
          child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
      );
    }


  }


}
