import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';

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

  void load() {
    perpage = perpage += 10;
    print("PERPAGE $perpage");
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading1 = false;
      });
    });
    _bloc.fetchListSosmed(1,perpage,'kosong');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      _bloc.fetchListSosmed(1,10,'kosong');
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
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(child:Center(child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))));
        }
    );
  }

  Widget buildContent(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
    return isLoading?CircularProgressIndicator():Container(
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
                if(snapshot.data.result.data[index].caption.length > 100){
                  caption = snapshot.data.result.data[index].caption.substring(0,100)+ " ....";
                }else{
                  caption = snapshot.data.result.data[index].caption;
                }

                return InkWell(
                  onTap: (){
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => DetailSosmed(
                        id: snapshot.data.result.data[index].id,
                      )),
                    ).whenComplete(_bloc.fetchListSosmed(1, perpage,'kosong'));
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
                                        child: Html(
                                          data:caption, defaultTextStyle:TextStyle(fontSize:12.0,color:Colors.black,fontFamily:'Rubik',fontWeight:FontWeight.bold),
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
                                    height: 80.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.result.data[index].picture,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
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
                                      Icon(FontAwesomeIcons.penAlt,color: Colors.grey,size: 12.0),
                                      SizedBox(width: 5.0),
                                      Text(snapshot.data.result.data[index].penulis,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
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
                                      Icon(FontAwesomeIcons.comment,color: Colors.grey,size: 12.0),
                                      SizedBox(width: 5.0),
                                      Text(snapshot.data.result.data[index].comments+' komentar',style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
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
                                      Icon(FontAwesomeIcons.clock,color: Colors.grey,size: 12.0),
                                      SizedBox(width: 5.0),
                                      Text("${snapshot.data.result.data[index].createdAt}",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:'Rubik',fontWeight:FontWeight.bold)),
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
          snapshot.data.result.count == int.parse(snapshot.data.result.perpage) ? Container(
            padding: EdgeInsets.only(left:15.0,right:15.0),
            child: InkWell(
              onTap: (){
                setState(() {isLoading1 = true;});
                load();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0,color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                padding: EdgeInsets.all(15.0),
                width: double.infinity,
                child: Center(child: isLoading1 ? CircularProgressIndicator() : Text("Tampilkan Lebih Banyak",style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),)),
              ),
            ),
          ):Container()
        ],
      ),
    );
  }
}
