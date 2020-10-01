import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/UI/component/sosmed/inboxSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'listLikeSosmed.dart';

class MyFeed extends StatefulWidget {

  @override
  _MyFeedState createState() => _MyFeedState();
}

class _MyFeedState extends State<MyFeed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final _bloc = SosmedBloc();
  int perpage = 10;
  bool isLoading = false;

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
      base64Image = "";
    }
    var res = await SosmedProvider().sendFeed(caption, base64Image);
    if(res is GeneralInsertId){
      GeneralInsertId results = res;
      if(results.status == 'success'){
        _bloc.fetchListSosmed(1, perpage,'ada');
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
  Future deleteFeed(var id) async{
    var res = await SosmedProvider().deleteFeed(id);
    if(res is General){
      General results = res;
      if(results.status == 'success'){
        setState(() {
          Navigator.of(context).pop();
        });
        _bloc.fetchListSosmed(1, perpage,'ada');
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg, "success");
      }else{
        setState(() {Navigator.of(context).pop();});
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg, "failed");

      }
    }
    else{
      General results = res;
      setState(() {Navigator.of(context).pop();});
      UserRepository().notifNoAction(_scaffoldKey, context,results.msg, "failed");

    }
  }
  Future deleteCountInbox() async{
    var res = await SosmedProvider().deleteCountInbox();
    if(res is General){
      General results = res;
      if(results.status == 'success'){
      }else{
        setState(() {isLoading = false;});
        UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"success");
      }
    }
    else{
      General results = res;
      print(results.msg);
      setState(() {isLoading = false;});
      UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");

    }
  }
  void load() {
    perpage = perpage += 10;
    print("PERPAGE ${perpage}");
    setState(() {});
    _bloc.fetchListSosmed(1,perpage,'ada');

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
  Color warna1;
  Color warna2;
  String gambar;
  String statusLevel ='0';
  String nama ='';
  Future loadTheme() async{
    final picture = await userRepository.getDataUser('picture');
    final name = await userRepository.getDataUser('name');

    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    setState(() {
      warna1 = hexToColors(color1);
      warna2 = hexToColors(color2);
      statusLevel = levelStatus;
      gambar = picture;
      nama = name;
    });
  }

  bool isLoadingShare=false,isLoadingLikeOrUnLike=false;
  int like=0;
  Future share(img,caption,index) async{
    setState(() {
      UserRepository().loadingQ(context);
    });
    var response = await Client().get(img);
    final bytes = response.bodyBytes;
    Timer(Duration(seconds: 1), () async {
      setState(() {
        Navigator.pop(context);
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
    var res = await SosmedProvider().sendLikeOrUnLike(id);
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
          _bloc.fetchListSosmed(1,perpage,'ada');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListSosmed(1, perpage,'ada');
    loadTheme();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.getResult,
        builder: (context, AsyncSnapshot<ListSosmedModel> snapshot){
          if (snapshot.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: UserRepository().appBarWithButton(context, "Postingan Saya",(){Navigator.pop(context);},<Widget>[
                Stack(
                  children: <Widget>[
                    new IconButton(
                        icon: Icon(Icons.notifications_none,color: Colors.black,),
                        onPressed: () {
                          deleteCountInbox();
                          print('tap');
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => InboxSosmed()),
                          ).whenComplete(_bloc.fetchListSosmed(1, perpage,'ada'));
                        }
                    ),
                    new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(minWidth: 14, minHeight: 14,),
                        // child: Text('${snapshot.data.result.notif}', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center),
                        child: UserRepository().textQ('${snapshot.data.result.notif}', 8, Colors.white, FontWeight.bold, TextAlign.center),
                      ),
                    )
                  ],
                )
              ]),

              // appBar:UserRepository().appBarWithButton(context,"Postingan Saya",warna1,warna2,(){Navigator.of(context).pop();}, new Stack(
              //   children: <Widget>[
              //     new IconButton(
              //         icon: Icon(Icons.notifications_none),
              //         onPressed: () {
              //           deleteCountInbox();
              //           print('tap');
              //           Navigator.of(context, rootNavigator: true).push(
              //             new CupertinoPageRoute(builder: (context) => InboxSosmed()),
              //           ).whenComplete(_bloc.fetchListSosmed(1, perpage,'ada'));
              //         }
              //     ),
              //     new Positioned(
              //       right: 11,
              //       top: 11,
              //       child: new Container(
              //         padding: EdgeInsets.all(2),
              //         decoration: new BoxDecoration(
              //           color: Colors.red,
              //           borderRadius: BorderRadius.circular(6),
              //         ),
              //         constraints: BoxConstraints(minWidth: 14, minHeight: 14,),
              //         // child: Text('${snapshot.data.result.notif}', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center),
              //         child: UserRepository().textQ('${snapshot.data.result.notif}', 8, Colors.white, FontWeight.bold, TextAlign.center),
              //       ),
              //     )
              //   ],
              // ),),
              body: Column(
                children: [
                  writeSomething(context),
                  SizedBox(height:10),
                  Expanded(
                      child:buildContent(snapshot, context)
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Scaffold(
            body: UserRepository().loadingWidget(),
          );
        }
    );
  }



  Widget buildContent(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    return snapshot.data.result.data.length > 0 ? isLoading ?UserRepository().loadingWidget():  Container(
      child:  LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor:ThaibahColour.primary2,
        key: _refresh,
        onRefresh:refresh,
        child: LoadMoreQ(
          child: ListView.builder(
              primary: true,
              shrinkWrap: true,
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
                return Dismissible(
                    key: Key(index.toString()),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => DetailSosmed(
                            id: snapshot.data.result.data[index].id,
                          )),
                        ).whenComplete(_bloc.fetchListSosmed(1, perpage,'ada'));
                      },
                      child: Container(

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
                            Padding(
                              padding: EdgeInsets.all(5.0),
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
                                  setState(() {
                                    UserRepository().loadingQ(context);
                                  });
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
                                            sendLikeOrUnLike(snapshot.data.result.data[index].id,snapshot.data.result.data[index].isLike);
                                          },
                                          child:Icon(FontAwesomeIcons.thumbsUp, size: 15.0, color: Colors.black)
                                      ),
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
                                        child:UserRepository().textQ(sukai,10, Colors.black,FontWeight.bold,TextAlign.left),
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
                      ),
                    ),
                    background: slideLeftBackground(),
                    confirmDismiss: (direction) async {
                      return UserRepository().notifAlertQ(context, "warning","Perhatian","Anda yakin akan mengahpus status ini", "Batal","Oke", (){
                        Navigator.of(context).pop();
                      }, (){
                        Navigator.of(context).pop();
                        setState(() {
                          UserRepository().loadingQ(context);
                        });
                        deleteFeed(snapshot.data.result.data[index].id);

                      });

                    }
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
    ) : UserRepository().noData();
  }
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            UserRepository().textQ(" Hapus", 14, Colors.white, FontWeight.bold, TextAlign.right),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
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

}


class BottomWidget extends StatefulWidget {
  final Function(String caption, File _image) sendFeed;
  final String name;
  BottomWidget({this.sendFeed,this.name});
  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  var captionController = TextEditingController();
  final FocusNode captionFocus = FocusNode();
  File _image;
  String nama='';





  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Container(
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0),topRight:Radius.circular(0.0) ),
      ),
      // color: Colors.white,
      child: Column(
        children: [
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 0.0, right: 10.0),
            title: UserRepository().textQ("buat status",14,Colors.grey,FontWeight.bold,TextAlign.left),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(Icons.arrow_back_ios, color: Colors.grey)),
              ),
            ),
            trailing: InkWell(
                onTap: ()async{
                  print(_image);
                  if(captionController.text == ''){
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                  else if(_image==null){
                    final img = await UserRepository().getImageFile(ImageSource.gallery);
                    setState(() {
                      _image=img;
                    });
                  }else{
                    Navigator.of(context).pop();
                    captionFocus.unfocus();
                    widget.sendFeed(captionController.text,_image);
                    captionController.text = '';
                    _image = null;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [ThaibahColour.primary1,ThaibahColour.primary2]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                  ),
                  child: UserRepository().textQ("simpan",14,Colors.white,FontWeight.bold,TextAlign.right),
                )
            ),
          ),
          Divider(),
          Card(
              elevation: 0.0,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color:Colors.grey,fontSize: ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold),
                  controller: captionController,
                  focusNode: FocusNode(),
                  autofocus: false,
                  maxLines: 25,
                  decoration: InputDecoration.collapsed(
                      hintText: "apa yang kamu pikirkan, ${widget.name} ? ",
                      hintStyle: TextStyle(color:Colors.grey,fontSize: ScreenUtilQ.getInstance().setSp(40),fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold)
                  ),
                ),
              )
          ),
          Divider(),
          InkWell(
            onTap: () async {
              final img = await UserRepository().getImageFile(ImageSource.gallery);
              setState(() {
                _image = img;
              });
            },
            child: ListTile(
              title: UserRepository().textQ("Ambil Photo",12,Colors.grey,FontWeight.bold,TextAlign.left),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: _image!=null?Image.file(_image):Center(child: Icon(Icons.satellite, color: Colors.grey)),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 20,),
            ),
          ),
          Divider(),

        ],
      ),
    );
  }




}

