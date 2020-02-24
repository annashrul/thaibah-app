import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listCommentSosmedModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';

class DetailSosmed extends StatefulWidget {
  final String id;
  final String image;
  final String caption;
  final String createdAt;
  final String creator;
  final bool isLikes;
  final String like;
  final String comment;
  DetailSosmed({this.id,this.image,this.caption,this.createdAt,this.creator,this.isLikes,this.like,this.comment});
  @override
  _DetailSosmedState createState() => _DetailSosmedState();
}

class _DetailSosmedState extends State<DetailSosmed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _bloc = CommentSosmedBloc();
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
        _bloc.fetchListCommentSosmed(widget.id);
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
  Future sendLike() async{
    var res = await SosmedProvider().sendLike(widget.id);
    if(res is GeneralInsertId){
      GeneralInsertId results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading = false;
          jmlLike = jmlLike+=1;
          isLikes = true;
        });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListCommentSosmed(widget.id);
    jmlLike = int.parse(widget.like);
    isLikes = widget.isLikes;
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
      body: ListView(
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
                                fit: BoxFit.fill,
                                image: new NetworkImage("${widget.image}")),
                          ),
                        ),
                        new SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("${widget.creator}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                            new Text("${widget.createdAt}",style: TextStyle(fontSize:10.0,color:Colors.grey,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
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
                        Html(data: widget.caption,defaultTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular( 10.0)
                            ),
                          ),
                          child: Image.network(widget.image,fit: BoxFit.fill,filterQuality: FilterQuality.high),
                        )
                      ],
                    )
                ),
              ),
            ],
          ),
          StreamBuilder(
              stream: _bloc.getResult,
              builder: (context, AsyncSnapshot<ListCommentSosmedModel> snapshot){
                if (snapshot.hasData) {
                  return Column(
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
                                    sendLike();
                                  },
                                  child:new Icon(FontAwesomeIcons.heart,color: isLikes==true?Colors.red:Colors.black)
                                ),
                                new SizedBox(width: 10.0),
                                Text("$jmlLike  menyukai",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                                new SizedBox(width: 16.0),
                                new Icon(FontAwesomeIcons.comment),
                                new SizedBox(width: 10.0),
                                Text("${snapshot.data.result.data.length}  komentar",style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(padding:EdgeInsets.only(left:15.0,right:15.0),child: Divider(),),
                      buildContent(snapshot, context)
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return _loading();
              }
          )
        ],
      ),
      bottomNavigationBar: _bottomNavBarBeli(context),
    );
  }
  Widget _bottomNavBarBeli(BuildContext context){
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/1,
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                ),
                color: Colors.green,
                onPressed: (){
                  _lainnyaModalBottomSheet(context);
                },
                child: Text("Buat Komentar", style: TextStyle(fontFamily:'Rubik',color: Colors.white)),
              )
          )
        ],
      ),
    );
  }
  void _lainnyaModalBottomSheet(context){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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

  Widget buildContent(AsyncSnapshot<ListCommentSosmedModel> snapshot, BuildContext context){
    return snapshot.data.result.data.length > 0 ? isLoading ? _loading() : ListView.builder(
        primary: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.result.data.length,
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
                      Html(data: snapshot.data.result.data[index].pengirim,defaultTextStyle: TextStyle(fontSize:12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                      Html(data: snapshot.data.result.data[index].komen,defaultTextStyle: TextStyle(fontSize:10.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                    ],
                  ),
                ),
                new SizedBox(width: 10.0),
                Text("${snapshot.data.result.data[index].createdAt}",style: TextStyle(fontFamily: 'Rubik',color: Colors.grey,fontSize: 8.0)),
              ],
            ),
          );
        }
    ) : Container(child: Center(child: Text('Belum Ada Komentar Di Postingan Ini ..... '),),);
  }


  Widget _loading(){
    return ListView.builder(
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
    );
  }
  
}
