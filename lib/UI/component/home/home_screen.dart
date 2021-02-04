import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/Model/newsModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/cardSaldo.dart';
import 'package:thaibah/UI/Widgets/mainCompass.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/mainHistoryTransaksi.dart';
import 'package:thaibah/UI/component/MLM/upgradePlatinum.dart';
import 'package:thaibah/UI/component/auth/loginPhone.dart';
import 'package:thaibah/UI/component/deposit/formDeposit.dart';
import 'package:thaibah/UI/component/home/widget_artikel.dart';
import 'package:thaibah/UI/component/home/widget_top_slider.dart';
import 'package:thaibah/UI/component/islamic/asma_ui.dart';
import 'package:thaibah/UI/component/islamic/doaHarian.dart';
import 'package:thaibah/UI/component/islamic/masjidTerdekat.dart';
import 'package:thaibah/UI/component/islamic/myQuran.dart';
import 'package:thaibah/UI/component/islamic/quran_list_ui.dart';
import 'package:thaibah/UI/component/islamic/subDoaHadist.dart';
import 'package:thaibah/UI/component/news/newsPage.dart';
import 'package:thaibah/UI/component/penarikan/penarikan.dart';
import 'package:thaibah/UI/component/sosmed/exploreFeed.dart';
import 'package:thaibah/UI/component/sosmed/listSosmed.dart';
import 'package:thaibah/UI/component/sosmed/myFeed.dart';
import 'package:thaibah/UI/component/transfer/transfer_ui.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/autoSizeTextQ.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/richAlertDialogQ.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/baseProvider.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/resources/logoutProvider.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final TextStyle whiteText = TextStyle(color: Colors.white);
  final userRepository = UserRepository();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PrayerModel prayerModel;
  Info info;
  Color warna1,warna2;
  String _name='',_saldoBonus="0",_saldoMain="0", _saldoVoucher="0",_saldoPlatinum="0",_saldo='0',_levelPlatinum='',_saldoRaw='0';
  String pinku = "", id="", _nohp='', _level='',_picture='',_kdRefferal='',_qr='',statusLevel ='0';
  String versionCode = '';
  static String latitude = '';
  static String longitude = '';
  int levelPlatinumRaw=0,statusMember,counterRTO=0;
  bool retry = false,modeUpdate = false,modeLogout = false,isLoading = false,versi = false,loadingVersion=false,loadingStatusMember=false;
  bool isTimeout=false,isToken=false;
  NewsModel newsModel;

  Future<void> refresh() async{
    final Completer<void> completer = Completer<void>();
    await Future.delayed(Duration(seconds: 1));
    completer.complete();
    return completer.future.then<void>((_) {
      loadData();
      loadArtikel();
    });

  }
  Future loadArtikel() async {
    final res = await BaseProvider().getProvider("berita?page=1&limit=4&category=artikel", newsModelFromJson);
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

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('lat');
    final lng = prefs.getDouble('lng');

    final token = await userRepository.getDataUser('token');
    final id = await userRepository.getDataUser('idServer');
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (token == null || token == '') {
      setState(() {
        isLoading = false;
        modeUpdate = true;
      });
      GagalHitProvider().fetchRequest('home', 'kondisi = ID SQLITE KOSONG, brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
    }
    else {
      var ceking = await userRepository.checker();
      if (ceking == true) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(new CupertinoPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
      } else {
        var jsonString = await http.get(
            ApiService().baseUrl + 'info?id=' + id,
            headers: {
              'Authorization': token,
              'username': ApiService().username,
              'password': ApiService().password
            }
        );
        if (jsonString.statusCode == 200) {
          setState(() {
            isLoading = false;
            retry = false;
            latitude=lat.toString();
            longitude=lng.toString();
            // ThaibahColour
            warna1 = color1 == '' ? ThaibahColour.primary1 : hexToColors(color1);
            warna2 = color2 == '' ? ThaibahColour.primary2 : hexToColors(color2);
            statusLevel = levelStatus;
          });
          final jsonResponse = json.decode(jsonString.body);
          info = new Info.fromJson(jsonResponse);
          _level = (info.result.level);
          _name = (info.result.name);
          _nohp = (info.result.noHp);
          _kdRefferal = (info.result.kdReferral);
          _picture = (info.result.picture);
          _qr = (info.result.qr);
          _saldo = (info.result.saldo);
          _saldoMain = (info.result.saldoMain);
          _saldoBonus = (info.result.saldoBonus);
          _saldoVoucher = (info.result.saldoVoucher);
          _levelPlatinum = (info.result.levelPlatinum);
          levelPlatinumRaw = (info.result.levelPlatinumRaw);
          _saldoPlatinum = (info.result.saldoPlatinum);
        }
        else {
          setState(() {
            isLoading = false;
            retry = false;
            warna1 = color1 == '' ? ThaibahColour.primary1 : hexToColors(color1);
            warna2 = color2 == '' ? ThaibahColour.primary2 : hexToColors(color2);
            statusLevel = levelStatus;
            modeUpdate = true;
          });
          throw Exception('Failed to load info');
        }

      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isLoading = true;
    loadData();
    loadArtikel();

    versi = true;
    // latitude  = widget.lat;
    // longitude = widget.lng;
    retry = false;
  }
  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive){
    }
    if(state == AppLifecycleState.paused){
    }
    if(state == AppLifecycleState.resumed){
    }
//    List<AppLifecycleState> cik = [];
    if(state == AppLifecycleState.detached){
    }
  }

  @override
  Widget build(BuildContext context) {
    return isToken?UserRepository().modeUpdate(context):modeUpdate == true ? UserRepository().modeUpdate(context) : isLoading ? _loading() : LiquidPullToRefresh(
      color: ThaibahColour.primary2,
      backgroundColor:Colors.white,
      key: _refresh,
      onRefresh: refresh,
      showChildOpacityTransition: false,
      child: buildContent(context),
    );
  }


  Widget buildContent(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Column(
      children: <Widget>[
        Container(
          padding:EdgeInsets.only(top:20.0,left:0.0,right:0.0,bottom:10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: <Color>[statusLevel!='0'?warna1:ThaibahColour.primary1,statusLevel!='0'?warna2:ThaibahColour.primary2],
            ),
          ),
          child: Column(
            children: [
              ListTile(
                // contentPadding: EdgeInsets.only(left:0.0),
                title:GestureDetector(
                  child:  Row(
                    children: [
                      UserRepository().textQ(_name,14,Colors.white.withOpacity(0.7),FontWeight.bold,TextAlign.left),
                      SizedBox(width: 5),
                      levelPlatinumRaw == 0 ?InkWell(
                        onTap: (){
                          Navigator.of(context).push(new CupertinoPageRoute(builder: (_) => UpgradePlatinum()));
                        },

                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child:UserRepository().textQ('upgrade',10,Colors.white,FontWeight.bold,TextAlign.center),
                        ),
                      ):(levelPlatinumRaw == 1 ? Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum.png",height:20.0,width:20.0)) :
                      Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum_vvip.png",height:20.0,width:20.0)))
                      // Image.asset("${ApiService().assetsLocal}thaibah_platinum.png",height:20.0,width:20.0)
                      // Icon(Icons.content_copy, color: Colors.grey, size: 15,),
                    ],
                  ),
                ),
                subtitle: GestureDetector(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserRepository().textQ(_kdRefferal,12,Colors.white.withOpacity(0.7),FontWeight.bold,TextAlign.left),
                        SizedBox(width: 5),
                        Icon(Icons.content_copy, color: Colors.white, size: 15,),
                      ]
                  ),
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: '${_kdRefferal}'));
                    UserRepository().notifNoAction(scaffoldKey, context,"Kode Referral Berhasil Disalin","success");
                  },
                ),
                leading: CircleAvatar(
                    radius:20.0,
                    backgroundImage: NetworkImage(_picture)
                ),
                trailing: InkWell(
                  child: Icon(Icons.share,color: Colors.white),
                  onTap: ()async{
                    UserRepository().loadingQ(context);
                    Timer(Duration(seconds: 1), () async {
                      Navigator.of(context).pop(false);
                      await WcFlutterShare.share(
                          sharePopupTitle: 'Thaibah Share Link',
                          subject: 'Thaibah Share Link',
                          text: "https://thaibah.com/signup/${_kdRefferal}\n\n\nAyo Buruan daftar",
                          mimeType: 'text/plain'
                      );
                    });
                    // share();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: SizedBox(
                  child: Container(height: 1.0,color: Colors.white),
                ),
              ),
              levelPlatinumRaw==0?CardSaldo(
                  saldoMain: _saldoMain=='0.00'?_saldoMain:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoMain))}",
                  saldoBonus: _saldoBonus=='0.00'?_saldoBonus:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoBonus))}",
                  saldoVoucher: _saldoVoucher=='0.00'?_saldoVoucher:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoVoucher))}",
                  saldoPlatinum: _saldoPlatinum=='0.00'?_saldoPlatinum:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoPlatinum))}"
              ):CardSaldoNoPlatinum(
                  saldoMain:_saldoMain=='0.00'?_saldoMain:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoMain))}",
                  saldoBonus:_saldoBonus=='0.00'?_saldoBonus:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoBonus))}",
                  saldoVoucher:_saldoVoucher=='0.00'?_saldoVoucher:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoVoucher))}",
                  saldoPlatinum:_saldoPlatinum=='0.00'?_saldoPlatinum:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoPlatinum))}"
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: SizedBox(
                  child: Container(height: 1.0,color: Colors.white),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left:10,right:10,top:0,bottom:10),
                child: Container(
                  decoration:BoxDecoration(
                    borderRadius:  BorderRadius.circular(10.0),
                    color: Colors.white,
                  ) ,
                  padding: EdgeInsets.only(top:10.0,bottom:10.0),
                  child: cardOneSection(context),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex:1,
          child:SingleChildScrollView(
              primary: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child:Column(
                children: <Widget>[
                  SizedBox(height:10.0),
                  WidgetTopSlider(),
                  Padding(
                    padding: EdgeInsets.only(left:10,right:10,top:10,bottom:0),
                    child: Container(
                      decoration:BoxDecoration(
                        borderRadius:  BorderRadius.circular(10.0),
                        color: Colors.white,
                      ) ,
                      padding: EdgeInsets.only(top:10.0,bottom:10.0),
                      child:  cardTwoSection(context),
                    ),
                  ),
                  if(newsModel.result.data.length>0) Padding(
                      padding: EdgeInsets.only(left:15,right:15,top:20,bottom:0),
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
                  if(newsModel.result.data.length>0) cardSixSection(context),
                  Padding(
                      padding: EdgeInsets.only(left:15,right:15,top:20,bottom:0),
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
                  const SizedBox(height: 0.0),
                  ListSosmed(),
                  const SizedBox(height: 30.0),
                ],
              )
          ),
        )
      ],
    );
  }
  Widget cardOneSection(BuildContext context){
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
        CardEmoney(imgUrl:'Icon_Utama_TopUp',title:'Deposit',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => FormDeposit(saldo: UserRepository().replaceRp(_saldoMain),name: _name))).whenComplete(() => loadData());
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
        ):CardEmoney(imgUrl:'Icon_Utama_Transfer',title:'Transfer',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => TransferUI(saldo:UserRepository().replaceRp(_saldoMain),qr:_qr))).whenComplete(() => loadData());
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
        ):CardEmoney(imgUrl:'Icon_Utama_Penarikan',title:'Penarikan',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>Penarikan(saldoMain: UserRepository().replaceRp(_saldoMain)))).whenComplete(() => loadData());
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
        ):CardEmoney(imgUrl:'Icon_Utama_History',title:'Riwayat',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => MainHistoryTransaksi(page: 'home'))).whenComplete(() => loadData());
        },),
      ],
    );



  }
  Widget cardTwoSection(BuildContext context){
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
        ):CardEmoney(imgUrl:'Icon_Utama_Asmaul_Husna',title:'Asmaul Husna',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => AsmaUI()));
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
        ):CardEmoney(imgUrl:'Icon_Utama_Baca_Alquran',title:'Alquran',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>QuranListUI()));
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
        ):CardEmoney(imgUrl:'Icon_Utama_Doa_Harian',title:'Do`a',xFunction: (){
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
        ):CardEmoney(imgUrl:'Icon_Utama_Hadits',title:'Hadits',xFunction: (){
          Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));
        },),
      ],
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

  /* STRUKTUR WIDGET LOADING */
  Widget _loading(){
    return Column(
      children: <Widget>[
        Flexible(
          flex: 4,
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 50,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: <Color>[Color(0xFFfafafa),Color(0xFFfafafa)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(child: SkeletonFrame(width: 50,height: 50),
                                    ),
                                  ),
                                  SizedBox(width: 7.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                      ),
                                      SizedBox(height: 7.0),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                      ),
                                      SizedBox(height: 7.0),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          child: SizedBox(
                            child: Container(height: 1.0,color: Colors.white),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 12.0),
                                    SizedBox(height: 10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 12.0),
                                  ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 12.0),
                                    SizedBox(height: 10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 12.0),
                                  ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 12.0),
                                    SizedBox(height: 10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 12.0),
                                  ],
                                ),

                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 15,
                  right: 15,
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(left:0.0,right:0.0,top:0.0,bottom:0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child:ListTile(
                              contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                              title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                              subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child:ListTile(
                              contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                              title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                              subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child:ListTile(
                              contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                              title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                              subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child:ListTile(
                              contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                              title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                              subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: ListView(
            scrollDirection: Axis.vertical,
            primary: true,
            children: <Widget>[
              Container(
                  padding:EdgeInsets.only(left:15.0,right:15.0),
                  child:SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 200.0)
              ),
              Card(
                elevation:0.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Colors.transparent,
                margin: const EdgeInsets.only(left:15.0,right: 15.0,top: 15.0,bottom: 15.0),
                child: Padding(
                    padding: EdgeInsets.only(left:15.0,right:15.0,top:20.0,bottom: 0.0),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio: 1.1,
                      crossAxisCount: 4,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10,bottom: 10.0),
                          title:CircleAvatar(radius: 20,backgroundColor: Colors.white,child: ClipOval(child: SkeletonFrame(width: 40,height: 40))),
                          subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0),
                        ),
                      ],
                    )
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: GestureDetector(
                  onTap: (){},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                      SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              // WrapperLevel(),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: GestureDetector(
                  onTap: (){},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                      SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              ListSosmed(),
              const SizedBox(height: 15.0),
            ],
          ),
        )
      ],
    );
  }
}
class CardSaldoNoPlatinum extends StatefulWidget {
  final String saldoMain;
  final String saldoBonus;
  final String saldoVoucher;
  final String saldoPlatinum;
  CardSaldoNoPlatinum({this.saldoMain,this.saldoBonus,this.saldoVoucher,this.saldoPlatinum});
  @override
  _CardSaldoNoPlatinumState createState() => _CardSaldoNoPlatinumState();
}

class _CardSaldoNoPlatinumState extends State<CardSaldoNoPlatinum> {
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Utama', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoMain, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Bonus', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoBonus, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Voucher', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoVoucher, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Platinum', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoPlatinum, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
          ],
        )
    );
  }
}



class CardSaldo extends StatefulWidget {
  final String saldoMain;
  final String saldoBonus;
  final String saldoVoucher;
  final String saldoPlatinum;
  CardSaldo({this.saldoMain,this.saldoBonus,this.saldoVoucher,this.saldoPlatinum});
  @override
  _CardSaldoState createState() => _CardSaldoState();
}

class _CardSaldoState extends State<CardSaldo> {
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false);
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Utama', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoMain, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Bonus', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoBonus, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Voucher', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoVoucher, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserRepository().textQ('Saldo Platinum', ScreenUtilQ.getInstance().setSp(26), Colors.white, FontWeight.bold, TextAlign.center,maxLines: 1),
                SizedBox(height:2.0),
                UserRepository().textQ(widget.saldoPlatinum, ScreenUtilQ.getInstance().setSp(26), Colors.yellowAccent, FontWeight.bold, TextAlign.center,maxLines: 1)

              ],
            ),
          ],
        )
    );
  }
}







class WrapperIcon extends StatefulWidget {
  final String imgUrl; String title; Function xFunction;
  WrapperIcon({this.imgUrl,this.title,this.xFunction});
  @override
  _WrapperIconState createState() => _WrapperIconState();
}

class _WrapperIconState extends State<WrapperIcon> {
  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize:MainAxisSize.min ,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            widget.xFunction();
//            if(type == 'alquran'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => QuranListUI()),);}
//            if(type == 'prayer'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PrayerList(lng: widget.lng,lat: widget.lat)),);}
//            if(type == 'masjid'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())),);}
//            if(type == 'doa'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')),);}
//            if(type == 'Hadits'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));}
//            if(type == 'asmaulhusna'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => AsmaUI()));}
//            if(type == 'kalender'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Kalender()));}
//            if(type == 'lainnya'){_lainnyaModalBottomSheet(context,'ppob');}
          },
          child: SvgPicture.network(
            widget.imgUrl,
            placeholderBuilder: (context) => SkeletonFrame(width: ScreenUtilQ.getInstance().setWidth(60),height: ScreenUtilQ.getInstance().setHeight(60)),
            height: ScreenUtilQ.getInstance().setHeight(60),
            width: ScreenUtilQ.getInstance().setWidth(60),
          ),
        ),
        SizedBox(height: 5.0),
        Text(widget.title, style: TextStyle(fontWeight:FontWeight.bold,color:Colors.black,fontSize: 10,fontFamily:ThaibahFont().fontQ)),
      ],
    );
  }

}









class AppScale {
  BuildContext _ctxt;

  AppScale(this._ctxt);

  double get labelDim => scaledWidth(.04);
  double get popupMenuButton => scaledHeight(.065);

  double scaledWidth(double widthScale) {
    return MediaQuery.of(_ctxt).size.width * widthScale;
  }

  double scaledHeight(double heightScale) {
    return MediaQuery.of(_ctxt).size.height * heightScale;
  }
}
