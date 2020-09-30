import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/sosmed/listInboxSosmedModel.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/component/sosmed/detailSosmed.dart';
import 'package:thaibah/bloc/sosmed/sosmedBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/sosmed/sosmed.dart';

class ScreenInboxDonasi extends StatefulWidget {
  @override
  _ScreenInboxDonasiState createState() => _ScreenInboxDonasiState();
}

class _ScreenInboxDonasiState extends State<ScreenInboxDonasi> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final _bloc = InboxSosmedBloc();
  int perpage = 10;
  bool isLoading = false;
  bool isLoading1 = false;
  void load() {
    perpage = perpage += 10;
    setState(() {isLoading = false;});
    _bloc.fetchListInboxSosmed('&type=donasi&age=$perpage');

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
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }
  Future deleteInbox(id,index) async{
    var res = await SosmedProvider().deleteInbox(id);
    if(res is General){
      General results = res;
      if(results.status == 'success'){
        Navigator.pop(context);
        _bloc.fetchListInboxSosmed('&type=donasi&age=$perpage');
        UserRepository().notifNoAction(scaffoldKey, context,'pesan berhasil di hapus', "success");
      }else{
        Navigator.pop(context);
        UserRepository().notifNoAction(scaffoldKey, context,results.msg, "failed");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetchListInboxSosmed('&type=donasi&age=$perpage');
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
      appBar: UserRepository().appBarWithButton(context, "Pesan Masuk",(){Navigator.pop(context);},<Widget>[]),

      // appBar: UserRepository().appBarWithButton(context,"Pesan Masuk",ThaibahColour.primary1,ThaibahColour.primary2, (){Navigator.pop(context);}, Container()),
      body: Container(
        margin: EdgeInsets.only(top:5.0),
        child: StreamBuilder(
            stream: _bloc.getResult,
            builder: (context, AsyncSnapshot<ListInboxModel> snapshot){
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Expanded(child: buildContent(snapshot, context))
                  ],
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return UserRepository().loadingWidget();
            }
        ),
      ),
    );
  }

  Widget buildContent(AsyncSnapshot<ListInboxModel> snapshot, BuildContext context){
    List colors = [Color(0xFF116240), Color(0xFF30cc23)];
    Random random = new Random();
    return snapshot.data.result.data.length > 0 ? isLoading ? UserRepository().loadingWidget() : LiquidPullToRefresh(
      color: Colors.transparent,
      backgroundColor:ThaibahColour.primary2,
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
                  // Navigator.of(context, rootNavigator: true).push(
                  //   new CupertinoPageRoute(builder: (context) => DetailSosmed(id: snapshot.data.result.data[index].id)),
                  // );
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
                                  UserRepository().textQ(hm, 10,Colors.white,FontWeight.bold,TextAlign.center),
                                  UserRepository().textQ(ymd,10,Colors.white,FontWeight.bold,TextAlign.center),
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
                            UserRepository().textQ(snapshot.data.result.data[index].title, 12,Colors.black,FontWeight.bold,TextAlign.left),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            UserRepository().textQ(snapshot.data.result.data[index].caption, 12,Colors.grey,FontWeight.bold,TextAlign.left),
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
                            child: new IconButton(
                                icon: Icon(FontAwesomeIcons.trash,color: Colors.grey,size: 12.0,),
                                onPressed: () {
                                  UserRepository().notifAlertQ(context,"warning","Perhatian","Apakah anda yakin akan menghapus pesan ini ?","Batal","Oke",(){
                                    Navigator.pop(context);
                                  },(){
                                    Navigator.pop(context);
                                    UserRepository().loadingQ(context);
                                    deleteInbox(snapshot.data.result.data[index].id,index);
                                  });


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
    ) : UserRepository().noData();
  }
}
