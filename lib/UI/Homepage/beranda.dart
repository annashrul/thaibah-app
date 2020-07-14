import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/checkerMemberModel.dart';
import 'package:thaibah/Model/checkerModel.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Homepage/news.dart';
import 'package:thaibah/UI/Widgets/mainCompass.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/asma_ui.dart';
import 'package:thaibah/UI/component/news/newsPage.dart';
import 'package:thaibah/UI/component/penarikan.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/UI/component/prayerList.dart';
import 'package:thaibah/UI/component/royalti/infoRoyaltiLevel.dart';
import 'package:thaibah/UI/component/royalti/level.dart';
import 'package:thaibah/UI/component/sosmed/listSosmed.dart';
import 'package:thaibah/UI/component/sosmed/myFeed.dart';
import 'package:thaibah/UI/history_ui.dart';
import 'package:thaibah/UI/lainnya/doaHarian.dart';
import 'package:thaibah/UI/lainnya/kalender.dart';
import 'package:thaibah/UI/lainnya/masjidTerdekat.dart';
import 'package:thaibah/UI/lainnya/ppobPascabayar.dart';
import 'package:thaibah/UI/lainnya/ppobPrabayar.dart';
import 'package:thaibah/UI/lainnya/subDoaHadist.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/ppob/listrik_ui.dart';
import 'package:thaibah/UI/ppob/pulsa_ui.dart';
import 'package:thaibah/UI/ppob/zakat_ui.dart';
import 'package:thaibah/UI/quran_list_ui.dart';
import 'package:thaibah/UI/saldo_ui.dart';
import 'package:thaibah/UI/transfer_ui.dart';
import 'package:thaibah/UI/upgradePlatinum.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/autoSizeTextQ.dart';
import 'package:thaibah/config/flutterMaskedText.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:http/http.dart' as http;
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/resources/configProvider.dart';
import 'package:thaibah/resources/gagalHitProvider.dart';
import 'package:device_info/device_info.dart';
import 'package:thaibah/UI/Widgets/tutorialClearData.dart';

import 'package:thaibah/Model/userLocalModel.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';

class Beranda extends StatefulWidget {
  final String lat;
  final String lng;
  Beranda({this.lat,this.lng});
  @override
  BerandaState createState()=>BerandaState();
}

class BerandaState extends State<Beranda> with WidgetsBindingObserver{
  final TextStyle whiteText = TextStyle(color: Colors.white);
  final userRepository = UserRepository();
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();


  String _name='',_saldoBonus="0",_saldoMain="0", _saldoVoucher="0",_saldoPlatinum="0",_saldo='0',_levelPlatinum='';
  String pinku = "", id="", _nohp='', _level='';
  String _picture='',_kdRefferal='',_qr='';
  int levelPlatinumRaw=0;
  bool showAlignmentCards = false;
  bool isLoading = false;
  var isPin;

  int jam    = 0;
  int menit  = 0;
  String waktuSholat = '';
  String keterangan = '';
  String latitude = '', longitude = '';
  bool versi = false;

  Info info;

  String versionCode = '';int statusMember;
  bool loadingVersion=false;
  bool loadingStatusMember=false;


  Future<void> refresh() async{
    Timer(Duration(seconds: 1), () {
      setState(() {isLoading = true;});
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadData();
  }

  bool retry = false;
  bool modeUpdate = false;
  bool modeLogout = false;
  int count = 0;
  Color warna1;
  Color warna2;
  String statusLevel ='0';



  Future<void> loadData() async {
    final token = await userRepository.getDataUser('token');
    final id = await userRepository.getDataUser('idServer');
    final levelStatus = await userRepository.getDataUser('statusLevel');
    final color1 = await userRepository.getDataUser('warna1');
    final color2 = await userRepository.getDataUser('warna2');

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (id == null || id == '') {
      print(
          '####################### DATA SQLITE KOSONG ########################');
      setState(() {
        isLoading = false;
        modeUpdate = true;
      });
      GagalHitProvider().fetchRequest('home',
          'kondisi = ID SQLITE KOSONG, brand = ${androidInfo
              .brand}, device = ${androidInfo.device}, model = ${androidInfo
              .model}');
    }
    else {
      var ceking = await userRepository.checker();
      print("###################### CEK MEMBER DI BERANDA = $ceking #######################");
      // ceking = true ? tidak aktif : aktif
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
          print("LEVEL PLATINUM ${info.result.levelPlatinum}");
        } else {
          throw Exception('Failed to load info');
        }
      }
    }
  }
  DateTime dt = DateTime.now();
  PrayerModel prayerModel;
  int isActive = 0;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
//    checker();
    isLoading = true;
    versi = true;
    latitude  = widget.lat;
    longitude = widget.lng;
    retry = false;
  }
  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print("########################## DISPOSE #######################");
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive){
      print("########################### IN ACTIVE ######################");
    }
    if(state == AppLifecycleState.paused){
      print("########################### PAUSED ######################");
    }
    if(state == AppLifecycleState.resumed){
      print("########################### RESUME ######################");

    }
//    List<AppLifecycleState> cik = [];
    if(state == AppLifecycleState.detached){
      print("########################### detached ######################");

    }
  }
  int counterRTO=0;

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }


  Widget buildContent(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return modeUpdate == true ? UserRepository().modeUpdate(context) : isLoading ? _loading() :Column(
      children: <Widget>[
        Container(
          padding:EdgeInsets.only(top:30.0,left:10.0,right:10.0,bottom:10.0),
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40.0,
                          child: CachedNetworkImage(
                            imageUrl: _picture,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => SkeletonFrame(width: 80.0,height: 80.0),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        SizedBox(width: 7.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 0.0),
//                                  child: Row(
//                                    mainAxisAlignment:MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Container(
//                                        width:100.0,
//                                        child: Text('Nama',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
//                                      ),
//                                      Text(": "+_name,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
//                                    ],
//                                  )
//                                ),
//                                SizedBox(width: 7.0),
//                                levelPlatinumRaw == 0 ? isLoading?Container():GestureDetector(
//                                  onTap: (){
//                                    Navigator.of(context).push(new MaterialPageRoute(builder: (_) => UpgradePlatinum()));
//                                  },
//                                  child: Container(
//                                      padding: EdgeInsets.all(5),
//                                      decoration: new BoxDecoration(
//                                        color: Colors.red,
//                                        borderRadius: BorderRadius.circular(6),
//                                      ),
//                                      constraints: BoxConstraints(
//                                        minWidth: 14,
//                                        minHeight: 14,
//                                      ),
//                                      child: Text("UPGRADE",style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))
//                                  ),
//                                ):(levelPlatinumRaw == 1 ? Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum.png",height:20.0,width:20.0)) :
//                                Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum_vvip.png",height:20.0,width:20.0)))
//                              ],
//                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Text(_name,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                                  ],
                                )
                            ),
                            SizedBox(height: 7.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:100.0,
                                    child: Text('Kode Referral',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
                                  ),
                                  Text(": "+_kdRefferal,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                                ],
                              )
                            ),
                            SizedBox(height: 7.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:100.0,
                                          child: Text('Membership',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
                                        ),
                                        Text(": "+_levelPlatinum,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                                      ],
                                    )
                                ),
                                SizedBox(width: 7.0),
                                levelPlatinumRaw == 0 ? isLoading?Container():GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(new CupertinoPageRoute(builder: (_) => UpgradePlatinum()));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text("UPGRADE",style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))
                                  ),
                                ):(levelPlatinumRaw == 1 ? Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum.png",height:20.0,width:20.0)) :
                                Container(child:Image.asset("${ApiService().assetsLocal}thaibah_platinum_vvip.png",height:20.0,width:20.0)))
                              ],
                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(left: 0.0),
//                              child:Row(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Container(
//                                    width:100.0,
//                                    child: Text('Membership',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
//                                  ),
//                                  Text(": "+_levelPlatinum,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
//
//                                ],
//                              )
////                              child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text('Level Membership : $_levelPlatinum',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
//                            ),
                            SizedBox(height: 7.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:100.0,
                                    child: Text('Level Royalti',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
                                  ),
                                  Text(": "+_level,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),

                                ],
                              )
//                              child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text('Level Royalti : $_level',style: whiteText.copyWith(fontSize: 14.0,fontFamily:ThaibahFont().fontQ)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: SizedBox(
                  child: Container(height: 1.0,color: Colors.white),
                ),
              ),
              levelPlatinumRaw==0?CardSaldo(
                  saldoMain: _saldoMain=='0.00'?_saldoMain:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoMain))}",
                  saldoBonus: _saldoBonus=='0.00'?_saldoBonus:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoBonus))}",
                  saldoVoucher: _saldoVoucher=='0.00'?_saldoVoucher:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoVoucher))}",
                  saldoPlatinum: _saldoPlatinum=='0.00'?_saldoPlatinum:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoPlatinum))}"
              ):cardSaldoNoPlatinum(
                  context,_saldoMain=='0.00'?_saldoMain:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoMain))}",
                  _saldoBonus=='0.00'?_saldoBonus:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoBonus))}",
                  _saldoVoucher=='0.00'?_saldoVoucher:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoVoucher))}",
                  _saldoPlatinum=='0.00'?_saldoPlatinum:"${MoneyFormat().moneyToLocal(MoneyFormat().moneyToInt(_saldoPlatinum))}"),
              SizedBox(height:15.0),
              Container(
                  padding: const EdgeInsets.only(left:0.0,right:0.0),
                  child:Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CardEmoney(imgUrl:'Icon_Utama_TopUp',title:'Top Up',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SaldoUI(saldo: _saldoMain,name: _name)),).then((val){
                              loadData(); //you get details from screen2 here
                            });}),
                            CardEmoney(imgUrl:'Icon_Utama_Transfer',title:'Transfer',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => TransferUI(saldo:_saldoMain,qr:_qr)),).whenComplete(loadData);},),
                            CardEmoney(imgUrl:'Icon_Utama_Penarikan',title:'Penarikan',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Penarikan(saldoMain: _saldoMain)),).whenComplete(loadData);},),
                            CardEmoney(imgUrl:'Icon_Utama_History',title:'Riwayat',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'home')));},),
                          ],
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
        SizedBox(height:10.0),
        Flexible(
          flex:1,
          child:RefreshIndicator(
            child: SingleChildScrollView(
                primary: true,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                child:Column(
                  children: <Widget>[
                    NewsHomePage(),
                    Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.white,
                      margin: const EdgeInsets.only(left:15.0,right: 15.0,top: 0.0,bottom: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize:MainAxisSize.min ,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize:MainAxisSize.min ,
                            children: <Widget>[
                              CardEmoney(imgUrl:'Icon_Utama_Baca_Alquran',title:'Al-Quran',xFunction: (){
                                Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => QuranListUI()));}),
                              CardEmoney(imgUrl:'Icon_Utama_Waktu_Shalat',title:'Waktu Shalat',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PrayerList(lng: widget.lng,lat: widget.lat)));},),
                              CardEmoney(imgUrl:'Icon_Utama_Masjid_Terdekat',title:'Masjid',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>  MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())));},),
                              CardEmoney(imgUrl:'Icon_Utama_Doa_Harian',title:'Doa Harian',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')));},),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize:MainAxisSize.min ,
                            children: <Widget>[
                              CardEmoney(imgUrl:'Icon_Utama_Hadits',title:'Hadits',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));},),
                              CardEmoney(imgUrl:'Icon_Utama_Asmaul_Husna',title:'Asmaul Husna',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => AsmaUI()));},),
                              CardEmoney(imgUrl:'Icon_Utama_Kalender_Hijriah',title:'Kalender',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Kalender()));},),
                              CardEmoney(imgUrl:'Icon_Utama_Lainnya',title:'Lainnya',xFunction: (){
                                _lainnyaModalBottomSheet(context,'ppob');
                              },),
                            ],
                          ),
                        ],
                      ),
                    ),
//                              buildCardIcon(),
                    const SizedBox(height: 15.0),
                    titleQ("Jenjang Karir",Colors.black,true,'level'),
                    const SizedBox(height: 15.0),
                    WrapperLevel(),
                    const SizedBox(height: 15.0),
                    titleQ("Informasi & Inspirasi",Colors.black,true,'inspirasi'),
                    const SizedBox(height: 0.0),
                    ListSosmed(),
                    const SizedBox(height: 30.0),
                  ],
                )
            ),
            key: _refresh,
            onRefresh: refresh
          ),
        )
      ],
    );
  }

  Widget buildContents(BuildContext context){
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return isLoading ? _loading() :Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 40,
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(0.0, ScreenUtilQ.getInstance().setHeight(50), 0.0, ScreenUtilQ.getInstance().setHeight(50)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: <Color>[ThaibahColour.primary1,ThaibahColour.primary2],
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
                                      radius: 35.0,
                                      child: CachedNetworkImage(
                                        imageUrl: _picture,
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => SkeletonFrame(width: 80.0,height: 80.0),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(width: 7.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 0.0),
                                              child: Text(_name,style: whiteText.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                                            ),
                                            SizedBox(width: 7.0),
                                            levelPlatinumRaw == 0 ? isLoading?Container():GestureDetector(
                                              onTap: (){
                                                Navigator.of(context).push(new MaterialPageRoute(builder: (_) => UpgradePlatinum()));
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 14,
                                                    minHeight: 14,
                                                  ),
                                                  child: Text("UPGRADE",style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ))
                                              ),
                                            ):Container(child:Image.asset("${ApiService().assetsLocal}platinum.png",height:20.0,width:20.0))
                                          ],
                                        ),
                                        levelPlatinumRaw == 0 ? SizedBox(height: 7.0) : Container(),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0.0),
                                          child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text('Kode Referral : '+_kdRefferal,style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
                                        ),
                                        SizedBox(height: 7.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0.0),
                                          child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text('Jenjang Karir : $_level',style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
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
                          levelPlatinumRaw==0?CardSaldo(saldoMain: _saldoMain,saldoBonus: _saldoBonus,saldoVoucher: _saldoVoucher,saldoPlatinum: _saldoPlatinum):CardSaldoNoPlatinum(saldoMain: _saldoMain,saldoBonus: _saldoBonus,saldoVoucher: _saldoVoucher,saldoPlatinum: _saldoPlatinum),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
//                    top:190,
                      bottom:0,
                      left: 10,
                      right: 10,
                      child: Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            CardEmoney(imgUrl:'Icon_Utama_TopUp',title:'Top Up',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SaldoUI(saldo: _saldoMain,name: _name)),).then((val){
                              loadData(); //you get details from screen2 here
                            });}),
                            CardEmoney(imgUrl:'Icon_Utama_Transfer',title:'Transfer',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => TransferUI(saldo:_saldoMain,qr:_qr)),).whenComplete(loadData);},),
                            CardEmoney(imgUrl:'Icon_Utama_Penarikan',title:'Penarikan',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Penarikan(saldoMain: _saldoMain)),).whenComplete(loadData);},),
                            CardEmoney(imgUrl:'Icon_Utama_History',title:'Riwayat',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'home')));},),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
              fit: FlexFit.loose,
              child: RefreshIndicator(
                  child: SingleChildScrollView(
                      child:Column(
                        children: <Widget>[
                          NewsHomePage(),
                          Card(
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.white,
                            margin: const EdgeInsets.only(left:15.0,right: 15.0,top: 0.0,bottom: 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize:MainAxisSize.min ,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize:MainAxisSize.min ,
                                  children: <Widget>[
                                    CardEmoney(imgUrl:'Icon_Utama_Baca_Alquran',title:'Al-Quran',xFunction: (){
                                      Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => QuranListUI()));}),
                                    CardEmoney(imgUrl:'Icon_Utama_Waktu_Shalat',title:'Waktu Shalat',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PrayerList(lng: widget.lng,lat: widget.lat)));},),
                                    CardEmoney(imgUrl:'Icon_Utama_Masjid_Terdekat',title:'Masjid',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>  MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())));},),
                                    CardEmoney(imgUrl:'Icon_Utama_Doa_Harian',title:'Doa Harian',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')));},),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize:MainAxisSize.min ,
                                  children: <Widget>[
                                    CardEmoney(imgUrl:'Icon_Utama_Hadits',title:'Hadits',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) =>SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));},),
                                    CardEmoney(imgUrl:'Icon_Utama_Asmaul_Husna',title:'Asmaul Husna',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => AsmaUI()));},),
                                    CardEmoney(imgUrl:'Icon_Utama_Kalender_Hijriah',title:'Kalender',xFunction: (){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Kalender()));},),
                                    CardEmoney(imgUrl:'Icon_Utama_Lainnya',title:'Lainnya',xFunction: (){
                                      _lainnyaModalBottomSheet(context,'ppob');
                                    },),
                                  ],
                                ),
                              ],
                            ),
                          ),
//                              buildCardIcon(),
                          const SizedBox(height: 15.0),
                          titleQ("Jenjang Karir",Colors.black,true,'level'),
                          const SizedBox(height: 15.0),
                          WrapperLevel(),
                          const SizedBox(height: 15.0),
                          titleQ("Informasi & Inspirasi",Colors.black,true,'inspirasi'),
                          const SizedBox(height: 0.0),
                          ListSosmed(),
                          const SizedBox(height: 15.0),
                        ],
                      )
                  ),
                  key: _refresh,
                  onRefresh: refresh
              )
          )

        ]
    );
  }

  /* STRUKTUR WIDGET CARD ISLAMIC */
  Widget buildCardIcon(){
    return Container(
      decoration: BoxDecoration(
        color:isLoading?Colors.transparent:Colors.green,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
      ),
//      color: isLoading?Colors.transparent:Colors.white,
      margin: const EdgeInsets.only(left:15.0,right: 15.0,top: 10.0,bottom: 0.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 1.1,
        crossAxisCount: 4,
        children: <Widget>[
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Baca_Alquran.svg',title: 'Al-Quran',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => QuranListUI()));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Waktu_Shalat.svg',title: 'Waktu Sholat',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PrayerList(lng: widget.lng,lat: widget.lat)));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Masjid_Terdekat.svg',title: 'Masjid',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Doa_Harian.svg',title: 'Doa Harian',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Hadits.svg',title: 'Hadits',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Asmaul_Husna.svg',title: 'Asmaul Husna',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => AsmaUI()));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Kalender_Hijriah.svg',title: 'Kalender',xFunction: (){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Kalender()));
          }),
          WrapperIcon(imgUrl: ApiService().iconUrl+'Icon_Utama_Lainnya.svg',title: 'Lainnya',xFunction: (){
            _lainnyaModalBottomSheet(context,'ppob');
          }),

        ],
      ),
    );
  }
  /* STRUKTUR WIDGET TITLE */
  Widget titleQ(String title,Color warna,bool param,type){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
      child: GestureDetector(
        onTap: (){

          if(type == 'news'){
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => NewsPage()),
            );
          }
          if(type == 'level'){
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => InfoRoyaltiLevel()),
            );
          }
          if(type == 'inspirasi'){
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(builder: (context) => MyFeed()),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16) : Text("$title",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold, fontSize: 14.0,color: warna)),
            isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16) : param == true ? type == 'level' ? Text("Info Jenjang Karir",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold, fontSize: 12.0,color: warna)) : Text("Lihat Semua",style: TextStyle(fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold, fontSize: 12.0,color: warna)) : Container(),
          ],
        ),
      ),
    );
  }
  /* STRUKTUR WIDGET FITUR LAINNYA */
  Widget moreStructure(var iconUrl,var page,String title){
    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
//      mainAxisSize:MainAxisSize.min ,
      children: <Widget>[
        InkWell(
          onTap: () {
            if(page == 'pulsa'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PulsaUI(nohp: _nohp))).whenComplete(loadData);}
            if(page == 'listrik'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => ListrikUI(nohp: _nohp))).whenComplete(loadData);}
            if(page == 'telepon'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'telkom',title:'Telepon / Internet'))).whenComplete(loadData);}
//            if(page == 'zakat'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => ZakatUI())).whenComplete(loadData);}
            if(page == 'masjid'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())));}
            if(page == 'hadis'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));}
            if(page == 'doa'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')));}
            if(page == 'kalender'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Kalender()));}
            if(page == 'emoney'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPrabayar(nohp:_nohp,param: "E_MONEY",title:'E-Money'))).whenComplete(loadData);}
            if(page == 'bpjs'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'BPJS',title:'BPJS'))).whenComplete(loadData);}
//            if(page == 'asuransi'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'ASURANSI',title:'Asuransi'))).whenComplete(loadData);}
//            if(page == 'telpPasca'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'TELEPHONE_PASCABAYAR',title:'Telepon Pascabayar')));}
            if(page == 'pdam'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'PDAM',title:'PDAM'))).whenComplete(loadData);}
            if(page == 'multiFinance'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'MULTIFINANCE',title:'Multi Finance'))).whenComplete(loadData);}
//            if(page == 'wifiId'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPrabayar(nohp:_nohp,param: "VOUCHER_WIFIID",title:'Voucher Wifi ID'))).whenComplete(loadData);}
            if(page == 'tvKabel'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: "PEMBAYARAN_TV",title:'Tv Kabel'))).whenComplete(loadData);}
          },
          child: SvgPicture.network(
            ApiService().iconUrl+iconUrl,
            placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
            height: ScreenUtilQ.getInstance().setHeight(60),
            width: ScreenUtilQ.getInstance().setWidth(60),
          )
        ),
        SizedBox(height: 10),
        Text(title.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 10,fontFamily:ThaibahFont().fontQ),)
      ],
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
                                    radius: 40,
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
              WrapperLevel(),
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
  void _lainnyaModalBottomSheet(context, String param){
    showModalBottomSheet(
        isScrollControlled: param == 'barcode' ? false : true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          if(param == 'barcode'){
            return Wrap(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1,
                  child: Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                      elevation: 5.0,
                      color:Colors.grey[50],
                      child: Column(
                          children: <Widget>[
                            SizedBox(height: 20,),
                            Text("Scan Kode Referral Anda ..", style: TextStyle(color: Colors.black,fontSize: 14,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Image.network(_qr,fit: BoxFit.contain,),
                            )
                          ]
                      )
                  ),
                )
              ],
            );
          }
          else if(param == 'compass'){
            return MainCompass();
          }
          else{
            return Wrap(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(

                      children: <Widget>[
                        SizedBox(height: 20),
                        Text("FITUR LAINNYA", style: TextStyle(color: Colors.black,fontSize: 16,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
                        SizedBox(height: 15),
                        Divider(),
                        SizedBox(height: 30),
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          children: <Widget>[
                            moreStructure("revisi/pulsa.svg", "pulsa", "Pulsa"),
                            moreStructure("revisi/Icon_PPOB_LISTRIK.svg", "listrik", "Listrik"),
                            moreStructure("revisi/Icon_PPOB_TELEPON_PASCA_BAYAR.svg", "telepon", "Telepon/Internet"),
//                            moreStructure("revisi/Icon_PPOB_ZAKAT.svg", "zakat", "Zakat"),
                            moreStructure("revisi/Icon_PPOB_E _ MONEY.svg", "emoney", "E-Money"),
                            moreStructure("revisi/Icon_PPOB_BPJS.svg", "bpjs", "BPJS"),
//                            moreStructure("revisi/Icon_PPOB_Asuransi.svg", "asuransi", "Asuransi"),
                            moreStructure("revisi/Icon_PPOB_PDAM.svg", "pdam", "PDAM"),
                            moreStructure("revisi/Icon_PPOB_MultiFinance.svg", "multiFinance", "Multi Finance"),
//                            moreStructure("revisi/Icon_PPOB_VOUCHER_WIFI_ID.svg", "wifiId", "Wifi ID"),
                            moreStructure("revisi/Icon_PPOB_TV_KABEL.svg", "tvKabel", "Tv Kabel"),
                          ],
                        )
                      ]
                  ),
                )
              ],
            );
          }
        }
    );
  }
  Widget cardSaldoNoPlatinum(BuildContext context,saldoMain,saldoBonus,saldoVoucher,saldoPlatinum) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
           Center(
             child:  Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 AutoSizeTextQ(
                   'Saldo Utama',
                   textAlign: TextAlign.center,
                   style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold,),
                   maxLines: 2,
                 ),
                 SizedBox(height:2.0),
                 AutoSizeTextQ(
                     saldoMain,
                     textAlign: TextAlign.center,
                     style: TextStyle(fontSize:10.0,color:statusLevel!='0'?Colors.white:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                     maxLines: 2
                 ),
               ],
             ),
           ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                    'Saldo Bonus',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(
                    saldoBonus,
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize:10.0,color:statusLevel!='0'?Colors.white:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                    'Saldo Voucher',
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(
                    saldoVoucher,
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize:10.0,color:statusLevel!='0'?Colors.white:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AutoSizeTextQ('Saldo Platinum',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                  SizedBox(height:2.0),
                  AutoSizeTextQ(
                      saldoPlatinum,
                      textAlign: TextAlign.center,

                      style: TextStyle(fontSize:10.0,color:statusLevel!='0'?Colors.white:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                ],
              ),
            )
          ],
        )
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
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                  'Saldo Utama',
                  style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold,),
                  maxLines: 2,
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(
                    widget.saldoMain,
                    style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                    'Saldo Bonus',
                    style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoBonus,style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ('Saldo Voucher',style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoVoucher,style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ('Saldo Platinum',style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoPlatinum,style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
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
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                  'Saldo Utama',
                  style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold,),
                  maxLines: 2,
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(
                    widget.saldoMain,
                    style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ(
                    'Saldo Bonus',
                    style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),
                    maxLines: 2
                ),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoBonus,style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ('Saldo Voucher',style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoVoucher,style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,width: 1.0,child: Container(color: Colors.white),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeTextQ('Saldo Platinum',style: TextStyle(fontSize:8.0,color:Colors.white,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
                SizedBox(height:2.0),
                AutoSizeTextQ(widget.saldoPlatinum,style: TextStyle(fontSize:10.0,color:Colors.yellowAccent,fontFamily:ThaibahFont().fontQ,fontWeight:FontWeight.bold),maxLines: 2),
              ],
            ),
          ],
        )
    );
  }
}


class CardEmoney extends StatefulWidget {
  final String imgUrl;final String title; final Function xFunction;
  CardEmoney({this.imgUrl,this.title,this.xFunction});
  @override
  _CardEmoneyState createState() => _CardEmoneyState();
}

class _CardEmoneyState extends State<CardEmoney> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          widget.xFunction();
        },
        child:ListTile(
          contentPadding: EdgeInsets.only(left:10.0,right:10,top:10,bottom:10),
          title: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize:MainAxisSize.min ,
            children: <Widget>[
              SvgPicture.network(
                ApiService().iconUrl+widget.imgUrl+'.svg',
                placeholderBuilder: (context) => SkeletonFrame(width: ScreenUtilQ.getInstance().setWidth(60),height: ScreenUtilQ.getInstance().setHeight(60)),
                height: ScreenUtilQ.getInstance().setHeight(60),
                width: ScreenUtilQ.getInstance().setWidth(60),
              ),
              SizedBox(height: 5.0),
              Text(widget.title,textAlign: TextAlign.center, style: TextStyle(color:ThaibahColour.primary1,fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ)),
            ],
          )),
        ),
      ),
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
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
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


//
//class CompasPage extends StatefulWidget {
//  @override
//  _CompasPageState createState() => _CompasPageState();
//}
//class _CompasPageState extends State<CompasPage> {
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return WebviewScaffold(
//      url: 'https://qiblafinder.withgoogle.com/intl/id/onboarding',
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        centerTitle: false,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//        elevation: 1.0,
//        automaticallyImplyLeading: true,
//        title: new Text("Arah Kiblat", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//      ),
//      withZoom: true,
//      withLocalStorage: true,
//      hidden: true,
//      initialChild: Container(
//        color: Colors.white,
//        child: const Center(
//          child: CircularProgressIndicator(),
//        ),
//      ),
//    );
//  }
//}

//
//class IsPIN extends StatefulWidget {
//  @override
//  _IsPINState createState() => _IsPINState();
//}
//
//class _IsPINState extends State<IsPIN> {
//  @override
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  var onTapRecognizer;
//  bool hasError = false;
//  String currentText = "";
//  final userRepository = UserRepository();
//  var pin;
//  @override
//  void initState() {
//    onTapRecognizer = TapGestureRecognizer()
//      ..onTap = () {
//        Navigator.pop(context);
//      };
//
//    super.initState();
//    _check();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//  bool _isLoading = false;
//  Future _check() async {
//    pin = await userRepository.getPin();
//  }
//  void showInSnackBar(String value,background) {
//    FocusScope.of(context).requestFocus(new FocusNode());
//    _scaffoldKey.currentState?.removeCurrentSnackBar();
//    _scaffoldKey.currentState.showSnackBar(new SnackBar(
//      content: new Text(
//        value,
//        textAlign: TextAlign.center,
//        style: TextStyle(
//            color: Colors.white,
//            fontSize: 16.0,
//            fontWeight: FontWeight.bold,
//            fontFamily: "Rubik"),
//      ),
//      backgroundColor: background,
//      duration: Duration(seconds: 3),
//    ));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        centerTitle: false,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//        elevation: 1.0,
//        automaticallyImplyLeading: true,
//        title: new Text("Keamanan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//      ),
//      key: _scaffoldKey,
//      body: GestureDetector(
//        onTap: () {
//          FocusScope.of(context).requestFocus(new FocusNode());
//        },
//        child: Container(
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
//          child: ListView(
//            children: <Widget>[
//              SizedBox(height: 30),
//              Image.asset(
//                'assets/images/verify.png',
//                height: MediaQuery.of(context).size.height / 3,
//                fit: BoxFit.fitHeight,
//              ),
//              SizedBox(height: 8),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 8.0),
//                child: Text(
//                  'Masukan Pin',
//                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Padding(
//                  padding:
//                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
//                  child: Builder(
//                    builder: (context) => Padding(
//                      padding: const EdgeInsets.all(5.0),
//                      child: Center(
//                        child: PinPut(
//                          fieldsCount: 6,
//                          isTextObscure: true,
//                          onSubmit: (String txtPin){
//                            setState(() {
//                              _isLoading=true;
//                            });
//                            if(int.parse(txtPin) == pin){
//                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
//                            }else{
//                              print('salaha');
//                            }
//                          },
//                          actionButtonsEnabled: false,
//                          clearInput: true,
//                        ),
//                      ),
//                    ),
//                  )
//              ),
//
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
class CustomText {
  final String label;
  final double fontSize;
  final String fontName;
  final int textColor;
  final int iconColor;
  final TextAlign textAlign;
  final int maxLines;
  final IconData icon;

  CustomText(
      {@required this.label,
        this.fontSize = 10.0,
        this.fontName,
        this.textColor = 0xFF000000,
        this.iconColor = 0xFF000000,
        this.textAlign = TextAlign.start,
        this.maxLines = 1,
        this.icon=Icons.broken_image
      });

  Widget text() {
    var text = new Text(
      label,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: new TextStyle(
        color: Color(textColor),
        fontSize: fontSize,
        fontFamily: fontName,
      ),
    );

    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new Icon(icon,color: Color(iconColor),),
        ),
        text
      ],
    );
  }
}








