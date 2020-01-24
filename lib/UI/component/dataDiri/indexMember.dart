import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:thaibah/Model/memberModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/History/deposit.dart';
import 'package:thaibah/UI/component/address/indexAddress.dart';
import 'package:thaibah/UI/component/bank/indexBank.dart';
import 'package:thaibah/UI/component/dataDiri/updateDataDiri.dart';
import 'package:thaibah/UI/component/pin/indexPin.dart';
import 'package:thaibah/bloc/memberBloc.dart';

class IndexMember extends StatefulWidget {
  final String id;
  IndexMember({this.id});
  @override
  _IndexMemberState createState() => _IndexMemberState();
}

class _IndexMemberState extends State<IndexMember> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    memberBloc.fetchMemberList(widget.id);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: new Text("Atur Akun Anda", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
      ),
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
                    FlatButton(
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => UpdateDataDiri(
                              name: snapshot.data.result.name,
                              nohp: snapshot.data.result.noHp,
                              gender: snapshot.data.result.gender,
                              picture: snapshot.data.result.picture,
                            )),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Data Diri", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 16.0),),
                                SizedBox(height:10.0),
                                Text("Klik Disini Untuk Mengubah Data Diri Anda", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
                              ],),
                            Icon(Icons.arrow_right)
                          ],
                        )
                    ),
                    Divider(),
                    FlatButton(
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => Pin(saldo: '',param:'profile')),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Keamanan", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 16.0),),
                                SizedBox(height:10.0),
                                Text("Klik Disini Untuk Mengubah PIN Anda", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
                              ],
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        )
                    ),
                    Divider(),
                    FlatButton(
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => IndexAddress()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Daftar Alamat", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 16.0),),
                                SizedBox(height:10.0),
                                Text("Klik Disini Untuk Mengubah Alamat Anda", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
                              ],
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        )
                    ),
                    Divider(),
                    FlatButton(
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => Bank()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Akun Bank", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 16.0),),
                                SizedBox(height:10.0),
                                Text("Klik Disini Untuk Mengatur Akun Bank Anda", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
                              ],
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        )
                    ),
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
}

