import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/imsakiyahModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
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
  AudioPlayer audioPlayer;
  String currentPlaying = '';
  bool isPLaying = false;
  bool isLoaded= false;
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
    prayerBloc.fetchPrayerList(widget.lng, widget.lat);
    return Scaffold(
      appBar:UserRepository().appBarWithButton(context,"Jadwal Sholat",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: StreamBuilder(
          stream: prayerBloc.allPrayer,
          builder: (context, AsyncSnapshot<PrayerModel> snapshot) {
            if(snapshot.hasData){
              var background;
              var newDateTimeObj = new DateFormat().add_Hm();
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
                          leading: Container(
                            alignment: Alignment.center,
                            width: 50.0,
                            height: 50.0,
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network('https://img.icons8.com/cotton/2x/speaker.png'),
                          ),
                          title: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16),
                          subtitle: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: <Widget>[
                                SkeletonFrame(width: MediaQuery.of(context).size.width/5,height: 16),
                                SizedBox(width: 5.0),
                                SkeletonFrame(width: MediaQuery.of(context).size.width/4,height: 16),
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
      bottomNavigationBar: !isLoaded ? null: controls(),
    );
  }

  Widget buildContent(var nama, var waktu, var background, String pathUrl, int index) {

    return GestureDetector(
        onTap: (){

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
              child: Image.network('https://img.icons8.com/cotton/2x/speaker.png'),
            ),
            title: Html(data:nama, defaultTextStyle: TextStyle(fontSize:12,fontFamily:ThaibahFont().fontQ,fontWeight: FontWeight.bold),),
            subtitle:
            Html(data:waktu, defaultTextStyle: TextStyle(fontSize:12,fontFamily:ThaibahFont().fontQ),),
            trailing: InkWell(
              onTap: (){load(nama,pathUrl);},
              child: Icon(Icons.play_circle_outline),
            ),
          ),
        )
    );
  }
  Widget controls (){
    return Container(
      height: 50.0,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: !isPLaying ? Icon(Icons.play_circle_outline): Icon(Icons.pause_circle_outline),
            onPressed: () => playpause(),
          ),

          Text(currentPlaying,style: TextStyle(fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ,fontSize:ScreenUtilQ().setSp(30)),)

        ],
      ),
    );
  }




  void load(nama,url) async{
    setState(() {
      currentPlaying = "$nama";
    });
    await audioPlayer.play(url);
    setState(() {
      isLoaded = true;
      isPLaying = true;
    });

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


}

