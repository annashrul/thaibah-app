import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listInboxSosmedModel.dart';
import 'package:thaibah/Model/sosmed/listSosmedModel.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';

class InboxSosmed extends StatefulWidget {
  @override
  _InboxSosmedState createState() => _InboxSosmedState();
}

class _InboxSosmedState extends State<InboxSosmed> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  String pesan = "When you do something beautiful and nobody noticed, do not be sad. For the sun every morning is a beautiful spectacle and the most of the audience sleeps.";
  final _bloc = InboxSosmedBloc();
  int perpage = 10;
  bool isLoading = false;
  bool isLoading1 = false;
  void load() {
    perpage = perpage += 10;
    print("PERPAGE ${perpage}");
    setState(() {isLoading = false;});
    _bloc.fetchListInboxSosmed(1,perpage);

  }
  Future<void> refresh() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
  }
  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }
  int cek = 0;
  Future deleteInbox(id,index) async{
    var res = await SosmedProvider().deleteInbox(id);
    if(res is General){
      General results = res;
      if(results.status == 'success'){
        setState(() {
          isLoading1 = false;
          cek = index;
        });
        _bloc.fetchListInboxSosmed(1, perpage);
        return showInSnackBar('pesan berhasil di hapus','success');
      }else{
        setState(() {
          isLoading1 = false;
          cek = index;
        });
        return showInSnackBar(results.msg,'success');
      }
    }
  }
  void showInSnackBar(String value,String param) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: param == 'success' ? Colors.green : Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListInboxSosmed(1, perpage);
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
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Pesan Masuk ', style: TextStyle(fontFamily:'Rubik',color:Colors.white,fontWeight: FontWeight.bold)),
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
      ),
      body: Container(
        margin: EdgeInsets.only(top:5.0),
        child: StreamBuilder(
            stream: _bloc.getResult,
            builder: (context, AsyncSnapshot<ListInboxSosmedModel> snapshot){
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Expanded(child: buildContent(snapshot, context))
                  ],
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Container(child:Center(child:CircularProgressIndicator()));
            }
        ),
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<ListInboxSosmedModel> snapshot, BuildContext context){
    List colors = [Color(0xFF116240), Color(0xFF30cc23)];
    Random random = new Random();
    return snapshot.data.result.data.length > 0 ? isLoading ? Container(child:Center(child:CircularProgressIndicator())) : RefreshIndicator(
      child: LoadMoreQ(
        child: ListView.builder(
          itemCount: snapshot.data.result.data.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            var hm = DateFormat.Hm().format(snapshot.data.result.data[index].createdAt.toLocal());
            var ymd = DateFormat.yMd().format(snapshot.data.result.data[index].createdAt.toLocal());
            return Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => DetailSosmed(id: snapshot.data.result.data[index].data.data.id)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(50),
                          offset: Offset(0, 0),
                          blurRadius: 5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent
//                          color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 60.0,
                            height: 60.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors[random.nextInt(2)],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text("$hm", style: new TextStyle(color: Colors.white, fontSize: 9.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                                  new Text("$ymd", style: new TextStyle(color: Colors.white, fontSize: 9.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${snapshot.data.result.data[index].title}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily:'Rubik',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Text(
                              '${snapshot.data.result.data[index].caption}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontFamily:'Rubik',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: index == cek ? isLoading1?CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))): new IconButton(
                                icon: Icon(FontAwesomeIcons.trash,color: Colors.grey,size: 12.0,),
                                onPressed: () {
                                  setState(() {isLoading1 = true;});
                                  deleteInbox(snapshot.data.result.data[index].id,index);
                                }
                            ): new IconButton(
                                icon: Icon(FontAwesomeIcons.trash,color: Colors.grey,size: 12.0,),
                                onPressed: () {
                                  setState(() {isLoading1 = true;});
                                  deleteInbox(snapshot.data.result.data[index].id,index);
                                }
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        whenEmptyLoad: true,
        delegate: DefaultLoadMoreDelegate(),
        textBuilder: DefaultLoadMoreTextBuilder.english,
        isFinish: snapshot.data.result.data.length < perpage,
        onLoadMore: _loadMore,
      ),
      onRefresh: refresh,
      key: _refresh,
    ) : Container(child:Center(child:Text("Data Tidak Tersdia",style:TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold))));
  }


}
