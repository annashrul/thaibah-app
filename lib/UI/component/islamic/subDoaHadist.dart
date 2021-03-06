import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/islamic/subCategoryDoaModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/bloc/islamic/islamicBloc.dart';
import 'package:thaibah/config/user_repo.dart';

import 'listDoaHadist.dart';

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
    idLocal = widget.id;
    param = widget.param;
    loadTheme();
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
      appBar: UserRepository().appBarWithButton(context, title.toUpperCase(),(){Navigator.pop(context);},<Widget>[]),

      // appBar:UserRepository().appBarWithButton(context,"${title.toUpperCase()}",warna1,warna2,(){Navigator.pop(context);},Container()),
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
                              labelStyle: TextStyle(fontSize: ScreenUtilQ().setSp(30),fontFamily: ThaibahFont().fontQ),
                              labelText: "Cari hadits disini ......",
                              fillColor: Colors.grey,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (val) {
                              if(val.length==0) {
                                return "Email cannot be empty";
                              }else{
                                return null;
                              }
                            },
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontSize: ScreenUtilQ().setSp(30),fontFamily: ThaibahFont().fontQ,
                            ),
                            onFieldSubmitted: (value){
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
                        Flexible(
                          child: UserRepository().textQ(snapshot.data.result[index].title, 14, Colors.black,FontWeight.bold,TextAlign.left),
                        ),
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
          child: UserRepository().textQ("Data Tidak Tersedia",14,Colors.black,FontWeight.bold,TextAlign.center),
        ),
      );
    }
  }

}
