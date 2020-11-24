import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/component/sosmed/listLikeSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'detailSosmed.dart';
import 'myFeed.dart';

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
  String gambar='',nama='';
  final userRepository = UserRepository();
  Future<File> file;
  String base64Image;
  File tmpFile;
  File _image;
  String fileName;
  Future sendFeed(caption,img) async{
    if(img != null){
      fileName = img.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(img.readAsBytesSync());
    }
    else{
      base64Image = "-";
    }
    print("BASE64 IMAGE $base64Image");
    var res = await SosmedProvider().sendFeed(caption, base64Image);
    if(res is GeneralInsertId){
      GeneralInsertId results = res;
      if(results.status == 'success'){
        _bloc.fetchListSosmed(1,perpage,'kosong');
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"success");
      }
      else{
        Navigator.pop(context);
        print(results.msg);
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
      }
    }
    else{
      General results = res;
      print(results.msg);
      Navigator.pop(context);

      UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
    }
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
          load();
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
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  Future loadUser() async{
    final img = await userRepository.getDataUser('picture');
    final name = await userRepository.getDataUser('name');
    setState(() {
      gambar=img;
      nama=name;
    });
  }

  void load() {
    perpage = perpage += 10;
    print("PERPAGE ${perpage}");
    setState(() {});
    _bloc.fetchListSosmed(1,perpage,'kosong');
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
    _bloc.fetchListSosmed(1,perpage,'kosong');
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
      },<Widget>[
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(
                        builder: (context) =>MyFeed()
                    )
                );
              },
              child: Container(
                margin:EdgeInsets.only(top:16.0,right:10),
                child: Icon(Icons.account_circle,color: Colors.grey),
              ),
            ),

          ],
        ),
      ]),
      body: Column(
        children: [
          writeSomething(context),
          SizedBox(height:10),
          Expanded(
              child:StreamBuilder(
                  stream: _bloc.getResult,
                  builder: (context, AsyncSnapshot<ListSosmedModel> snapshot){
                    if (snapshot.hasData) {
                      return itemContext(snapshot, context);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return UserRepository().loadingWidget();
                  }
              )
          )
        ],
      ),
    );
  }

  Widget itemContext(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return snapshot.data.result.data.length>0?Container(
      child: LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor:ThaibahColour.primary2,
        key: _refresh,
        onRefresh:refresh,
        child: LoadMoreQ(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.result.data.length,
              itemBuilder: (context,index){
                String sukai='disukai oleh ${int.parse(snapshot.data.result.data[index].likes)} orang ';
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
                      load(); //you get details from screen2 here
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data.result.data[index].penulisPicture),
                            radius: 20.0,
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              UserRepository().textQ(snapshot.data.result.data[index].penulis, 14, Colors.black,FontWeight.bold, TextAlign.left),
                              SizedBox(height: 5.0),
                              UserRepository().textQ(snapshot.data.result.data[index].createdAt, 12, Colors.grey,FontWeight.normal, TextAlign.left),
                            ],
                          ),
                          trailing: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child:InkWell(
                                  onTap:(){
                                    UserRepository().loadingQ(context);
                                    share(snapshot.data.result.data[index].picture,snapshot.data.result.data[index].caption,index);
                                    // share(snapshot.data.result.picture,snapshot.data.result.caption);
                                  },
                                  child:new Icon(FontAwesomeIcons.shareAlt)
                              )
                          ),
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
                                SizedBox(width: 5.0,),
                                GestureDetector(
                                  onTap: ()async{
                                    await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ListLikeSosmed(
                                          id: snapshot.data.result.data[index].id,
                                        ),
                                      ),
                                    ).then((val){
                                      load(); //you get details from screen2 here
                                    });
                                  },
                                  child:UserRepository().textQ(sukai,10, Colors.black,FontWeight.bold,TextAlign.left,textDecoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(FontAwesomeIcons.comments, size: 15.0, color: Colors.black),
                                SizedBox(width: 5.0,),
                                UserRepository().textQ('${snapshot.data.result.data[index].comments} komentar', 10, Colors.black, FontWeight.bold,TextAlign.left),
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
      ),
    ):UserRepository().noData();

  }

  Widget writeSomething(BuildContext context){
    return ListTile(
      title: InkWell(
        onTap: ()=>_lainnyaModalBottomSheet(context),
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1.0,
                    color: Colors.grey[400]
                ),
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: UserRepository().textQ("tulis status anda disini ...",12,Colors.grey,FontWeight.bold,TextAlign.left)
        ),
      ),
      leading: CircleAvatar(
          radius:20.0,
          backgroundImage: NetworkImage('$gambar')
      ),

    );

  }
  void _lainnyaModalBottomSheet(context){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context){
          return DraggableScrollableSheet(
            initialChildSize:1, // half screen on load
            maxChildSize: 1,       // full screen on scroll
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return BottomWidget(sendFeed: (String caption, File img){
                print("FILE IMAGE $img");
                setState(() {
                  UserRepository().loadingQ(context);
                });
                sendFeed(caption,img);
              },name:nama);
            },
          );

        }
    );
  }
}
