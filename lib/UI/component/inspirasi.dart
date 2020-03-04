import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thaibah/Model/inspirationModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/detailInspirasi.dart';
import 'package:thaibah/bloc/inspirationBloc.dart';

import 'package:http/http.dart' show Client,Response;
import 'package:wc_flutter_share/wc_flutter_share.dart';




class Inspirasi extends StatefulWidget {
  final String kdReferral;
  Inspirasi({this.kdReferral});
  @override
  _InspirasiState createState() => _InspirasiState();
}

class _InspirasiState extends State<Inspirasi> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  double _height;
  double _width;



  Future<Null> shareInspirasi(param) async{
    var response = await Client().get(param);
    final bytes = response.bodyBytes;
    await WcFlutterShare.share(
        sharePopupTitle: 'Thaibah Share Inspirasi & Informasi',
        subject: 'Thaibah Share Inspirasi & Informasi',
        text: 'Thaibah Share Inspirasi & Informasi',
        fileName: 'share.png',
        mimeType: 'image/png',
        bytesOfFile:bytes
    );
  }


  int perpage = 4;

  void load() {
    print("load $perpage");
    setState(() {
      perpage = perpage += 4;
    });
    inspirationBloc.fetchInspirationList(1,perpage);
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
    // TODO: implement initState
    super.initState();
    inspirationBloc.fetchInspirationList(1,perpage);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          centerTitle: false,
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
          elevation: 1.0,
          automaticallyImplyLeading: true,
          title: new Text("Inspirasi & Informasi", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        body:StreamBuilder(
            stream: inspirationBloc.allInspiration,
            builder: (context,  AsyncSnapshot<InspirationModel> snapshot){
              if (snapshot.hasData) {
                return buildContents(snapshot, context);
              }else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return _loading(context);
            }
        )

    );
  }


  Widget buildContents(AsyncSnapshot<InspirationModel> snapshot, BuildContext context){
    if(snapshot.data.result.data.length > 0){
      return Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
                child: LoadMoreQ(
                  child: ListView.builder(
                    itemCount: snapshot.data.result.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(0.0),
                        child: Card(
                          color:Colors.black.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.only(top:0.0,bottom:0.0),
                                  alignment: Alignment.bottomLeft,
                                  height: ScreenUtilQ.getInstance().setHeight(350),
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
                                    )
                                  )
                                ),
                                onTap: (){
                                  Navigator.of(context, rootNavigator: true).push(
                                    new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Inspirasi & Informasi',video: snapshot.data.result.data[index].video,caption: '',rating: '0',type: 'inspirasi',)),
                                  );
                                },
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: InkWell(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        height: ScreenUtilQ.getInstance().setHeight(100),
                                        color:Color(0xFF116240),
                                        child: InkWell(
                                          onTap: () async {
                                            await WcFlutterShare.share(
                                                sharePopupTitle: 'Thaibah Share Inspirasi & Informasi',
                                                subject: 'Thaibah Share Inspirasi & Informasi',
                                                text: 'Thaibah Share Inspirasi & Informasi \n ${snapshot.data.result.data[index].video} \n\n\nKunjungi Link Berikut Untuk Bergabung https://thaibah.com/signup/${widget.kdReferral}',
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
                                        width: MediaQuery.of(context).size.width/2,
                                        height: ScreenUtilQ.getInstance().setHeight(100),
                                        color:Color(0xFF116240),
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.of(context, rootNavigator: true).push(
                                              new CupertinoPageRoute(builder: (context) => DetailInspirasi(param:'Inspirasi & Informasi',video: snapshot.data.result.data[index].video,caption: '',rating: '0',type: 'inspirasi',)),
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
            ),
          ),
        ],
      );
    }else{
      return Container(
        child: Center(
          child: Text("Data Tidak Tersedia",style: TextStyle(color: Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
        ),
      );
    }

  }




  Widget _loading(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: new StaggeredGridView.countBuilder(
            primary: false,
            physics: ScrollPhysics(),
            crossAxisCount: 1,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            itemCount: 3,
            itemBuilder: (context, index) {
              return new GestureDetector(
                  child: Card(
                    color: Colors.transparent,
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
                                child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 400.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:10.0),
                        SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0),

                      ],
                    ),
                  )
              );
            },
            staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
          )
      ),
    );
  }

}

