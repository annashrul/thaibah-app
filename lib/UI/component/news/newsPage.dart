import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:loadmore/loadmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/Widgets/theme.dart' as AppTheme;
import 'package:thaibah/UI/detailNewsPerCategory.dart';
import 'package:thaibah/UI/detail_berita_ui.dart';
import 'package:thaibah/bloc/categoryBloc.dart';
import 'package:thaibah/bloc/newsBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Color mainColor = const Color(0xff3C3261);
  int perpage = 10;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    newsBloc.fetchNewsList(1, perpage);
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
    super.initState();
    newsBloc.fetchNewsList(1,perpage);

  }
  @override
  void dispose() {
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
                            icon: Icon(Icons.keyboard_backspace,color: Colors.black),
                            onPressed: (){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
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
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: new Text(
                    'Berita Terkini',
                    style: new TextStyle(fontSize: 20.0,color: mainColor,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                    textAlign: TextAlign.left,
                  ),
                ),
                new Expanded(
                  child: StreamBuilder(
                    stream: newsBloc.allNews,
                    builder: (context, AsyncSnapshot<NewsModel> snapshot) {
                      if (snapshot.hasData) {
                        return buildContent(snapshot, context);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return new ListView.builder(
                          itemCount: 10,
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

  Widget buildContent(AsyncSnapshot<NewsModel> snapshot, BuildContext context){
    if(snapshot.data.result.data.length > 0){
      return RefreshIndicator(
        child: LoadMore(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailBeritaUI(id: snapshot.data.result.data[i].id, category: snapshot.data.result.data[i].category)
                      ),
                    );
                  },
//              color: Colors.white,
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
        child: Center(
          child: Text('Data Tidak Tersedia'),
        ),
      );
    }
  }
}

class BeritaTerkini extends StatefulWidget {
  @override
  _BeritaTerkiniState createState() => _BeritaTerkiniState();
}

class _BeritaTerkiniState extends State<BeritaTerkini> {
  Color mainColor = const Color(0xff3C3261);
  final _bloc = NewsBloc();
  int perpage = 10;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += perpage;
    });
    _bloc.fetchNewsList(1, perpage);
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
    super.initState();
    _bloc.fetchNewsList(1, perpage);
  }
  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.allNews,
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(child:Center(child:CircularProgressIndicator()));
      },
    );
  }

  Widget buildContent(AsyncSnapshot<NewsModel> snapshot, BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/2.6,
      child: LoadMore(
        child: ListView.builder(
            primary: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.result.data.length,
            itemBuilder: (context,index){
              var caption = "";
              var title = "";
              if(snapshot.data.result.data[index].caption.length > 50){
                caption = snapshot.data.result.data[index].caption.substring(0,50)+' ...';
              }else{
                caption = snapshot.data.result.data[index].caption;
              }
              if(snapshot.data.result.data[index].title.length > 50){
                title = snapshot.data.result.data[index].title.substring(0,50)+' ...';
              }else{
                title = snapshot.data.result.data[index].title;
              }
              return Container(
                padding: EdgeInsets.only(bottom: 10.0,left:15.0,right:15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Html(
                                      data:title, defaultTextStyle:TextStyle(fontSize:12.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Html(
                                      data:caption, defaultTextStyle:TextStyle(fontSize:10.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 3.0),
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.result.data[index].picture,
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
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.person_pin_circle,color: Colors.grey,size: 17.0),
                                  Text(snapshot.data.result.data[index].penulis,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.favorite_border,color: Colors.grey,size: 17.0),
                                  Text("20",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.access_time,color: Colors.grey,size: 17.0),
                                  Text(snapshot.data.result.data[index].createdAt,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                ),
              );
            }
        ),
        isFinish: snapshot.data.result.data.length < perpage,
        onLoadMore: _loadMore,
        whenEmptyLoad: true,
        delegate: DefaultLoadMoreDelegate(),
        textBuilder: DefaultLoadMoreTextBuilder.english,
      ),
    );
  }
  Widget _loading(){
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 2,
        itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.only(bottom: 28.0,left:15.0,right:15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: SkeletonFrame(width: 50,height:15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0.0),
                      child: Stack(
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.only(top: 3.0),
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(ApiService().assetsLocal+'bg.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: SkeletonFrame(width: 50,height:15),
                      ),
                    ),

                  ],
                )
              ],
            ),
          );
        }
    );
  }

}

//
//class SectionHome extends StatefulWidget {
//  @override
//  _SectionHomeState createState() => _SectionHomeState();
//}
//
//class _SectionHomeState extends State<SectionHome> {
//  Info info;
//  final userRepository = UserRepository();
//  bool isLoading = false;
//  Future<void> loadData() async{
//    String id = await userRepository.getID();
//    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
//    if (jsonString.statusCode == 200) {
//      final jsonResponse = json.decode(jsonString.body);
//      info = new Info.fromJson(jsonResponse);
//      setState(() {
//        isLoading = false;
//      });
//    } else {
//      throw Exception('Failed to load info');
//    }
//  }
//  int perpage = 10;
//
//  void load() {
//    print("load $perpage");
//    setState(() {
//      info.result.section.length+perpage;
//    });
//  }
//  Future<void> _refresh() async {
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    load();
//  }
//  Future<bool> _loadMore() async {
//    print("onLoadMore");
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    load();
//    return true;
//  }
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    loadData();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return isLoading?CircularProgressIndicator():Container(
////      height: MediaQuery.of(context).size.height/2.6,
//      child: LoadMore(
//        child: ListView.builder(
//            primary: true,
//            shrinkWrap: true,
//            physics: const NeverScrollableScrollPhysics(),
//            scrollDirection: Axis.vertical,
//            itemCount: info.result.section.length,
//            itemBuilder: (context,index){
//              var berita = info.result.section[index].berita;
//              var feed = info.result.section[index].feed;
//              print("############################# BERITA = ${berita.length} #########################");
//              print("############################# BERITA = ${feed.length} #########################");
//              return Column(
//                children: <Widget>[
//                  ListView.builder(
//                      primary: true,
//                      shrinkWrap: true,
//                      physics: const NeverScrollableScrollPhysics(),
//                      scrollDirection: Axis.vertical,
//                      itemCount: info.result.section[index].berita.length,
//                      itemBuilder: (context,index){
//                        var caption = "";
//                        var title = "";
//                        if(berita[index].caption.length > 50){
//                          caption = berita[index].caption.substring(0,50)+' ...';
//                        }else{
//                          caption = berita[index].caption;
//                        }
//                        if(berita[index].title.length > 50){
//                          title = berita[index].title.substring(0,50)+' ...';
//                        }else{
//                          title = berita[index].title;
//                        }
//                        return Container(
//                          padding: EdgeInsets.only(bottom: 10.0,left:15.0,right:15.0),
//                          child: Column(
//                            children: <Widget>[
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                children: <Widget>[
//                                  Container(
//                                    child: Flexible(
//                                      child: Column(
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Align(
//                                            alignment: Alignment.centerLeft,
//                                            child: Container(
//                                              child: Html(
//                                                data:title, defaultTextStyle:TextStyle(fontSize:12.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
//                                              ),
//                                            ),
//                                          ),
//                                          Align(
//                                            alignment: Alignment.centerLeft,
//                                            child: Container(
//                                              child: Html(
//                                                data:caption, defaultTextStyle:TextStyle(fontSize:10.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(left: 0.0),
//                                    child: Stack(
//                                      children: <Widget>[
//                                        Container(
//                                          margin: EdgeInsets.only(top: 3.0),
//                                          height: 70.0,
//                                          width: 70.0,
//                                          decoration: BoxDecoration(
//                                            borderRadius: BorderRadius.circular(12.0),
//                                          ),
//                                          child: CachedNetworkImage(
//                                            imageUrl: berita[index].picture,
//                                            placeholder: (context, url) => Center(
//                                              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                                            ),
//                                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
//                                            imageBuilder: (context, imageProvider) => Container(
//                                              decoration: BoxDecoration(
//                                                borderRadius: new BorderRadius.circular(10.0),
//                                                color: Colors.grey,
//                                                image: DecorationImage(
//                                                  image: imageProvider,
//                                                  fit: BoxFit.fill,
//                                                ),
//                                                boxShadow: [new BoxShadow(color:Color(0xff3C3261),blurRadius: 5.0,offset: new Offset(2.0, 5.0))],
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//
//                                      ],
//                                    ),
//                                  ),
//
//                                ],
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(Icons.person_pin_circle,color: Colors.grey,size: 17.0),
//                                            Text(berita[index].penulis,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
//                                          ],
//                                        )
//                                    ),
//                                  ),
//                                  SizedBox(width: 10.0),
//                                  Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(Icons.favorite_border,color: Colors.grey,size: 17.0),
//                                            Text("20",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
//                                          ],
//                                        )
//                                    ),
//                                  ),
//                                  SizedBox(width: 10.0),
//                                  Align(
//                                    alignment: Alignment.centerRight,
//                                    child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(Icons.access_time,color: Colors.grey,size: 17.0),
//                                            Text("${berita[index].createdAt}",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
//                                          ],
//                                        )
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Divider()
//                            ],
//                          ),
//                        );
//                      }
//                  ),
//                  ListView.builder(
//                      primary: true,
//                      shrinkWrap: true,
//                      physics: const NeverScrollableScrollPhysics(),
//                      scrollDirection: Axis.vertical,
//                      itemCount: info.result.section[index].feed.length,
//                      itemBuilder: (context,i){
//                        var caption = "";
//                        var title = "";
////                        print(info.result.section[index].feed[i].title)
//                        caption = info.result.section[index].feed[i].caption;
//                        title = 'title';
//                        print(feed.length);
//                        return Container(
//                          padding: EdgeInsets.only(bottom: 10.0,left:15.0,right:15.0),
//                          child: Column(
//                            children: <Widget>[
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                children: <Widget>[
//                                  Container(
//                                    child: Flexible(
//                                      child: Column(
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Align(
//                                            alignment: Alignment.centerLeft,
//                                            child: Container(
//                                              child: Html(
//                                                data:title, defaultTextStyle:TextStyle(fontSize:12.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
//                                              ),
//                                            ),
//                                          ),
//                                          Align(
//                                            alignment: Alignment.centerLeft,
//                                            child: Container(
//                                              child: Html(
//                                                data:caption, defaultTextStyle:TextStyle(fontSize:10.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(left: 0.0),
//                                    child: Stack(
//                                      children: <Widget>[
//                                        Container(
//                                          margin: EdgeInsets.only(top: 3.0),
//                                          height: 70.0,
//                                          width: 70.0,
//                                          decoration: BoxDecoration(
//                                            borderRadius: BorderRadius.circular(12.0),
//                                          ),
//                                          child: CachedNetworkImage(
//                                            imageUrl: feed[i].picture,
//                                            placeholder: (context, url) => Center(
//                                              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                                            ),
//                                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
//                                            imageBuilder: (context, imageProvider) => Container(
//                                              decoration: BoxDecoration(
//                                                borderRadius: new BorderRadius.circular(10.0),
//                                                color: Colors.grey,
//                                                image: DecorationImage(
//                                                  image: imageProvider,
//                                                  fit: BoxFit.fill,
//                                                ),
//                                                boxShadow: [new BoxShadow(color:Color(0xff3C3261),blurRadius: 5.0,offset: new Offset(2.0, 5.0))],
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//
//                                      ],
//                                    ),
//                                  ),
//
//                                ],
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(Icons.person_pin_circle,color: Colors.grey,size: 17.0),
//                                            Text(berita[i].penulis,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
//                                          ],
//                                        )
//                                    ),
//                                  ),
//                                  SizedBox(width: 10.0),
//                                  Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(Icons.favorite_border,color: Colors.grey,size: 17.0),
//                                            Text(feed[i].comments,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
//                                          ],
//                                        )
//                                    ),
//                                  ),
//                                  SizedBox(width: 10.0),
//                                  Align(
//                                    alignment: Alignment.centerRight,
//                                    child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(Icons.access_time,color: Colors.grey,size: 17.0),
//                                            Text("${feed[i].createdAt}",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
//                                          ],
//                                        )
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Divider()
//                            ],
//                          ),
//                        );
//                      }
//                  )
//                ],
//              );
//            }
//        ),
//        isFinish: info.result.section.length < perpage,
//        onLoadMore: _loadMore,
//        whenEmptyLoad: true,
//        delegate: DefaultLoadMoreDelegate(),
//        textBuilder: DefaultLoadMoreTextBuilder.english,
//      ),
//    );
//  }
//}
//
