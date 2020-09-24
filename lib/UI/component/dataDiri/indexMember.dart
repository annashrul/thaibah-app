
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thaibah/Model/memberModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/address/indexAddress.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/UI/component/dataDiri/updateDataDiri.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/bloc/memberBloc.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';

class IndexMember extends StatefulWidget {
  final String id;
  IndexMember({this.id});
  @override
  _IndexMemberState createState() => _IndexMemberState();
}

class _IndexMemberState extends State<IndexMember> {
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
    loadTheme();


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
      appBar:UserRepository().appBarWithButton(context,"Pengaturan",warna1,warna2,(){Navigator.pop(context);},Container()),
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

