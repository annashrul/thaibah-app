import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaibah/Model/downlineModel.dart';
import 'package:thaibah/UI/Widgets/skeletonFrame.dart';
import 'package:thaibah/UI/component/dataDiri/createMember.dart';
import 'package:thaibah/UI/component/detailDownline.dart';
import 'package:thaibah/bloc/downlineBloc.dart';
import 'package:thaibah/config/api.dart';

import 'Homepage/index.dart';
import 'Widgets/pin_screen.dart';

import 'package:thaibah/Constants/constants.dart';
import 'package:thaibah/config/user_repo.dart';
class JaringanUI extends StatefulWidget {
  final String name;
  final String kdReferral;
  JaringanUI({this.name,this.kdReferral});
  @override
  _JaringanUIState createState() => _JaringanUIState();
}

class _JaringanUIState extends State<JaringanUI> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  final formatter = new NumberFormat("#,###");
  String kdReferral = '';
  String name = '';
  bool isLoading=false;
  Future<void> get() async{
    detailDownlineBloc.fetchDetailDownlineList(kdReferral);
    print("########################## ISLOADING $isLoading ###############################");
  }

  void pindah(kdReferral,nama) async{
    print("####################### PINDAH = $nama ###########################");
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral:kdReferral,name: nama,)),
    ).whenComplete(get);
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
    loadTheme();
    kdReferral = widget.kdReferral;
    isLoading=true;
//    name = widget.name;
//    print("################# IEU REFERRAL AKTIF $kdReferral #####################");
//    print("################# IEU NAMA AKTIF $name #####################");
//    name = widget.name;
//    downlineBloc.fetchDownlineList();
    get();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:UserRepository().appBarWithButton(context,"Jaringan Member ${widget.name}",warna1,warna2,(){
        Navigator.of(context).pop(true);
      },Container()),
      body: StreamBuilder(
          stream: detailDownlineBloc.allDetailDownline,
          builder: (context, AsyncSnapshot<DownlineModel> snapshot) {
            if(snapshot.hasData){
              return buildContent(snapshot, context);
            }else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return _loading();
          }
      ),
    );
  }

  @override
  Widget buildContent(AsyncSnapshot<DownlineModel> snapshot, BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    print("########################## LENGTH = ${snapshot.data.result.length}");
    return snapshot.data.result.length > 0 ?
      Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data.result.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 0.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
                child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
//                        radius: 35.0,
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data.result[index].downlinePicture,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                            ),
                          ),
                          placeholder: (context, url) => SkeletonFrame(width: 80.0,height: 80.0),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),

                    title: InkWell(
                      onTap: (){
                        print("################### DOWNLINE NAME = ${snapshot.data.result[index].downlineName}");
                        pindah(snapshot.data.result[index].downlineReferralRaw,snapshot.data.result[index].downlineName);

//                        Navigator.push(context,MaterialPageRoute(builder: (context) => DetailDownline(kdReff: snapshot.data.result[index].downlineReferralRaw,downlineNmae: snapshot.data.result[index].downlineName)));
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '${snapshot.data.result[index].downlineName}',
                          style: TextStyle(fontSize:11.0,color: Colors.black, fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                          children: <TextSpan>[
                            TextSpan(text: ' ( ${snapshot.data.result[index].downlineReferral} )', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 11.0)),
                          ],
                        ),
                      ),

                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: InkWell(
                      onTap: (){
                        print("################### DOWNLINE NAME = ${snapshot.data.result[index].downlineName}");
                        pindah(snapshot.data.result[index].downlineReferralRaw,snapshot.data.result[index].downlineName);
//                        Navigator.push(context,MaterialPageRoute(builder: (context) => DetailDownline(kdReff: snapshot.data.result[index].downlineReferralRaw,downlineNmae: snapshot.data.result[index].downlineName)));
                      },

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah Downline :',
                                  style: TextStyle(fontSize:11.0,color: Colors.grey, fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' ${snapshot.data.result[index].downline} Orang', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 11.0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah Omset :',
                                  style: TextStyle(fontSize:11.0,color: Colors.grey, fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' Rp ${formatter.format(int.parse(snapshot.data.result[index].downlineOmset))}', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 11.0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah STP : ',
                                  style: TextStyle(fontSize:11.0,color: Colors.grey, fontWeight: FontWeight.bold,fontFamily:ThaibahFont().fontQ),
                                  children: <TextSpan>[
                                    TextSpan(text: '${snapshot.data.result[index].downlineStp}', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontFamily:ThaibahFont().fontQ,fontSize: 11.0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: InkWell(
                      onTap: (){
//                        Navigator.of(context, rootNavigator: true).push(
//                          new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral:snapshot.data.result[index].downlineReferralRaw)),
//                        ).whenComplete(get);
                        Navigator.push(context,MaterialPageRoute(builder: (context) => CreateMember(
                          kdReff: snapshot.data.result[index].downlineReferral,nama:snapshot.data.result[index].downlineName))).whenComplete(() => get());
                      },
                      child: Icon(Icons.group_add, color: Colors.black, size: 30.0),
                    )
                ),
              ),
            );
          },
        ),
      ):Container(child: Center(child:Text("Tidak Ada Data",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Rubik'),)));
//    }else{
//      return ;
//    }

  }



  Widget _loading() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    width: 80.0,
                    height: 130.0,
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      minRadius: 150,
                      maxRadius: 150,
                      child: CachedNetworkImage(
                        imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                        placeholder: (context, url) => Center(
                          child: SkeletonFrame(width: 80.0,height:130.0),
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
                  title: InkWell(
                    child:SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16.0)
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: InkWell(

                    child: Row(
                      children: <Widget>[
                        SkeletonFrame(width: MediaQuery.of(context).size.width/3,height: 16.0)
                      ],
                    ),
                  ),
                  trailing: InkWell(
                    child: SkeletonFrame(width: MediaQuery.of(context).size.width/10,height: 30.0),
                  )
              ),
            ),
          );
        },
      ),
    );

  }

}
