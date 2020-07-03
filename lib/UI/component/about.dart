import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_at_runtime/sqlite_at_runtime.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/promosiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/detail_promosi_ui.dart';
import 'package:thaibah/bloc/promosiBloc.dart';
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
      perpage = perpage += 4;
    });
    promosiListBloc.fetchAllPromosiList(1,perpage);
    print(perpage);
    return true;
  }



  @override
  void initState() {
    loadTheme();
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
      appBar:  UserRepository().appBarNoButton(context,'Tentang Thaibah',warna1,warna2),
      body: StreamBuilder(
          stream: promosiListBloc.allPromosiList,
          builder: (context, AsyncSnapshot<PromosiModel> snapshot) {
            if(snapshot.hasData){
              return _buildContent(snapshot, context);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return _loading(context);
          }
      ),
    );
  }


  Widget _loading(BuildContext context,) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
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
                          height: ScreenUtilQ.getInstance().setHeight(450),
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

  Widget _buildContent(AsyncSnapshot<PromosiModel> snapshot, BuildContext context){
    return snapshot.data.result.data.length > 0?RefreshIndicator(
      child: LoadMoreQ(
        child: ListView.builder(
          itemCount: snapshot.data.result.data.length,
          itemBuilder: (BuildContext context, int index) {

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
                child: Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtilQ.getInstance().setHeight(400),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data.result.data[index].thumbnail,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
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
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.result.data[index].thumbnail),
                      ),
                      title: Text(
                        snapshot.data.result.data[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),
                      ),
                      subtitle: Text(snapshot.data.result.data[index].penulis+" . "+snapshot.data.result.data[index].createdAt,
                          style: TextStyle(
                            color: Colors.grey, fontFamily: ThaibahFont().fontQ
                          )),
                      trailing: _threeItemPopup(snapshot.data.result.data[index].link),
                    ),
                  ],
                ),
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
    ):Container(
    child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: ThaibahFont().fontQ),))
    );
  }

  Widget _threeItemPopup(var link) => PopupMenuButton(
    onSelected: (e) async{
      String url = '$link';
      if (await canLaunch(url)) {
        await launch(url);
      }else{
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            content: Text('Link Download Tidak Tersedia',style: TextStyle(color:Colors.white,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
          )
        );
      }
    },
    itemBuilder: (context) {
      var list = List<PopupMenuEntry<Object>>();
      list.add(
        CheckedPopupMenuItem(
          child: Text(
            "Download",
            style: TextStyle(color: Colors.black,fontFamily: ThaibahFont().fontQ),
          ),
          value: 1,
        ),
      );
      return list;
    },
    icon: Icon(
      Icons.more_vert,
      size: 20,
      color: Colors.black,
    ),
  );

}


