import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/prayerBloc.dart';
import 'package:thaibah/config/user_repo.dart';

enum PlayerState { stopped, playing, paused }
typedef void OnError(Exception exception);

class PrayerList extends StatefulWidget {
  final String lng;
  final String lat;
  PrayerList({Key key,this.lng,this.lat}) : super(key: key);
  @override
  _PrayerListState createState() => _PrayerListState();
}

class _PrayerListState extends State<PrayerList> {
  double _imageHeight = 256.0;

  double _height;
  double _width;
  Duration duration;
  Duration position;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  bool isPlay = false;
  AudioPlayer audioPlayer = AudioPlayer();

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


  Future<void> pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlay = false;
      });
    }
  }

  void stop(int index) async {
    if(index == 0){
      await audioPlayer.stop();
      setState(() {
        isPlay = false;
      });
    }else if(index == 1){
      await audioPlayer.stop();
      setState(() {
        isPlay = false;
      });
    }else if(index == 2){
      await audioPlayer.stop();
      setState(() {
        isPlay = false;
      });
    }else {
      await audioPlayer.stop();
      setState(() {
        isPlay = false;
      });
    }
    print(index);
  }

//  if((int.parse(compareIsya)+20) <= int.parse(compareNow)){
//  keterangan = '';
//  print("######################################KOSONG######################################");
//  }else{
//  print("######################################AYAAN######################################");
//  keterangan = 'selamat menunaikan sholat isya';
//  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
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
    // TODO: implement initState
    super.initState();
    loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
//    var userLocation = Provider.of<UserLocation>(context);
//    prayerBloc.fetchPrayerList(userLocation.longitude==null?'':userLocation.longitude,userLocation.latitude==null?'':userLocation.latitude);
    prayerBloc.fetchPrayerList(widget.lng, widget.lat);
    return Scaffold(
      appBar:UserRepository().appBarWithButton(context,"Jadwal Sholat",warna1,warna2,(){Navigator.pop(context);},Container()),
//      body: buildContent('Dzuhur', '12:00')
      body: StreamBuilder(
          stream: prayerBloc.allPrayer,
          builder: (context, AsyncSnapshot<PrayerModel> snapshot) {
            if(snapshot.hasData){
              var background;
              var newDateTimeObj = new DateFormat().add_Hm();
              print(newDateTimeObj);
              return Column(
                children: <Widget>[
                  buildContent("Shubuh", snapshot.data.result.rawFajr,background,'http://thaibah.com/assets/subuh_.mp3',0),
                  buildContent("Dzuhur", snapshot.data.result.rawDhuhr,background,'http://thaibah.com/assets/adzan_.mp3',1),
                  buildContent("Ashar", snapshot.data.result.rawAsr,background,'http://thaibah.com/assets/adzan_.mp3',2),
                  buildContent("Maghrib", snapshot.data.result.rawMaghrib,background,'http://thaibah.com/assets/adzan_.mp3',3),
                  buildContent("Isya", snapshot.data.result.rawIsha,background,'http://thaibah.com/assets/adzan_.mp3',4),
                ],
              );
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context,i){
                    return Card(
                      color: Colors.white,
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          title: SkeletonFrame(width: _width/2,height: 16),
                          subtitle: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: <Widget>[
                                SkeletonFrame(width: _width/5,height: 16),
                                SizedBox(width: 5.0),
                                SkeletonFrame(width: _width/4,height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }


              ),
            );
          }
      ),
    );
  }

  Widget buildContent(var nama, var waktu, var background, String pathUrl, int index) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
        Card(
          color: background,
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    nama,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.access_time, color: Colors.black, size: 20.0,),
                        SizedBox(width: 5.0),
                        Text(waktu, style: TextStyle(color: Colors.green,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(

                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              await audioPlayer.play(pathUrl);
                            },
                            icon: Icon(Icons.play_circle_outline),
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () => stop(index),
                            icon: Icon(Icons.stop),
                          ),
                        ),
//                        new IconButton(
//                          onPressed: () => stop(index),
//                          iconSize: 30.0,
//                          icon: Icon(Icons.stop)
//                        ),
                      ]
                  ),
              ),
            ),
          )
        ],

      ),
    );


  }



}

