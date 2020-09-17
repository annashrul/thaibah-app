import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listDetailSosmedModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/autoSizeTextQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'listLikeSosmed.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';

class DetailSosmed extends StatefulWidget {
  final String id;

  DetailSosmed({this.id});
  @override
  _DetailSosmedState createState() => _DetailSosmedState();
}

class _DetailSosmedState extends State<DetailSosmed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  final _blocDetail = DetailSosmedBloc();
  final _bloc = SosmedBloc();

  var captionController = TextEditingController();
  bool isLoading = false;
  bool isLoadingLikeOrUnLike = false;
  bool isLoadingShare = false;
  int jmlKomen = 0;
  int jmlLike = 0;
  bool isLikes = false;
  Future sendComment() async{
    UserRepository().loadingQ(context);
    if(captionController.text.length > 255){
      Navigator.pop(context);
      UserRepository().notifNoAction(_scaffoldKey, context,"Komentar terlalu panjang","failed");
    }else{
      var res = await SosmedProvider().sendComment(widget.id, captionController.text);
      if(res=='error'||res=='timeout'){
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,"Terjadi Kesalahan sistem","failed");
      }
      else{
        if(res is GeneralInsertId){
          GeneralInsertId results = res;
          print("GENERAL INSERT ID STATUS ${res.status}");
          if(results.status == 'success'){
            captionController.clear();
            _blocDetail.fetchListDetailSosmed(widget.id);
            _bloc.fetchListSosmed(1,10,'kosong');
            Navigator.pop(context);
          }else{
            Navigator.pop(context);
            UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
          }
        }
        else{
          General results = res;
          print("GENERAL STATUS ${res.status}");
          Navigator.pop(context);
          UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
        }
      }
    }


  }


  Future sendLikeOrUnLike(bool param) async{
    UserRepository().loadingQ(context);
    var res = await SosmedProvider().sendLikeOrUnLike(widget.id);
    if(res.toString() == 'timeout' || res.toString() == 'error'){
      Navigator.pop(context);
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      GagalHitProvider().fetchRequest('like or unlike','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
      UserRepository().notifNoAction(_scaffoldKey, context,"Terjadi Kesalahan","failed");
    }else{
      if(res is General){
        General results = res;
        if(results.status == 'success'){
          Navigator.pop(context);
          _blocDetail.fetchListDetailSosmed(widget.id);
        }else{
          Navigator.pop(context);
          UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
        }
      }
      else{
        General results = res;
        Navigator.pop(context);
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
      }
    }
  }

  Future<void> refresh() async{
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }

  void load(){
    setState(() {isLoading = false;});
    _blocDetail.fetchListDetailSosmed(widget.id);

  }
  Future share(img,caption) async{
    UserRepository().loadingQ(context);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    loadTheme();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _blocDetail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar:UserRepository().appBarWithButton(context,"Detail Postingan",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: Scrollbar(
          child: RefreshIndicator(
            child: StreamBuilder(
                stream: _blocDetail.getResult,
                builder: (context, AsyncSnapshot<ListDetailSosmedModel> snapshot){
                  if (snapshot.hasData) {
                    String sukai='';
                    if(int.parse(snapshot.data.result.likes) > 0){
                      sukai = 'disukai oleh ${int.parse(snapshot.data.result.likes)-1} orang';
                    }
                    else{
                      sukai = '0';
                    }

                    return ListView(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      new Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: new NetworkImage("${snapshot.data.result.penulisPicture}")
                                          ),
                                        ),
                                      ),

                                      new SizedBox(width: 10.0),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          UserRepository().textQ(snapshot.data.result.penulis, 14, Colors.black,FontWeight.bold,TextAlign.left),
                                          UserRepository().textQ(snapshot.data.result.createdAt, 12, Colors.grey,FontWeight.bold,TextAlign.left),
                                        ],
                                      )
                                    ],
                                  ),
                                  isLoadingShare ? CircularProgressIndicator(): Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child:InkWell(
                                        onTap:(){
                                          share(snapshot.data.result.picture,snapshot.data.result.caption);
                                        },
                                        child:new Icon(FontAwesomeIcons.shareAlt)
                                    )
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                  padding:EdgeInsets.only(left:15.0,right:15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Linkify(
                                        onOpen: (link) async {
                                          print('tap link');
                                          if (await canLaunch(link.url)) {
                                            await launch(link.url);
                                          } else {
                                            throw 'Could not launch $link';
                                          }
                                        },
                                        text: snapshot.data.result.caption,
                                        style: TextStyle(fontFamily:ThaibahFont().fontQ),
                                        linkStyle: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ),
                                      ),
                                      SizedBox(height: 10.0),
                                      InkWell(
                                        onDoubleTap: (){
                                          sendLikeOrUnLike(snapshot.data.result.isLike);
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
                                                snapshot.data.result.picture,fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,width: MediaQuery.of(context).size.width/1,
                                              )
                                          ),
                                        )
                                      ),

                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                          onTap:(){
                                            sendLikeOrUnLike(snapshot.data.result.isLike);
                                          },
                                          child:Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.black)
                                          // child:new Icon(FontAwesomeIcons.heart,size:  ScreenUtilQ.getInstance().setSp(70),color: snapshot.data.result.isLike==true?Colors.red:Colors.black)
                                      ),
                                      new SizedBox(width: 10.0),
                                      GestureDetector(
                                        onTap: ()async{
                                          await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => ListLikeSosmed(
                                                id: widget.id,
                                              ),
                                            ),
                                          ).then((val){
                                            _blocDetail.fetchListDetailSosmed(widget.id); //you get details from screen2 here
                                          });
                                        },
                                        child:UserRepository().textQ(sukai,10, Colors.grey,FontWeight.bold,TextAlign.left),
                                      ),
                                      new SizedBox(width: 16.0),
                                      new Icon(FontAwesomeIcons.comment,size: 15, color: Colors.black),
                                      new SizedBox(width: 10.0),
                                      UserRepository().textQ("${snapshot.data.result.comments} komentar",10, Colors.grey,FontWeight.bold,TextAlign.left),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(padding:EdgeInsets.only(left:15.0,right:15.0),child: Divider(),),
                            buildContent(snapshot, context)
                          ],
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return _loading();
                }
            ),
            onRefresh: refresh,
            key: _refresh,
          )
      ),
      floatingActionButton: new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(FontAwesomeIcons.penAlt),
        backgroundColor: new Color(0xFF30cc23),
        onPressed: (){_lainnyaModalBottomSheet(context);}
      )
    );
  }

  void _lainnyaModalBottomSheet(context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);

    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.black,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal:18 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: TextFormField(
                  style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),color:Colors.white,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),
                  controller: captionController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                  onFieldSubmitted: (value){
                    if(captionController.text != ''){
                      Navigator.of(context).pop();
                      sendComment();
                    }
                  },
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),color:Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                    border: InputBorder.none,
                    hintText: "Tambahkan Komentar...",
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  width: MediaQuery.of(context).size.width/1,
                  child: InkWell(
                    onTap: (){
                      if(captionController.text != ''){
                        setState(() {isLoading = true;});
                        Navigator.of(context).pop();
                        sendComment();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 22.0, 10.0, 22.0),
                      child:Center(child: Text("Simpan",style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(45),color:Colors.white,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),),
                    ),
                  )
              )
            ],
          ),
        )
    );
  }

  Widget buildContent(AsyncSnapshot<ListDetailSosmedModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return isLoading?_loading():snapshot.data.result.comment.length > 0 ? ListView.builder(
        primary: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.result.comment.length,
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(snapshot.data.result.comment[index].profilePicture)),
                      ),
                    ),
                    new SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          UserRepository().textQ(snapshot.data.result.comment[index].name, 14, Colors.black, FontWeight.bold, TextAlign.left),
                          Linkify(
                            onOpen: (link) async {
                              if (await canLaunch(link.url)) {
                                await launch(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            text: snapshot.data.result.comment[index].caption,
                            style: TextStyle(color:Colors.grey,fontSize:10.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                            linkStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                          ),
                        ],
                      ),
                    ),
                    new SizedBox(width: 10.0),
                    Text("${snapshot.data.result.comment[index].createdAt}",style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey,fontSize:ScreenUtilQ.getInstance().setSp(26))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Divider(),
              )
            ],
          );
        }
    ) : Container();
  }

  Widget _loading(){
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Container(
                        height: 50.0,
                        width: 50.0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: ClipOval(child: SkeletonFrame(width: 50,height: 50),
                          ),
                        ),
                      ),
                      new SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 12.0,),
                          SizedBox(height: 10.0),
                          SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 12.0),
                        ],
                      )
                    ],
                  ),

                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                  padding:EdgeInsets.only(left:15.0,right:15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16.0),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular( 10.0)
                          ),
                        ),
                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 200.0),
                      )
                    ],
                  )
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(padding:EdgeInsets.only(left:15.0,right:15.0),child: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16.0),),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          height: 40.0,
                          width: 40.0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: ClipOval(child: SkeletonFrame(width: 40,height: 40),
                            ),
                          ),
                        ),
                        new SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 16.0,),
                              SizedBox(height: 10.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 16.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
            )
          ],
        )
      ],
    );
  }
  
}
