import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/nearbyMosqueModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/nearbyMosqueBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class MasjidTerdekat extends StatefulWidget {
  final String lat,lng;
  MasjidTerdekat({this.lat,this.lng});
  @override
  _MasjidTerdekatState createState() => _MasjidTerdekatState();
}

class _MasjidTerdekatState extends State<MasjidTerdekat> {


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
    print('latitude = ${widget.lat}, longitude = ${widget.lng}');
    nearbyMosqueBloc.fetchCariSurat(widget.lat,widget.lng);
    loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:UserRepository().appBarWithButton(context,"Masjid Terdekat",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: StreamBuilder(
        stream: nearbyMosqueBloc.getResult,
        builder: (context, AsyncSnapshot<NearbyMosqueModel> snapshot) {
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){

                        },
                        child:  Card(
                          elevation: 0.0,
                          margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              leading: SkeletonFrame(width:90.0,height: 50.0),
                              title: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                              subtitle: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                            ),
                          ),
                        ),
                      );
                    },
                  )
              )
            ],
          );
        },
      ),
    );
  }


  Widget buildContent(AsyncSnapshot<NearbyMosqueModel> snapshot, BuildContext context) {
    if(snapshot.data.result.length > 0){
      return  Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                itemCount: snapshot.data.result.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async{
                      MapUtils.openMap(snapshot.data.result[index].lat,snapshot.data.result[index].lng);

//                      var mapSchema = 'geo:${snapshot.data.result[index].lat},${snapshot.data.result[index].lat}';
//                      if (await canLaunch(mapSchema)) {
//                        await launch(mapSchema);
//                      } else {
//                        throw 'Could not launch $mapSchema';
//                      }
                      String url = 'https://www.google.com/maps/search/${Uri.encodeFull("${snapshot.data.result[index].name}, ${snapshot.data.result[index].address}, ${snapshot.data.result[index].city}, ${snapshot.data.result[index].state}, ${snapshot.data.result[index].country}")}';
                      print(url);
                      if (await canLaunch(url)) {
                        await launch(url);
                      }else{

                      }
                    },
                    child:  Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                          leading: Container(
                            width: 45.0,
                            height: 40.0,
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.network(
                              ApiService().iconUrl+'mesjid2.svg',
                              placeholderBuilder: (context) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),

                              height: ScreenUtilQ.getInstance().setHeight(60),
                              width: ScreenUtilQ.getInstance().setWidth(60),
                            ),
                          ),
                          title: Text(
                            snapshot.data.result[index].name,style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(snapshot.data.result[index].address, style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.grey,fontSize: 11.0,fontWeight:FontWeight.bold))
                            ],
                          ),
                          trailing: Text(snapshot.data.result[index].distance,style: TextStyle(fontFamily:ThaibahFont().fontQ,color: Colors.black,fontSize: 11.0,fontWeight:FontWeight.bold),),
                        ),
                      ),
                    ),
                  );
                },
              )
          )
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily:ThaibahFont().fontQ),))
          ),
        ],
      );
    }

  }
}

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}