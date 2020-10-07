import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/categoryDoaModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/islamic/subDoaHadist.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';

import 'listDoaHadist.dart';

class DoaHarian extends StatefulWidget {
  final String param;
  DoaHarian({this.param});
  @override
  _DoaHarianState createState() => _DoaHarianState();
}

class _DoaHarianState extends State<DoaHarian> {


  String paramLocal = '';
  double _height;
  double _width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  String title = '';

  Future search() async{
    print('tap');
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute(builder: (context) => ListDoaHadist(
        title:'Daftar Pencarian',
        type:widget.param,
        id: "1",
        search: searchController.text,
      )
      ),
    );
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
    paramLocal = widget.param;
    title = paramLocal=="doa"?"DO'A":"HADITS";
    categoryDoaBloc.fetchCategoryDoa('$paramLocal');
    loadTheme();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Kategori",(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context,"Kategori $title",warna1,warna2,(){Navigator.pop(context);},Container()),
      body: Column(
        children: <Widget>[
          Flexible(
              child: new Container (
                  padding: const EdgeInsets.only(left:15.0,right:15.0,top:15.0),
                  color: Colors.white,
                  child: new Container(
                    child: new Center(
                        child: new Column(
                            children : [
                              new TextFormField(
                                decoration: new InputDecoration(
                                  labelStyle: TextStyle(fontSize: ScreenUtilQ().setSp(30),fontFamily: ThaibahFont().fontQ),
                                  labelText: "Cari Do`a Disini ......",
                                  fillColor: Colors.grey,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    borderSide: new BorderSide(
                                        color: Colors.grey
                                    ),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                validator: (val) {
                                  if(val.length==0) {
                                    return "Email cannot be empty";
                                  }else{
                                    return null;
                                  }
                                },
                                controller: searchController,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                style: new TextStyle(
                                  fontFamily: ThaibahFont().fontQ,fontSize: ScreenUtilQ().setSp(30)
                                ),
                                focusNode: searchFocus,
                                onFieldSubmitted: (value){
                                  searchFocus.unfocus();
                                  if(searchController.text != ''){
                                    search();
                                  }

                                },
                              ),
                              SizedBox(height: 10.0),
                              Expanded(
                                  child: ListView(
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: categoryDoaBloc.getResult,
                                        builder: (context, AsyncSnapshot<CategoryDoaModel> snapshot) {
                                          if (snapshot.hasData) {
                                            return vwPulsa(snapshot, context);
                                          } else if (snapshot.hasError) {
                                            return Text(snapshot.error.toString());
                                          }

                                          return GridView.builder(
                                            itemCount: 9,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return GestureDetector(
                                                child: Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  margin: EdgeInsets.all(1.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey, width: 0.5)
                                                  ),
                                                  child: Center(
                                                    child: GridTile(
                                                        header: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                                                        footer: SkeletonFrame(width: MediaQuery.of(context).size.width/1,height: 16),
                                                        child: Container(
                                                          padding: EdgeInsets.all(20.0),
                                                          child: Center(
                                                            child: Image.network(ApiService().noImage),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  )
                              )
                            ]
                        )
                    ),
                  )
              )
          ),
        ],
      ),
//      bottomNavigationBar: _bottomNavBarBeli(context),
    );
  }
  Widget vwPulsa(AsyncSnapshot<CategoryDoaModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return GridView.builder(
        itemCount: snapshot.data.result.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: ()=>{
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute(builder: (context) => SubDoaHadist(
                    id: snapshot.data.result[index].id.toString(),
                    title:snapshot.data.result[index].title,
                    param:widget.param
                )),
              )
            },
            child: Container(
              padding: EdgeInsets.all(7.0),
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Colors.grey, width: 0.5)
              ),
              child: Center(
                child: GridTile(
                    header: UserRepository().textQ(snapshot.data.result[index].title, 12, Colors.black,FontWeight.bold, TextAlign.center),
                    child: Container(
                      margin: EdgeInsets.only(top:15.0),
                      padding: EdgeInsets.only(left:20.0,right:20.0,top:20.0,bottom: 20.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 35.0,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.result[index].image,
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
                      ),
                    )
                ),
              ),
            ),
          );
        },
      );
    }else{
      return Container(
        child: Center(
          child: Text('Data Tidak Ada',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: ThaibahFont().fontQ),),
        ),
      );
    }

  }
//  Widget _bottomNavBarBeli(BuildContext context){
//    return Container(
//
//      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//
//          Container(
//              width: MediaQuery.of(context).size.width/1,
//              height: kBottomNavigationBarHeight,
//              child: FlatButton(
//                shape:RoundedRectangleBorder(
//                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10) ),
//                ),
//                color: Colors.green,
//                onPressed: (){
//                  Navigator.of(context, rootNavigator: true).push(
//                    new CupertinoPageRoute(builder: (context) => SubDoaHadist(
//                        id: 0.toString(),
//                        title:'Semua $title',
//                        param:widget.param
//                    )),
//                  );
//                },
//                child: Text("Lihat Semua $title".toUpperCase(), style: TextStyle(fontFamily:'Rubik',fontWeight:FontWeight.bold,color: Colors.white)),
//              )
//          )
//        ],
//      ),
//    );
//  }
}
