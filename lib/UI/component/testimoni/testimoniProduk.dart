import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/Widgets/widgetDetailVideo.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:http/http.dart' as http;

class TestimoniProduk extends StatefulWidget {
  @override
  _TestimoniProdukState createState() => _TestimoniProdukState();
}

class _TestimoniProdukState extends State<TestimoniProduk> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  bool isLoading=false;
  bool isLoading1=false;
  bool isLoadingShare = false;
  TabController _tabController;
  int cek = 0;
  int perpage=5;
  List video;
  List<String> categoryArray=['0'];
  List<String> categoryString=['semua'];
  List<Widget> videosWidget = List();
  final userRepository = UserRepository();
  Future<void> loadCategory() async{
    final token = await userRepository.getDataUser('token');
    try{
      final jsonString = await http.get(
          ApiService().baseUrl+'category?type=testimoni',
          headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
      ).timeout(Duration(seconds: ApiService().timerActivity));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        jsonResponse['result'].forEach((element){
          setState(() {
            categoryString.add(element['title']);
            categoryArray.add(element['id'].toString());
          });
        });

      }
      else {
        throw Exception('Failed to load photos');
      }
      _tabController = new TabController(length:categoryString.length, vsync: this, initialIndex: 0);
      setState(() {
        isLoading1=false;
      });
    }catch(e){
      print(e);
    }
  }
  Future<void> loadTestimoni(var idCategory) async{
    String q='testi?tipe=0&page=1&limit=100';
    if(idCategory!=''){
      q += '&category=$idCategory';
    }else{
      idCategory=='0' ? q=q : q=q;
    }
    try{
      final jsonString = await http.get(
          ApiService().baseUrl+q,
          headers: {'Authorization':'','username':ApiService().username,'password':ApiService().password}
      ).timeout(Duration(seconds: ApiService().timerActivity));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        setState(() {
          isLoading=false;
          video = jsonResponse['result']['data'];
        });
        print("===> RESPONSE TESTIMONI $jsonResponse <===");
      }
      else {
        throw Exception('Failed to load photos');
      }
    }catch(e){
      print(e);
    }
  }
  int cloneIndex=0;
  Future<void> refresh() async{
    setState(() {
      isLoading=true;
      _tabController.index = cloneIndex;
    });
    loadTestimoni('');
  }

  Future search(param) async{
    setState(() {isLoading=true;});
    param==0?loadTestimoni(''):loadTestimoni(categoryArray[param]);
  }

  Future share(param,index) async{
    setState(() {
      isLoadingShare = true;
      cek = index;
    });

    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
      await WcFlutterShare.share(
          sharePopupTitle: 'Thaibah Share Testimoni Produk',
          subject: 'Thaibah Share Testimoni Produk',
          text: "$param",
          mimeType: 'text/plain'
      );
    });
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadTestimoni('');
    return true;
  }
  @override
  void initState() {
    super.initState();
    isLoading=true;
    isLoading1=true;
    loadTestimoni('');
    loadCategory();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: UserRepository().appBarNoButton(context,"Testimoni",<Widget>[]),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                pinned: false,
                snap: false,
                elevation: 5,
                backgroundColor: Colors.white,
                title: isLoading1?SkeletonFrame(width:double.infinity,height: 50):TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  onTap: (index) {
                    print(index);
                    setState(() {
                      _tabController.index = index;
                      cloneIndex = index;
                    });
                    search(index);
                  },
                  tabs: List.generate(categoryString.length, (index) => Tab(
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: UserRepository().textQ(categoryString[index], 12, Colors.white,FontWeight.bold, TextAlign.center)
                      ),
                      decoration: BoxDecoration(color: index == _tabController.index ? Colors.black : Colors.black12, borderRadius: BorderRadius.circular(20)),
                    ),
                  )),
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  indicatorWeight: 1,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                ),
              ),
              isLoading?SliverPadding(
                padding: EdgeInsets.all(2.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                    return UserRepository().loadingWidget();
                  },childCount: 1),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                ),
              ):
              LiquidPullToRefresh(
                  color: Colors.transparent,
                  backgroundColor:ThaibahColour.primary2,
                  key: _refresh,
                  onRefresh:refresh,
                  child: LoadMoreQ(
                    child: SliverFixedExtentList(
                      itemExtent: MediaQuery.of(context).size.height/1.5,
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return contents(
                              context,
                              video[index]['video'],
                              video[index]['name'],
                              video[index]['caption'],
                              video[index]['rating'],
                              video[index]['thumbnail']
                          );
                        },
                        childCount: video.length,
                      ),
                    ),
                    whenEmptyLoad: true,
                    delegate: DefaultLoadMoreDelegate(),
                    textBuilder: DefaultLoadMoreTextBuilder.english,
                    isFinish: video.length < perpage,
                    onLoadMore: _loadMore,
                  )

              )
            ],
          )
        )
      ),
    );
  }



  Widget contents(BuildContext context,link,title,caption,rating,picture){
    String cap='';
    if(caption.length > 70){
      cap = '${caption.substring(0,70)} ...';
    }
    else{
      cap = caption;
    }
    return InkWell(
        onTap: (){
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(builder: (context) => WidgetDetailVideo(
                param:'Testimoni Produk',
                video: link,
                caption: caption,
                rating:rating.toString()
            )),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: UserRepository().textQ(removeAllHtmlTags(title),12,Colors.black,FontWeight.bold,TextAlign.left),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular( 10.0)
                ),
              ),
              child: Center(
                  child:Image.network(
                    picture,fit: BoxFit.fitWidth,filterQuality: FilterQuality.high,width: MediaQuery.of(context).size.width/1,
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Html(data:caption,defaultTextStyle: TextStyle(color: Colors.black,fontFamily:ThaibahFont().fontQ),)
            ),
            Divider()
          ],
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
