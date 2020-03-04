import 'dart:async';
import 'dart:ui';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Widgets/alertq.dart';



class MainUI extends StatefulWidget {
  @override
  _MainUIState createState() => _MainUIState();
}


class _MainUIState extends State<MainUI> {
//  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
//  List<Product> dealsListItems;
//  bool isExpanded = false;
//  String greetings, header_greetings, imsakiyah;
//  bool isData = false;
//  bool isLoading = false;
//  bool isLoading2 = false;
//
//  List<Product> recommendListItems;
//  var scaffoldKey = GlobalKey<ScaffoldState>();
//  List<Product> trendingListItems;
//
//  String _imsak,_sunrise,_fajr,_dhuhr,_asr,_sunset,_maghrib,_isha,_midnight;
//  String _hijri,_masehi,_name,_saldo="Rp 0",_saldoBonus,_idSurat, _surat,_ayat,_suratAyat,_terjemahan, _inspiration,_saldoMain;
//  bool showAlignmentCards = false;
//  String pinku = "";
//  double _height;
//  double _width;
//  PageController pageController = PageController(initialPage: 0);
//  StreamController<int> indexcontroller = StreamController<int>.broadcast();
//  int index = 0;
//  GlobalKey _keyList = GlobalKey();
//  final userRepository = UserRepository();
//
//  SharedPreferences preferences;
//
//  Future loadData() async {
//    final prefs = await SharedPreferences.getInstance();
//    print("PINKU = "+prefs.getString('pin'));
//
//    String id = await userRepository.getID();
//    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
//    if (jsonString.statusCode == 200) {
//      final jsonResponse = json.decode(jsonString.body);
//      Info response = new Info.fromJson(jsonResponse);
//      _name = (response.result.name.toString());
//      _saldo = (response.result.saldo);
//      _saldoBonus = (response.result.saldoBonus.toString());
//      _masehi = (response.result.masehi.toString());
//      _hijri = (response.result.hijri.toString());
//      _idSurat = (response.result.ayat.id);
//      _surat = (response.result.ayat.surat.toString());
//      _ayat = (response.result.ayat.ayat.toString());
//      _suratAyat = (response.result.ayat.surahAyat);
//      _terjemahan = (response.result.ayat.terjemahan);
//      _inspiration = (response.result.inspiration);
//      _saldoMain = (response.result.saldoMain);
//      setState(() {
//        pinku = prefs.getString('pin');
//        isLoading = false;
//      });
//    } else {
//      throw Exception('Failed to load list');
//    }
//  }
//  String id="";
//  checkLoginStatus() async {
//    preferences = await SharedPreferences.getInstance();
//    setState(() {
//      id    = preferences.getString("id");
//    });
//
//    if(preferences.getString("id") == null) {
//      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
//    }
//  }
//
//
//  @override
//  void initState() {
//    super.initState();
//    checkLoginStatus();
//    loadData();
//
//    isLoading = true;
//    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
//    var settings = {
//      OSiOSSettings.autoPrompt: false,
//      OSiOSSettings.promptBeforeOpeningPushUrl: true
//    };
//    OneSignal.shared.init("6a4c55fd-d96d-427f-8634-d2c4b9d96d69", iOSSettings: settings);
//    OneSignal.shared.setNotificationOpenedHandler((notification) {
//      var notify = notification.notification.payload.additionalData;
//      print("################################################################################");
//      print(notify);
//      print("################################################################################");
//      if (notify["type"] == "berita") {
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailBeritaUI(id: notify['id'],category: notify['category'])));
//      }
//      if (notify["type"] == "transaksi_bonus") {
//        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
//      }
//      if (notify["type"] == "transaksi_suplemen") {
//        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
//      }
//      if (notify["type"] == "transaksi_tanah") {
//        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
//      }
//      if (notify["type"] == "transaksi_ppob") {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => DetailHistoryPPOB(kdTrx: notify['id']),
//          ),
//        );
//      }
//      if (notify["type"] == "transaksi_saldo") {
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
//      }
//    });
//
//  }
//
//
//  @override
//  void dispose() {
//    super.dispose();
//    indexcontroller.close();
//
//  }
//
//
//
//  Widget pembatas(){
//    return Padding(
//      padding: EdgeInsets.only(right: 20,top:0,left:20,bottom:20),
//      child: SizedBox(
//        height: 10.0,
//        child: new Center(
//          child: new Container(
//            margin: new EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
//            height: 5.0,
//            color: Color(0xFFe0e0e0),
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget clipShape(BuildContext context) {
//    //pagi = 05:00 - 10:00, siang = 10:00 - 15:00, sore = 15:00 - 18:00,petang = 18:00 - 19:00,malam = 19:00 - 00:00,dinihari = 00:00 - 05:00
//    DateTime dt = DateTime.now();
//    int hours = dt.hour;
//    Color tulisan;
//
//    if(hours>=5 && hours<=10){
//      tulisan = Styles.primaryColor;
//      greetings = "Selamat Pagi";
//      header_greetings = "http://walldiskpaper.com/wp-content/uploads/2014/09/Cute-Green-Light-Background-HD.jpg";
//    } else if(hours>=10 && hours<=15){
//      tulisan = Styles.primaryColor;
//      greetings = "Selamat Siang";
//      header_greetings = "https://pngimage.net/wp-content/uploads/2018/05/afternoon-png-6.png";
//    } else if(hours>=15 && hours<=18){
//      tulisan = Colors.white;
//      greetings = "Selamat Sore";
//      header_greetings = "https://i-love-png.com/images/nature_celebrating_india_6400.png";
//    } else if(hours>=18 && hours<=24){
//      tulisan = Colors.white;
//      greetings = "Selamat Malam";
//      header_greetings = "https://static.businessinsider.sg/2019/08/08/5d69556d6f24eb2e0c6d1634.png";
//    }else if(hours == 0 || hours<=4){
//      tulisan = Colors.white;
//      greetings = "Selamat Malam";
//      header_greetings = "https://static.businessinsider.sg/2019/08/08/5d69556d6f24eb2e0c6d1634.png";
//    }
//    print("###############################$hours############################################");
//    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
//    return Stack(
//      children: <Widget>[
//        Container(
//          height: 150,
//          width: _width,
//          child:CachedNetworkImage(
//            imageUrl: header_greetings,
//            placeholder: (context, url) => Center(
//              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//            ),
//            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
//            imageBuilder: (context, imageProvider) => Container(
//              decoration: BoxDecoration(
//                borderRadius: new BorderRadius.circular(0.0),
//                color: Colors.grey,
//                image: DecorationImage(
//                  image: imageProvider,
//                  fit: BoxFit.cover,
//                ),
//              ),
//            ),
//          ),
//        ),
//
//        Column(
//          children: <Widget>[
//            Container(
//                padding: EdgeInsets.all(10),
//                //color: Colors.blue,
//                margin: EdgeInsets.only(left: 20, top: _height /15),
//                alignment: Alignment.center,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(greetings, style: TextStyle(color: tulisan,fontWeight: FontWeight.bold, fontFamily: 'Rubik',fontSize: 20),),
//                  ],
//                )
//            ),
//            Container(
//              width: _width/1.1,
//              height: _width/2.3,
//              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
//              padding: EdgeInsets.only(left:20,right:20),
//              decoration: new BoxDecoration(
//                color: Colors.white,
//                boxShadow: [
//                  new BoxShadow(
//                      color: Colors.grey,
//                      offset: new Offset(0.0, 0.0),
//                      blurRadius: 0.0,
//                      spreadRadius: 0.0
//                  )
//                ],
//                borderRadius: new BorderRadius.vertical(
//                  top: new Radius.circular(0.0),
//                  bottom: new Radius.circular(0.0),
//                ),
//              ),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.max,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Container(
//                          margin: const EdgeInsets.only(top:0.0),
//                          child: Text("Saldo Anda", style: TextStyle(color: Styles.primaryColor, fontFamily: 'Rubik',fontSize: 16)),
//                        ),
//                        Column(
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            crossAxisAlignment: CrossAxisAlignment.end,
//                            children: <Widget>[
//                              Text("$_saldo", style: TextStyle(color: Styles.primaryColor, fontFamily: 'Rubik',fontSize: 16)),
//                            ]
//                        ),
//
//                      ]
//                  ),
//                  SizedBox(height: 10.0,),
//                  Divider(),
//                  SizedBox(height: 10.0,),
//                  Row(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: <Widget>[
//                      Column(
//                        children: <Widget>[
//                          GestureDetector(
//                            onTap: () {
//                              print("Routing $_name");
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => SaldoUI(page:'home',saldo: _saldoMain, name:_name),
//                                ),
//                              );
//                            },
//                            child: SvgPicture.network(
//                              'http://203.190.54.5/assets/icon/topup.svg',
//                              placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                              height: ScreenUtil.getInstance().setHeight(80),
//                              width: ScreenUtil.getInstance().setWidth(80),
//                            ),
//                          ),
//                          SizedBox(height: 5,),
//                          Text("Top Up", style: TextStyle(fontWeight:FontWeight.bold, color:Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          GestureDetector(
//                            onTap: () {
//                              Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
//                              print('Routing to Electronics item list');
//                            },
//                            child: SvgPicture.network(
//                              'http://203.190.54.5/assets/icon/history.svg',
//                              placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                              height: ScreenUtil.getInstance().setHeight(80),
//                              width: ScreenUtil.getInstance().setWidth(80),
//                            ),
//                          ),
//                          SizedBox(
//                            height: 5,
//                          ),
//                          Text("Riwayat",  style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          GestureDetector(
//                            onTap: () {
//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TransferUI(saldo: _saldoMain)));
////                              Navigator.push(context,MaterialPageRoute(builder: (context) => TransferUI(saldo: _saldoMain)));
//                            },
//                            child: SvgPicture.network(
//                              'http://203.190.54.5/assets/icon/transaksi.svg',
//                              placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                              height: ScreenUtil.getInstance().setHeight(80),
//                              width: ScreenUtil.getInstance().setWidth(80),
//                            ),
//                          ),
//                          SizedBox(
//                            height: 5,
//                          ),
//                          Text("Transfer",  style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                        ],
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//
//            ppob(),
//            Padding(
//              padding: EdgeInsets.only(right: 0,top:0,left:0,bottom:20),
//              child: SizedBox(
//                height: 10.0,
//                child: new Center(
//                  child: new Container(
//                    margin: new EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
//                    height: 5.0,
//                    color: Color(0xFFe0e0e0),
//                  ),
//                ),
//              ),
//            ),
//            Container(
//                constraints: BoxConstraints(maxWidth: _width/1.1),
//                padding: EdgeInsets.only(left:0, right:0, bottom: 10),
//                child: GestureDetector(
//                  onTap: (){
//                    Navigator.push(context,MaterialPageRoute(builder: (context) =>About()));
//                  },
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Tentang Thaibah", style: TextStyle( fontSize: 14, color: const Color(0xFF116240), fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//                      Icon(Icons.arrow_right)
//                    ],
//                  ),
//                )
//            ),
//            PromoCard(),
//            Padding(
//              padding: EdgeInsets.only(right: 20,top:0,left:20,bottom:20),
//              child: SizedBox(
//                height: 10.0,
//                child: new Center(
//                  child: new Container(
//                    margin: new EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
//                    height: 5.0,
//                    color: Color(0xFFe0e0e0),
//                  ),
//                ),
//              ),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                isLoading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))):
//                SuratHome(idSurat: _idSurat,surat: _surat,suratAyat: _suratAyat,terjemahan: _terjemahan)
//              ],
//            ),
//
//            Padding(
//              padding: EdgeInsets.only(right: 20,top:0,left:20,bottom:20),
//              child: SizedBox(
//                height: 10.0,
//                child: new Center(
//                  child: new Container(
//                    margin: new EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
//                    height: 2.0,
//                    color: Color(0xFFeeeeee),
//                  ),
//                ),
//              ),
//            ),
//            Container(
//                constraints: BoxConstraints(maxWidth: _width/1.1),
//                padding: EdgeInsets.only(left:0, right:0, bottom: 10),
//                child: GestureDetector(
//                  onTap: (){
//                    print("test");
//                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CategoryPage()));
//                  },
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Kategori", style: TextStyle( fontSize: 14, color: const Color(0xFF116240), fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//                      Icon(Icons.arrow_right)
//                    ],
//                  ),
//                )
//            ),
////
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                CategoryHome(),
//              ],
//            ),
//
//            Container(
//                constraints: BoxConstraints(maxWidth: _width/1.1),
//                padding: EdgeInsets.only(left:0, right:0, bottom: 10),
//                child: GestureDetector(
//                  onTap: (){
//                    print("test");
//                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewsPage()));
//                  },
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Berita Terbaru", style: TextStyle( fontSize: 14, color: const Color(0xFF116240), fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//                      Icon(Icons.arrow_right)
//                    ],
//                  ),
//                )
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                NewsHome(),
//              ],
//            ),
//
//
//            Container(
//                constraints: BoxConstraints(maxWidth: _width/1.1),
//                padding: EdgeInsets.only(left:0, right:0, bottom: 10),
//                child: GestureDetector(
//                  onTap: (){
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => Inspirasi()
//                      ),
//                    );
//                  },
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Inspirasi", style: TextStyle( fontSize: 14, color: const Color(0xFF116240), fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//                      Icon(Icons.arrow_right)
//                    ],
//                  ),
//                )
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                InspirasiHome(imgInspiration: _inspiration)
//              ],
//            ),
//
//
//
//            Padding(
//              padding: EdgeInsets.only(right: 20,top:10,left:20,bottom:20),
//              child: SizedBox(
//                height: 10.0,
//                child: new Center(
//                  child: new Container(
//                    margin: new EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
//                    height: 2.0,
//                    color: Color(0xFFeeeeee),
//                  ),
//                ),
//              ),
//            ),
//            Container(
//                constraints: BoxConstraints(maxWidth: _width/1.1),
//                padding: EdgeInsets.only(left:0, right:0, bottom: 10),
//                child: GestureDetector(
//                  onTap: (){
//                    print("test");
//                    Navigator.of(context).pushNamed(KATEGORI_BERITA_UI);
//                  },
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Testimoni", style: TextStyle( fontSize: 14, color: const Color(0xFF116240), fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//                      Icon(Icons.arrow_right)
//                    ],
//                  ),
//                )
//            ),
//            TestiCard(),
//            SizedBox(height: 10,),
//            Padding(
//              padding: EdgeInsets.only(right: 20,top:10,left:20,bottom:20),
//              child: SizedBox(
//                height: 10.0,
//                child: new Center(
//                  child: new Container(
//                    margin: new EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
//                    height: 2.0,
//                    color: Color(0xFFeeeeee),
//                  ),
//                ),
//              ),
//            ),
//            Container(
//                constraints: BoxConstraints(maxWidth: _width/1.1),
//                padding: EdgeInsets.only(left:0, right:0, bottom: 10),
//                child: GestureDetector(
//                  onTap: (){
//                    print("test");
//                    Navigator.of(context).pushNamed(KATEGORI_BERITA_UI);
//                  },
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Member Terbaik", style: TextStyle( fontSize: 14, color: const Color(0xFF116240), fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//                      Icon(Icons.arrow_right)
//                    ],
//                  ),
//                )
//            ),
//            Stack(
//              children: <Widget>[
//                Container(
//                    margin: EdgeInsets.all(9.0),
//                    padding: EdgeInsets.all(9.0),
//
//                    child: Column(
//                      children: <Widget>[
//                        BestMemberContent(no: 1, picture: "assets/images/ava2.jpg", name: "Usep", amount: "Rp. 10,000,000"),
//                        SizedBox(height: 10.0),
//                        BestMemberContent(no: 2, picture: "assets/images/ava2.jpg", name: "Rizki", amount: "Rp. 9,000,000"),
//                        SizedBox(height: 10.0),
//                        BestMemberContent(no: 3, picture: "assets/images/ava2.jpg", name: "Didin", amount: "Rp. 8,000,000")
//                      ],
//                    )
//                )
//              ],
//            ),
////          SwipeFeedPage(),
////          Column
//          ],
//        )
//      ],
//    );
//  }
//
//
//  Widget ppob() {
//    return Container(
//      // width: _width/1,
//      margin: EdgeInsets.only(left: 20, right: 20, top:15,bottom:5),
//      child: Material(
//          elevation: 0.0,
//          color:Colors.grey[50],
//          child: GridView.count(
//            physics: NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            childAspectRatio: 0.7,
//            crossAxisCount: 5,
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).pushNamed(QURAN_LIST_UI);
//                      print('Routing to Electronics item list');
//                    },
//                    child: SvgPicture.network(
//                      'http://203.190.54.5/assets/icon/alquran.svg',
//                      placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                      height: ScreenUtil.getInstance().setHeight(70),
//                      width: ScreenUtil.getInstance().setWidth(70),
//                    ),
//                  ),
//                  SizedBox( height: 15),
//                  Flexible(
//                    child: Text("Al-Quran",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: "Rubik")),
//                  ),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  GestureDetector(
//                      onTap: () {
//                        //Navigator.of(context).pushNamed(PROPERTIES_ITEM_LIST);
//                        print('Routing to Properties item list');
//                        Navigator.of(context).pushNamed(ASMA_UI);
//                      },
//
//                      child: SvgPicture.network(
//                        'http://203.190.54.5/assets/icon/99_nama.svg',
//                        placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                        height: ScreenUtil.getInstance().setHeight(70),
//                        width: ScreenUtil.getInstance().setWidth(70),
//                      )
//                  ),
//                  SizedBox(height: 15),
//                  Flexible(
//                    child: Text("99 Nama",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                  ),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  GestureDetector(
//                      onTap: () {
//                        Navigator.of(context).pushNamed(PRAYER_LIST);
//                      },
//                      child: SvgPicture.network(
//                        'http://203.190.54.5/assets/icon/jadwal_solat.svg',
//                        placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                        height: ScreenUtil.getInstance().setHeight(70),
//                        width: ScreenUtil.getInstance().setWidth(70),
//                      )),
//                  SizedBox(height: 15),
//                  Flexible(
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          Text("Prayer",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                        ],)
//                  ),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  GestureDetector(
//                      onTap: () {
//                        Navigator.of(context).pushNamed(VIDEO_LIST_UI);
//                        print('Routing to Furniture item list');
//                      },
//                      child: SvgPicture.network(
//                        'http://203.190.54.5/assets/icon/video.svg',
//                        placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                        height: ScreenUtil.getInstance().setHeight(70),
//                        width: ScreenUtil.getInstance().setWidth(70),
//                      )),
//                  SizedBox(height: 15),
//                  Flexible(
//                    child: Text("Video",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                  ),
//                ],
//              ),
//              Column(
//                children: <Widget>[
//                  GestureDetector(
//                    onTap: (){
//                      _lainnyaModalBottomSheet(context);
//                    },
//                    child: SvgPicture.network(
//                      'http://203.190.54.5/assets/icon/more.svg',
//                      placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//                      height: ScreenUtil.getInstance().setHeight(70),
//                      width: ScreenUtil.getInstance().setWidth(70),
//                    ),
//                  ),
//                  SizedBox(height: 15),
//                  Flexible(
//                    child: Text("Lainnya",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 12,fontFamily: 'Rubik')),
//                  ),
//                ],
//              ),
//            ],
//          )
//      ),
//    );
//  }
//
//  void _lainnyaModalBottomSheet(context){
//    showModalBottomSheet(
//        context: context,
//        backgroundColor: Colors.transparent,
//        builder: (BuildContext bc){
//          return Container(
//            child: Material(
//              //margin: EdgeInsets.only(top: 10),
//                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
//                // backgroundColor: Colors.grey,
//                elevation: 5.0,
//                color:Colors.grey[50],
//                child: Column(
//                    children: <Widget>[
//                      SizedBox(height: 20,),
//                      Text("Pembayaran Lainnya", style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
//                      SizedBox(height: 30,),
//                      GridView.count(
//                        physics: NeverScrollableScrollPhysics(),
//                        shrinkWrap: true,
//                        crossAxisCount: 4,
//                        children: <Widget>[
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                onTap: (){
//                                  Navigator.of(context).popAndPushNamed(BPJS_UI);
//                                  print('Routing to Cars item list');
//                                },
//                                child: SvgPicture.asset(
//                                  'assets/images/ppob/bpjs.svg',
//                                  placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                  height: ScreenUtil.getInstance().setHeight(60),
//                                  width: ScreenUtil.getInstance().setWidth(60),
//                                ),
//                              ),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "BPJS",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                onTap: (){
//                                  Navigator.of(context).pushNamed(ZAKAT_UI);
//                                  print('Routing to Bikes item list');
//                                },
//                                child: SvgPicture.asset(
//                                  'assets/images/ppob/zakat.svg',
//                                  placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                  height: ScreenUtil.getInstance().setHeight(60),
//                                  width: ScreenUtil.getInstance().setWidth(60),
//                                ),
//                              ),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "ZAKAT",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.of(context).pushNamed(TV_BERBAYAR_UI);
//                                    print('Routing to Mobiles item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/tv.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "TV",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                onTap: () {
//                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PulsaUI()));
//
////                                  Navigator.of(context).pushNamed(PULSA_UI);
//                                  print('Routing to Electronics item list');
//                                },
//                                child: SvgPicture.asset(
//                                  'assets/images/ppob/pulsa.svg',
//                                  placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                  height: ScreenUtil.getInstance().setHeight(60),
//                                  width: ScreenUtil.getInstance().setWidth(60),
//                                ),
//                              ),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "Pulsa",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.of(context).pushNamed(PULSA_SMS_TELP_UI);
//                                    print('Routing to Properties item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/tlpnsms.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "SMS/Telp",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListrikUI()));
//
//                                    print('Routing to Jobs item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/listrik.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "Listrik",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.of(context).pushReplacementNamed(PDAM_UI);
//                                    print('Routing to Furniture item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/pdam.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "Air PDAM",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.of(context).pushNamed(EMONEY_UI);
//                                    print('Routing to Furniture item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/emoney.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "Emoney",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.of(context).pushNamed(TELP_KABEL_UI);
//                                    print('Routing to Furniture item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/telepon.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "Telp.Kabel",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Column(
//                            children: <Widget>[
//                              GestureDetector(
//                                  onTap: () {
//                                    Navigator.of(context).pushNamed(MULTIFINANCE_UI);
//                                    print('Routing to Furniture item list');
//                                  },
//                                  child: SvgPicture.asset(
//                                    'assets/images/ppob/finance.svg',
//                                    placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
//
//                                    height: ScreenUtil.getInstance().setHeight(60),
//                                    width: ScreenUtil.getInstance().setWidth(60),
//                                  )),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Flexible(
//                                child: Text(
//                                  "Multifinance",
//                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12,fontFamily: 'Rubik'),
//                                ),
//                              ),
//                            ],
//                          ),
//
//                        ],
//                      )
//                    ]
//                )
//            ),
//          );
//        }
//    );
//  }




//  Widget build(BuildContext context) {
//    _height = MediaQuery.of(context).size.height;
//    _width = MediaQuery.of(context).size.width;
//
//    return new WillPopScope(
//      onWillPop: _onBackPressed,
//      child: Scaffold(
//        backgroundColor: Colors.transparent,
//        key: scaffoldKey,
//        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//        body: SafeArea(
//            bottom: false,
//            top: false,
//            child: isLoading ? SafeArea(
//              child: Align(
//                alignment: Alignment.topCenter,
//                child: LinearProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Colors.green[900]), backgroundColor: Colors.white),
//              ),
//            ) :
//            SingleChildScrollView(
//              child: Column(
//                children: <Widget>[
//
//                  clipShape(context),
//                ],
//              ),
//            )
//        ),
//      ),
//    );
//  }
  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: PageView(
//        physics: NeverScrollableScrollPhysics(),
//        onPageChanged: (index) {
//          indexcontroller.add(index);
//        },
//        controller: pageController,
//        children: <Widget>[
////          iconQu(context),
////          DashboardThreePage(),
//          _buildBody(context),
//          Center(
//            child: Text('Security'),
//          ),
//          Center(
//            child: Text('Security'),
//          ),
//          Center(
//            child: Text('Message'),
//          ),
//        ],
//      ),
//      bottomNavigationBar: StreamBuilder<Object>(
//          initialData: 0,
//          stream: indexcontroller.stream,
//          builder: (context, snapshot) {
//            int cIndex = snapshot.data;
//            return FancyBottomNavigation(
//              currentIndex: cIndex,
//              items: <FancyBottomNavigationItem>[
//                FancyBottomNavigationItem(icon: Icon(Icons.home), title: Text('Home')),
//                FancyBottomNavigationItem(icon: Icon(Icons.person), title: Text('User')),
//                FancyBottomNavigationItem(icon: Icon(Icons.security), title: Text('Security')),
//                FancyBottomNavigationItem(icon: Icon(Icons.message), title: Text('Message')),
//              ],
//              onItemSelected: (int value) {
//                indexcontroller.add(value);
//                pageController.jumpToPage(value);
//              },
//            );
//          }
//      ),
//    );
    return DashboardThreePage();
  }

//  @override



//  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
//    var loginBtn = new Container(
//      padding: EdgeInsets.all(5.0),
//      alignment: FractionalOffset.center,
//      decoration: new BoxDecoration(
//        color: bgColor,
//        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
//        boxShadow: <BoxShadow>[
//          BoxShadow(
//            color: const Color(0xFF696969),
//            offset: Offset(1.0, 6.0),
//            blurRadius: 0.001,
//          ),
//        ],
//      ),
//      child: Text(
//        buttonLabel,
//        style: new TextStyle(
//            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
//      ),
//    );
//    return loginBtn;
//  }
}




// *************************************** START BEST MEMBER *************************************** //
//class BestMemberContent extends StatelessWidget {
//  final int no; final String picture; final String name; final String amount;
//  const BestMemberContent({Key key,@required this.no, @required this.picture,@required this.name,@required this.amount });
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.all(9.0),
//      decoration: BoxDecoration(
//        color: Colors.white,
//        boxShadow: [BoxShadow(blurRadius: 5.0,color: Colors.grey[350],offset: Offset(0, 3))],
//      ),
//      child: Row(
//        children: <Widget>[
//          Flexible(
//            flex: 1,
//            child: Stack(
//              children: <Widget>[
//                ClipRRect(
//                  borderRadius: BorderRadius.circular(0.0),
//                  child: Image.asset(picture),
//                ),
//                Container(
//                  width: 15.0,
//                  height: 15.0,
//                  decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
//                  child: FittedBox(child: Text(no.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
//                ),
//              ],
//            ),
//          ),
//          SizedBox(width: 5.0),
//          Flexible(
//            flex: 4,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,5.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[Text(name,style: TextStyle( fontSize: 12,  fontWeight: FontWeight.bold,fontFamily: 'Rubik'))],
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,5.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[Text(amount,style: TextStyle( fontSize: 12,  fontWeight: FontWeight.bold,fontFamily: 'Rubik'))],
//                  ),
//                ),
//              ],
//            ),
//          ),
//
//        ],
//      ),
//    );
//  }
//}
// *************************************** END BEST MEMBER ***************************************** //


