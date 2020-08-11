import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_at_runtime/sqlite_at_runtime.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/promosiModel.dart';
import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/detail_promosi_ui.dart';
import 'package:thaibah/bloc/promosiBloc.dart';
import 'package:thaibah/bloc/testiBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
//  About({Key key}) : super(key: key);
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  double _height;
  double _width;
  int perpage = 10;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  Color warna1;
  Color warna2;
  String statusLevel ='0';
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
  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    promosiListBloc.fetchAllPromosiList(1,perpage);
    print(perpage);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      isLoading=false;
    });
    promosiListBloc.fetchAllPromosiList(1,perpage);
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    promosiListBloc.fetchAllPromosiList(1,perpage);
    print(perpage);
    return true;
  }



  @override
  void initState() {
    loadTheme();
    testiBloc.fetchTesti('0',1,100);
//    promosiListBloc.fetchAllPromosiList(1,perpage);
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
      appBar:  UserRepository().appBarNoButton(context,'Tentang Thaibah',warna1,warna2),
      body: StreamBuilder(
          stream: testiBloc.getResult,
          builder: (context, AsyncSnapshot<TestimoniModel> snapshot) {
            if(snapshot.hasData){
              return _content(snapshot, context);
//              return _buildContent(snapshot, context);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator(strokeWidth: 10,valueColor: new AlwaysStoppedAnimation<Color>(statusLevel!='0'?warna1:ThaibahColour.primary1)),);
          }
      ),
    );
  }

  Widget _content(AsyncSnapshot<TestimoniModel> snapshot, BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator(strokeWidth: 10,valueColor: new AlwaysStoppedAnimation<Color>(statusLevel!='0'?warna1:ThaibahColour.primary1)),):RefreshIndicator(
      child: StaggeredGridView.countBuilder(
        physics: new BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: snapshot.data.result.data.length,
        itemBuilder: (BuildContext context, int index){
          String cap = '';
          if(snapshot.data.result.data[index].caption.length > 20){
            cap = '${snapshot.data.result.data[index].caption.substring(0,20)} ...';
          }else{
            cap = snapshot.data.result.data[index].caption;
          }
          return InkWell(

            child: new Card(
              elevation: 2.0,
              margin: const EdgeInsets.all(5.0),
              child: new Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  new Hero(
                    tag: 'tagImage$index',
                    child: new Image.network(snapshot.data.result.data[index].thumbnail, fit: BoxFit.cover),
                  ),
                  new Align(
                    child: new Container(
                      padding: const EdgeInsets.all(6.0),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(snapshot.data.result.data[index].name, style: new TextStyle(fontFamily: ThaibahFont().fontQ,color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                          Html(
                            data: cap,
                            defaultTextStyle: new TextStyle(color: Colors.white,fontFamily: ThaibahFont().fontQ, fontSize: 12.0) ,
                          )
                        ],
                      ),
                      color: Colors.black.withOpacity(0.4),
                      width: double.infinity,
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
            onTap: (){
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => DetailPromosiUI(
                    id:snapshot.data.result.data[index].id,
                    title: snapshot.data.result.data[index].name,
                    picture: snapshot.data.result.data[index].thumbnail,
                    caption: snapshot.data.result.data[index].caption,
                    penulis: snapshot.data.result.data[index].name,
                    createdAt: snapshot.data.result.data[index].createdAt.toString(),
                    link:snapshot.data.result.data[index].rating.toString()
                )),
              );
            },
          );
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      onRefresh: _refresh
    );
  }

}


