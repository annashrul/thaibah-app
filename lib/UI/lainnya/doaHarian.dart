import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/islamic/categoryDoaModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/tabPulsa.dart';
import 'package:thaibah/UI/lainnya/listDoaHadist.dart';
import 'package:thaibah/UI/lainnya/subDoaHadist.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/api.dart';

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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paramLocal = widget.param;
    title = paramLocal=="doa"?"DO'A":"HADITS";
    categoryDoaBloc.fetchCategoryDoa('$paramLocal');
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        elevation: 0.0,
        title: Text('KATEGORI $title',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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
      ),
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
                                  fontFamily: "Rubik",
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
                                                            child: CircleImage(imgUrl: 'http://lequytong.com/Content/Images/no-image-02.png'),
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
      bottomNavigationBar: _bottomNavBarBeli(context),
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
                    header: Text(snapshot.data.result[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize:11.0,color: Colors.black, fontFamily: "Rubik",fontWeight: FontWeight.bold),
                    ),
//                      footer: Text(
//                          "${snapshot.data.result[index].countcontent} Do'a",
//                          textAlign: TextAlign.center,
//                          style: TextStyle(color: Colors.black, fontFamily: "Rubik",fontWeight: FontWeight.bold)
//                      ),
                    child: Container(
                      margin: EdgeInsets.only(top:15.0),
                      padding: EdgeInsets.only(left:20.0,right:20.0,top:20.0,bottom: 20.0),
                      child: Center(
//                        child: CircleImage(imgUrl: snapshot.data.result[index].thumbnail),
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
          child: Text('Data Tidak Ada',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
        ),
      );
    }

  }
  Widget _bottomNavBarBeli(BuildContext context){
    return Container(

      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Container(
              width: MediaQuery.of(context).size.width/1,
              height: kBottomNavigationBarHeight,
              child: FlatButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10) ),
                ),
                color: Colors.green,
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(builder: (context) => SubDoaHadist(
                        id: 0.toString(),
                        title:'Semua $title',
                        param:widget.param
                    )),
                  );
                },
                child: Text("Lihat Semua $title".toUpperCase(), style: TextStyle(fontFamily:'Rubik',fontWeight:FontWeight.bold,color: Colors.white)),
              )
          )
        ],
      ),
    );
  }
}
