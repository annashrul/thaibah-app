import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/detailInspirasi.dart';
import 'package:thaibah/bloc/categoryBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'dart:async';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:thaibah/Model/tertimoniModel.dart'  as Prefix1;
import 'package:http/http.dart' as http;

class TestiSuplemen extends StatefulWidget {
  @override
  _TestiSuplemenState createState() => _TestiSuplemenState();
}

class _TestiSuplemenState extends State<TestiSuplemen> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isLoading=false;
  bool isLoading1=false;
  TabController _tabController;
  bool isLoadingShare = false;
  int cek = 0;
  int perpage=10;
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
    String q='testi?tipe=0&page=1&limit=${perpage.toString()}';
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

  loadNextData() {
    perpage = perpage+=10;
    Future.delayed(Duration(seconds: 3), () {
      loadTestimoni('');
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    isLoading=true;
    isLoading1=true;
    loadTestimoni('');
    loadCategory();
  }

  final _itemExtent = 56.0;

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
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
              SliverFixedExtentList(
                itemExtent: MediaQuery.of(context).size.height/2.5,  // I'm forcing item heights
                delegate: SliverChildBuilderDelegate((context, index) {
                  String cap='';
                  if(video[index]['caption'].length > 70){
                    cap = '${video[index]['caption'].substring(0,70)} ...';
                  }
                  else{
                    cap = video[index]['caption'];
                  }
                  return InkWell(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).push(
                        new CupertinoPageRoute(builder: (context) => DetailInspirasi(
                            param:'Testimoni Produk',
                            video: video[index]['video'],
                            caption: video[index]['caption'],
                            rating:video[index]['rating'].toString()
                        )),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height/4,
                          child: CachedNetworkImage(
                            imageUrl: video[index]['thumbnail'],
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)),
                            ),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(0.0),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(video[index]['thumbnail']),
                          ),
                          title: Html(
                            data:cap,
                            defaultTextStyle: TextStyle(fontSize:12.0,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),
                          ),
                          trailing: index == cek ? isLoadingShare ? CircularProgressIndicator(strokeWidth:10, valueColor: new AlwaysStoppedAnimation<Color>(ThaibahColour.primary1)) : PopupMenuButton(
                            onSelected: (e) async{
                              if(e=='0'){
                                setState(() {
                                  isLoadingShare = true;
                                });

                                share(video[index]['video'],index);
                              }else{
                                Navigator.of(context, rootNavigator: true).push(
                                  new CupertinoPageRoute(builder: (context) => DetailInspirasi(
                                      param:'Testimoni Produk',
                                      video: video[index]['video'],
                                      caption: video[index]['caption'],
                                      rating:video[index]['rating'].toString()
                                  )),
                                );
                              }
                            },
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              new PopupMenuItem<String>(child: Html(data:'Bagikan',defaultTextStyle: TextStyle(fontSize:14,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),), value: '0'),
                              new PopupMenuItem<String>(child: Html(data:'Putar',defaultTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),), value: '1'),
                            ],
                          ):PopupMenuButton(
                            onSelected: (e) async{
                              print(e);
                              if(e=='0'){
                                setState(() {
                                  isLoadingShare = true;
                                });
                                share(video[index]['video'],index);
                              }else{
                                Navigator.of(context, rootNavigator: true).push(
                                  new CupertinoPageRoute(builder: (context) => DetailInspirasi(
                                      param:'Testimoni Produk',
                                      video: video[index]['video'],
                                      caption: video[index]['caption'],
                                      rating:video[index]['rating'].toString()
                                  )),
                                );
                              }
                            },
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              new PopupMenuItem<String>(child: Html(data:'Bagikan',defaultTextStyle: TextStyle(fontSize:14,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),), value: '0'),
                              new PopupMenuItem<String>(child: Html(data:'Putar',defaultTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),), value: '1'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                  childCount: video.length,
                ),
              ),
            ],
          )
      ),
    );
  }

}


