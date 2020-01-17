import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/royalti/royaltiMemberModel.dart';
import 'package:thaibah/UI/Homepage/level.dart';
import 'package:thaibah/bloc/royalti/royaltiBloc.dart';

class WrapperLevel extends StatefulWidget {

  @override
  _WrapperLevelState createState() => _WrapperLevelState();
}

class _WrapperLevelState extends State<WrapperLevel> {

  bool isLoading = false;

  Future searchMember(param) async{
    setState(() {
      isLoading = true;
    });
    if(param == 'kosong'){
      setState(() {
        isLoading = false;
      });
      if(mounted){
        royaltiMemberBloc.fetchRoyaltiMemberList('kosong');
      }

    }else{
      setState(() {
        isLoading = false;
      });
      if(mounted){
        royaltiMemberBloc.fetchRoyaltiMemberList(param);
      }


    }

//    return CircularProgressIndicator(backgroundColor: Colors.green,);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchMember('kosong');
    isLoading = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return wrapperBuildContent(context);
  }

  Widget wrapperBuildContent(BuildContext context){
    return Container(

      padding: EdgeInsets.only(right:12.0,left:12.0,top:0,bottom:0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Color(0xFF116240),Color(0xFF30cc23)],
          ),
        ),
//        elevation: 0.0,
//        color: Color(0xFF2196f3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: Level(onItemInteraction:(param){
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
                  return CircularProgressIndicator(backgroundColor: Colors.green,);
                }
            ),
          ],
        ),
      ) ,
    );
  }

  Widget buildContent(AsyncSnapshot<RoyaltiMemberModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return Container(
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
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
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
                      Text(snapshot.data.result[index].memberName, textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
                      Text(snapshot.data.result[index].level, textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik'))
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }else{
      return Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text('tidak ada data',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
        ),
      );
    }
  }

}
