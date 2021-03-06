import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/donasi/listDonasiModel.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/cardSaldo.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/auth/loginPhone.dart';
import 'package:thaibah/UI/component/donasi/screenInboxDonasi.dart';
import 'package:thaibah/UI/component/donasi/widget_donasi.dart';
import 'package:thaibah/UI/component/home/widget_artikel.dart';
import 'package:thaibah/UI/component/home/widget_top_slider.dart';
import 'package:thaibah/UI/component/islamic/asma_ui.dart';
import 'package:thaibah/UI/component/islamic/doaHarian.dart';
import 'package:thaibah/UI/component/islamic/masjidTerdekat.dart';
import 'package:thaibah/UI/component/islamic/quran_list_ui.dart';
import 'package:thaibah/UI/component/islamic/subDoaHadist.dart';
import 'package:thaibah/UI/component/sosmed/exploreFeed.dart';
import 'package:thaibah/UI/component/sosmed/listSosmed.dart';
import 'package:thaibah/bloc/donasi/donasiBloc.dart';
import 'package:thaibah/bloc/newsBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/resources/baseProvider.dart';
import 'package:thaibah/resources/logoutProvider.dart';



class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final userRepository = UserRepository();
  static String latitude = '';
  static String longitude = '';
  static String name= '';
  bool isLoading=false;
  bool isLoadmore=false;
  bool isToken=false;
  bool isTimeout=false;
  var sekarang;String echoWaktu='',echoKetWaktu;
  var shubuh,sunrise,dzuhur,ashar,magrib,isya;
  var city;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _timeString;
  PrayerModel prayerModel;
  Timer _timer;
  NewsModel newsModel;
  Future loadArtikel() async {
    final res = await BaseProvider().getProvider("berita?page=1&limit=4&category=artikel", newsModelFromJson);
    print("############################## RESPONSE RES ARTIKEL $res");
    if(res==ApiService().timeoutException||res==ApiService().socketException){
      setState(() {
        isLoading=false;
        isTimeout=true;
        isToken=false;
      });
    }
    else if(res==ApiService().tokenExpiredError){
      setState(() {
        isLoading=false;
        isTimeout=true;
        isToken=true;
      });
      UserRepository().notifDialog(context,"Informasi !!!", "Sesi anda telah habis", ()async{
        UserRepository().loadingQ(context);
        final res = await LogoutProvider().logout();
        if(res==true){
          setState(() {
            Navigator.pop(context);
          });
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
        }
      });
    }
    else{
      if(res is NewsModel){
        NewsModel result=res;
        setState(() {
          isLoading=false;
          isTimeout=false;
          isToken=false;
          newsModel = NewsModel.fromJson(result.toJson());
        });
      }
    }

  }
  Future<void> loadDonasi() async {
    final lat = await userRepository.getDataUser('latitude');
    final lng = await userRepository.getDataUser('longitude');
    print("STATUS PRAYER ${ApiService().baseUrl+'islamic/jadwalsholat?long=107.61861&lat=-6.90389'}");
    await listDonasiBloc.fetchListDonasi('&perpage=4');
    setState(() {
      isLoading=false;
    });
  }
  showNotification(String title, desc, ) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$desc', platform,payload: 'Nitish Kumar Singh is part time Youtuber');
  }
  Future<void> loadPrayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('lat');
    final lng = prefs.getDouble('lng');
    final token = await userRepository.getDataUser('token');
    final nama = await userRepository.getDataUser('name');
    var jsonString = await http.get(
        ApiService().baseUrl+'islamic/jadwalsholat?long=${lng.toString()}&lat=${lat.toString()}',
        headers: {'Authorization':token,'username':ApiService().username,'password':ApiService().password}
    );
    if (jsonString.statusCode == 200) {
      final jsonResponse = json.decode(jsonString.body);
      prayerModel = new PrayerModel.fromJson(jsonResponse);
      setState(() {
        name = nama;
        latitude = lat.toString();
        longitude = lng.toString();
        sekarang = new DateFormat('HHmmss').format(DateTime.now());
        shubuh = new DateFormat('HHmmss').format(prayerModel.result.fajr);
        sunrise = new DateFormat('HHmmss').format(prayerModel.result.sunrise);
        dzuhur = new DateFormat('HHmmss').format(prayerModel.result.dhuhr);
        ashar = new DateFormat('HHmmss').format(prayerModel.result.asr);
        magrib = new DateFormat('HHmmss').format(prayerModel.result.maghrib);
        isya = new DateFormat('HHmmss').format(prayerModel.result.isha);
        city = prayerModel.result.city;
      });
      _timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    } else {
      throw Exception('Failed to load info');
    }
  }
  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadPrayer();
    loadDonasi();
  }
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('hh:mm:ss').format(now);
    final String timeLocal = new DateFormat('HHmmss').format(now);
    print("SEKARANG $timeLocal");
    if(int.parse(timeLocal)==int.parse(shubuh)){
      showNotification('Hai $name','Selamat Menunaikan Sholat Shubuh');
    }
    if(int.parse(timeLocal)==int.parse(dzuhur)){
      showNotification('Hai $name','Selamat Menunaikan Sholat Dzuhur');
    }
    if(int.parse(timeLocal)==int.parse(ashar)){
      showNotification('Hai $name','Selamat Menunaikan Sholat Ashar');
    }
    if(int.parse(timeLocal)==int.parse(magrib)){
      showNotification('Hai $name','Selamat Menunaikan Sholat Maghrib');
    }
    if(int.parse(timeLocal)==int.parse(isya)){
      showNotification('Hai $name','Selamat Menunaikan Sholat Isya');
    }
    setState(() {
      _timeString = formattedDateTime;
    });
    if(int.parse(timeLocal) > int.parse(isya) && int.parse(timeLocal) < 235900){
      setState(() {
        echoKetWaktu='Isya';
        echoWaktu = new DateFormat('HH:mm').format(prayerModel.result.isha);
      });
    }
    if(int.parse(timeLocal) < int.parse(shubuh) && int.parse(timeLocal) > 000000){
     setState(() {
       echoKetWaktu='Tahajud';
       echoWaktu = new DateFormat('HH:mm').format(DateTime.now());

     });
    }
    if(int.parse(timeLocal) >= int.parse(shubuh) && int.parse(timeLocal) < int.parse(sunrise)){
      setState(() {
        echoKetWaktu='Shubuh';
        echoWaktu = new DateFormat('HH:mm').format(prayerModel.result.fajr);
      });
    }
    if(int.parse(timeLocal) >= int.parse(dzuhur) && int.parse(timeLocal) < int.parse(ashar)){
      setState(() {
        echoKetWaktu='Dzuhur';
        echoWaktu = new DateFormat('HH:mm').format(prayerModel.result.dhuhr);
      });
    }
    if(int.parse(timeLocal) >= int.parse(ashar) && int.parse(timeLocal) < int.parse(magrib)){
      setState(() {
        echoKetWaktu='Ashar';
        echoWaktu = new DateFormat('HH:mm').format(prayerModel.result.asr);
      });
    }
    if(int.parse(timeLocal) >= int.parse(magrib) && int.parse(timeLocal) < int.parse(isya)){
      setState(() {
        echoKetWaktu='Maghrib';
        echoWaktu = new DateFormat('HH:mm').format(prayerModel.result.maghrib);
      });
    }
    // loadPrayer();

  }
  Future onSelectNotification(String payload) async {
    print(payload);
  }
  Future loadAll()async{
    await loadArtikel();
    await loadDonasi();
    await loadPrayer();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    isLoading=true;
    loadAll();
    _timeString = DateFormat('hh:mm:ss').format(DateTime.now());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarNoButton(context, "Beranda",<Widget>[
        Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>ScreenInboxDonasi()));
              },
              child: Container(
                margin:EdgeInsets.only(top:16.0,right:10),
                child: Icon(Icons.notifications_none,color: Colors.grey),
              ),
            ),

          ],
        ),
      ]),


      body: isToken?UserRepository().modeUpdate(context):LiquidPullToRefresh(
        color: ThaibahColour.primary2,
        backgroundColor:Colors.white,
        key: _refresh,
        onRefresh: refresh,
        child: SingleChildScrollView(
          primary: true,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 10.0),
              WidgetTopSlider(),
              SizedBox(height: 10.0),
              lineSection(context),
              Padding(
                padding: EdgeInsets.only(left:0,right:5,top:10,bottom:10),
                child: Container(
                  child: cardSecondSection(context),
                ),
              ),
              lineSection(context),
              SizedBox(height: 10.0),
              cardThreeSection(context),
              SizedBox(height: 15.0),
              lineSection(context),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserRepository().textQ("Donasi Terbaru",14,Colors.black,FontWeight.bold,TextAlign.left),
                          UserRepository().textQ("Mari kita bantu mereka yang membutuhkan",12,Colors.grey,FontWeight.normal,TextAlign.left),
                        ],
                      ),
                    ],
                  )
              ),
              donasi(context),
              Container(
                padding: EdgeInsets.only(left:15,right:15),
                child: UserRepository().buttonQ(context,(){
                  Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => WidgetDonasi(any:'',noScaffold: '',))).whenComplete(() => loadDonasi());
                },"Lihat Semua"),
              ),
              SizedBox(height: 10.0),
              lineSection(context),
              // titleSection(context,"Artikel Untuk Kamu","Berita terbaru disekitar kita"),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserRepository().textQ("Artikel Untuk Kamu",14,Colors.black,FontWeight.bold,TextAlign.left),
                          UserRepository().textQ("Berita terbaru disekitar kita",12,Colors.grey,FontWeight.normal,TextAlign.left),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => ScreenArtikel(noScaffold: '',))).whenComplete(() => loadArtikel());
                        },
                        child: UserRepository().textQ("Lihat Semua",14,Colors.green,FontWeight.bold,TextAlign.left),
                      )

                    ],
                  )
              ),
              cardSixSection(context),
              SizedBox(height: 10.0),
              lineSection(context),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserRepository().textQ("Sosial Media",14,Colors.black,FontWeight.bold,TextAlign.left),
                          UserRepository().textQ("Kegiatan member thaibah",12,Colors.grey,FontWeight.normal,TextAlign.left),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => ExploreFeed()));

                        },
                        child: UserRepository().textQ("Lihat Semua",14,Colors.green,FontWeight.bold,TextAlign.left),
                      )

                    ],
                  )
              ),
              ListSosmed(),
            ],
          ),
        ),
      ),
    );

  }
  Widget titleSection(BuildContext context,title,desc){
    return Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserRepository().textQ(title,14,Colors.black,FontWeight.bold,TextAlign.left),
            UserRepository().textQ(desc,12,Colors.grey,FontWeight.normal,TextAlign.left),
          ],
        )
    );
  }
  Widget lineSection(BuildContext context){
    return Container(
      color: Colors.grey[200],
      width: MediaQuery.of(context).size.width,
      height: 10.0,
    );
  }
  Widget cardSecondSection(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        isLoading?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:EdgeInsets.all(10),
              decoration:BoxDecoration(
                borderRadius:  BorderRadius.circular(100.0),
              ) ,
              child: SkeletonFrame(width:50,height: 50),
            ),
            SizedBox(height: 5.0),
            SkeletonFrame(width:50,height: 15)
          ],
        ):
        CardEmoney(imgUrl:'ALQURAN.png',title:'Al-Quran',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => QuranListUI()));
        }),
        isLoading?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:EdgeInsets.all(10),
              decoration:BoxDecoration(
                borderRadius:  BorderRadius.circular(100.0),
              ) ,
              child: SkeletonFrame(width:50,height: 50),
            ),
            SizedBox(height: 5.0),
            SkeletonFrame(width:50,height: 15)
          ],
        ):CardEmoney(imgUrl:'DOA.png',title:'Doa Harian',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')));
        },),
        isLoading?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:EdgeInsets.all(10),
              decoration:BoxDecoration(
                borderRadius:  BorderRadius.circular(100.0),
              ) ,
              child: SkeletonFrame(width:50,height: 50),
            ),
            SizedBox(height: 5.0),
            SkeletonFrame(width:50,height: 15)
          ],
        ):CardEmoney(imgUrl:'HADIS.png',title:'Hadits',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));
        },),
        isLoading?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:EdgeInsets.all(10),
              decoration:BoxDecoration(
                borderRadius:  BorderRadius.circular(100.0),
              ) ,
              child: SkeletonFrame(width:50,height: 50),
            ),
            SizedBox(height: 5.0),
            SkeletonFrame(width:50,height: 15)
          ],
        ):CardEmoney(imgUrl:'ASMA.png',title:'Asma Allah',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => AsmaUI()));
        },),
      ],
    );



  }
  Widget cardThreeSection(BuildContext context) {
    return isLoading?Container(
      padding:EdgeInsets.all(15),
      decoration:BoxDecoration(
        borderRadius:  BorderRadius.circular(100.0),
      ) ,
      child: SkeletonFrame(width:double.infinity,height:100),
    ):Container(
      padding: EdgeInsets.only(left:15,right:15),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius:  BorderRadius.circular(10.0),
          image: DecorationImage(
              image: NetworkImage("https://dekdun.files.wordpress.com/2011/05/picture1.png"),
              fit: BoxFit.cover
          ),
        ),
        child: new Align(
          child: new Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius:  BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.only(left:10.0,right:10.0,top:30.0,bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    UserRepository().textQ("Waktu Sholat $echoKetWaktu",14,Colors.white,FontWeight.bold,TextAlign.left),
                    SizedBox(height: 10.0),
                    UserRepository().textQ(echoWaktu,24,Colors.white,FontWeight.bold,TextAlign.left),
                    UserRepository().textQ(_timeString,12,Colors.white,FontWeight.bold,TextAlign.left),
                    // SizedBox(height: 10.0),
                    // UserRepository().textQ("-1 Jam : 32 Menit menuju Ashar",12,Colors.white,FontWeight.bold,TextAlign.left),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(Icons.place,color: Colors.white),
                        Container(
                          width:  MediaQuery.of(context).size.width/1.9,
                          child: UserRepository().textQ(city,10,Colors.white,FontWeight.normal,TextAlign.left),
                        )
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap:(){
                    Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>  MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())));
                  },
                  child: Container(
                    padding:EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius:  BorderRadius.circular(100.0),
                        border: Border.all(color: Colors.white)
                    ),
                    child:  Center(
                      child: UserRepository().textQ("Masjid",12,Colors.white,FontWeight.bold,TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
            width: double.infinity,
          ),
        ),
      ),
    );

  }
  Widget donasi(BuildContext context){
    return StreamBuilder(
        stream: listDonasiBloc.getResult,
        builder: (context, AsyncSnapshot<ListDonasiModel> snapshot) {
          if(snapshot.hasData){
            return Padding(
              padding: EdgeInsets.only(left:5.0,right:5.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                      callback: ()=>loadDonasi(),
                      noDeadline: snapshot.data.result.data[index].nodeadline,
                    );
                  }
              ),
            );
          }
          else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return LoadingDonasi();
        }
    );
  }
  Widget cardSixSection(BuildContext context){
    return isLoading?LoadingArtikel():Padding(
      padding: EdgeInsets.only(left:5.0,right:5.0),
      child: ListView.builder(
          primary: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: newsModel.result.data.length,
          itemBuilder:(context,index){
            return WidgetArtikel(
              id: newsModel.result.data[index].id,
              category: newsModel.result.data[index].category,
              image:newsModel.result.data[index].picture ,
              title:newsModel.result.data[index].title ,
              desc:newsModel.result.data[index].caption ,
              link: newsModel.result.data[index].link,
            );
          }
      ),
    );
  }

}

