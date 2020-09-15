import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/royalti/levelModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/royalti/royaltiBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

class InfoRoyaltiLevel extends StatefulWidget {
  @override
  _InfoRoyaltiLevelState createState() => _InfoRoyaltiLevelState();
}

class _InfoRoyaltiLevelState extends State<InfoRoyaltiLevel> {
  final TextStyle dropdownMenuItem =
  TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

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
    royaltiLevelBloc.fetchLevelList();
    loadTheme();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:UserRepository().appBarWithButton(context,"Info Jenjang Karir",warna1,warna2,(){Navigator.of(context).pop();},Container()),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: StreamBuilder(
                stream: royaltiLevelBloc.getResult,
                builder: (context, AsyncSnapshot<LevelModel> snapshot){
                  if (snapshot.hasData) {
                    return buildList(snapshot, context);
                  }
                  else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context,index){
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.transparent,
                          ),
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SkeletonFrame(width: double.infinity,height: 16.0),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Divider(),
                                    SkeletonFrame(width: double.infinity,height: 16.0),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    SkeletonFrame(width: double.infinity,height: 16.0),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    SkeletonFrame(width: double.infinity,height: 16.0),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  );

                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<LevelModel> snapshot, BuildContext context) {
    return ListView.builder(
        itemCount: snapshot.data.result.data.length,
        itemBuilder: (context,index){
          return Container(
            decoration: BoxDecoration(
              
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      UserRepository().textQ(snapshot.data.result.data[index].name, 16, primary, FontWeight.bold,TextAlign.left),
                      SizedBox(height: 6,),
                      Divider(),
                      UserRepository().textQ('Jumlah Kaki', 14, Colors.black, FontWeight.bold,TextAlign.left),
                      Row(
                        children: <Widget>[
                          generateStart(snapshot.data.result.data[index].kaki),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: <Widget>[
                          Flexible(
                              child:UserRepository().textQ('Nilai Omset per kaki sebesar : ${snapshot.data.result.data[index].omset}', 12,primary, FontWeight.bold,TextAlign.left)
                          )
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: UserRepository().textQ("Mendapatkan Royalti Sebesar : ${snapshot.data.result.data[index].royalti.toString()} % x Omset Nasional", 12, primary, FontWeight.bold,TextAlign.left)
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  Widget generateStart(int rating){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(10, (index) {
          if(index < rating){
            return Flexible(child: Icon(Icons.star,color: Colors.amberAccent,size: 20));
          }else{
            return Flexible(child: Icon(Icons.star_border));
          }
        }),
      ),
    );
  }

}
