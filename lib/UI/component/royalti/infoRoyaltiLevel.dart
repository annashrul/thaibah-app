import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/royalti/levelModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/royalti/royaltiBloc.dart';

class InfoRoyaltiLevel extends StatefulWidget {
  @override
  _InfoRoyaltiLevelState createState() => _InfoRoyaltiLevelState();
}

class _InfoRoyaltiLevelState extends State<InfoRoyaltiLevel> {
  final TextStyle dropdownMenuItem =
  TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

  @override
  void initState() {
    super.initState();
    royaltiLevelBloc.fetchLevelList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
        title: new Text("Info Jenjang Karir", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
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
        elevation: 0.0,
      ),
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
              borderRadius: BorderRadius.circular(25),
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
                      Text(
                        snapshot.data.result.data[index].name,
                        style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Divider(),
                      Text('Jumlah Kaki',style: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                      Row(
                        children: <Widget>[
                          generateStart(snapshot.data.result.data[index].kaki),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[

                          Text("Nilai Omset per kaki sebesar : "+snapshot.data.result.data[index].omset,
                              style: TextStyle(
                                  fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: primary, fontSize: 11, letterSpacing: .3)),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[

                          Text("Mendapatkan Royalti Sebesar : " +snapshot.data.result.data[index].royalti.toString()+" % x Omset Nasional",
                              style: TextStyle(
                                  fontFamily: 'Rubik',fontWeight: FontWeight.bold,color: primary, fontSize: 11, letterSpacing: .3)),
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
            return Icon(Icons.star,color: Colors.amberAccent,size: 20);
          }else{
            return Icon(Icons.star_border);
          }
        }),
      ),
    );
  }

}
