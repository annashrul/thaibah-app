
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/Model/memberModel.dart';
import 'package:thaibah/Model/resendOtpModel.dart';
import 'package:thaibah/UI/Widgets/pin_screen.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/address/indexAddress.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/UI/component/dataDiri/updateDataDiri.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/memberProvider.dart';

class IndexMember extends StatefulWidget {
  final String id;
  IndexMember({this.id});
  @override
  _IndexMemberState createState() => _IndexMemberState();
}

class _IndexMemberState extends State<IndexMember> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    memberBloc.fetchMemberList(widget.id);
    return  Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: UserRepository().appBarWithButton(context, "Pengaturan",(){Navigator.pop(context);},<Widget>[]),
      body: Container(
          margin: EdgeInsets.only(top:10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              StreamBuilder(
                  stream: memberBloc.getResult,
                  builder: (context,AsyncSnapshot<MemberModel> snapshot){
                    return snapshot.hasData ? Column(
                      children: <Widget>[
                        itemContent(context, "Data Diri","Tap Disini Untuk Mengubah Data Diri Anda",  (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => UpdateDataDiri(
                              name: snapshot.data.result.name,
                              nohp: snapshot.data.result.noHp,
                              gender: snapshot.data.result.gender,
                              picture: snapshot.data.result.picture,
                            )),
                          );
                        }),

                        Divider(),
                        itemContent(context, "Keamanan","Tap Disini Untuk Mengubah PIN Anda",  (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => Pin(saldo: '',param:'profile')),
                          );
                          // UserRepository().loadingQ(context);
                          // sendOtp();
                        }),
                        Divider(),
                        itemContent(context, "Daftar Alamat","Tap Disini Untuk Mengatur Alamat Anda",  (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => IndexAddress()),
                          );
                        }),

                        Divider(),
                        itemContent(context, "Daftar Bank","Tap Disini Untuk Mengatur Akun Bank Anda",  (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => Bank()),
                          );
                        }),

                        Divider(),
                      ],
                    ):Column(
                      children: <Widget>[
                        FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                    SizedBox(height:10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/1.5,height: 16.0),
                                  ],),
                                Icon(Icons.arrow_right)
                              ],
                            )
                        ),
                        Divider(),
                        FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                    SizedBox(height:10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/1.5,height: 16.0),
                                  ],
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            )
                        ),
                        Divider(),
                        FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                    SizedBox(height:10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/1.5,height: 16.0),
                                  ],
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            )
                        ),
                        Divider(),
                        FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/2,height: 16.0),
                                    SizedBox(height:10.0),
                                    SkeletonFrame(width: MediaQuery.of(context).size.width/1.5,height: 16.0),
                                  ],
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            )
                        ),
                        Divider(),
                      ],
                    );
                  }
              )

            ],
          )
      ),
    );
  }

  Widget itemContent(BuildContext context,title,desc, Function callback){
    return FlatButton(
        onPressed:callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UserRepository().textQ(title, 14, Colors.black, FontWeight.bold,TextAlign.left),
                SizedBox(height:10.0),
                UserRepository().textQ(desc, 12, Colors.grey, FontWeight.bold,TextAlign.left),
              ],),
            Icon(Icons.arrow_right)
          ],
        )
    );
  }

}

