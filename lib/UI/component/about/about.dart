import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/widgetDetailVideo.dart';
import 'package:thaibah/bloc/testiBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  int perpage = 10;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;

  String tipe='2';

  void load() {
    setState(() {
      perpage = perpage += 10;
    });
    testiBloc.fetchTesti(tipe,1,perpage);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    setState(() {
      isLoading=false;
    });
    testiBloc.fetchTesti(tipe,1,perpage);

  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    print("load $perpage");
    setState(() {
      perpage = perpage += 10;
    });
    testiBloc.fetchTesti(tipe,1,perpage);
    print(perpage);
    return true;
  }



  @override
  void initState() {
    testiBloc.fetchTesti(tipe,1,100);
    super.initState();
  }
//
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: scaffoldKey,
      appBar:  UserRepository().appBarNoButton(context,'Tentang Thaibah',<Widget>[]),
      body: StreamBuilder(
          stream: testiBloc.getResult,
          builder: (context, AsyncSnapshot<TestimoniModel> snapshot) {
            if(snapshot.hasData){
              return _content(snapshot, context);
//              return _buildContent(snapshot, context);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return UserRepository().loadingWidget();
          }
      ),
    );
  }

  Widget _content(AsyncSnapshot<TestimoniModel> snapshot, BuildContext context) {
    return isLoading?Center(child: UserRepository().loadingWidget()):RefreshIndicator(
      child: StaggeredGridView.countBuilder(
        physics: new BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: snapshot.data.result.data.length,
        itemBuilder: (BuildContext context, int index){
          String cap = '';String tit='';
          if(snapshot.data.result.data[index].caption.length > 20){
            cap = '${snapshot.data.result.data[index].caption.substring(0,20)} ...';
          }
          else{
            cap = snapshot.data.result.data[index].caption;
          }
          if(snapshot.data.result.data[index].name.length > 20){
            tit = '${snapshot.data.result.data[index].name.substring(0,20)} ...';
          }
          else{
            tit = snapshot.data.result.data[index].name;
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
                          new Html(data:tit, defaultTextStyle: new TextStyle(fontFamily: ThaibahFont().fontQ,color: Colors.white, fontWeight: FontWeight.bold, fontSize:12)),
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
                new CupertinoPageRoute(builder: (context) => WidgetDetailVideo(
                    param:'Tentang Thaibah',
                    video: snapshot.data.result.data[index].video,
                    caption: snapshot.data.result.data[index].caption,
                    rating:snapshot.data.result.data[index].rating.toString()
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


