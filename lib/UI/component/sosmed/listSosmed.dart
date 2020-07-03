import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:url_launcher/url_launcher.dart';

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
    loadTheme();
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
          return Container(padding:EdgeInsets.all(20.0),child:Center(child:CircularProgressIndicator(strokeWidth: 10,valueColor: AlwaysStoppedAnimation<Color>(ThaibahColour.primary1))));
        }
    );
  }

  Widget buildContent(AsyncSnapshot<ListSosmedModel> snapshot, BuildContext context){
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
                                          style: TextStyle(fontSize:12.0,color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                                          linkStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
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
                                      Icon(FontAwesomeIcons.penAlt,color: Colors.grey,size: 12.0),
                                      SizedBox(width: 5.0),
                                      Text(snapshot.data.result.data[index].penulis,style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold)),
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
                                      Text(snapshot.data.result.data[index].comments+' komentar',style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold)),
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
                                      Text("${snapshot.data.result.data[index].createdAt}",style:TextStyle(fontSize:10.0,color:Colors.grey,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold)),
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
//          snapshot.data.result.count == int.parse(snapshot.data.result.perpage) ? Container(
//            padding: EdgeInsets.only(left:15.0,right:15.0),
//            child: InkWell(
//              onTap: (){
//                setState(() {isLoading1 = true;});
//                load();
//              },
//              child: Container(
//                decoration: BoxDecoration(
//                  border: Border.all(width: 1.0,color:ThaibahColour.primary1),
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                ),
//                padding: EdgeInsets.all(15.0),
//                width: double.infinity,
//                child: Center(child: isLoading1 ? CircularProgressIndicator(strokeWidth: 10,valueColor: AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)) : Text("Tampilkan Lebih Banyak",style: TextStyle(color:ThaibahColour.primary1,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),)),
//              ),
//            ),
//          ):Container()
        ],
      ),
    );
  }
}
