import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/Model/mainUiModel.dart';
import 'package:thaibah/Model/user_location.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Homepage/news.dart';
import 'package:thaibah/UI/Homepage/newsCategory.dart';
import 'package:thaibah/UI/Widgets/mainCompass.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/asma_ui.dart';
import 'package:thaibah/UI/component/about.dart';
import 'package:thaibah/UI/component/inspirasi.dart';
import 'package:thaibah/UI/component/inspirasiHome.dart';
import 'package:thaibah/UI/component/news/newsPage.dart';
import 'package:thaibah/UI/component/penarikan.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/UI/component/prayerList.dart';
import 'package:thaibah/UI/component/royalti/infoRoyaltiLevel.dart';
import 'package:thaibah/UI/component/royalti/level.dart';
import 'package:thaibah/UI/component/suratHome.dart';
import 'package:thaibah/UI/history_ui.dart';
import 'package:thaibah/UI/lainnya/doaHarian.dart';
import 'package:thaibah/UI/lainnya/kalender.dart';
import 'package:thaibah/UI/lainnya/masjidTerdekat.dart';
import 'package:thaibah/UI/lainnya/ppobPascabayar.dart';
import 'package:thaibah/UI/lainnya/ppobPrabayar.dart';
import 'package:thaibah/UI/lainnya/subDoaHadist.dart';
import 'package:thaibah/UI/lainnya/telkom.dart';
import 'package:thaibah/UI/lainnya/wifiId.dart';
import 'package:thaibah/UI/loginPhone.dart';
import 'package:thaibah/UI/ppob/listrik_ui.dart';
import 'package:thaibah/UI/ppob/pulsa_ui.dart';
import 'package:thaibah/UI/ppob/zakat_ui.dart';
import 'package:thaibah/UI/quran_list_ui.dart';
import 'package:thaibah/UI/saldo_ui.dart';
import 'package:thaibah/UI/transfer_ui.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaibah/resources/location_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';



class Beranda extends StatefulWidget {
  final String lat;
  final String lng;
  Beranda({this.lat,this.lng});
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda>{
  final TextStyle whiteText = TextStyle(color: Colors.white);
  final userRepository = UserRepository();

  String _idSurat='', _surat='',_suratAyat='',_terjemahan='',_ayat='',_suratNama='';
  String _hijri='',_masehi='',_name='',_saldo="Rp 0",_saldoBonus="0",_inspiration='',_saldoMain="0", _saldoVoucher="0";
  String pinku = "", id="", _nohp='', _level='';
  String _picture='',_kdRefferal='',_qr='', _thumbnail='', _versionCode='';
  bool showAlignmentCards = false;
  bool isLoading = false;
  double _height;
  double _width;
  var isPin;

  int jam    = 0;
  int menit  = 0;
  String waktuSholat = '';
  String keterangan = '';
  String latitude = '', longitude = '';
  bool versi = false;

  Future cekStatusLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('id') == null || prefs.getString('id') == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
    }
  }
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isPin'));
    final isPinZero  = await userRepository.getPin();
    cekStatusLogin();


    String id = await userRepository.getID();
    var jsonString = await http.get(ApiService().baseUrl+'info?id='+id);
    if (jsonString.statusCode == 200) {
      final jsonResponse = json.decode(jsonString.body);
      Info response = new Info.fromJson(jsonResponse);
      _level = (response.result.level);
      _name         = (response.result.name);
      _nohp         = (response.result.noHp);
      _kdRefferal   = (response.result.kdReferral);
      _picture      = (response.result.picture);
      _qr           = (response.result.qr);
      _saldo        = (response.result.saldo);
      _saldoMain    = (response.result.saldoMain);
      _saldoBonus   = (response.result.saldoBonus);
      _saldoVoucher   = (response.result.saldoVoucher);
      _masehi       = (response.result.masehi.toString());
      _hijri        = (response.result.hijri.toString());
      _idSurat      = (response.result.ayat.id);
      _surat        = (response.result.ayat.surat.toString());
      _suratNama    = (response.result.ayat.surahNama.toString());
      _ayat         = (response.result.ayat.ayat.toString());
      _suratAyat    = (response.result.ayat.surahAyat);
      _terjemahan   = (response.result.ayat.terjemahan);
      _inspiration  = (response.result.inspiration);
      _thumbnail  = (response.result.thumbnail);
      _versionCode = (response.result.versionCode);
      if(_versionCode != ApiService().versionCode){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdatePage()), (Route<dynamic> route) => false);
      }else{
        if(isPinZero == 0){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Pin(saldo: '',param: 'beranda')), (Route<dynamic> route) => false);
          print("############################ CAN BOGA PIN ########################");
        }else{
          setState(() {
            isPin = prefs.getBool('isPin');
          });
          if(isPin == false){
            prefs.setBool('isPin', true);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) => PinScreen(callback: _callBackPin)
            ), (Route<dynamic> route) => false);
            print("############################ KUDU NGABUSKEUN PIN ########################");
          }else{
            print("############################ TEU KUDU NGABUSKEUN PIN $isPinZero ########################");

          }
        }
      }
      setState(() {
        isLoading = false;
      });
      print("###########################################################LOAD DATA HOME###############################################################");
      print(jsonResponse);
    } else {
      throw Exception('Failed to load info');
    }
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
    }
    else{
//      setState(() {Navigator.of(context).pop();});
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!"),
            content: new Text("Masukan pin yang sesuai."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DateTime dt = DateTime.now();
  Duration duration;
  Duration position;

  String localFilePath;



  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  bool isPlay = false;
  AudioPlayer audioPlayer = AudioPlayer();
  Timer _timer, _timer2;
  bool showVolume = false;
  var shubuh; var sunrise; var dzuhur; var ashar; var maghrib; var isya;
  var menitShubuh;var menitSunrise;var menitDzuhur;var menitAshar; var menitMaghrib; var menitIsya;
  String _timeString='', _timeStringClone='';
  String detikDzuhur = '0';

  PrayerModel prayerModel;


  void play(mp3URL) async {
    print(mp3URL);
    if (!isPlay) {
      int result = await audioPlayer.play(mp3URL);
      if (result == 1) {
        setState(() {
          isPlay = true;
        });
      }
    } else {
      int result = await audioPlayer.stop();
      if (result == 1) {
        setState(() {
          isPlay = false;
        });
      }
    }
  }



  Future onSelectNotification(String payload) async {
    await audioPlayer.stop();
    setState(() {
      isPlay = false;
      showVolume = false;
//      isActive = 0;
    });
  }
  int isActive = 0;

  showNotification(String title, desc, ) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$desc', platform,payload: 'Nitish Kumar Singh is part time Youtuber');
  }


//  BuildContext context = context;
//  BuildContext context;
  Future<void> loadPrayer() async {
    print("############################## LOCATION ##########################");
//    print(Provider.of<UserLocation>(context).latitude);
//    var jsonString = await http.get(ApiService().baseUrl+'islamic/jadwalsholat?long=${lng==null?'':lng}&lat=${lat==null?'':lat}');
    var jsonString = await http.get(ApiService().baseUrl+'islamic/jadwalsholat?long=${widget.lng==null?'':widget.lng}&lat=${widget.lat==null?'':widget.lat}');
//    print('islamic/jadwalsholat?long=${widget.lng}&lat=${widget.lat}');
    print("###################################### JADWAL SHOLAT ###################################");
    print(jsonString.body);

    if (jsonString.statusCode == 200) {
      final jsonResponse = json.decode(jsonString.body);
      prayerModel = new PrayerModel.fromJson(jsonResponse);
      shubuh        = new DateFormat('HH').format(prayerModel.result.fajr);
      sunrise       = new DateFormat('HH').format(prayerModel.result.sunrise);
      dzuhur        = new DateFormat('HH').format(prayerModel.result.dhuhr);
      ashar         = new DateFormat('HH').format(prayerModel.result.asr);
      maghrib       = new DateFormat('HH').format(prayerModel.result.maghrib);
      isya          = new DateFormat('HH').format(prayerModel.result.isha);
      menitShubuh   = new DateFormat('mm').format(prayerModel.result.fajr);
      menitSunrise  = new DateFormat('mm').format(prayerModel.result.sunrise);
      menitDzuhur   = new DateFormat('mm').format(prayerModel.result.dhuhr);
      menitAshar    = new DateFormat('mm').format(prayerModel.result.asr);
      menitMaghrib  = new DateFormat('mm').format(prayerModel.result.maghrib);
      menitIsya     = new DateFormat('mm').format(prayerModel.result.isha);
      setState(() {
        isLoading = false;
      });

      DateTime dt = DateTime.now();
      int hours  = dt.hour;
      int minute = dt.minute;

      print("SEKARANG =  $hours");
      print("DZUHUR =  $dzuhur ");
      print("ASHAR =  $ashar $menitAshar");
      print("MAGHRIB =  $maghrib $menitMaghrib");
      print("ISYA =  $isya ");
      print("SHUBUH =  $shubuh ");
      print("SUNRISE =  $sunrise ");

    } else {
      throw Exception('Failed to load info');
    }
  }
  void _getCurrentTimeClone() async{
    String strHour    = '${DateTime.now().hour}';
    String strMinute  = '${DateTime.now().minute}';
    String strSecond  = '${DateTime.now().second}';
    setState(() {
      _timeStringClone = "${strHour} : ${strMinute} : ${strSecond}";
    });
    String resMinute = '';
    String resHours  = '';
    if(strMinute.toString().length == '1' || strMinute.toString().length == 1 ){
      resMinute = "0${strMinute}";
    }else{
      resMinute = "${strMinute}";
    }
    if(strHour.toString().length == 1){
      resHours  = "0${strHour}";
    }else{
      resHours  = "${strHour}";
    }
    String compareNow     = "${resHours}${resMinute}";
    String compareMagrib  = "${maghrib}${menitMaghrib}";
    String compareIsya    = "${isya}${menitIsya}";
    String compareShubuh  = "0${shubuh}${menitShubuh}";
    String compareSunrise = "${sunrise}${menitSunrise}";
    String compareDzuhur  = "${dzuhur}${menitDzuhur}";
    String compareAshar   = "${ashar}${menitAshar}";

    String batasSubuh   = '${int.parse(compareShubuh) - 60}';
    String batasDzuuhr  = '${int.parse(compareAshar) - 60}';
    String batasAshar   = '${int.parse(compareMagrib) - 60}';
    String batasMagrib  = '${int.parse(compareIsya) - 60}';


    if((int.parse(compareIsya)-int.parse(compareNow)) <= 60 && (int.parse(compareIsya)-int.parse(compareNow)) != 00 && (int.parse(compareIsya)-int.parse(compareNow)) > 0){
      var d = Duration(hours: (int.parse(strHour)-int.parse(isya)),minutes: int.parse(strMinute)-int.parse(menitIsya));
      jam = d.abs().inMinutes;
      keterangan = '${jam} Menit Menjelang Waktu Isya';
    }else if(int.parse(compareIsya) <= int.parse(compareNow) && int.parse(compareNow) <= 2359){
      keterangan = 'selamat menunaikan sholat isya';
    }
    else if(0000 < int.parse(batasSubuh) && int.parse(compareNow) == int.parse(batasSubuh) || int.parse(compareNow) < int.parse(batasSubuh) ){
      keterangan = 'selamat menunaikan sholat tahajud';
    }
    else if((int.parse(compareShubuh)-int.parse(compareNow)) <= 60 && (int.parse(compareShubuh)-int.parse(compareNow)) != 00 && (int.parse(compareShubuh)-int.parse(compareNow)) > 0){
      var d = Duration(hours: (int.parse(strHour)-int.parse(shubuh)),minutes: int.parse(strMinute)-int.parse(menitShubuh));
      jam = d.abs().inMinutes;
      keterangan = '${jam} Menit Menjelang Waktu Shubuh';
    }else if(int.parse(compareShubuh) < int.parse(compareSunrise) && int.parse(compareNow) < int.parse(compareSunrise)){
      keterangan = 'selamat menunaikan Waktu Shubuh';
    }
    else if(int.parse(compareNow) > int.parse(compareSunrise) && int.parse(compareSunrise) < 1100 && int.parse(compareNow) < 1100 ){
      keterangan = '';
    }
    else if((int.parse(compareDzuhur)-int.parse(compareNow)) < 60 && (int.parse(compareDzuhur)-int.parse(compareNow)) != 00 && (int.parse(compareDzuhur)-int.parse(compareNow)) > 0){
      var d = Duration(hours: (int.parse(strHour)-int.parse(dzuhur)),minutes: int.parse(strMinute)-int.parse(menitDzuhur));
      jam = d.abs().inMinutes;
      keterangan = '${jam} Menit Menjelang Waktu Dzuhur';
    }
    else if(int.parse(compareNow) == int.parse(batasDzuuhr) || int.parse(compareNow) < int.parse(batasDzuuhr) ){
      keterangan = 'Selamat Menunaikan Waktu Dzuhur';
    }
    else if((int.parse(compareAshar)-int.parse(compareNow)) <= 60 && (int.parse(compareAshar)-int.parse(compareNow)) != 00 && (int.parse(compareAshar)-int.parse(compareNow)) > 0){
      var d = Duration(hours: (int.parse(strHour)-int.parse(ashar)),minutes: int.parse(strMinute)-int.parse(menitAshar));
      jam = d.abs().inMinutes;
      keterangan = '${jam} Menit Menjelang Waktu Ashar';
    }
    else if(int.parse(compareNow) == int.parse(batasAshar) || int.parse(compareNow) < int.parse(batasAshar) ){
      keterangan = 'Selamat Menunaikan Waktu Ashar';
    }
    else if((int.parse(compareMagrib)-int.parse(compareNow)) <= 60 && (int.parse(compareMagrib)-int.parse(compareNow)) != 00 && (int.parse(compareMagrib)-int.parse(compareNow)) > 0){
      var d = Duration(hours: (int.parse(strHour)-int.parse(maghrib)),minutes: int.parse(strMinute)-int.parse(menitMaghrib));
      jam = d.abs().inMinutes;
      keterangan = '${jam} Menit Menjelang Waktu Maghrib';
    }

    else if(int.parse(compareNow) == int.parse(batasMagrib) || int.parse(compareNow) < int.parse(batasMagrib) ){
      keterangan = 'Selamat Menunaikan Waktu Maghrib';
    }
    print("###################################CEK WAKTU PAS#################################################");
    print(int.parse(compareNow) > int.parse(compareSunrise) && int.parse(compareDzuhur) < 1100 );
    print(int.parse(compareNow) > int.parse(compareSunrise) || int.parse(compareDzuhur) < int.parse(compareNow));
    print(int.parse(compareNow));
    print(int.parse(compareSunrise));
    print(int.parse(compareDzuhur));
  }
  void _getCurrentTime()  async{
    String strHour    = '${DateTime.now().hour}';
    String strMinute  = '${DateTime.now().minute}';
    String strSecond  = '${DateTime.now().second}';
    setState(() {
      _timeString = "${strHour} : ${strMinute} : ${strSecond}";
    });
    print("#######################################$_timeString###########################################");
    String resMinute = '';
    String resHours  = '';
    if(strMinute.toString().length == '1' || strMinute.toString().length == 1 ){
      resMinute = "0${strMinute}";
    }else{
      resMinute = "${strMinute}";
    }
    if(strHour.toString().length == 1){
      resHours  = "0${strHour}";
    }else{
      resHours  = "${strHour}";
    }
//    print("########################LENGT HOURS ${strMinute.toString().length}###########################");
    String compareNow     = "${resHours}${resMinute}${strSecond}";
    String compareMagrib  = "${maghrib}${menitMaghrib}0";
    String compareIsya    = "${isya}${menitIsya}0";
    String compareShubuh  = "${shubuh}${menitShubuh}0";
//    String compareSunrise = "${sunrise}${menitSunrise}0";
    String compareDzuhur  = "${dzuhur}${menitDzuhur}0";
    String compareAshar   = "${ashar}${menitAshar}0";

//    String batasSubuh   = '0${int.parse(compareShubuh) - 60}';
//    String batasDzuuhr  = '${int.parse(compareAshar) - 60}';
//    String batasAshar   = '${int.parse(compareMagrib) - 60}';
//    String batasMagrib  = '${int.parse(compareIsya) - 60}';

    if(int.parse(compareIsya) == int.parse(compareNow)){
      showNotification('Selamat Menunaikan Sholat Isya','Sentuh untuk mematikan suara');
      await audioPlayer.play('https://thaibah.com/assets/adzan_.mp3');
//      _timer.cancel();
      showVolume = true;
    }
    else if(int.parse(compareNow) == int.parse(compareShubuh)){
      showNotification('Selamat Menunaikan Sholat Shubuh','Sentuh untuk mematikan suara');
      await audioPlayer.play('https://thaibah.com/assets/subuh_.mp3');
      showVolume = true;
//      _timer.cancel();
    }
    else if(int.parse(compareDzuhur) == int.parse(compareNow)){
      showNotification('Selamat Menunaikan Sholat Dzuhur','Sentuh untuk mematikan suara');
      await audioPlayer.play('https://thaibah.com/assets/adzan_.mp3');
//      _timer.cancel();
      showVolume = true;
    }
    else if(int.parse(compareAshar) == int.parse(compareNow)){
      showNotification('Selamat Menunaikan Sholat Ashar','Sentuh untuk mematikan suara');
      await audioPlayer.play('https://thaibah.com/assets/adzan_.mp3');
//      _timer.cancel();
      showVolume = true;
    }

    else if(int.parse(compareMagrib) == int.parse(compareNow)){
      showNotification('Selamat Menunaikan Sholat Maghrib','Sentuh untuk mematikan suara');
      await audioPlayer.play('https://thaibah.com/assets/adzan_.mp3');
//      _timer.cancel();
      showVolume = true;
    }
    print("###################### COMPARE NOTIF ######################");
    print(    int.parse(compareNow) == int.parse(compareShubuh));

  }


  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadData();
    loadPrayer();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekStatusLogin();
//    print("######################################")
    loadData();
    versi = true;
    isLoading=true;
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    _timer = new Timer.periodic(Duration(seconds:1), (Timer t) => _getCurrentTime());
    _timeStringClone = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    _timer2 = new Timer.periodic(Duration(seconds:1), (Timer t) => _getCurrentTimeClone());
//    var userLocation = Provider.of<UserLocation>(context);
    loadPrayer();
    print(isActive);
    latitude  = widget.lat;
    longitude = widget.lng;
  }





  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
    _timer2.cancel();
  }
  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    print(Duration(hours: hours, minutes: minutes, microseconds: micros));
  }
  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }

  Widget buildContent(BuildContext context){
    return RefreshIndicator(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildCardHeader(),
          const SizedBox(height: 10.0),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  buildCardSecond(context),
                  titleQ("Rincian Saldo Anda",Colors.black,false,''),
                  buildCardSaldo(),
                  buildCardIcon(),
                  SizedBox(height: 5.0,child: Container(color: Color(0xFFf5f5f5))),
                  const SizedBox(height: 16.0),
                  isLoading?SuratHomeLoading():SuratHome(idSurat: _idSurat,surat: _surat,suratAyat: _suratAyat,terjemahan: _terjemahan, kdReferral: _kdRefferal,suratNama:_suratNama),
                  SizedBox(height: 16.0),
                  SizedBox(height: 5.0,child: Container(color: Color(0xFFf5f5f5))),
                  const SizedBox(height: 15.0),
                  titleQ("Kategori Berita",Colors.black,false,'category'),
                  NewsCategoryHomePage(),
                  SizedBox(height: 5.0,child: Container(color: Color(0xFFf5f5f5))),
                  const SizedBox(height: 15.0),
                  titleQ("Berita Terkini",Colors.black,true,'news'),
                  NewsHomePage(),
                  SizedBox(height: 5.0,child: Container(color: Colors.transparent)),
                  const SizedBox(height: 15.0),
                  titleQ("Jenjang Karir",Colors.black,true,'level'),
                  const SizedBox(height: 15.0),
                  WrapperLevel(),
                  const SizedBox(height: 15.0),
                  titleQ("Informasi & Inspirasi",Colors.black,true,'inspirasi'),
                  const SizedBox(height: 15.0),
                  isLoading?SuratHomeLoading():InspirasiHome(imgInspiration: _inspiration, kdReferral:_kdRefferal,thumbnail:_thumbnail),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          )
        ],
      ),
      onRefresh: _refresh
    );
  }

  Widget buildCardSecond(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(15.0),
      child:Container(
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width/1,
        color: isLoading?Colors.transparent:Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      _lainnyaModalBottomSheet(context,'barcode');
                    },
                    child: Container(
                      child: isLoading?SkeletonFrame(width: 50.0,height: MediaQuery.of(context).size.height/15):Image.network(
                        _qr,
                        height: MediaQuery.of(context).size.height/15,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.0),
                  isLoading? SkeletonFrame(width: 60.0,height: 12.0):Text('QR Code',style: TextStyle(fontSize:16.0,color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                  SizedBox(height: 5.0),
                  isLoading? SkeletonFrame(width: 70.0,height: 12.0):Text('Untuk Transfer',style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                  SizedBox(height: 2.0),
                  isLoading? SkeletonFrame(width: 80.0,height: 12.0):Text('Ke Sesama Member',style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                ],
              ),
            ),
            Container(
              width:1.0,
              color: Colors.grey,
              height: 110.0,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await WcFlutterShare.share(
                        sharePopupTitle: 'Thaibah Share Link',
                        subject: 'Thaibah Share Link',
                        text: "https://thaibah.com/signup/$_kdRefferal\n\n\nAyo Buruan daftar",
                        mimeType: 'text/plain'
                      );
                    },
                    child: Container(
                      child: isLoading?SkeletonFrame(width: 50.0,height: MediaQuery.of(context).size.height/15):Image.asset(
                        'assets/images/shareIcon.png',
                        height: MediaQuery.of(context).size.height/15,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.0),
                  isLoading? SkeletonFrame(width: 60.0,height: 12.0):Text('Share',style: TextStyle(fontSize:16.0,color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                  SizedBox(height: 5.0),
                  isLoading? SkeletonFrame(width: 70.0,height: 12.0):Text('Share Link',style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                  SizedBox(height: 2.0),
                  isLoading? SkeletonFrame(width: 80.0,height: 12.0):Text('Ke Kerabat Anda',style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardHeader(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isLoading?<Color>[Color(0xFFfafafa),Color(0xFFfafafa)]:<Color>[Color(0xFF116240),Color(0xFF30cc23)],
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
                    isLoading?SkeletonFrame(width: 100.0,height: 100.0,):CircleAvatar(
                      radius: 35.0,
                      child: CachedNetworkImage(
                        imageUrl: _picture==null?IconImgs.noImage:_picture,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text(_name,style: whiteText.copyWith(fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                        ),
                        SizedBox(height: 7.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text('Kode Referral : '+_kdRefferal,style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                        ),
                        SizedBox(height: 7.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0):Text('Jenjang Karir : ${_level}',style: whiteText.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                        ),
                      ],
                    )

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 12.0):
                    Row(
                      children: <Widget>[
                        Text('$_timeStringClone',style: TextStyle(fontSize:24.0,color:Colors.white,fontFamily: 'Rubik',fontWeight:FontWeight.bold),),
                        SizedBox(width: 10.0,),
                        showVolume? InkWell(
                          onTap: () async{
                            await audioPlayer.stop();
                            setState(() {
                              isPlay = false;
                              showVolume = false;
                            });
                          },
                          child: Icon(Icons.stop),
                        ):Text('')
                      ],
                    ),
                    SizedBox(height:2.0),
                    isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 12.0) : Text('$keterangan',style: TextStyle(fontSize:12.0,color:Colors.white,fontFamily: 'Rubik',fontWeight:FontWeight.bold),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 12.0):InkWell(
                      child: Text('Versi : '+ApiService().versionCode,style: TextStyle(fontSize:12.0,color:Colors.white,fontFamily: 'Rubik',fontWeight:FontWeight.bold),),
                    ),
                    SizedBox(height:10.0),
                    isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 12.0):InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(
                          new CupertinoPageRoute(builder: (context) => CompasPage()),
                        );
                      },
//                      onTap: () async {
//                        print('cek');
//                        String url = 'https://qiblafinder.withgoogle.com/intl/id/finder/map';
////                        String url = 'https://www.google.com/maps/search/mosque+maps+google/@${widget.lat},${widget.lng},12z/data=!3m1!4b1';
//                        if (await canLaunch(url)) {
//                          await launch(url);
//                        }else{
//
//                        }
//                      },
                      child: Text('Lihat Arah Kiblat',style: TextStyle(fontSize:12.0,color:Colors.white,fontFamily: 'Rubik',fontWeight:FontWeight.bold),),
                    ),
                  ],
                ),

              ],
            )
          )

        ],
      ),
    );
  }

  Widget buildCardSaldo(){
    return Card(
      elevation: isLoading?0.0:4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: isLoading?Colors.transparent:Colors.white,
      margin: const EdgeInsets.only(left:15.0,right:15.0,top:15.0,bottom:15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child: Column(
                children: <Widget>[
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-rQgCZkgFg-Om5juLS6DMUZSkcipOcMhFUi36URkc2CCBn5J0',width: 20.0,),
                  SizedBox(height: 5.0),
                  Text("Saldo Utama", style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                  SizedBox(height: 5.0),
                  Text(_saldoMain, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 10.0,fontFamily: 'Rubik'))
                ],
              )),
//              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child: Text("Saldo Utama", style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),),
//              subtitle: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child:Text(_saldoMain, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 10.0,fontFamily: 'Rubik'))),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/13,width: 1.0,child: Container(color: Colors.green),),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child: Column(
                children: <Widget>[
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-rQgCZkgFg-Om5juLS6DMUZSkcipOcMhFUi36URkc2CCBn5J0',width: 20.0,),
                  SizedBox(height: 5.0),
                  Text("Saldo Bonus", style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                  SizedBox(height: 5.0),
                  Text(_saldoBonus, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 10.0,fontFamily: 'Rubik'))
                ],
              )),
//              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child: Text("Saldo Bonus", style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),),
//              subtitle: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child:Text(_saldoBonus, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 10.0,fontFamily: 'Rubik'))),
//              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Text("Saldo Bonus", style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//              subtitle: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Text(_saldoBonus, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 11.0,fontFamily: 'Rubik')),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/13,width: 1.0,child: Container(color: Colors.green),),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child: Column(
                children: <Widget>[
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-rQgCZkgFg-Om5juLS6DMUZSkcipOcMhFUi36URkc2CCBn5J0',width: 20.0,),
                  SizedBox(height: 5.0),
                  Text("Saldo Voucher", style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                  SizedBox(height: 5.0),
                  Text(_saldoVoucher, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 10.0,fontFamily: 'Rubik'))
                ],
              )),
//              subtitle: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Center(child:Text(_saldoVoucher, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 10.0,fontFamily: 'Rubik'))),
//              title: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Text("Saldo Voucher", style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//              subtitle: isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:16.0):Text(_saldoVoucher, style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 11.0,fontFamily: 'Rubik')),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardIcon(){
    return Card(
      elevation: isLoading?0.0:4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: isLoading?Colors.transparent:Colors.white,
      margin: const EdgeInsets.only(left:15.0,right: 15.0,top: 10.0,bottom: 10.0),
      child: Padding(
          padding: const EdgeInsets.only(left:0.0,right:0.0,top:0.0,bottom: 0.0),
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 1.1,
            crossAxisCount: 4,
            children: <Widget>[
              wrapperIcon(context,ApiService().iconUrl+'revisi/topup.svg', 'Topup','topup'),
              wrapperIcon(context,ApiService().iconUrl+'revisi/history.svg','Riwayat','riwayat'),
              wrapperIcon(context,ApiService().iconUrl+'revisi/transfer.svg','Transfer','transfer'),
              wrapperIcon(context,ApiService().iconUrl+'penarikan.svg','Penarikan','penarikan'),
              wrapperIcon(context,ApiService().iconUrl+'revisi/jadwal_solat.svg','Prayer','prayer'),
              wrapperIcon(context,ApiService().iconUrl+'revisi/asmaul_husna.svg','99 Nama','asma'),
              wrapperIcon(context,ApiService().iconUrl+'revisi/alquran.svg','Al-Quran','alquran'),
              wrapperIcon(context,ApiService().iconUrl+'revisi/more.svg','Lainnya','lainnya'),
            ],
          )
      ),
    );
  }

  Widget wrapperIcon(BuildContext context,String imgUrl, String title, String type){
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Column(
      mainAxisSize:MainAxisSize.min ,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if(type == 'topup'){
              print('topup');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => SaldoUI(saldo: _saldoMain,name: _name)),
              ).whenComplete(loadData);
            }
            if(type == 'riwayat'){
              print('riwayat');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => HistoryUI(page: 'home')),
              );
            }
            if(type == 'transfer'){
              print('transfer');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => TransferUI(saldo:_saldoMain,qr:_qr)),
              );
            }
            if(type == 'alquran'){
              print('alquran');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => QuranListUI()),
              );
            }
            if(type == 'prayer'){
              print('prayer');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => PrayerList()),
              );
            }
            if(type == 'penarikan'){
              print('tentang');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => Penarikan(saldoMain: _saldoMain)),
              );
            }
            if(type == 'asma'){
              print('asma');
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => AsmaUI()),
              );
            }
            if(type == 'lainnya'){
              _lainnyaModalBottomSheet(context,'ppob');
            }
          },
          child: SvgPicture.network(
            isLoading?"http://lequytong.com/Content/Images/no-image-02.png":'$imgUrl',
            placeholderBuilder: (context) => SkeletonFrame(width: ScreenUtil.getInstance().setWidth(60),height: ScreenUtil.getInstance().setHeight(60)),
            height: ScreenUtil.getInstance().setHeight(60),
            width: ScreenUtil.getInstance().setWidth(60),
          ),
        ),
        SizedBox(height: 5,),
        isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:16.0):Text("$title", style: TextStyle(fontWeight:FontWeight.bold, color:Colors.black,fontSize: 12,fontFamily: 'Rubik')),
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
          return Container(
            height: MediaQuery.of(context).size.height/1,
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              elevation: 5.0,
              color:Colors.grey[50],
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Text("Scan Kode Referral Anda ..", style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                  SizedBox(height: 10.0,),
                  Container(
                    height:MediaQuery.of(context).size.height/2,
                    padding: EdgeInsets.all(10),
                    child: Image.network(_qr),
                  )
                ]
              )
            ),
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
                    Text("FITUR LAINNYA", style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                    SizedBox(height: 15),
                    Divider(),
                    SizedBox(height: 30),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: <Widget>[
                        moreStructure("mesjid2.svg", "masjid", "Masjid Terdekat"),
                        moreStructure("hadis2.svg", "hadis", "Hadits"),
                        moreStructure("doa.svg", "doa", "Doa Harian"),
                        moreStructure("kalender_hijriah.svg", "kalender", "Kalender Hijriah"),
                        moreStructure("revisi/pulsa.svg", "pulsa", "Pulsa"),
                        moreStructure("revisi/Icon_PPOB_LISTRIK.svg", "listrik", "Listrik"),
                        moreStructure("revisi/Icon_PPOB_TELEPON_PASCA_BAYAR.svg", "telepon", "Telepon/Internet"),
                        moreStructure("revisi/Icon_PPOB_ZAKAT.svg", "zakat", "Zakat"),
                        moreStructure("revisi/Icon_PPOB_E _ MONEY.svg", "emoney", "E-Money"),
                        moreStructure("revisi/Icon_PPOB_BPJS.svg", "bpjs", "BPJS"),
                        moreStructure("revisi/Icon_PPOB_Asuransi.svg", "asuransi", "Asuransi"),
//                        moreStructure("revisi/more.svg", "telpPasca", "Telp.Pascabayar"),
                        moreStructure("revisi/Icon_PPOB_PDAM.svg", "pdam", "PDAM"),
                        moreStructure("revisi/Icon_PPOB_MultiFinance.svg", "multiFinance", "Multi Finance"),
                        moreStructure("revisi/Icon_PPOB_VOUCHER_WIFI_ID.svg", "wifiId", "Wifi ID"),
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
              new CupertinoPageRoute(builder: (context) => Inspirasi(kdReferral:_kdRefferal)),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16) : Text("$title",style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize: 14.0,color: warna)),
            isLoading?SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16) : param == true ? type == 'level' ? Text("Info Jenjang Karir",style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize: 12.0,color: warna)) : Text("Lihat Semua",style: TextStyle(fontFamily:'Rubik',fontWeight: FontWeight.bold, fontSize: 12.0,color: warna)) : Container(),
          ],
        ),
      ),
    );
  }

  /* STRUKTUR WIDGET FITUR LAINNYA */
  Widget moreStructure(var iconUrl,var page,String title){
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if(page == 'pulsa'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PulsaUI(nohp: _nohp)));}
            if(page == 'listrik'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => ListrikUI(nohp: _nohp)));}
            if(page == 'telepon'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'telkom',title:'Telepon / Internet')));}
            if(page == 'zakat'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => ZakatUI()));}
            if(page == 'masjid'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => MasjidTerdekat(lat:latitude.toString(),lng:longitude.toString())));}
            if(page == 'hadis'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => SubDoaHadist(id:'0',title: 'hadis',param: 'hadis')));}
            if(page == 'doa'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => DoaHarian(param:'doa')));}
            if(page == 'kalender'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => Kalender()));}
            if(page == 'emoney'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPrabayar(nohp:_nohp,param: "E_MONEY",title:'E-Money')));}
            if(page == 'bpjs'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'BPJS',title:'BPJS')));}
            if(page == 'asuransi'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'ASURANSI',title:'Asuransi')));}
//            if(page == 'telpPasca'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'TELEPHONE_PASCABAYAR',title:'Telepon Pascabayar')));}
            if(page == 'pdam'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'PDAM',title:'PDAM')));}
            if(page == 'multiFinance'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: 'MULTIFINANCE',title:'Multi Finance')));}
            if(page == 'wifiId'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPrabayar(nohp:_nohp,param: "VOUCHER_WIFIID",title:'Voucher Wifi ID')));}
            if(page == 'tvKabel'){Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => PpobPascabayar(param: "PEMBAYARAN_TV",title:'Tv Kabel')));}
          },
          child: SvgPicture.network(
            ApiService().iconUrl+iconUrl,
            placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
            height: ScreenUtil.getInstance().setHeight(60),
            width: ScreenUtil.getInstance().setWidth(60),
          )
        ),
        SizedBox(height: 10),
        Text(title.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 10,fontFamily: 'Rubik'),)
      ],
    );
  }

}


class CompasPage extends StatefulWidget {
  @override
  _CompasPageState createState() => _CompasPageState();
}

class _CompasPageState extends State<CompasPage> {
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: 'https://qiblafinder.withgoogle.com/intl/id/onboarding',
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF116240),
                Color(0xFF30cc23)
              ],
            ),
          ),
        ),
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Arah Kiblat", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


class IsPIN extends StatefulWidget {
  @override
  _IsPINState createState() => _IsPINState();
}

class _IsPINState extends State<IsPIN> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  final userRepository = UserRepository();
  var pin;
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
    _check();
  }

  @override
  void dispose() {
    super.dispose();
  }
  bool _isLoading = false;
  Future _check() async {
    pin = await userRepository.getPin();
  }
  void showInSnackBar(String value,background) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: background,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF116240),
                Color(0xFF30cc23)
              ],
            ),
          ),
        ),
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Keamanan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                'assets/images/verify.png',
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Masukan Pin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: PinPut(
                          fieldsCount: 6,
                          isTextObscure: true,
                          onSubmit: (String txtPin){
                            setState(() {
                              _isLoading=true;
                            });
                            if(int.parse(txtPin) == pin){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                            }else{
                              print('salaha');
                            }
                          },
                          actionButtonsEnabled: false,
                          clearInput: true,
                        ),
                      ),
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}

