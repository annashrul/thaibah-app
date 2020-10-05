import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/donasi/historyDonasiModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/component/donasi/widget_donasi.dart';
import 'package:thaibah/bloc/donasi/donasiBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class HistoryDonasi extends StatefulWidget {
  @override
  _HistoryDonasiState createState() => _HistoryDonasiState();
}

class _HistoryDonasiState extends State<HistoryDonasi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  int perpage=10;
  void load() {
    setState(() {
      perpage = perpage += 10;
    });
    historyDonasiBloc.fetchHistoryDonasi('&perpage=$perpage');
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    historyDonasiBloc.fetchHistoryDonasi('&perpage=$perpage');

  }
  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historyDonasiBloc.fetchHistoryDonasi('&perpage=$perpage');
    initializeDateFormatting('id');
  }
  final formatter = new NumberFormat("#,###");


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Riwayat Donasi",(){
        Navigator.of(context).pop();
      },<Widget>[]),
      body: StreamBuilder(
        stream: historyDonasiBloc.getResult,
        builder: (context, AsyncSnapshot<HistoryDonasiModel> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.result.data.length>0?LiquidPullToRefresh(
              color: ThaibahColour.primary2,
              backgroundColor:Colors.white,
              key: _refresh,
              onRefresh:refresh,
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
                      return ListTile(
                        title:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/3,
                              child: UserRepository().textQ(snapshot.data.result.data[index].title, 12, Colors.black, FontWeight.bold, TextAlign.left),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/7,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: snapshot.data.result.data[index].status==1?Colors.green.withOpacity(0.7):Colors.red.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: UserRepository().textQ("${snapshot.data.result.data[index].status==1?'Diterima':'Pending'}", 10, Colors.white, FontWeight.bold, TextAlign.center),
                            )
                          ],
                        ),
                        subtitle:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserRepository().textQ('Rp ${formatter.format(snapshot.data.result.data[index].amount)}', 12,Colors.green, FontWeight.bold, TextAlign.left),
                            UserRepository().textQ("${DateFormat.yMMMMEEEEd('id').add_jm().format(snapshot.data.result.data[index].createdAt.toLocal())}", 10, Colors.grey, FontWeight.normal, TextAlign.left),
                          ],
                        ),
                        leading: Container(
                          margin: const EdgeInsets.only(left:10.0,right:5.0),
                          width:ScreenUtilQ.getInstance().setWidth(250),
                          height:ScreenUtilQ.getInstance().setHeight(200),
                          child:CachedNetworkImage(
                            imageUrl: snapshot.data.result.data[index].gambar,
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
                      );
                    }
                ),
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
