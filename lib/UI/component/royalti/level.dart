import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/royalti/royaltiMemberModel.dart';
import 'package:thaibah/UI/Homepage/level.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/royalti/royaltiBloc.dart';
import 'package:thaibah/config/user_repo.dart';

class WrapperLevel extends StatefulWidget {

  @override
  _WrapperLevelState createState() => _WrapperLevelState();
}

class _WrapperLevelState extends State<WrapperLevel> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;
  ThaibahColour thaibahColour;
  bool isLoading = false;
  final userRepository = UserRepository();
  Color warna1;
  Color warna2;
  String statusLevel ='0';
  Future searchMember(param) async{
    if(mounted){
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
      royaltiMemberBloc.fetchRoyaltiMemberList(param);

    }
  }

  Future loadRepo() async{
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
    loadRepo();
    if(mounted){
      royaltiMemberBloc.fetchRoyaltiMemberList('kosong');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return wrapperBuildContent(context);
  }

  Widget wrapperBuildContent(BuildContext context){
    return Container(
      padding: EdgeInsets.only(right:12.0,left:12.0,top:0,bottom:0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: <Color>[statusLevel!='0'?warna1:ThaibahColour.primary1,statusLevel!='0'?warna2:ThaibahColour.primary2],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: Level(onItemInteraction:(param){
                setState(() {
                  isLoading = true;
                });
                searchMember(param);
              }),
            ),

            const SizedBox(height: 20.0),
            StreamBuilder(
                stream: royaltiMemberBloc.getResult,
                builder: (context, AsyncSnapshot<RoyaltiMemberModel> snapshot){
                  if (snapshot.hasData) {
                    return buildContent(snapshot, context);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Container(child:Center(child:CircularProgressIndicator(strokeWidth:10,valueColor: AlwaysStoppedAnimation<Color>(Colors.white))));
                }
            ),
          ],
        ),
      ) ,
    );
  }

  Widget buildContent(AsyncSnapshot<RoyaltiMemberModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return isLoading?Container(child:Center(child:CircularProgressIndicator(strokeWidth:10,valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))):Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.result.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(left: 10.0,right:10.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200.0),
                    child: CachedNetworkImage(
//                      "https://cdn2.tstatic.net/palembang/foto/bank/images/ranty-maria-hijab.jpg"
                      imageUrl: snapshot.data.result[index].memberPicture==null?IconImgs.noImage:snapshot.data.result[index].memberPicture,
                      fadeInCurve: Curves.easeIn,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Visibility(
                  visible: true,
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data.result[index].memberName, textAlign: TextAlign.center,style: TextStyle(fontSize:12.0,color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                      Text(snapshot.data.result[index].level, textAlign: TextAlign.center,style: TextStyle(fontSize:12.0,color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'))
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            );
          },
        ),
      );
    }else{
      return Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: isLoading?Container(child:Center(child:CircularProgressIndicator(strokeWidth:10,valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))):Text('tidak ada data',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
        ),
      );
    }
  }

  Widget _loading(BuildContext context){
    return Container(
      padding: EdgeInsets.only(right:12.0,left:12.0,top:0,bottom:0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: <Color>[statusLevel!='0'?warna1:ThaibahColour.primary1,statusLevel!='0'?warna2:ThaibahColour.primary2],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: Level(onItemInteraction:(param){
                setState(() {
                  isLoading = true;
                });
                searchMember(param);
              }),
            ),

            const SizedBox(height: 20.0),
            StreamBuilder(
                stream: royaltiMemberBloc.getResult,
                builder: (context, AsyncSnapshot<RoyaltiMemberModel> snapshot){
                  if (snapshot.hasData) {
                    return buildContent(snapshot, context);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Container(child:Center(child:CircularProgressIndicator(strokeWidth:10,valueColor: AlwaysStoppedAnimation<Color>(Colors.white))));
                }
            ),
          ],
        ),
      ) ,
    );
  }



}
