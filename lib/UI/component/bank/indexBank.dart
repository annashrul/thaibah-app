import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/generalInsertId.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/myBankModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/listBank.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/bank/formBank.dart';
import 'package:thaibah/bloc/myBankBloc.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';
class Bank extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentCardIndex = 0;
  Future delete(id) async{
    var res = await deleteMyBankBloc.fetchDeleteMyBank(id);
    if(res is General){
      General result = res;
      if(result.status == 'success'){
        setState(() {
          Navigator.of(context).pop();
        });
        UserRepository().notifNoAction(_scaffoldKey, context,"Data Bank Berhasil Dihapus","success");
        myBankBloc.fetchMyBankList();
      }else{
        setState(() {Navigator.of(context).pop();});
        UserRepository().notifNoAction(_scaffoldKey, context,result.msg,"failed");
      }
    }else{
      General results = res;
      setState(() {Navigator.of(context).pop();});
      UserRepository().notifNoAction(_scaffoldKey, context,results.msg,"failed");
    }
  }
  @override
  void initState() {
    super.initState();
    myBankBloc.fetchMyBankList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserRepository().appBarWithButton(context, "Daftar Bank",(){Navigator.pop(context);},<Widget>[
        IconButton(
          icon: Icon(Icons.add, color: Colors.black),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (_context) => FormBank()),);
          },
        )
      ]),
      body: StreamBuilder(
        stream: myBankBloc.allBank,
        builder: (context, AsyncSnapshot<MyBankModel> snapshot) {
          if (snapshot.hasData) {
            return buildContent(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return  Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            width: 80.0,
                            height: 80.0,
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              minRadius: 150,
                              maxRadius: 150,
                              child: CachedNetworkImage(
                                imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                                placeholder: (context, url) => Center(
                                  child: SkeletonFrame(width: 80,height:80),
                                ),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:16),
                          subtitle: Row(
                            children: <Widget>[
                              SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget buildContent(AsyncSnapshot<MyBankModel> snapshot, BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(allowFontScaling: false)..init(context);
    if(snapshot.data.result.length > 0){
      return  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Text(
              'Pilih dan Geser Untuk Menghapus Data Bank Anda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtilQ.getInstance().setSp(40),fontFamily:ThaibahFont().fontQ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              itemCount: snapshot.data.result.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 0.0,
                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              width: 80.0,
                              height: 80.0,
                              padding: EdgeInsets.all(10),
                              child: CircleAvatar(
                                minRadius: 150,
                                maxRadius: 150,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.result[index].picture,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))),
                                  ),
                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(0.0),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data.result[index].accName,style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Text(snapshot.data.result[index].accNo, style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ,color: Colors.black))
                              ],
                            ),
                        ),
                      ),
                    ),
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.delete, color: Colors.white,),
                            Text(" Delete",
                              style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(40),color: Colors.white, fontWeight: FontWeight.w700,fontFamily: ThaibahFont().fontQ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(width: 20,),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Anda Yakin Akan Menghapus Data Ini ???",style:TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),fontFamily:ThaibahFont().fontQ)),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancel", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.black,fontFamily: ThaibahFont().fontQ)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Delete", style: TextStyle(fontSize:ScreenUtilQ.getInstance().setSp(30),color: Colors.red,fontFamily: ThaibahFont().fontQ),),
                                onPressed: () async {
                                  setState(() {
                                    UserRepository().loadingQ(context);
                                  });
                                  delete(snapshot.data.result[index].id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                );
              },
            ),
          ),
        ],
      );
    }else{
      return UserRepository().noData();
    }

  }

}
