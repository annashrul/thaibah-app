import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/loadMoreQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/detailInspirasi.dart';
import 'package:thaibah/bloc/testiBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:http/http.dart' as http;

class TestiKavling extends StatefulWidget {
  @override
  _TestiKavlingState createState() => _TestiKavlingState();
}

class _TestiKavlingState extends State<TestiKavling> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive => true;
  bool isLoading=false;
  bool isLoading1=false;
  TabController _tabController;
  Color warna1;
  Color warna2;
  String statusLevel ='0';
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
    String q='testi?tipe=1&page=1&limit=${perpage.toString()}';
    if(idCategory!=''){
      q += '&category=$idCategory';
    }else{
      idCategory=='1' ? q=q : q=q;
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
    loadTheme();
  }

  final _itemExtent = 56.0;

  @override
  Widget build(BuildContext context) {
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
                title: isLoading1?Center(child: CircularProgressIndicator(strokeWidth: 10,valueColor: new AlwaysStoppedAnimation<Color>(statusLevel!='0'?warna1:ThaibahColour.primary1)),):TabBar(
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
                        child: Text(
                          categoryString[index],
                          style: TextStyle(fontSize: 15,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(color: index == _tabController.index ? warna1 : Colors.black12, borderRadius: BorderRadius.circular(20)),
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 10, valueColor: new AlwaysStoppedAnimation<Color>(statusLevel!='0'?warna1:ThaibahColour.primary1)),
                          ),
                        )
                      ],
                    );
                  },childCount: 1),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                ),
              ):
              SliverFixedExtentList(
                itemExtent: MediaQuery.of(context).size.height/2,  // I'm forcing item heights
                delegate: SliverChildBuilderDelegate((context, index) {
                  String cap='';
                  if(video[index]['caption'].length > 100){
                    cap = '${video[index]['caption'].substring(0,100)} ...';
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
                          height: ScreenUtilQ.getInstance().setHeight(400),
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
                          subtitle: Text(video[index]['category'], style: TextStyle(color: Colors.grey, fontFamily: ThaibahFont().fontQ)),
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
                              new PopupMenuItem<String>(child: const Text('Bagikan'), value: '0'),
                              new PopupMenuItem<String>(child: const Text('Putar'), value: '1'),
                            ],
                          ):PopupMenuButton(
                            onSelected: (e) async{
                              print(e);
                              if(e=='0'){
                                setState(() {
                                  isLoadingShare = true;
                                });
                                share(video[index]['video'],index);
                              }
                            },
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              new PopupMenuItem<String>(child: const Text('Bagikan'), value: '0'),
                              new PopupMenuItem<String>(child: const Text('Putar'), value: '1'),
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
