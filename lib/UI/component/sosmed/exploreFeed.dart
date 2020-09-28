import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'detailSosmed.dart';

class ExploreFeed extends StatefulWidget {
  @override
  _ExploreFeedState createState() => _ExploreFeedState();
}

class _ExploreFeedState extends State<ExploreFeed> {
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int cek = 0;
  int like=0;
  bool isLoading = false;
  bool isLoading1 = false;
  int perpage = 10;
  final _bloc = SosmedBloc();
  load() async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    perpage = perpage += 10;
    // await prefs.setInt('perpage', perpage);
    _bloc.fetchListSosmed(1,perpage,'kosong');
  }

  Future loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int page=prefs.getInt("perpage");
    _bloc.fetchListSosmed(1,page==null?10:page,'kosong');
  }


  Future share(img,caption,index) async{
    var response = await Client().get(img);
    final bytes = response.bodyBytes;
    Timer(Duration(seconds: 1), () async {
      Navigator.pop(context);
      await WcFlutterShare.share(
        sharePopupTitle: 'Thaibah Share Sosial Media',
        bytesOfFile:bytes,
        subject: '',
        text: '$caption',
        fileName: 'share.png',
        mimeType: 'image/png',
      );
    });

  }
  Future sendLikeOrUnLike(id,isLike,BuildContext context) async{

    var res = await SosmedProvider().sendLikeOrUnLike(id);
    if(res.toString() == 'timeout' || res.toString() == 'error'){
      Navigator.of(context).pop(false);
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      GagalHitProvider().fetchRequest('like or unlike','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
      UserRepository().notifNoAction(_scaffoldKey, context,"Terjadi Kesalahan","failed");
    }else{
      if(res is General){
        General results = res;
        if(results.status == 'success'){
          print("sukses");
          loadData();
          // Navigator.pop(context);
          setState(() {
            Navigator.of(context).pop(false);
          });

        }else{
          print("gagal");
          // Navigator.pop(context);
          // UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
        }
      }
      else{
        General results = res;
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
      }
    }


  }
  Future<void> refresh() async {
    setState(() {
      isLoading=true;
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    setState(() {
      isLoading=false;
    });
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
    if(mounted){
      loadData();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context,"Explore",(){
        Navigator.pop(context);
      },<Widget>[]),
      body: StreamBuilder(
          stream: _bloc.getResult,
          builder: (context, AsyncSnapshot<ListSosmedModel> snapshot){
            if (snapshot.hasData) {
              return itemContext(snapshot, context);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return UserRepository().loadingWidget();
          }
      ),
    );
  }

  Widget itemContext(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return snapshot.data.result.data.length>0?LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor:ThaibahColour.primary2,
        key: _refresh,
        onRefresh:refresh,
        child: LoadMoreQ(
          child: ListView.builder(

              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.result.data.length,
              itemBuilder: (context,index){
                String sukai='';
                if(snapshot.data.result.data[index].isLike == true){
                  sukai = 'disukai oleh anda dan ${int.parse(snapshot.data.result.data[index].likes)-1} orang lainnya ';
                }else{
                  if(int.parse(snapshot.data.result.data[index].likes) > 0 ){
                    sukai = 'disukai oleh ${int.parse(snapshot.data.result.data[index].likes)} orang ';
                  }
                  else{
                    sukai = '0';
                  }

                }

                String caption = '';
                if(snapshot.data.result.data[index].caption.substring(0,1) == "<"){
                  caption = 'konten tidak tersedia';
                }else{
                  if(snapshot.data.result.data[index].caption.length > 200){
                    caption = snapshot.data.result.data[index].caption.substring(0,200)+ " ....";
                  }else{
                    caption = snapshot.data.result.data[index].caption;
                  }
                }
                return InkWell(
                  onTap: () async{
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DetailSosmed(
                          id: snapshot.data.result.data[index].id,
                        ),
                      ),
                    ).then((val){
                      loadData(); //you get details from screen2 here
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left:15,right:15,top:10),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data.result.data[index].picture),
                              radius: 20.0,
                            ),
                            SizedBox(width: 7.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                UserRepository().textQ(snapshot.data.result.data[index].penulis, 14, Colors.black,FontWeight.bold, TextAlign.left),
                                SizedBox(height: 5.0),
                                UserRepository().textQ(snapshot.data.result.data[index].createdAt, 12, Colors.grey,FontWeight.normal, TextAlign.left),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.only(left:15,right:15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child:Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              text: removeAllHtmlTags(caption),
                              style: TextStyle(fontSize:12.0,color:Colors.black,fontFamily:ThaibahFont().fontQ),
                              linkStyle: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
                          onDoubleTap: (){
                            UserRepository().loadingQ(context);
                            sendLikeOrUnLike(snapshot.data.result.data[index].id,snapshot.data.result.data[index].isLike,context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular( 10.0)
                              ),
                            ),
                            child: Center(
                                child:Image.network(
                                  snapshot.data.result.data[index].picture,fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,width: MediaQuery.of(context).size.width/1,
                                )
                            ),
                          )
                      ),

                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.only(left:15,right:15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[

                                InkWell(
                                    onTap:(){
                                      UserRepository().loadingQ(context);
                                      sendLikeOrUnLike(snapshot.data.result.data[index].id,snapshot.data.result.data[index].isLike,context);
                                    },
                                    child:Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.black)
                                ),
                                UserRepository().textQ(' $sukai', 10, Colors.black, FontWeight.bold,TextAlign.left)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                UserRepository().textQ('${snapshot.data.result.data[index].comments} komentar  •  ', 10, Colors.black, FontWeight.bold,TextAlign.left),
                                InkWell(
                                  onTap:(){
                                    UserRepository().loadingQ(context);
                                    share(snapshot.data.result.data[index].picture,snapshot.data.result.data[index].caption,index);
                                  },
                                  child:Icon(FontAwesomeIcons.share, size: 15.0,color: Colors.black,),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        color: Colors.grey[200],
                        width: MediaQuery.of(context).size.width,
                        height: 3.0,

                      )
                    ],
                  ),
                );
              }
          ),
          whenEmptyLoad: true,
          delegate: DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.english,
          isFinish: snapshot.data.result.data.length < perpage,
          onLoadMore: _loadMore,
        ),
    ):UserRepository().noData();

  }
}
