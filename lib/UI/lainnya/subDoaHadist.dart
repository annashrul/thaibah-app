import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/islamic/subCategoryDoaModel.dart';
import 'package:thaibah/UI/Homepage/index.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/lainnya/listDoaHadist.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/api.dart';

class SubDoaHadist extends StatefulWidget {
  final String id,title,param;
  SubDoaHadist({this.id,this.title,this.param});

  @override
  _SubDoaHadistState createState() => _SubDoaHadistState();
}

class _SubDoaHadistState extends State<SubDoaHadist> {

  String idLocal = '';
  String param = '';
  String title = '';
  var scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idLocal = widget.id;
    param = widget.param;
    if(param == 'hadis'){
      title = 'Hadits';
      subCategoryDoaHadistBloc.fetchSubCategoryDoaHadist('hadis',idLocal);
    }else{
      title = "Do'a";
      subCategoryDoaHadistBloc.fetchSubCategoryDoaHadist('doa',idLocal);
    }

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
        title: Text('${title.toUpperCase()}',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
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

                  color: Colors.white,
                  child: Column(
                      children : [
                        param=='hadis'?Container(
                          padding: EdgeInsets.only(top:10.0,bottom: 10.0,left:10.0,right:10.0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Cari hadits disini ......",
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
//                                controller: searchController,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Rubik",
                            ),
//                                focusNode: searchFocus,
                            onFieldSubmitted: (value){
//                                  searchFocus.unfocus();
//                                  if(searchController.text != ''){
//                                    search();
//                                  }

                            },
                          ),
                        ):Text(''),


                        Expanded(
                            child: StreamBuilder(
                              stream: subCategoryDoaHadistBloc.getResult,
                              builder: (context, AsyncSnapshot<SubCategoryDoaModel> snapshot) {
                                if (snapshot.hasData) {
                                  return buildContent(snapshot, context);
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }

                                return Container(
                                  padding: EdgeInsets.only(top:10.0,bottom: 10.0,left:10.0,right:10.0),
                                  child: ListView.builder(
                                    itemBuilder: (context,index){
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SkeletonFrame(width: MediaQuery.of(context).size.width/1.08,height: 16.0),
                                          SizedBox(height: 30.0)
                                        ],
                                      );
                                    },
                                    itemCount: 30,
                                  ),
                                );
                              },
                            )
                        )
                      ]
                  )
              )
          ),
        ],
      ),
//      body: StreamBuilder(
//        stream: subCategoryDoaHadistBloc.getResult,
//        builder: (context, AsyncSnapshot<SubCategoryDoaModel> snapshot) {
//          if (snapshot.hasData) {
//            return buildContent(snapshot, context);
//          } else if (snapshot.hasError) {
//            return Text(snapshot.error.toString());
//          }
//
//          return Container(
//            padding: EdgeInsets.only(top:10.0,bottom: 10.0,left:10.0,right:10.0),
//            child: ListView.builder(
//              itemBuilder: (context,index){
//                return Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    SkeletonFrame(width: MediaQuery.of(context).size.width/1.08,height: 16.0),
//                    SizedBox(height: 30.0)
//                  ],
//                );
//              },
//              itemCount: 30,
//            ),
//          );
//        },
//      ),
    );
  }

  Widget buildContent(AsyncSnapshot<SubCategoryDoaModel> snapshot, BuildContext context){
    if(snapshot.data.result.length > 0){
      return Container(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemBuilder: (context,index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    print(widget.title);
                    var kategori;
                    if(widget.title == 'Kategori Doa'){
                      kategori = 'doa';
                    }else{
                      kategori = 'hadis';
                    }
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute(builder: (context) => ListDoaHadist(
                        title:snapshot.data.result[index].title,
                        type:widget.param,
                        id: snapshot.data.result[index].id.toString(),
                        search: '',)
                      ),
                    );
                  },
                  child:Container(
                    padding: EdgeInsets.only(top:13.0,bottom: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
//                      Text('${snapshot.data.result[index].id}.',style: TextStyle(color:Colors.black,fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
//                      SizedBox(width: 10.0),
                        Flexible(
                          child: new Text("${snapshot.data.result[index].title}",
                              style: TextStyle(fontFamily: "Rubik",color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip),
                        ),
//                        Icon(Icons.arrow_forward_ios,size: 15.0)
                      ],
                    ),
                  ),
                ),

                Divider()
              ],

            );
          },
          itemCount: snapshot.data.result.length,
        ),
      );
    }else{
      return Container(
        child: Center(
          child: Text('Data Tidak Ada',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
        ),
      );
    }
  }

}
