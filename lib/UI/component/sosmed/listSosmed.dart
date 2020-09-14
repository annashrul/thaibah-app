import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../Widgets/SCREENUTIL/ScreenUtilQ.dart';

class ListSosmed extends StatefulWidget {
  @override
  _ListSosmedState createState() => _ListSosmedState();
}

class _ListSosmedState extends State<ListSosmed> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  bool isLoading1 = false;

  final _bloc = SosmedBloc();
  int perpage = 10;
  load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    perpage = perpage += 10;
    await prefs.setInt('perpage', perpage);
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading1 = false;
      });
    });
    _bloc.fetchListSosmed(1,perpage,'kosong');
  }
  Color warna1;
  Color warna2;
  String statusLevel ='0';
  final userRepository = UserRepository();
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
  Future loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int page=prefs.getInt("perpage");
    _bloc.fetchListSosmed(1,page==null?10:page,'kosong');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTheme();
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

    super.build(context);
    return StreamBuilder(
        stream: _bloc.getResult,
        builder: (context, AsyncSnapshot<ListSosmedModel> snapshot){
          if (snapshot.hasData) {
            return itemContext(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(padding:EdgeInsets.all(20.0),child:Center(child:CircularProgressIndicator(strokeWidth: 10,valueColor: AlwaysStoppedAnimation<Color>(ThaibahColour.primary1))));
        }
    );
  }

  Widget buildContent(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return isLoading?CircularProgressIndicator(strokeWidth: 10):Container(
      child:  Column(
        children: <Widget>[
          ListView.builder(
              primary: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.result.data.length,
              itemBuilder: (context,index){
                String caption = '';
                if(snapshot.data.result.data[index].caption.substring(0,1) == "<"){
                  caption = 'konten tidak tersedia';
                }else{
                  if(snapshot.data.result.data[index].caption.length > 100){
                    caption = snapshot.data.result.data[index].caption.substring(0,100)+ " ....";
                  }else{
                    caption = snapshot.data.result.data[index].caption;
                  }
                }

                return InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DetailSosmed(
                          id: snapshot.data.result.data[index].id,
                        ),
                      ),
                    ).then((val){
                      _bloc.fetchListSosmed(1, perpage,'kosong'); //you get details from screen2 here
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 0.0,left:15.0,right:15.0),
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
                                    height: ScreenUtilQ.getInstance().setHeight(120),
                                    width: ScreenUtilQ.getInstance().setWidth(140),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.result.data[index].picture,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
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
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.penAlt,color: Colors.grey,size:ScreenUtilQ.getInstance().setHeight(24)),
                                      SizedBox(width: 5.0),
                                      Text(snapshot.data.result.data[index].penulis,style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(24),color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold)),
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
                                      Icon(FontAwesomeIcons.comment,color: Colors.grey,size:ScreenUtilQ.getInstance().setHeight(24)),
                                      SizedBox(width: 5.0),
                                      Text(snapshot.data.result.data[index].comments+' komentar',style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(24),color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold)),
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
                                      Icon(FontAwesomeIcons.clock,color: Colors.grey,size:ScreenUtilQ.getInstance().setHeight(24)),
                                      SizedBox(width: 5.0),
                                      Text("${snapshot.data.result.data[index].createdAt}",style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(24),color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold)),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              }
          ),
          snapshot.data.result.count == int.parse(snapshot.data.result.perpage) ? UserRepository().buttonLoadQ(context, warna1, warna2,(){
            setState(() {isLoading1 = true;});
            load();
          }, isLoading1):Container()

        ],
      ),
    );
  }
  int cek = 0;
  bool isLoadingShare=false,isLoadingLikeOrUnLike=false;
  int like=0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future share(img,caption,index) async{
    setState(() {
      isLoadingShare = true;
      cek=index;
    });
    var response = await Client().get(img);
    final bytes = response.bodyBytes;
    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
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
  Future sendLikeOrUnLike(id,isLike) async{
    print(isLike);
    if(isLike==false){

    }
    var res = await SosmedProvider().sendLikeOrUnLike(id);
    if(res.toString() == 'timeout' || res.toString() == 'error'){
      setState(() {
        isLoadingLikeOrUnLike = false;
      });
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      GagalHitProvider().fetchRequest('like or unlike','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
      UserRepository().notifNoAction(_scaffoldKey, context,"Terjadi Kesalahan","failed");
    }else{
      if(res is General){
        General results = res;
        if(results.status == 'success'){
          setState(() {
            isLoadingLikeOrUnLike = false;
          });
          loadData();
        }else{
          setState(() {
            isLoadingLikeOrUnLike = false;
          });
          UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
        }
      }
      else{
        General results = res;
        setState(() {
          isLoadingLikeOrUnLike = false;
        });
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
      }
    }


  }

  Widget itemContext(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Column(
      children: [
        ListView.builder(
            primary: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.result.data.length,
            itemBuilder: (context,index){
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
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
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
                              Text(snapshot.data.result.data[index].penulis, style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(40))),
                              SizedBox(height: 5.0),
                              Text(snapshot.data.result.data[index].createdAt, style: TextStyle(color:Colors.grey,fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(30)))
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20.0),
                      Align(
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
                      SizedBox(height: 10.0),
                      InkWell(
                          onDoubleTap: (){
                            // print(snapshot.data.result.data[index].isLike);
                            sendLikeOrUnLike(snapshot.data.result.data[index].id,snapshot.data.result.data[index].isLike);

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[

                              InkWell(
                                onTap:(){
                                  sendLikeOrUnLike(snapshot.data.result.data[index].id,snapshot.data.result.data[index].isLike);
                                },
                                child:Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.blue),
                              ),

                              Text(' ${snapshot.data.result.data[index].likes}', style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(30))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('${snapshot.data.result.data[index].comments} comments  •  ', style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(30))),

                              InkWell(
                                onTap:(){
                                  setState(() {
                                    isLoadingShare=true;
                                  });
                                  share(snapshot.data.result.data[index].picture,snapshot.data.result.data[index].caption,index);
                                },
                                child:index == cek ? isLoadingShare ? CircularProgressIndicator(strokeWidth:10, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)) : Icon(FontAwesomeIcons.share, size: 20.0):Icon(FontAwesomeIcons.share, size: 20.0),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        color: Colors.grey[400],
                        width: MediaQuery.of(context).size.width,
                        height: 5.0,

                      )
                      //
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Row(
                      //       children: <Widget>[
                      //         Icon(FontAwesomeIcons.thumbsUp, size: 20.0),
                      //         SizedBox(width: 5.0),
                      //         Text('Like', style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(30))),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: <Widget>[
                      //         Icon(FontAwesomeIcons.commentAlt, size: 20.0),
                      //         SizedBox(width: 5.0),
                      //         Text('Comment', style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(30))),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: <Widget>[
                      //         Icon(FontAwesomeIcons.share, size: 20.0),
                      //         SizedBox(width: 5.0),
                      //         Text('Share', style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize:ScreenUtilQ.getInstance().setSp(30))),
                      //       ],
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              );
            }
        ),
        snapshot.data.result.count == int.parse(snapshot.data.result.perpage) ? UserRepository().buttonLoadQ(context, warna1, warna2,(){
          setState(() {isLoading1 = true;});
          load();
        }, isLoading1):Container()
      ],
    );

  }

}
