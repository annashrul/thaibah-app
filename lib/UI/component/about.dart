
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loadmore/loadmore.dart';
import 'package:thaibah/Model/promosiModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/detail_promosi_ui.dart';
import 'package:thaibah/bloc/promosiBloc.dart';

class About extends StatefulWidget {
//  About({Key key}) : super(key: key);
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About>{
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  double _height;
  double _width;

  int perpage = 4;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 4;
    });
    promosiListBloc.fetchAllPromosiList(1,perpage);
    print(perpage);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    promosiListBloc.fetchAllPromosiList(1,perpage);
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    print("load $perpage");
    setState(() {
      perpage = perpage += 4;
    });
    promosiListBloc.fetchAllPromosiList(1,perpage);
    print(perpage);
    return true;
  }

  @override
  void initState() {
    promosiListBloc.fetchAllPromosiList(1,perpage);
    super.initState();
  }
//
  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(

        centerTitle: false,
        elevation: 0.0,
        title: Text('Tentang Thaibah',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      body: StreamBuilder(
          stream: promosiListBloc.allPromosiList,
          builder: (context, AsyncSnapshot<PromosiModel> snapshot) {
            if(snapshot.hasData){
              return buildContent(snapshot, context);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return _loading(context);
          }
      ),
    );
  }


  Widget buildContent(AsyncSnapshot<PromosiModel> snapshot, BuildContext context,) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    if(snapshot.data.result.data.length > 0){
      return RefreshIndicator(
        child: LoadMore(
           child:  ListView.builder(
             itemCount: snapshot.data.result.data.length,
             itemBuilder: (context, index) {
              return InkWell(
                onTap: ()=>{
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => DetailPromosiUI(
                        id:snapshot.data.result.data[index].id,
                        title: snapshot.data.result.data[index].title,
                        picture: snapshot.data.result.data[index].picture,
                        caption: snapshot.data.result.data[index].caption,
                        penulis: snapshot.data.result.data[index].penulis,
                        createdAt: snapshot.data.result.data[index].createdAt,
                        link:snapshot.data.result.data[index].link
                    )),
                  )
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: new Column(
                      children: <Widget>[
                        new Stack(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil.getInstance().setHeight(450),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data.result.data[index].thumbnail,
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
                            Container(
                              color:Colors.black.withOpacity(0.5),
                              height:ScreenUtil.getInstance().setHeight(450),
                              margin: EdgeInsets.only(top:0.0,bottom:0.0),
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top:100.0,bottom:0.0),
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    snapshot.data.result.data[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(color: Colors.white,fontSize:16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  )
                ),
              );
            },
           ),
          onLoadMore: _loadMore,
          whenEmptyLoad: true,
          delegate: DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
          isFinish: snapshot.data.result.data.length < perpage,
        ),
        onRefresh: _refresh
      );
    }else{
      return Container(
        child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
      );
    }
  }

  Widget _loading(BuildContext context,) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return InkWell(
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                child: new Column(
                  children: <Widget>[
                    new Stack(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil.getInstance().setHeight(450),
                          child: SkeletonFrame(width: double.infinity,height: 200),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
        );
      },
    );
  }
}
