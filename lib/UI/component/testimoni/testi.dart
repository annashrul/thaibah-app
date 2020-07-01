import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/categoryModel.dart' as Prefix1;
import 'package:thaibah/Model/categoryModel.dart';
import 'package:thaibah/Model/tertimoniModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/component/testimoni/testiKavling.dart';
import 'package:thaibah/bloc/categoryBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/config/api.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'dart:async';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class Testimoni extends StatefulWidget {
  @override
  _TestimoniState createState() => _TestimoniState();
}

class _TestimoniState extends State<Testimoni> with SingleTickerProviderStateMixin  {
  int currentPos;
  String stateText;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;
  Color warna1;
  Color warna2;
  String statusLevel ='0';
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
    print('#################### AKTIF INDEX TESTIMONI #####################');
    currentPos = 0;
    stateText = "Video not started";
    super.initState();
    loadTheme();

  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      statusLevel!='0'?warna1:Color(0xFF116240),
                      statusLevel!='0'?warna2:Color(0xFF30cc23)
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              title: Text('Testimoni', style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 2,
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white, fontFamily: 'Rubik',fontSize: 16),
                  tabs: <Widget>[
                    Tab(text: "Produk",),
                    Tab(text: "Bisnis"),
                  ]
              ),
            ),
            body: TabBarView(
                children: <Widget>[
//                  TestiSuplemen(),
                  IndexTestimoni(),
                  TestiKavling(),
                ]
            ),
          )
      ),
    );
  }

}


class IndexTestimoni extends StatefulWidget {
  @override
  _IndexTestimoniState createState() => _IndexTestimoniState();
}

class _IndexTestimoniState extends State<IndexTestimoni> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isLoading=false;
  final List<YoutubePlayerController> tampung= [];
  var res = [];
  int i =0;bool isLoadingShare = false;
  int cek = 0;
  final _bloc = CategoryBloc();

  String _currentItemSelectedCategory=null;
  TestimoniModel testimoniModel;
  Future<void> loadData() async{
    try{
      final jsonString = await http.get(
          ApiService().baseUrl+'testi?tipe=0&page=1&limit=100',
          headers: {'Authorization':'','username':ApiService().username,'password':ApiService().password}
      ).timeout(Duration(seconds: ApiService().timerActivity));
      if (jsonString.statusCode == 200) {
        final jsonResponse = json.decode(jsonString.body);
        testimoniModel = new TestimoniModel.fromJson(jsonResponse);
        testimoniModel.result.data.forEach((element) {
          i++;
          tampung.add(YoutubePlayerController(
            initialVideoId: YoutubePlayer.convertUrlToId(element.video),
            flags: const YoutubePlayerFlags(
              autoPlay: false,
            ),
          ));
          res.add(element.video);
          print("ELEMET $element");
        });
        setState(() {
          isLoading=false;
        });
        print("load data $res");
      }
      else {
        throw Exception('Failed to load photos');
      }
    }catch(e){
      print(e);
    }
  }
  Future<void> refresh() async {
    setState(() {
      isLoading=true;
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadData();
  }

  Future share(param,index) async{
    print("PARAM ${param[index-1]}");
    print("PARAM $index");
    setState(() {
      isLoadingShare = true;
      cek = index-1;
    });

    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
      await WcFlutterShare.share(
          sharePopupTitle: 'Thaibah Share Testimoni Produk',
          subject: 'Thaibah Share Testimoni Produk',
          text: "${param[index-1]}",
          mimeType: 'text/plain'
      );
    });
  }
  void _onDropDownItemSelectedCategory(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      _currentItemSelectedCategory = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
    _bloc.fetchCategoryList('testimoni');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading?_loading(context):Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child:Padding(
            padding: EdgeInsets.only(left:5.0,right:5.0),
            child:  kategori(context),
          ),
        ),
        Expanded(
          flex: 9,
            child: RefreshIndicator(
          child: Scrollbar(
              child:Container(
                child: GridView.builder(
                    itemCount: tampung.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context,int index){
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                flex:8,
                                child: YoutubePlayer(
                                  liveUIColor: Color(0xFFFFFFFF),
                                  key: ObjectKey(tampung[index]),
                                  controller: tampung[index],
                                  bottomActions: [
                                    CurrentPosition(),
                                    const SizedBox(width: 10.0),
                                    ProgressBar(isExpanded: true),
                                    const SizedBox(width: 10.0),
                                    RemainingDuration(),
                                    FullScreenButton(),
                                  ],
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: MediaQuery.of(context).size.width/1,
                                height: ScreenUtilQ.getInstance().setHeight(100),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
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
                                      print(cek);
                                      share(res,index+1);
                                    },
                                    child: Center(
                                      child: index == cek ? isLoadingShare ? CircularProgressIndicator(
                                          strokeWidth:10,
                                          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))
                                      ):Text("BAGIKAN VIDEO", style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)) : Text("BAGIKAN VIDEO", style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
//                                  child: index==cek?CircularProgressIndicator(strokeWidth:10,valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF))):Text("BAGIKAN VIDEO", style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)):Text("BAGIKAN VIDEO", style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                ),
              )
          ),
          onRefresh: refresh,
        )
        )
      ],
    );
  }

  Widget kategori(BuildContext context) {
    return StreamBuilder(
      stream:  _bloc.getResult,
      builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.result.length,
            itemBuilder: (context,int index){
              return Text(snapshot.data.result[index].title);
            }
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return CircularProgressIndicator();
      },
//        builder: (context,AsyncSnapshot<CategoryModel> snapshot) {
//          if(snapshot.hasData){
//            print("SNAPSHOT $snapshot");
//            return new InputDecorator(
//              decoration: const InputDecoration(
//                  labelText: 'Kategori Testimoni:',
//                  labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontFamily: "Rubik",fontSize: 20)
//              ),
//              isEmpty: _currentItemSelectedCategory == null,
//              child: new DropdownButtonHideUnderline(
//                child: new DropdownButton<String>(
//                  value: _currentItemSelectedCategory,
//                  isDense: true,
//                  onChanged: (String newValue) {
//                    setState(() {
//                      _onDropDownItemSelectedCategory(newValue);
//                    });
//                  },
//                  items: snapshot.data.result.map((Prefix1.Result items){
//                    return new DropdownMenuItem<String>(
//                      value: items.id.toString(),
//                      child: Text(items.title,style: TextStyle(fontFamily: 'Rubik',fontSize: 12.0),),
//                    );
//                  }),
//
//                ),
//              ),
//            );
//          }else if(snapshot.hasError){
//            return Text(snapshot.error);
//          }
//          return Center(
//              child: new LinearProgressIndicator(
//                valueColor:new AlwaysStoppedAnimation<Color>(Colors.green),
//              )
//          );
//        }
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      child: GridView.builder(
          itemCount:10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context,int index){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex:8,
                      child:  SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: MediaQuery.of(context).size.height/3),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child:SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: ScreenUtilQ.getInstance().setHeight(100)),
                    ),
                  )
                ],
              ),
            );
          }
      ),

    );
  }
}
