
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/suratModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/islamic/myQuran.dart';
import 'file:///E:/THAIBAH/mobile/thaibah-app/lib/UI/component/islamic/quran_read_ui.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:unicorndial/unicorndial.dart';
import 'dart:async';
import '../../Widgets/SCREENUTIL/ScreenUtilQ.dart';

class QuranListUI extends StatefulWidget {
  @override
  QuranListUIState createState() => new QuranListUIState();
}
enum PlayerState { stopped, playing, paused }

class QuranListUIState extends State<QuranListUI> {

  bool isLoading = false;
  List colors = [Color(0xFF3f51b5), Color(0xFF116240), Colors.green, Colors.blue];
  Random random = new Random();
  Widget appBarTitle = Html(data:'Daftar Surat',defaultTextStyle: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold));
  Icon actionIcon = new Icon(Icons.search, color: Colors.black,);
  final key = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";


  bool isPLaying = false;
  bool isLoaded= false;
  var list;
  AudioPlayer audioPlayer;
  String currentPlaying = '';

  Future Cari() async{
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute(builder: (context) => QuranReadUI(id: "1",param:_searchQuery.text,param1:'search')),
    );
  }


  Future<void> refresh() async {
    setState(() {
      isLoading = true;
    });
    suratBloc.fetchSuratList();
  }

  var childButtons = List<UnicornButton>();


  void load(i,url,indonesia,arab) async{
    print(url);
    setState(() {
      currentPlaying = "${indonesia} ( ${arab} )";
    });
    await audioPlayer.play(url);
    setState(() {
      isLoaded = true;
      isPLaying = true;
    });
    print(url);
  }

  void playpause()async{
    if(isPLaying){
      await audioPlayer.pause();
      setState(() {
        isPLaying = false;
      });
    } else {
      await audioPlayer.resume();
      setState(() {
        isPLaying = true;
      });
    }
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
    super.initState();
    _IsSearching = false;
    loadTheme();
    refresh();
    audioPlayer = new AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
    setState(() {
      isPLaying = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Note",
        currentButton: FloatingActionButton(
          heroTag: "Note",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => MyQuran(param:'note')),
            );
          },
        )
      )
    );
    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Favorite",
        currentButton: FloatingActionButton(
          heroTag: "Favorite",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.favorite),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => MyQuran(param:'fav')),
            );
          },
        )
      )
    );
    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Check",
        currentButton: FloatingActionButton(
          heroTag: "Check",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.check_circle),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => MyQuran(param:'checked')),
            );
          },
        )
      )
    );
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
//    return PlayerWidget(url: "http://ia802609.us.archive.org/13/items/quraninindonesia/010Yunus.mp3",);
    return Scaffold(
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.green,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.toc),
          childButtons: childButtons
      ),
      bottomNavigationBar: !isLoaded ? null: controls(),
      appBar:buildBar(context),
//      body: PlayerWidget(url: "http://ia802609.us.archive.org/13/items/quraninindonesia/010Yunus.mp3",),
      body: StreamBuilder(
        stream: suratBloc.allSurat,
        builder: (context, AsyncSnapshot<SuratModel> snapshot) {
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return ListView.builder(
              itemCount: 9,
              itemBuilder: (context, index){
                return GestureDetector(
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        leading:SkeletonFrame(width: 50.0,height: 50.0),
                        title: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                        subtitle:SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16),
                        isThreeLine: false,
                      ),
                    )
                );
              }
          );
        },
      ),

    );
  }

  Widget controls (){
    return Container(
      height: 50.0,
      padding: EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: !isPLaying ? Icon(Icons.play_circle_outline): Icon(Icons.pause_circle_outline),
            onPressed: () => playpause(),
          ),
          Container(width: 100.0,),
          Text(currentPlaying,style: TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize:ScreenUtilQ.getInstance().setSp(30)),)

        ],
      ),
    );
  }


  Widget buildContent(AsyncSnapshot<SuratModel> snapshot, BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    if(snapshot.data.result.length > 0){
      return RefreshIndicator(
        child: ListView.builder(
            itemCount: snapshot.data.result.length,
            itemBuilder: (context, index){
              return GestureDetector(
                  onTap: (){
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => QuranReadUI(total:snapshot.data.result[index].jumlahAyat.toString(),id: snapshot.data.result[index].id.toString(),param: 'detail',param1:snapshot.data.result[index].suratIndonesia)),
                    );
                  },
                  child: Card(
                    color:(index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9),
                    elevation: 0,
                    child: ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 50.0,
                        height: 50.0,
                        padding: const EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors[random.nextInt(4)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Html(customTextAlign: (_) => TextAlign.center, data:snapshot.data.result[index].suratArab, defaultTextStyle: new TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.white, fontSize:10,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      title: Html(data:snapshot.data.result[index].suratIndonesia+' - '+snapshot.data.result[index].arti, defaultTextStyle: TextStyle(fontSize:12,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
                      subtitle:
                      Html(data:"Terdiri dari "+snapshot.data.result[index].jumlahAyat.toString()+" ayat", defaultTextStyle: TextStyle(fontSize:12,fontFamily:ThaibahFont().fontQ),),
                      trailing: InkWell(
                        onTap: () => load(index,snapshot.data.result[index].suratAudio,snapshot.data.result[index].suratIndonesia,snapshot.data.result[index].suratArab),
                        child: Icon(Icons.play_circle_outline),
                      ),
//                      isThreeLine: false,
                    ),
                  )
              );
            }
        ),
        onRefresh: refresh,
        key: _refresh,
      );
    }else{
      return Container(
        child: Center(
          child: Text('Data Tidak Ada'),
        ),
      );
    }
  }
  Widget buildBar(BuildContext context) {
    return new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Colors.white,Colors.white
//                Color(0xFF30cc23)
              ],
            ),
          ),
        ),
        centerTitle: false,
        title: appBarTitle,
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.black,);
                this.appBarTitle = new TextFormField(
                  controller: _searchQuery,
                  autofocus: true,
                  style: new TextStyle(
                    color: Colors.black,fontFamily: ThaibahFont().fontQ
                  ),
                  decoration: new InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
//                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Tulis Sesuatu Disini ...",
                      hintStyle: new TextStyle(color: Colors.black,fontFamily: ThaibahFont().fontQ)
                  ),
                  onFieldSubmitted: (value){
                    setState(() {
                      isLoading = true;
                    });
                    Cari();
                  },
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });

  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.black,);
      this.appBarTitle = Html(data:'Daftar Surat',defaultTextStyle: TextStyle(color:Colors.black,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold));
      _IsSearching = false;
      _searchQuery.clear();

    });
  }



}




