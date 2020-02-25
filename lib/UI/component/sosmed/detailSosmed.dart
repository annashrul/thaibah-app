import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listDetailSosmedModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';

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

  var captionController = TextEditingController();
  bool isLoading = false;
  int jmlKomen = 0;
  int jmlLike = 0;
  bool isLikes = false;
  Future sendComment() async{
    var res = await SosmedProvider().sendComment(widget.id, captionController.text);
    if(res is GeneralInsertId){
      GeneralInsertId results = res;
      if(results.status == 'success'){
        captionController.clear();
        _blocDetail.fetchListDetailSosmed(widget.id);
        setState(() {isLoading = false;});
      }else{
        setState(() {isLoading = false;});
        return showInSnackBar(results.msg);
      }
    }else{
      General results = res;
      setState(() {isLoading = false;});
      return showInSnackBar(results.msg);
    }
  }

  Future sendUnLike() async{
    print('unlike');
    var res = await SosmedProvider().sendUnLike(widget.id);
    if(res is General){
      General results = res;
      if(results.status == 'success'){
        setState(() { isLikes = false;jmlLike = jmlLike-=1;});
        _blocDetail.fetchListDetailSosmed(widget.id);
      }else{
        setState(() {isLoading = false;});
        return showInSnackBar(results.msg);
      }
    }else{
      General results = res;
      setState(() {isLoading = false;});
      return showInSnackBar(results.msg);
    }
  }

  Future sendLike() async{
    print('like');
    var res = await SosmedProvider().sendLike(widget.id);
    if(res is GeneralInsertId){
      GeneralInsertId results = res;
      if(results.status == 'success'){
        setState(() {isLikes = true;jmlLike = jmlLike+=1;});
        _blocDetail.fetchListDetailSosmed(widget.id);
      }else{
        setState(() {isLoading = false;});
        return showInSnackBar(results.msg);
      }
    }else{
      General results = res;
      setState(() {isLoading = false;});
      return showInSnackBar(results.msg);
    }

  }
  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _blocDetail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: true,
        title: new Text("Detail Postingan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
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
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        child: StreamBuilder(
          stream: _blocDetail.getResult,
          builder: (context, AsyncSnapshot<ListDetailSosmedModel> snapshot){
            if (snapshot.hasData) {
              return isLoading ? _loading() : ListView(
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
                                    new Text("${snapshot.data.result.penulis}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                                    new Text("${snapshot.data.result.createdAt}",style: TextStyle(fontSize:10.0,color:Colors.grey,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
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
                                Html(data: snapshot.data.result.caption,defaultTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                                SizedBox(height: 10.0),
                                Container(
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
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  Column(
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
                                      print(isLikes);
                                      if(snapshot.data.result.isLike == true){
                                        sendUnLike();
                                      }else{
                                        sendLike();
                                      }
                                    },
                                    child:new Icon(FontAwesomeIcons.heart,color: snapshot.data.result.isLike==true?Colors.red:Colors.black)
                                ),
                                new SizedBox(width: 10.0),
                                Text("${int.parse(snapshot.data.result.likes)}  menyukai",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                                new SizedBox(width: 16.0),
                                new Icon(FontAwesomeIcons.comment),
                                new SizedBox(width: 10.0),
                                Text("${snapshot.data.result.comments}  komentar",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
//              Padding(
//                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    new Container(
//                      height: 40.0,
//                      width: 40.0,
//                      decoration: new BoxDecoration(
//                        shape: BoxShape.circle,
//                        image: new DecorationImage(
//                            fit: BoxFit.fill,
//                            image: new NetworkImage(
//                                "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
//                      ),
//
//                    ),
//                    new SizedBox(
//                      width: 10.0,
//                    ),
//                  ],
//                ),
//              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextFormField(
                  style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                  controller: captionController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                  onFieldSubmitted: (value){
                    if(captionController.text != ''){
                      setState(() {isLoading = true;});
                      Navigator.of(context).pop();
                      sendComment();
                    }
                  },
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),
                    border: InputBorder.none,
                    hintText: "Tambahkan Komentar...",
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ));
  }

  Widget buildContent(AsyncSnapshot<ListDetailSosmedModel> snapshot, BuildContext context){
    return snapshot.data.result.comment.length > 0 ? isLoading ? _loading() : ListView.builder(
        primary: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.result.comment.length,
        itemBuilder: (context,index){
          return Padding(
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
                        image: new NetworkImage("https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                  ),
                ),
                new SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Html(data: snapshot.data.result.comment[index].name,defaultTextStyle: TextStyle(fontSize:12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                      Html(data: snapshot.data.result.comment[index].caption,defaultTextStyle: TextStyle(fontSize:10.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                    ],
                  ),
                ),
                new SizedBox(width: 10.0),
                Text("${snapshot.data.result.comment[index].createdAt}",style: TextStyle(fontFamily: 'Rubik',color: Colors.grey,fontSize: 8.0)),
              ],
            ),
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
