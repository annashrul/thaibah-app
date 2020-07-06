import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future<void> loadTestimoni(var idCategory) async{
    String q='';
    if(idCategory!=''){
      q = 'testi?tipe=1&page=1&limit=${perpage.toString()}&category=$idCategory';
    }else{
      if(idCategory=='0'){
        q='testi?tipe=1&page=1&limit=${perpage.toString()}';
      }else{
        q='testi?tipe=1&page=1&limit=${perpage.toString()}';
      }

    }
    print(q);
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
        print("############### RESPONSE $jsonResponse");
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
          text: "${param}",
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
    loadTheme();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
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
              SliverToBoxAdapter(
                child: video.length==0?Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.center,children: <Widget>[Container(height: 600.0,child:Center(child:Text('Tidak Ada Data', style: TextStyle(fontSize: 15,fontFamily: ThaibahFont().fontQ,fontWeight: FontWeight.bold),)))],):RefreshIndicator(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(1.0),
                        height: MediaQuery.of(context).size.height/1,
                        child: InfiniteGridView(
                          loadingWidget:Center(child: CircularProgressIndicator(strokeWidth: 10)),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height/5.9,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: _signInButton(video[index]['video'],video[index]['caption'],video[index]['rating'].toString()),
                                    ),
                                    decoration:
                                    BoxDecoration(
                                      color: Colors.black.withOpacity(0.9),
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter:
                                        ColorFilter.mode(Colors.black.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: new NetworkImage(
                                          video[index]['thumbnail'],
                                        ),
                                      ),
                                    ),
//                                    decoration: BoxDecoration(
//                                        color: Color.fromRGBO(255, 255, 255, 0.19),
//                                        image: DecorationImage(
//                                          image: NetworkImage(video[index]['thumbnail']),
//                                          fit: BoxFit.cover,
//                                        )
//                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width/1,
                                    height: ScreenUtilQ.getInstance().setHeight(60),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [statusLevel!='0'?warna1:Color(0xFF116240),statusLevel!='0'?warna2:Color(0xFF30CC23)]),
                                        borderRadius: BorderRadius.circular(0.0),
                                        boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isLoadingShare = true;
                                          });
//
                                          share(video[index]['video'],index);
                                        },
                                        child: Center(
                                          child: index == cek ? isLoadingShare ? CircularProgressIndicator(strokeWidth:10, valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))
                                          ):Text("BAGIKAN VIDEO", style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)) : Text("BAGIKAN VIDEO", style: TextStyle(color: Colors.white,fontFamily:ThaibahFont().fontQ,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                            );
                          },
                          itemCount: video.length,
                          hasNext: video.length >= perpage,
                          nextData: this.loadNextData,
                        )
                    ),
                    onRefresh: refresh
                ),
              ),

            ],
          )
      ),
    );
  }
  Widget _signInButton(var video,var caption,var rating) {
    return ButtonTheme(
        height: 50,
        minWidth: 50,
        child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => DetailInspirasi(
                    param:'Testimoni Produk',
                    video: video,
                    caption: caption,
                    rating:rating.toString()
                )),
              );
            }, //
            child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 10,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(Icons.play_circle_outline,size: 70.0,color: Colors.white,)
                          )
                      )
                    ]
                )
            )
        )
    );
  }

}
