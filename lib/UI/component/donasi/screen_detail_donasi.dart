import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/Model/depositManual/listAvailableBank.dart' as Prefix1;
import 'package:thaibah/Model/donasi/checkoutDonasiModel.dart';
import 'package:thaibah/Model/donasi/detailDonasiModel.dart';
import 'package:thaibah/Model/generalModel.dart';
import 'package:thaibah/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/donasi/form_donasi.dart';
import 'package:thaibah/bloc/depositManual/listAvailableBankBloc.dart';
import 'package:thaibah/bloc/donasi/donasiBloc.dart';
import 'package:thaibah/config/api.dart';
import 'package:thaibah/config/user_repo.dart';
import 'package:thaibah/resources/donasi/donasiProvider.dart';

class ScreenDetailDonasi extends StatefulWidget {

  final String id;
  final int noDeadline;
  final String toDeadline;
  ScreenDetailDonasi({this.id,this.noDeadline,this.toDeadline});
  @override
  _ScreenDetailDonasiState createState() => _ScreenDetailDonasiState();
}

class _ScreenDetailDonasiState extends State<ScreenDetailDonasi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailDonasiBloc.fetchDetailDonasi(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");

    return Scaffold(
      key:_scaffoldKey,
      body: StreamBuilder(
        stream: detailDonasiBloc.getResult,
        builder: (context, AsyncSnapshot<DetailDonasiModel> snapshot){
          if (snapshot.hasData) {

            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    floating: true,
                    elevation: 0,
                    snap: true,
                    backgroundColor: Colors.white,
                    brightness: Brightness.light,
                    actions: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            UserRepository().textQ(snapshot.data.result.title,14,Colors.black,FontWeight.bold,TextAlign.left),
                          ],
                        ),
                      ),

                    ],
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                snapshot.data.result.gambar,
                            )
                          )
                        ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserRepository().textQ(snapshot.data.result.title, 12, Colors.black, FontWeight.bold, TextAlign.left),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UserRepository().textQ("${snapshot.data.result.donatur.length.toString()} Donatur", 10, Colors.grey, FontWeight.bold, TextAlign.left),
                              widget.noDeadline==1?Icon(Icons.all_inclusive,color: Colors.grey):UserRepository().textQ("${snapshot.data.result.todeadline}", 10, Colors.grey, FontWeight.bold, TextAlign.left),
                              // UserRepository().textQ("${widget.noDeadline==1?'unlimited':snapshot.data.result.todeadline}", 10, Colors.grey, FontWeight.bold, TextAlign.left),
                            ],
                          ),
                          SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 5,
                              child: LinearProgressIndicator(
                                value: snapshot.data.result.persentase, // percent filled
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              UserRepository().textQ("Rp ${formatter.format(snapshot.data.result.terkumpul)}", 12, ThaibahColour.primary1, FontWeight.bold, TextAlign.left),
                              SizedBox(width: 1.0),
                              UserRepository().textQ("Tercapai dari Rp ${formatter.format(int.parse(snapshot.data.result.target))}", 10, Colors.grey, FontWeight.normal, TextAlign.left),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:  BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey[200]
                              ),
                            ),
                            child: ListTile(
                              title:UserRepository().textQ(snapshot.data.result.penggalang,11,Colors.black,FontWeight.bold,TextAlign.left),
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius:20.0,
                                backgroundImage: NetworkImage(
                                  snapshot.data.result.pictPenggalang,
                                  scale: 1.0
                                )
                              ),
                              subtitle: UserRepository().textQ(snapshot.data.result.verifikasiPenggalang==1?'Sudah terverifikasi':'Belum terverifikasi',10,Colors.grey,FontWeight.normal,TextAlign.left),

                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:  BorderRadius.circular(10.0),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          UserRepository().textQ("Deskripsi", 12, Colors.black, FontWeight.bold, TextAlign.left),
                          SizedBox(height: 5.0),
                          Html(
                            padding: EdgeInsets.all(0.0),
                              data: snapshot.data.result.deskripsi,
                            defaultTextStyle: TextStyle(color: Colors.black,fontFamily:ThaibahFont().fontQ,fontSize: 10,fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:  BorderRadius.circular(10.0),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          UserRepository().textQ("Donatur", 12, Colors.black, FontWeight.bold, TextAlign.left),
                          SizedBox(height: 5.0),
                          snapshot.data.result.donatur.length>0?ListView.builder(
                              padding: EdgeInsets.only(top:5.0),
                              primary: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.result.donatur.length,
                              itemBuilder: (context,index){
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:  BorderRadius.circular(10.0),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey[200]
                                        ),
                                      ),
                                      child: ListTile(
                                        title:UserRepository().textQ(snapshot.data.result.donatur[index].name,11,Colors.black,FontWeight.bold,TextAlign.left),
                                        leading: CircleAvatar(
                                            radius:20.0,
                                            backgroundImage: NetworkImage(snapshot.data.result.donatur[index].picture)
                                        ),
                                        subtitle: UserRepository().textQ("${snapshot.data.result.donatur[index].nominal}",10,Colors.grey,FontWeight.normal,TextAlign.left),
                                        trailing: UserRepository().textQ("${snapshot.data.result.donatur[index].time}",10,Colors.grey,FontWeight.normal,TextAlign.left),
                                      ),
                                    ),
                                    SizedBox(height: 5.0)
                                  ],
                                );
                              }
                          ):UserRepository().textQ('tidak ada donatur', 12,Colors.grey,FontWeight.bold, TextAlign.center)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(
            padding: EdgeInsets.only(left:10.0,right:10.0,top:20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonFrame(width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height/4),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/3,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/3,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/3,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/3,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/1,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/2,height:15),
                SizedBox(height: 10.0),
                SkeletonFrame(width: MediaQuery.of(context).size.width/3,height:15),

              ],
            ),
          );

        }
      ),
      bottomNavigationBar:InkWell(
        onTap: (){
          print("TODEADLINE ${widget.toDeadline}");
          print("NODEADLINE ${widget.noDeadline}");
          if(widget.noDeadline==1){
            Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => FormDonasi(id: widget.id))).whenComplete(() => detailDonasiBloc.fetchDetailDonasi(widget.id));
          }
          else{
            if(widget.toDeadline.toLowerCase()!='selesai.'){
              Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => FormDonasi(id: widget.id))).whenComplete(() => detailDonasiBloc.fetchDetailDonasi(widget.id));
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green,Colors.green]),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.only(top:20.0),
            child:UserRepository().textQ('Donasi',14,Colors.white,FontWeight.bold,TextAlign.center),
          ),
        ),
      )
    );
  }


}
