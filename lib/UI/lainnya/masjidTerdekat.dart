import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:thaibah/Model/islamic/nearbyMosqueModel.dart';
import 'package:thaibah/Model/user_location.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/nearbyMosqueBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:url_launcher/url_launcher.dart';

class MasjidTerdekat extends StatefulWidget {
  final String lat,lng;
  MasjidTerdekat({this.lat,this.lng});
  @override
  _MasjidTerdekatState createState() => _MasjidTerdekatState();
}

class _MasjidTerdekatState extends State<MasjidTerdekat> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('latitude = ${widget.lat}, longitude = ${widget.lng}');
    nearbyMosqueBloc.fetchCariSurat(widget.lat,widget.lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Masjid Terdekat", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
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

                              height: ScreenUtil.getInstance().setHeight(60),
                              width: ScreenUtil.getInstance().setWidth(60),
                            ),
                          ),
                          title: Text(
                            snapshot.data.result[index].name,style: TextStyle(fontFamily:'Rubik',color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(snapshot.data.result[index].address, style: TextStyle(fontFamily:'Rubik',color: Colors.grey,fontSize: 11.0,fontWeight:FontWeight.bold))
                            ],
                          ),
                          trailing: Text(snapshot.data.result[index].distance,style: TextStyle(fontFamily:'Rubik',color: Colors.black,fontSize: 11.0,fontWeight:FontWeight.bold),),
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
        children: <Widget>[
          Container(
              child: Center(child:Text("Data Tidak Tersedia",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),))
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