import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/donasi/screen_detail_donasi.dart';
import 'package:thaibah/bloc/donasi/donasiBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class WidgetDonasi extends StatefulWidget {
  final String any;
  final String noScaffold;
  WidgetDonasi({this.any,this.noScaffold});
  @override
  _WidgetDonasiState createState() => _WidgetDonasiState();
}

class _WidgetDonasiState extends State<WidgetDonasi> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  int perpage=10;
  void load() {
    setState(() {
      perpage = perpage += 10;
    });
    listDonasiBloc.fetchListDonasi('&perpage=$perpage');
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    listDonasiBloc.fetchListDonasi('&perpage=$perpage');
  }
  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }
  String title='Donasi';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listDonasiBloc.fetchListDonasi('&perpage=10${widget.any}');
    if(widget.any!=''){
      title='hasil pencarian ${widget.any.substring(8,widget.any.length)}';
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // listDonasiBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return MyFeed();
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, title,(){Navigator.pop(context);},<Widget>[]),

      body:StreamBuilder(
        stream: listDonasiBloc.getResult,
        builder: (context, AsyncSnapshot<ListDonasiModel> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.result.data.length>0?LiquidPullToRefresh(
              color: ThaibahColour.primary2,
              backgroundColor:Colors.white,
              key: _refresh,
              onRefresh:refresh,
              child: Padding(
                  padding: EdgeInsets.only(left:5.0,right:5.0,top:10.0),
                  child: LoadMoreQ(
                    whenEmptyLoad: true,
                    delegate: DefaultLoadMoreDelegate(),
                    textBuilder: DefaultLoadMoreTextBuilder.english,
                    isFinish: snapshot.data.result.data.length < perpage,
                    onLoadMore: _loadMore,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.result.data.length,
                        itemBuilder: (context,index){
                          return DonasiContent(
                            id: snapshot.data.result.data[index].id,
                            gambar: snapshot.data.result.data[index].gambar,
                            title: snapshot.data.result.data[index].title,
                            penggalang: snapshot.data.result.data[index].penggalang,
                            persentase: snapshot.data.result.data[index].persentase,
                            todeadline: snapshot.data.result.data[index].todeadline,
                            verifikasiPenggalang: snapshot.data.result.data[index].verifikasiPenggalang.toString(),
                            terkumpul: snapshot.data.result.data[index].terkumpul,
                            callback: ()=>load(),
                            noDeadline: snapshot.data.result.data[index].nodeadline,
                          );
                        }
                    ),
                  )
              ),
            ):UserRepository().noData();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Padding(padding: EdgeInsets.only(top:10.0),child: LoadingDonasi());
        },
      ),
    );

  }

}



class DonasiContent extends StatefulWidget {
  final String id;
  final String gambar;
  final String title;
  final String penggalang;
  final double persentase;
  final String todeadline;
  final String verifikasiPenggalang;
  final String terkumpul;
  final Function callback;
  final int noDeadline;
  DonasiContent({
    this.id,
    this.gambar,
    this.title,
    this.penggalang,
    this.persentase,
    this.todeadline,
    this.verifikasiPenggalang,
    this.terkumpul,
    this.callback,
    this.noDeadline
  });
  @override
  _DonasiContentState createState() => _DonasiContentState();
}

class _DonasiContentState extends State<DonasiContent> {
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return InkWell(
      onTap: (){
        Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(
                builder: (context) => ScreenDetailDonasi(id:widget.id,noDeadline:widget.noDeadline,toDeadline:widget.todeadline)
            )
        ).whenComplete(() => widget.callback());
      },
      child: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left:10.0,right:5.0),
                width:ScreenUtilQ.getInstance().setWidth(250),
                height:ScreenUtilQ.getInstance().setHeight(200),
                child:CachedNetworkImage(
                  imageUrl: widget.gambar,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(strokeWidth:10,valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(ApiService().noImage),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.circular(10.0),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              new Expanded(
                  child: new Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: new Column(
                      children: [
                        UserRepository().textQ(widget.title, 14, Colors.black, FontWeight.bold, TextAlign.left),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: UserRepository().textQ(widget.penggalang, 12, Colors.black.withOpacity(0.7), FontWeight.normal, TextAlign.left),
                            ),
                            SizedBox(width: 2.0),
                            widget.verifikasiPenggalang=='1'?Container(
                                padding:const EdgeInsets.all(0.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.green,Colors.green]),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Icon(Icons.check,color: Colors.white,size: 10.0)
                            ):Text(''),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 5,
                            child: LinearProgressIndicator(
                              value: widget.persentase, // percent filled
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        UserRepository().textQ('Rp ${formatter.format(int.parse(widget.terkumpul))}', 12, Colors.green, FontWeight.bold, TextAlign.left),
                        SizedBox(height: 5.0),
                        widget.noDeadline==1?Icon(Icons.all_inclusive,color: Colors.grey[400]):UserRepository().textQ(widget.todeadline, 10, Colors.grey, FontWeight.normal, TextAlign.left),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  )),
            ],
          ),
          Container(
            padding:EdgeInsets.only(left:10.0,right:10.0),
            child: Divider(),
          )
        ],
      ),
    );
  }
}

class LoadingDonasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:5.0,right:5.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (context,index){
            return InkWell(
              onTap: () async{},
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left:10.0,right:5.0),
                        child:SkeletonFrame(width: ScreenUtilQ.getInstance().setWidth(300),height: ScreenUtilQ.getInstance().setHeight(250)),
                      ),
                      new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: new Column(
                              children: [
                                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 15),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonFrame(width: 100,height: 15),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                SkeletonFrame(width: 100,height: 15),
                                SizedBox(height: 5.0),
                                SkeletonFrame(width: 100,height: 15),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    padding:EdgeInsets.only(left:10.0,right:10.0),
                    child: Divider(),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}

